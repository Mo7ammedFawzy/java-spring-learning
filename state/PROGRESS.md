# Progress

Maintained by the `/learn` skill. Read at the start of every session, updated after step 7.
Confidence is honest, not encouraging: `solid` / `ok` / `shaky`.

## Current

Topic: 02 — Strings
Step: not started

## Completed

| # | Topic | Date | Confidence | Notes |
|---|---|---|---|---|
| 01 | Types, values and references | 2026-09-01, reviewed 2026-09-06 | solid | Review closed four of five weak spots. Exercise and task both clean on first attempt, diagnosed from symptoms with no TODOs. |

## Weak spots to revisit

- **Defaults to a mutable copy when exposing a collection, to avoid the throw.** Twice now framed
  `UnsupportedOperationException` as a problem to prevent rather than the API refusing a bad caller.
  The safe default for a getter is `List.copyOf`. Re-test by asking for the *recommendation*, not
  the option list.
- **Shallow copy boundary.** `new ArrayList<>(orders)` protects the list, not the orders in it.
  Mutating an element is still visible to the caller. Never volunteered this.
- Closed on 2026-09-06: pass-by-value vs pass-by-reference; copy vs live view (the two axes now
  drive the choice); `Integer` cache; unboxing NPE and `getOrDefault`; rebinding a parameter.

## Notes to self

- **Teaching language: English + light Egyptian Arabic.** Mix a little Egyptian dialect into the
  conversational layer — framing, encouragement, corrections: "خلينا نشوف", "واضح كده؟", "برافو",
  "غلط، وهقولك ليه". Keep it light seasoning, not every sentence.
  **Technical content stays English**: code, terms (reference, heap, proxy, bean, erasure), the
  step-1 explanation, and the reasoning for *why* something breaks. That is the exact vocabulary
  needed in the interview itself, so it never gets translated.
  Rule of thumb: **Arabic for the room, English for the material.**

- **Never mix Arabic and English in the same line.** A line is either pure Arabic — a short
  standalone phrase, with no English words, no `code`, no backticks, no trailing English
  punctuation — or pure English. Mixed right-to-left lines get visually scrambled in the terminal:
  words and punctuation jump to the wrong end and the sentence becomes unreadable. If a thought
  needs an English term or a code token, write that whole thought in English.

- **Lab codebase: step 4 only, and optional there.** Quoting a short real extract from the active
  lab (10–40 lines) is welcome as *illustration*. But **step 5's task is never modelled on the lab
  codebase** — no lab domain names, no lab-flavoured tickets. Write a self-contained,
  production-shaped task in a neutral domain instead. Step 4 may also skip the lab entirely when a
  synthetic example teaches the concept better; say so and move on. The learner explicitly asked
  for this (2026-09-01).

- **Symptom-driven tasks land better than TODO-driven ones.** In the 01 review, the step-5 task
  gave four bug reports and no TODOs — the learner had to work out which method each symptom came
  from, and got all four in one attempt. Use that shape again.
