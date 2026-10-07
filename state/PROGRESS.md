# Progress

Maintained by the `/learn` skill. Read at the start of every session, updated after step 5.
Confidence is honest, not encouraging: `solid` / `ok` / `shaky`.

**Current is one line, not a log.** It names the topic and the step in progress, plus anything
needed to resume. Detail about what went wrong belongs under **Weak spots to revisit** when the
topic closes.

**Keep progress lightweight.** Update it only when a lesson closes or a two-round re-test identifies
a weak spot. Record the next topic, confidence, and specific gap; do not turn each lesson into a
task log or require a real-world exercise or formal code review to mark it complete.

**Weak spot line format** (new entries; older ones without `Held` count as `0/2`):
`- **<misconception label>** (topic, date). Why it is wrong. Re-test: <framing>. Held: n/2`
Each lesson's warm-up re-tests one entry; two holds in a row closes it.

## Current

Topic: 08b — Maps: `HashMap` internals, `LinkedHashMap`, `TreeMap`, `Hashtable` (SOURCES rows 9, 10). Step: not started. (06b — `final`, nested classes — has no source rows and waits behind the PDFs.)

Last review: 2026-09-06 (topic 01).

## Completed

| # | Topic | Date | Confidence | Notes |
|---|---|---|---|---|
| 01 | Types, values and references | 2026-09-01, reviewed 2026-09-06 | solid | Review closed four of five weak spots. Exercise and task both clean on first attempt, diagnosed from symptoms with no TODOs. |
| 02a | Strings — immutability, the pool, `==` vs `equals` | 2026-09-21 | ok | Exercise clean in one attempt. Drill: Q1 fully right with mechanism; Q2a answered the rule not the question; Q2b still ticked the blank final. |
| 02b | Strings — `StringBuilder` and loop concatenation | 2026-09-22 | ok | Spotted the disguised `new StringBuilder(sb)` bug unprompted and fixed it. But located the cost in allocation rather than copying, and left the headline `toCsv` case untouched after writing the identical fix one method below. |
| 03a | equals and hashCode — the contract, and how breaking it corrupts a `HashMap` | 2026-09-23 | shaky | Step 2 capped at two rounds. Needed a full Arabic step-by-step re-teach before step 3; Report B then took two wrong tries and two hints. Drill: Q1 right on `==` but opened with "`equals` compares values"; Q2 called `equals` without `hashCode` "not a bug". |
| 04a | Abstract class vs interface | 2026-09-27 | ok | Step 2 capped on `private` interface methods. Step 3: first put the counter in `FileSink`, corrected without a hint, then clean fix (abstract hooks, own field per class) with the right reason. Drill: Q1 right; Q2 listed state, constructors, visibility but missed `final` methods. |
| 04b | Composition over inheritance + OOP | 2026-09-29 | shaky | Step 2: Set size wrong, leaking getter called composition; two re-tests capped (GC reachability, "designed for extension"). Step 3: one level-1 hint, composition fix right first try, then closed two leaks (`public` field, `public final`). Why `ArrayList` skipped the limit: "return type boolean". Drill: Q2 passed with the right conditions. (Q1 on the four OOP concepts was drilled without being taught — not graded; SOURCES row 1 moved to 05.) |
| 04c | Constructors | 2026-09-30 | shaky | Mechanics good, articulation not. Step 2: Q1 called the hidden `super()` failure a "missing field", then passed the re-test with reasons. Step 3 clean first try, and did not add a no-arg constructor to the parent. Drill: both questions failed after one probe ("why not inherited", "what does a constructor return"). |
| 05a | Overriding vs overloading, static hiding | 2026-10-02 | ok | Step 2: Q1 and Q2 wrong, re-test A passed, re-test B output right but reason missed, Q3 right. Step 3: one level-1 hint, then all three reports fixed, with B moved onto the receiver rather than `instanceof`; `equals(Object)` cast without a type check. Drill: both passed with the mechanism (declared type, compile time), no probe needed. Never said the word "hiding". |
| 05b | Dynamic dispatch, the four OOP concepts, varargs | 2026-10-03 | ok | Dispatch and encapsulation landed, varargs resolution did not. Step 2: one of three right; re-tests on dispatch and encapsulation passed with reasons, varargs capped. Step 3: all three reports fixed first try, no hints, validation shared by constructor and setter; `@Override` left off. Drill: Q1 passed after one probe; Q2 failed, answer flipped when the declarations were swapped. |
| 06a | `static` and class initialisation | 2026-10-04 | ok | Step 2: one of three right (static vs instance access); both re-tests passed with reasons. Step 3: all three reports fixed first try, no hints, told "per class" from "per object" in both directions; dropped `private` from `Ticket.next`. Drill: both base answers passed, both probes failed (first use of the main class; said static binding happens at runtime). |
| 08a | List and Set, backing structure and Big O | 2026-10-07 | shaky | Sets landed, the headline list question did not. Step 2: Q1 wrong (`LinkedHashSet` read as `LinkedList`, `HashSet` order called known), re-test capped on "`contains` walks the links". Step 3: A and B first try, C after one level-1 hint, fixed by copying into an `ArrayList` rather than for-each. Drill: Q1 (`ArrayList` vs `LinkedList` middle insert) failed, still O(1) for `LinkedList` after the probe; Q2 passed (O(n²), `HashSet`, bucket reason), its *Then* got "slower" with no Big O. |

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
  08a warm-up (2026-10-05): held. Held: 1/2

