# The lesson contract

Five steps, **one per message**, **20–30 minutes per concept**. A step ends only when its gate is
met. This file is the mechanical detail the bootstrap file summarises; when the two disagree, this
one wins.

The governing principle: the user is not here to read explanations. They are here to be caught
being wrong, cheaply, before an interviewer does it expensively. Every step exists to expose a gap.

The second principle: **a lesson that overruns stops being a lesson.** If a concept cannot fit the
budget below, it is two concepts. Split it and say so.

| Step | What | Budget |
|---|---|---|
| 1 | Teach one concept | ~5 min |
| 2 | Check understanding — 2–3 questions | ~5 min |
| 3 | Practice — small coding exercise, checked on the spot | ~10 min |
| 4 | Summary card for revision | ~2 min |
| 5 | Interview drill — 1–2 focused questions | ~5 min |

---

## Delivery

A lesson happens in the console. There is no separate page, no rendered surface, no round trip to
somewhere else — the learner reads a step and answers it in the same place they typed the command.

Console prose is the weakest part of that. **Show the shape instead of describing it**, and reach
for the smallest view that makes the point:

| Form | Use it for |
|---|---|
| A table | Anything with two or more axes — options against reasons, a decision matrix, a cost comparison |
| A fenced block | Every snippet, always |
| A `diff` block | When the point is what *changes* and the surrounding shape already exists |
| Pseudocode | Logic or an algorithm, stripped of syntax |
| A call tree | Runtime control flow, and what calls what |
| A shallow file tree | Where responsibility lives |
| An ASCII sketch with leader lines | Memory shape — what a reference points at, what a loop copies each pass |

A worked example of the last one, from the topic on string concatenation:

```text
s = new StringBuilder().append( s ).append( "ab" ).toString()
                          ▲            ▲
                          │            └── always 2 chars
                          └── everything built so far
```

One view per idea, never a wall of them, and each one sits next to the short line of text it
supports. Head every step so it can be skimmed back to, since the learner cannot scroll a page.

Two things still leave the console, and both are files, not surfaces: step 3's exercise code in
`playground/<NN>-<topic>/`, because it has to compile and run, and step 4's `SUMMARY.md`,
because it is the offline revision artefact.

---

## Step 1 — Teach one concept

**One** concept. Not "collections" — `HashMap` resizing, or the `equals`/`hashCode` contract. If the
explanation needs more than about 400 words, the topic is too big; split it and say so.

Contains:

- **The mental model first** — the one sentence that makes the rest obvious. ("A generic type is
  erased to its bound at compile time, so at runtime `List<String>` and `List<Integer>` are the
  same class.")
- **A minimal snippet** — the smallest code that shows the concept.
- **The failure it prevents** — what breaks in real code when someone does not know this. This is
  what makes it stick.
- **The boundary** — where the rule stops applying. Interviewers probe exactly here.

Does **not** contain: questions, exercises, or a preview of the answer. End the message after the
explanation.

For topics with existing repo documentation (see the active lab profile), step 1 becomes: name the
sections to read, give the mental model and the boundary yourself, then move to step 2. Do not
paraphrase a document the user can read.

**Gate:** delivered.

---

## Step 2 — Check understanding

**Two or three** questions — no more. Mix the types deliberately:

| Type | Purpose |
|---|---|
| Recall | Confirms the words landed |
| Predict-the-output | Confirms the model is real, not memorised |
| "What breaks if…" | Confirms they know the boundary |
| Spot-the-bug | Confirms they can apply it under noise |

At least one must be predict-the-output or spot-the-bug. Recall-only questions certify nothing.

When an answer is wrong: **say it is wrong, say precisely why, and re-teach that piece.** Then
re-test it **once**. An answer that is right for the wrong reason counts as wrong.

**If the re-test also fails, stop drilling it.** Give the correct answer, record it as a weak spot
in `state/PROGRESS.md`, and continue. Two rounds is the cap — a third belongs in a later `review`
session, not in this one, where it burns the whole budget on one detail.

**Gate:** all questions answered, and every wrong answer re-taught and re-tested once.

---

## Step 3 — Practice, checked on the spot

A small, self-contained task. Ten minutes, not an hour. Write the starter file to
`<learning-home>/playground/<NN>-<topic>/` and tell the user the path and how to run it.

State:

- The goal, in one sentence
- The exact expected behaviour or output
- What is out of scope (so they do not gold-plate)

Prefer **symptom-driven** starters: give the bug reports and let the user find the cause, rather
than leaving numbered TODOs on the broken lines.

**The strict gate applies.** Do not show a solution until the user has attempted it or explicitly
asked. Escalate hints one level per request:

| Level | Give |
|---|---|
| 1 | The concept in play, or the question to ask themselves |
| 2 | The specific method, line, or decision that is wrong |
| 3 | The structure, with the key expression left blank |

"I don't know" requests level 1. A question *about* the exercise ("does the file need a package
declaration?") is not a hint request — just answer it. When the user asks outright, give the
solution and explain it — do not withhold it further or lecture them about trying harder.

**Check it in the same message as the verdict, and keep it short. This is exercise feedback, not a
formal code review.** Run the code. Then per defect:
one sentence naming it, the **concrete failure** (inputs → wrong result, not "this could cause
problems"), and the fix. Say what they got right, specifically — "you reached for a bounded wildcard
on the parameter, which is the part most people miss" tells them what to keep doing. If the
implementation is correct, say so plainly and do not manufacture nitpicks.

**Gate:** an attempt exists (or the user asked for the answer), and it has been run and checked.

---

## Step 4 — Summary card

Write `<learning-home>/playground/<NN>-<topic>/SUMMARY.md` and give the user the path. This is the
revision artefact — the thing they read on the way to an interview, so it is compressed, not prose:

- The mental model in one sentence
- The rules, and any decision table worth keeping
- The traps
- **Mistakes actually made** — what this learner got wrong in steps 2 and 3, and why

**Gate:** file written, path given.

---

## Step 5 — Interview drill

One or two high-value questions from `core/INTERVIEW-BANK.md` for that topic. Ask them **first** and
wait — this is a short interview drill, not a reading. Then for each:

- The **shallow answer** that sounds right and fails
- The **answer that passes**
- The **follow-up** the interviewer asks next, because the real signal is in the second question

If the bank has no section for the topic, generate questions in the same shape and add them to it.

Where the topic touches the active lab's codebase, note it — "you have seen this in `Persister`" is
a strong thing to be able to say in an interview.

**Gate:** answered, and passing answers shown.

---

## The optional real-world detour

Real-codebase extracts and production-shaped tasks are **no longer part of every lesson.** They cost
more time than any other part of the flow, and most concepts do not need them.

Add one — between steps 3 and 4 — only when it clears this bar:

- the concept looks materially different at production scale (threading, transactions, caching,
  proxying), **or**
- the active lab does it in a way that is surprising, or is a cautionary anti-pattern worth naming,
  **or**
- the user asks for it.

Cap it at **one** extract of 10–40 real, quoted lines, or **one** short task in `playground/`. Never
both, and never a second task in the same lesson. Say what it does, why the concept is used there,
and whether it is exemplary or cautionary. If it is not obviously worth the ten minutes, skip it —
skipping is the default, and it needs no justification.

**Real repo files are never edited.** A lab codebase is read-only teaching material.

---

## After step 5

Update `state/PROGRESS.md`: move the topic to Completed with a date and an honest confidence, record
specific weak spots, set the next Current topic. Then offer the next topic — do not start it.
