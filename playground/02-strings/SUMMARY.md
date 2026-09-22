# 02a — Strings: immutability, the pool, `==` vs `equals`

## Mental model

A `String` object never changes. Every "modifying" method returns a **new** one — so the only
questions left are *which* object you are holding, and whether it came from the pool.

## The rules

- **Immutable means the object.** `s.toUpperCase()` returns a new string and leaves `s` alone.
  Ignoring the return value is the whole bug.
- **A literal is interned at compile time.** `new String(...)` always allocates. Anything computed at
  runtime — `split`, `substring`, `concat`, `+` on variables, I/O — is a fresh heap object, never
  pooled.
- **`==` on strings compares references.** Never the right tool for comparing text. Use `equals`, and
  reverse it — `REFUND.equals(cmd)` — for null-safety for free.
- **`intern()`** returns the pooled instance with that value. A memory tool, not a comparison tool.
- **Constant variable** = `final` **+** primitive or `String` **+** *initialised in its own declarator
  with a constant expression*. All three. Its value is then inlined into every class that reads it.

## Constant or not

| Declaration | Constant? | Because |
|---|---|---|
| `final String p = "HI";` | yes | literal in the declarator |
| `final String q = "H" + "I";` | yes | both operands constant, folded to `"HI"` |
| `final String r = p.toLowerCase();` | **no** | a method call is runtime, always |
| `final String s = String.valueOf("HI");` | **no** | same — a constant argument changes nothing |
| `static final String t;` assigned in a static block | **no** | blank final, assigned at class-init time |

**Why the last row matters in production:** a constant variable's value is *copied into every class
that reads it* at compile time. Ship a library with `public static final String VERSION = "1.0";`,
change it to `"2.0"`, recompile only the library — every client still prints `1.0` until it is
recompiled too. Move the assignment into a static block and the inlining stops.

## The traps

- Calling a `String` method and discarding the result. The compiler will not warn you.
- `==` that passes every test because the test uses literals and production does not.
- Judging "is it constant?" by the obvious value rather than by what the expression is made of.
- Reaching for `intern()` to make `==` work instead of using `equals`.

## Interview answers worth having ready

**"`String a = "hi"; String b = new String("hi");` — how many objects?"**
Two. The literal is folded into the pool at compile time; `new String` always allocates a fresh heap
object that copies it. `a == b` is false. `a == b.intern()` is true, because `intern()` looks the
*value* up in the pool and hands back the pooled instance — the very object `a` points at.
*Follow-up:* delete the first line — still two objects.

**"`==` on strings: tests green, production red. How?"**
In the test both strings are **literals written in the source**, so the compiler pools them and both
names point at the same instance — `==` is true by accident. In production the string arrives at
runtime (socket, DB column, JSON parse, `split`, `substring`, `new String`, concatenation of
non-constants), which is always a fresh un-interned heap object. The test never exercised the path
the bug lives on.
*Follow-up:* "would `intern()` fix it?" — it would make `==` work, and it is still the wrong fix:
a pool lookup on every comparison, and correctness now depends on every caller remembering to intern.

## Mistakes actually made

- **Constant variables — third time.** Step 2 took four rounds; the drill still ticked the blank
  final assigned in a static block. The missing piece is consistently the same one: *initialised in
  its own declarator*. Not "is it final", not "does the value look fixed".
- **Answered the rule instead of the question.** The `==` question explicitly granted that `==`
  compares references and that `equals` is the fix, and asked *why the test was green*. The answer
  given was the definition of `==`. Right fact, wrong question — and the interviewer scores the
  second one.
- **One line where five reasons were asked for.** The question said "including the ones you left
  unticked". Reasoning is the graded part; skipping it costs the point even when the ticks are right.

## What went well

- Q1 fully correct *with* the mechanism — object count, reference identity, and what `intern()` hands
  back, all three.
- Exercise: four bug reports, no TODOs, all four found and fixed in one attempt — including spotting
  that `ticketId` was discarding the result of `toUpperCase()`.
- `p.toLowerCase()` and `String.valueOf("HI")` both correctly rejected. The method-call half of the
  constant rule has landed.
