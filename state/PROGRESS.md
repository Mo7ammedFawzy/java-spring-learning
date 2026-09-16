# Progress

Maintained by the `/learn` skill. Read at the start of every session, updated after step 5.
Confidence is honest, not encouraging: `solid` / `ok` / `shaky`.

**Current is one line, not a log.** It names the topic and the step in progress, plus anything
needed to resume. Detail about what went wrong belongs under **Weak spots to revisit** when the
topic closes.

## Current

Topic: 02 — Strings (split: 02a immutability, pool, `==` vs `equals`; 02b `StringBuilder` and loop concatenation — each gets its own five steps)
Step: 02a — steps 1–3 done (exercise `playground/02-strings/Main.java`, all checks PASS, four bugs fixed first attempt). Interview drill asked, awaiting answers; then write the summary card and close. Flow was switched to the five-step version mid-topic, so the old step 4 (real-world example) already ran as a detour. Re-test 4: L/M/N all correct including `"hi".toString()` = no (the discriminator), but skipped the rule statement and the H-vs-I question and gave no reasons for the fourth time. For close: constant-folding rule took four rounds; habit of bare answers without reasoning. Re-test 3: marked `String.valueOf("hi")` constant while marking `x.trim()` not — judges by the obvious result, not by what the expression is made of; gave no reasons again despite being asked. Re-test 2 closed stored hash (T2) and object count (T3); T1 marked `final String r = p.toLowerCase()` as constant — method call, third miss on this rule, gave no reasons. Re-test 1: closed Q2 (fix + `Objects.equals`) and intern identity; still missed `final String d = c` is not constant (needs constant initializer), mutated `HashSet` element — said `contains(p)` true, right-answer-wrong-reason on `contains(new Point(1,2))` ("new reference"), and counted `new String` twice as 2 objects not 3. First pass: Q1 said `nonFinal + "va" == "Java"` is true (constant-folding rule); Q2 found discarded trim/toUpperCase but missed `== "USD"`; Q3 thought the mutated key is findable by its new value (missed stored hash); Q4 said `new String("hi")` makes one object (missed the pooled literal). Codebase-free mode (no lab matches the learning repo).

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

- **Keep lessons to 20–30 minutes.** Requested on 2026-09-16: five steps, no mandatory real-world
  task, no separate review step, no drilling one detail past two rounds. If a concept will not fit,
  split it into two lessons rather than overrunning.

- **The real-world detour is the exception, not the routine.** Take it only when it clears the bar
  in `core/METHODOLOGY.md`. When it is taken, a lab extract is *illustration* only — a task is never
  modelled on the lab codebase, no lab domain names, no lab-flavoured tickets. Write a
  self-contained task in a neutral domain instead (asked for on 2026-09-01).

- **Symptom-driven exercises land better than TODO-driven ones.** Both in the 01 review and in 02a,
  the starter gave bug reports and no TODOs — the learner had to work out which method each symptom
  came from, and got them all in one attempt. Use that shape.

- **The summary card is step 4, and it is not optional.** Requested on 2026-09-06 so there is
  something to study from between sessions.
