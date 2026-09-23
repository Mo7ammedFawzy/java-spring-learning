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

Topic: 04 — Classes, interfaces, abstraction (first topic with open `SOURCES.md` rows; 03b has none
and waits). Step: not started.

## Completed

| # | Topic | Date | Confidence | Notes |
|---|---|---|---|---|
| 01 | Types, values and references | 2026-09-01, reviewed 2026-09-06 | solid | Review closed four of five weak spots. Exercise and task both clean on first attempt, diagnosed from symptoms with no TODOs. |
| 02a | Strings — immutability, the pool, `==` vs `equals` | 2026-09-21 | ok | Exercise clean in one attempt. Drill: Q1 fully right with mechanism; Q2a answered the rule not the question; Q2b still ticked the blank final. |
| 02b | Strings — `StringBuilder` and loop concatenation | 2026-09-22 | ok | Spotted the disguised `new StringBuilder(sb)` bug unprompted and fixed it. But located the cost in allocation rather than copying, and left the headline `toCsv` case untouched after writing the identical fix one method below. |
| 03a | equals and hashCode — the contract, and how breaking it corrupts a `HashMap` | 2026-09-23 | shaky | Step 2 capped at two rounds. Needed a full Arabic step-by-step re-teach before step 3; Report B then took two wrong tries and two hints. Drill: Q1 right on `==` but opened with "`equals` compares values"; Q2 called `equals` without `hashCode` "not a bug". |

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
- **Answers the adjacent question, not the one asked. Three times now, across two lessons.**
  02a drill: asked *why the unit test is green and production red*, answered with the definition of
  `==` — which the question had explicitly ruled out. 02b step 2: asked why `a + b + c + d` is not
  quadratic, answered "it's literal concatenation" — there are no literals in it. 02b drill: asked
  the flat *"is `+` slow?"*, answered "yes of course" and then described the loop case, which is a
  different question; "yes" commits to rewriting `prefix + "-" + id` by hand. The fact is known
  every time; the question on the table is not the one answered. Re-test with deliberately flat or
  inverted framings — "why does the *wrong* case work?", "is X slow?" — never "what's wrong with
  this?", which hands over the frame.
- **Locates cost in allocation rather than copying.** Both 02b drill answers explained the quadratic
  blowup as "it creates new objects in the heap". Allocation in Java is a bump-pointer in the TLAB and
  the objects die young — 20,000 of them is nothing. The cost is `append(accumulator)` **copying**
  every character built so far, every pass: ~400 million char copies at n=10,000. Re-test by asking
  for the cost of a loop in *characters*, and refuse "objects" as the unit.

- **Cannot produce a count when a count is asked for.** 02b step 2 and its re-test both asked for
  total characters copied across four iterations. First answer was the four resulting strings, second
  was a bare "4". The mechanism was written correctly one question earlier, so this is not a
  knowledge gap — the arithmetic does not come out under a direct request. Two rounds, capped.
  Re-test with a small n and demand the per-iteration line, not the total.

- **Names the wrong method as the one that failed. Two rounds, capped in 03a step 2.** Asked why
  `map.get(t)` returns null after a hashed field was mutated, answered "equals is wrong" twice —
  `equals` is never reached there, the hash sends the probe to an empty bucket. And the mirror case,
  `get(new Tag("java"))`, was called a hit both times: right bucket, but the stored key now disagrees,
  so `equals` is what fails. Re-test by handing a failing lookup and asking **which of the two methods
  was the one that failed, and whether the other one even ran** — never "what's wrong with this?".
  Related: a bucket was described as a slot holding one entry (`HashSet` of two equal-hash items
  answered as size 1). That half closed on the re-test.

- **Calls a broken `equals`/`hashCode` contract "not a bug". 03a drill.** Asked flat "is overriding
  `equals` without `hashCode` a bug?", answered "not a bug, it creates mini buckets", framing a
  correctness failure as a storage detail. It is a bug: equal objects get different identity hashes,
  so a `HashSet` keeps duplicates and `map.get(equalKey)` returns `null`. This happened one step
  after fixing exactly that in `Sku`. Same pattern as the flat "is `+` slow?" in 02b. Re-test flat.
- **"`equals` compares values" as a blanket rule. 03a drill.** `Object.equals` is `==`. It compares
  values only when the class overrides it. The follow-up "depends on Point's equals" rescued it, but
  the opening line is the one an interviewer writes down.
- **Renaming a hashed key: did not reach remove-then-put unaided. 03a step 3.** First renamed to the
  same name, then `put` the new key and left the old entry orphaned. Needed hints on left-to-right
  argument evaluation, and that a fresh equal key finds the stored entry.

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

- **The interview PDFs in `sources/` take priority.** Added on 2026-09-23 — the learner wants them
  finished first. `state/SOURCES.md` maps every question to a topic and decides what comes next.