- **Calls a broken `equals`/`hashCode` contract "not a bug". 03a drill.** Asked flat "is overriding
  `equals` without `hashCode` a bug?", answered "not a bug, it creates mini buckets", framing a
  correctness failure as a storage detail. It is a bug: equal objects get different identity hashes,
  so a `HashSet` keeps duplicates and `map.get(equalKey)` returns `null`. This happened one step
  after fixing exactly that in `Sku`. Same pattern as the flat "is `+` slow?" in 02b. Re-test flat.
  08a warm-up (2026-10-07): held. Said yes, size 2, different identity hashes so `equals` never
  runs, and gave the fix. Held: 1/2
- **"`equals` compares values" as a blanket rule. 03a drill.** `Object.equals` is `==`. It compares
  values only when the class overrides it. The follow-up "depends on Point's equals" rescued it, but
  the opening line is the one an interviewer writes down.
- **Renaming a hashed key: did not reach remove-then-put unaided. 03a step 3.** First renamed to the
  same name, then `put` the new key and left the old entry orphaned. Needed hints on left-to-right
  argument evaluation, and that a fresh equal key finds the stored entry.

- **`private` interface methods: read as `default`. Two rounds, capped in 04a step 2.** Knew Java 9
  added `private` methods, yet said `(b)` compiles "but I don't know why", then on the re-test called
  `private String wrap(...)` "a default method" and said an implementor can call it. It cannot:
  `private` is visible only inside the interface body; it exists so defaults share a helper without
  leaking it into every implementor's API. Re-test by asking who can call a given interface member.
  Diamond fix syntax closed on the re-test (`A.super.who()` inside the override).
  04a drill: now knows `private` exists and breaks "all methods are public"; "who can call it" was not re-tested.

- **Abstract class vs interface: missed `final` as a reason. 04a drill.** Listed state, constructors
  and visibility, but not that an abstract class can make a template method `final`; an interface
  `default` can always be overridden, so the interface cannot lock its algorithm. Re-test by asking
  how to stop an implementor from overriding `export()`.
  04c warm-up: said `final` (right), but also offered `private`/`static`, which break a public
  template method. Gave the interface reason as "only signatures" rather than "`final` is not allowed
  on an interface method, so a `default` can always be overridden".
  05a warm-up: failed again, offered `static`/`private` and gave "interface methods are public" as
  the reason. Held: 0/2

- **Constructors not inherited: gave the consequence as the reason. 04c drill.** Said "because they
  can't be overridden". That follows from not being inherited; it is not why. If `Employee(String)`
  were inherited, `new Manager("Sara")` would build a `Manager` whose own fields (`reports`) nobody
  initialised. Each class must initialise its own part. "I don't know" after the probe. Re-test by
  asking what an object built through an inherited parent constructor would look like. Held: 0/2
- **"A constructor returns the new instance". 04c drill.** A constructor returns nothing, not even
  `void`. It runs on an object `new` already allocated, and `new` returns the reference. This was
  drawn in step 1. It also answered part two of the question instead of part one (see the
  adjacent-question entry). Re-test flat: "what does a constructor return?" Held: 0/2

