# Progress

Maintained by the `/learn` skill. Read at the start of every session, updated after step 5.
Confidence is honest, not encouraging: `solid` / `ok` / `shaky`.

**Current is one line, not a log.** It names the topic and the step in progress, plus anything
needed to resume. Detail about what went wrong belongs under **Weak spots to revisit** when the
topic closes.

**Keep progress lightweight.** Update it only when a lesson closes or a two-round re-test identifies
a weak spot. Record the next topic, confidence, and specific gap; do not turn each lesson into a
task log or require a real-world exercise or formal code review to mark it complete.

## Current

Topic: 02b — `StringBuilder` and when loop concatenation actually costs
Step: not started.

## Completed

| # | Topic | Date | Confidence | Notes |
|---|---|---|---|---|
| 01 | Types, values and references | 2026-09-01, reviewed 2026-09-06 | solid | Review closed four of five weak spots. Exercise and task both clean on first attempt, diagnosed from symptoms with no TODOs. |
| 02a | Strings — immutability, the pool, `==` vs `equals` | 2026-09-21 | ok | Exercise clean in one attempt. Drill: Q1 fully right with mechanism; Q2a answered the rule not the question; Q2b still ticked the blank final. |

## Weak spots to revisit

- **Defaults to a mutable copy when exposing a collection, to avoid the throw.** Twice now framed
  `UnsupportedOperationException` as a problem to prevent rather than the API refusing a bad caller.
  The safe default for a getter is `List.copyOf`. Re-test by asking for the *recommendation*, not
  the option list.
- **Shallow copy boundary.** `new ArrayList<>(orders)` protects the list, not the orders in it.
  Mutating an element is still visible to the caller. Never volunteered this.
- **Constant variable — the *declarator* condition. Three rounds now, still open.** The method-call
  half has landed (`p.toLowerCase()` and `String.valueOf("HI")` both correctly rejected in the 02a
  drill). The half that keeps failing is the third condition: a constant variable must be initialised
  **in its own declarator**. A blank `static final String t;` assigned in a static block is *not* one,
  and it was ticked as one. Re-test with blank finals specifically, not with method calls — and
  anchor it to the consequence: a constant variable's value is inlined into every class that reads it,
  so changing a library's `VERSION` and recompiling only the library leaves clients on the old value.
- **Answers the rule instead of the question.** New in the 02a drill: asked *why the unit test is
  green and production red*, the answer was the definition of `==`. The question had explicitly ruled
  that out. Same shape as the articulation gap below, one level up — the fact is known, the asked
  question is not the one answered. Re-test by asking "why does the *wrong* case work?", never
  "what's wrong with this?".
- **Answers arrive without reasoning.** Four times in 02a step 2, and again in the drill: Q2b asked
  for a reason for each of five items, including the unticked ones, and got one line. The gap is not
  knowledge — it is articulation, which is exactly what an interview grades. Always ask for the
  reason, and do not accept the answer alone.
- Closed on 2026-09-06: pass-by-value vs pass-by-reference; copy vs live view (the two axes now
  drive the choice); `Integer` cache; unboxing NPE and `getOrDefault`; rebinding a parameter.

## Notes to self

- **The interactive lesson page is gone.** Asked for on 2026-09-21, removed on 2026-09-22: the round
  trip was slow and cost a publish per step, and the terminal is cheap and fast. The rule now lives
  in `core/METHODOLOGY.md` § *Delivery* — do not restate it here. Two published pages from those two
  days still exist in the artifact gallery (topics 02a and 02b); they are dead and can be deleted.

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
  task, no formal code-review step, and no drilling one detail past two rounds. If a concept will
  not fit, split it into two lessons rather than overrunning.

- **The real-world detour is the exception, not the routine.** Take it only when it clears the bar
  in `core/METHODOLOGY.md`. When it is taken, a lab extract is *illustration* only — a task is never
  modelled on the lab codebase, no lab domain names, no lab-flavoured tickets. Write a
  self-contained task in a neutral domain instead (asked for on 2026-09-01).

- **Symptom-driven exercises land better than TODO-driven ones.** Both in the 01 review and in 02a,
  the starter gave bug reports and no TODOs — the learner had to work out which method each symptom
  came from, and got them all in one attempt. Use that shape.

- **The summary card is step 4, and it is not optional.** Requested on 2026-09-06 so there is
  something to study from between sessions.
