# 02b — StringBuilder, and when concatenation actually costs

## Mental model

The compiler already turns `a + b` into a `StringBuilder` for you. The cost is not concatenation —
it is that a loop does it **once per iteration**, and each pass copies every character accumulated
so far.

## What the compiler actually writes

```text
s += part;

  becomes

s = new StringBuilder().append( s ).append( part ).toString()
                          ▲             ▲
                          │             └── flat: the new part only
                          └── grows every pass — this is the O(n²)
```

Four iterations of `s += "ab"` to build 8 characters costs **20** copies: `0+2, 2+2, 4+2, 6+2`.
A thousand iterations costs half a million.

## The rules

- **One expression gets one builder.** `a + b + c + d` is linear and already optimal — rewriting it
  by hand buys nothing. A loop body is one expression *per iteration*, so `n` iterations is `n`
  builders.
- **Hoist the builder out of the loop.** That is the entire fix. One buffer, reused and doubled when
  it runs out, so each `append` is amortised O(1).
- **Anything that rebuilds the buffer is the same bug in disguise.**
  `sb = new StringBuilder(sb).append(x)` inside a loop *uses* `StringBuilder` and is still quadratic —
  the copy hides in the constructor.
- **Quadratic ≠ slow.** It is a statement about growth. Judge by `n`, not by a stopwatch at small `n`.
- **Separator before, not after.** `if (sb.length() > 0) sb.append(", ");` at the top of the loop
  leaves nothing to clean up afterwards.
- **`StringBuffer`** is the synchronised twin. Legacy only.

## Boundary

| Situation | Builder needed? |
|---|---|
| `a + b + c + d`, one expression | no — already one builder |
| `"a" + "b"`, constants | no — folded at compile time, zero runtime work |
| Loop of 5 | no — readability wins |
| Loop of 10,000 | **yes** |
| Joining with a delimiter | `String.join` / `StringJoiner` / `Collectors.joining` beats both |
| Java 9+ | `+` compiles to `invokedynamic`, not a literal builder — same shape of bug |

## The traps

- Describing the lowering without the accumulator in it. Say `append(out)` out loud — leave it out
  and you have described a loop with no performance problem.
- `trim()` to remove a trailing separator. It only strips whitespace, and it corrupts items that
  legitimately carry spaces.
- Benchmarking at n=1,000 and concluding the quadratic version is fine.
- Fixing one method and leaving the identical bug in the method above it.

## Mistakes actually made

- **Q1 — right count, wrong expression.** Wrote `new StringBuilder(row).append("\n")`. `out` was
  missing, and `append(out)` *is* the quadratic. The same lowering was written correctly in Q2·C one
  question later, so it is a slip in articulation, not a gap in knowledge.
- **Q2·A — called four variables "literals".** `a + b + c + d` folds nothing; it is linear because
  it is one expression, one builder. Same shape as the 02a constant miss: judged by what the code
  looks like, not what the expression is made of.
- **Q3 — answered "1000".** No sentence, no consequence. The direction was probably right.
- **Re-test — gave the four strings, never the counts.** Two rounds, capped. The strings were the
  inputs to the arithmetic; the arithmetic did not follow. Pattern: the mechanism is known, the
  *number* does not come out when a number is asked for.
- **Step 3 — `toCsv` left untouched.** The headline case of the whole lesson, and the identical fix
  had already been written one method below in `bullets`.
- **Step 3 — `joinWithComma`: changed the data to fit the tool.** Switched the separator to `" "` so
  `trim()` would work, which deleted the comma from the output.

## What went well

- Q1 count correct, and all four Q2 classifications correct including D, the disguised one.
- `bullets` fixed by hoisting the builder — the right fix, for the right reason.
- `label` correctly left alone. That was the planted trap and the direct re-test of the Q2·A miss.