- **Reachability: did not answer whether a leaked part is GC-eligible. Two rounds, capped in 04b step 2.**
  `Engine e = new Car().getEngine();` then asked if the `Engine` can be collected, answered "idk".
  It cannot: `e` still references it. The `Car` is collectable and the `Engine` is not, which is
  why a getter turns composition into aggregation. The fix half was right (defensive copy
  `return new Engine(engine)`). Also first said a leaking getter was still composition because
  `new` happened inside. Re-test by asking which object outlives which.
- **Inheritance: is-a is not enough. Two rounds, capped in 04b step 2.** Gave only "use it when
  is-a holds", then "I don't know" for the second condition. `CountingSet extends HashSet` is a
  valid is-a and still counts double. The missing condition is that the parent is **designed and
  documented for extension** (it says which methods call which, as `AbstractList` does), or that
  you own it. Re-test flat: "`X` is a `Y`, so should `X extends Y`?"

- **Wrong reason for a bypassed override. 04b step 3.** Said `ArrayList.addAll` skipped the `add`
  override because of "a different method with return type boolean". It copies the array with
  `System.arraycopy` and never calls `add`. Self-use goes either way (`HashSet` calls it).
- **`final` read as protection. 04b step 3.** Fixed a leaking `public` field by adding `final`.
  `final` freezes the reference, not the object; `cart.list.addAll(...)` still worked.

- **Static hiding explained as "not overridden". Two rounds, capped in 05a step 2.** First called an
  instance method calling a static one a compile error (the restriction runs the other way). On the
  re-test got the output (`prod`) but said the method "only exists in `Config`" while `TestConfig`
  declares its own `env()`. The reason is binding: the compiler turns `env()` inside `Config` into
  `Config.env()`, and a static call is never dispatched. Re-test by asking why the subclass's
  static method was *not* picked.
  05a drill (2026-10-02): asked in that framing, gave the binding reason unaided ("the compiler
  picks the declared type and ignores the actual object"). Not counted as a hold: same sitting as
  the hint table and the card. Did not use the word "hiding".
  05b warm-up: failed. Said `show()` is not overridden so `Config`'s body calls `Config`'s `env()`,
  with no mention of `static` or compile-time binding; then predicted `prod` for the instance
  version too.
  06a warm-up (2026-10-04): not held. Gave the rule's name ("static cannot be overridden") rather
  than the binding, but got the instance version right this time. 06a drill: said "declared type
  `A`" unaided, then on the probe said the choice is made "at runtime, I think" and still did not
  produce the word "hiding". Re-test: ask *when* the choice is made. Held: 0/2
- **`equals(Object)` that casts without a type check. 05a step 3** (05a, 2026-10-02). Wrote
  `Tag tag = (Tag) obj;` then a null check, so `new Tag("java").equals("java")` throws
  `ClassCastException` where the contract wants `false`. Also left `@Override` off `equals` while
  adding it to the other two fixes. Re-test: hand over an `equals` and ask what it returns for a
  `String` argument. Held: 0/2
- **`@Override` read as a marker for the reader. 05a step 2.** It is a compiler check: no overridden
  method, no compile. Closed on the re-test (said adding it to a static method is a compile error).

- **Overload resolution read as declaration order** (05b, 2026-10-03). Three misses: `f(5)` with
  `f(Integer)` and `f(int...)` answered "varargs, closest type"; `g(7)` right but because "an `int`
  is an object"; in the drill `log("x", "y")` answered varargs, then "two" once the declarations
  were swapped, and confirmed "first in the file". Order in the file never matters. The compiler
  runs three phases and stops at the first with a match: exact/widening, then boxing, then varargs.
  And `7` reaches `g(Object)` by boxing to `Integer`; a primitive is never an object. Re-test: swap
  two overloads and ask whether the output changes. Held: 0/2
- **`@Override` left off a real override. 05a and 05b step 3** (05b, 2026-10-03). Knows it is a
  compiler check, does not write it. Rename the parent method and the subclass method silently
  stops overriding. Re-test: hand over a subclass and ask what is missing. Held: 0/2
- **"A call inside a parent method stays in the parent". 05b step 2.** Predicted `prod` for an
  inherited `show()` calling an overridden instance `env()`. Unqualified `env()` is `this.env()`.
  Closed on the re-test and in the exercise.
- **"`private` plus getter and setter is encapsulation". 05b step 2.** Closed on the re-test, the
  exercise and the drill probe (said the setter needs a guard).

- **Class loading and initialisation treated as one thing** (06a, 2026-10-04). Drill probe: asked
  what the first use of `Main` is under `java Main`, answered with a different trigger (a
  non-constant static field read) and "first use means the class needs to load at runtime". The
  launcher initialises the main class before calling `main`; loading alone runs no static code.
  Also said "the compiler initialises statics" in step 2: the JVM does. Re-test flat: "a static
  block runs when the class is loaded — true?" Held: 0/2
- **"Static initialisation re-runs on every use". 06a step 2.** Predicted a second line for a
  second `new`, and `init` twice. Closed on the re-test and in the exercise.
- **"Reading a constant triggers initialisation". 06a step 2.** Closed on the re-test (`MAX`
  inlined, `MIN = Integer.parseInt("1")` not). The blank-final half of the constant-variable entry
  above was not re-tested in isolation.

- **"`LinkedList` inserts in the middle in O(1)"** (08a, 2026-10-07). Drill: answered O(1) for
  `linkedList.add(500_000, x)`, and again after a probe that drew the walk. The link itself is
  O(1), reaching the node is an O(n) walk, so the call is O(n). O(1) holds only at the two ends or
  at an iterator already standing there. Also gave O(1) for the `ArrayList` middle insert one line
  after writing that it is O(n); corrected on the probe. Re-test: ask what `add(i, x)` does
  *before* it links the node. Held: 0/2
- **Gives "slower" where a Big O is asked** (08a, 2026-10-07). Constant `hashCode`: said all keys
  share one bucket and it gets slower, no complexity. It is O(log n) once the bucket treeifies
  (O(n) before Java 8, or under 8 entries). Same family as the count entry above. Re-test: demand
  the O-term, refuse an adjective. Held: 0/2
- **`LinkedHashSet` read as a `LinkedList`; `HashSet` order called known** (08a, 2026-10-05, step
  2). "Linked" buys insertion order on a hash table, not list costs; `HashSet` promises no order.
  Not re-tested since. The capped "`contains` walks the links" closed in the drill ("searches the
  bucket, not the index"). Re-test: ask the cost of `contains` on a `LinkedHashSet`. Held: 0/2

- **Answers arrive without reasoning.** Four times in 02a step 2, and again in the drill: Q2b asked
  for a reason for each of five items, including the unticked ones, and got one line. The gap is not
  knowledge — it is articulation, which is exactly what an interview grades. Always ask for the
  reason, and do not accept the answer alone.
- Closed on 2026-09-06: pass-by-value vs pass-by-reference; copy vs live view (the two axes now
  drive the choice); `Integer` cache; unboxing NPE and `getOrDefault`; rebinding a parameter.

## Notes to self

- **Teaching language: English + light Egyptian Arabic.** Arabic for the room — and more Arabic
  than feels natural in English prose. Framing, encouragement, corrections and the nudge at the end
  of a step go in light Egyptian dialect: "خلينا نشوف", "واضح كده؟", "برافو",
  "غلط، وهقولك ليه".
  **Technical content stays English**: code, terms (reference, heap, proxy, bean, erasure), the
  step-1 explanation, and the reasoning for *why* something breaks. That is the exact vocabulary
  needed in the interview itself, so it never gets translated.
  Rule of thumb: **Arabic for the room, English for the material.**

- **Never mix Arabic and English in the same line.** A line is either pure Arabic — a short
  standalone phrase, with no English words, no `code`, no backticks, no trailing English
  punctuation — or pure English. Mixed right-to-left lines get visually scrambled in the terminal:
  words and punctuation jump to the wrong end and the sentence becomes unreadable. If a thought
  needs an English term or a code token, write that whole thought in English.

- **A sentence worth memorising is given twice** — the English line, then the Arabic line directly
  underneath it, never on the same line:

  ```
  A HashMap never searches — hashCode picks the bucket, equals picks the entry.
  ‫الهاش ماب مابيدورش، الهاش كود بيختار المكان والإيكوالز بيختار العنصر.‬
  ```

  The Arabic half is transliterated where a term has no natural translation, so the line stays pure
  Arabic. The English half is where the exact terms live — the Arabic is the memory hook, not the
  source of truth.

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
  **The PDF also decides the lesson content, not only the topic** (asked for on 2026-09-24). Before
  step 2, open the mapped question in the PDF (`pdftotext -layout`) and build steps 2 and 5 from
  what it actually asks and claims. Anything beyond the PDF is a follow-up, never the core.
