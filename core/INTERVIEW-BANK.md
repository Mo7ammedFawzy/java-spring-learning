# Interview bank

Questions for step 7, keyed to `core/CURRICULUM.md` topic numbers. Each entry is written as the
interviewer sees it:

- **Q** — the question as asked
- **Shallow** — the answer that sounds right, is technically true, and does not get the job
- **Passes** — what a strong candidate says
- **Then** — the follow-up, because the real signal is in the second question

Ask the questions first and wait for answers. Only then reveal Shallow/Passes/Then. This file is a
starting set, not a ceiling — generate more in the same shape when a topic needs deeper drilling,
and add any question the user is asked in a real interview.

---

## 01 — Types and references

**Q.** Is Java pass-by-value or pass-by-reference?
- *Shallow:* "Pass-by-reference for objects, pass-by-value for primitives."
- *Passes:* Always pass-by-value. For objects the *reference* is copied by value — so mutating the
  object through it is visible to the caller, but reassigning the parameter is not.
- *Then:* "Write a `swap(a, b)` that works." (It cannot, for immutables — that is the point.)

**Q.** `Integer a = 127, b = 127; a == b`? And with 128?
- *Shallow:* "True, because they're equal."
- *Passes:* `true` then `false`. `Integer.valueOf` caches −128..127, so the small values are the same
  object. Above the cache, two distinct objects, and `==` compares references.
- *Then:* "So when is `==` on boxed types ever correct?" (Essentially never — use `equals`.)

## 03 — equals and hashCode

**Q.** Why must `equals` and `hashCode` be overridden together?
- *Shallow:* "Because it's the convention / good practice."
- *Passes:* Hash-based collections locate by bucket first. Two objects equal by `equals` but with
  different hash codes land in different buckets, so `map.get(key)` misses a key that is present.
  The object becomes unfindable in a `HashMap` and duplicable in a `HashSet`.
- *Then:* "What happens if you mutate a field used in `hashCode` after inserting into a `HashSet`?"
  (The object is lost — it hashes to a bucket it is not in.)

**Q.** `instanceof` or `getClass()` in `equals`?
- *Shallow:* "`instanceof`, it's cleaner."
- *Passes:* `instanceof` permits subclasses and can break symmetry (`a.equals(b)` true,
  `b.equals(a)` false); `getClass()` guarantees symmetry but breaks Liskov substitution. The real
  answer is to make the class `final`, or use composition, and cite Bloch's item on it.
- *Then:* "Which does `AbstractList` use, and why can it get away with it?"

## 07 — Generics

**Q.** What is type erasure, and what does it cost you?
- *Shallow:* "The compiler removes the generic types at runtime."
- *Passes:* Type parameters are erased to their bound (`Object` if unbounded) after compile-time
  checking. Consequences: no `new T[]`, no `instanceof List<String>`, no overloading on
  `List<String>` vs `List<Integer>` (same erasure), and unchecked-cast warnings when going the other
  way. Bridge methods are synthesised to preserve polymorphism.
- *Then:* "Then how does `Collections.emptyList()` return the right type?" (Inference at the call
  site; the object itself is untyped.)

**Q.** Explain PECS.
- *Shallow:* "Producer extends, consumer super."
- *Passes:* The mnemonic *plus* why: `? extends T` lets you read `T` but not write (the actual type
  could be narrower); `? super T` lets you write `T` but reads come back as `Object`. So a parameter
  you only read from is `extends`, one you only write into is `super`.
- *Then:* "Why is `Collections.copy(dest, src)` declared `List<? super T> dest, List<? extends T> src`?"

## 08 — Collections

**Q.** How does `HashMap` work internally?
- *Shallow:* "It uses hashing to store key-value pairs."
- *Passes:* Array of buckets; `hash(key)` spread and masked to an index; collisions chain in a
  linked list that becomes a red-black tree past a threshold (8, with capacity ≥ 64); resizes at
  load factor 0.75 by doubling and rehashing. Get is O(1) amortised, O(log n) in a treeified bucket.
- *Then:* "What happens with a deliberately bad `hashCode` returning a constant?" (Everything in one
  bucket — degrades to O(log n) after treeification, and was O(n) before Java 8. A DoS vector.)

**Q.** `ArrayList` or `LinkedList`?
- *Shallow:* "`LinkedList` for lots of insertions, `ArrayList` for random access."
- *Passes:* Almost always `ArrayList`. `LinkedList`'s theoretical O(1) insert requires you to
  already hold the node; reaching it is O(n), and its cache locality is terrible, so it loses in
  practice at nearly every size. `LinkedList` is defensible mainly as a `Deque`.
- *Then:* "When did you last legitimately use a `LinkedList`?"

## 10 — Streams

**Q.** What does laziness mean in a stream pipeline?
- *Shallow:* "It doesn't evaluate until you need it."
- *Passes:* Intermediate operations only build the pipeline; nothing runs until a terminal operation.
  Then elements are pulled one at a time through the whole chain, which is why `filter` before `map`
  matters and why short-circuiting (`findFirst`, `anyMatch`, `limit`) can avoid touching most of the
  source.
- *Then:* "What does a stream with no terminal operation do?" (Nothing at all.)

**Q.** When should you *not* use a stream?
- *Shallow:* "When the collection is small."
- *Passes:* When you need to mutate the source, when you need an index, when checked exceptions are
  involved, when the loop needs to `break` in a way short-circuiting cannot express, and when the
  stream version is simply harder to read. Also: `parallelStream` on small or IO-bound work is
  usually slower and shares the common `ForkJoinPool`.
- *Then:* "What is wrong with a `forEach` that adds to an `ArrayList` in parallel?"

## 11 — Optional and null

**Q.** What is `Optional` for?
- *Shallow:* "To avoid `NullPointerException`."
- *Passes:* To make "possibly absent" explicit in a **return type**, so the caller cannot ignore it.
  It is not a general null replacement: not for fields (not serialisable, adds allocation), not for
  parameters (the caller can just pass null, and now you have two absent states).
- *Then:* "What is wrong with `if (o.isPresent()) return o.get();`?" (It is the null check with more
  ceremony — use `map`/`orElse`/`orElseThrow`.)

*Lab tie-in:* some codebases do not use `Optional` at all. If the active lab profile names a
house null-checking utility, teach that contrast here. Be ready to explain both, and why a large legacy codebase might rationally
choose a null-checking utility over retrofitting `Optional`.

## 12 — Exceptions

**Q.** Checked or unchecked for a new API?
- *Shallow:* "Unchecked, checked exceptions are bad."
- *Passes:* Checked when the caller can plausibly recover and you want to force the decision;
  unchecked for programming errors and unrecoverable conditions. Note the practical drift: modern
  APIs, streams and lambdas all push toward unchecked, and Spring converts SQL exceptions to an
  unchecked hierarchy deliberately.
- *Then:* "Why did Spring wrap `SQLException` in `DataAccessException`?"

**Q.** What does try-with-resources actually generate?
- *Shallow:* "It closes the resource automatically."
- *Passes:* A `finally` that calls `close()` in reverse declaration order, plus suppressed-exception
  handling — if the body throws and `close` also throws, the close exception is attached via
  `addSuppressed` rather than replacing the original. Hand-written `finally` blocks usually lose
  the original exception.
- *Then:* "Which one do you see in the stack trace, and where is the other?"

## 15 — Testing

**Q.** What is worth mocking?
- *Shallow:* "Everything the class depends on."
- *Passes:* Mock what is slow, non-deterministic, or outside your control — network, clock, external
  services. Do not mock value objects or the type under test, and be wary of mocking types you do
  not own, since the mock encodes your *belief* about their behaviour. Over-mocking produces tests
  that pass while production breaks.
- *Then:* "What is the difference between a stub and a mock, and which does an assertion belong on?"

**Q.** `@SpringBootTest` or a slice test?
- *Passes:* Slice (`@WebMvcTest`, `@DataJpaTest`) whenever it suffices — it boots a fraction of the
  context and runs in a fraction of the time. Reserve full `@SpringBootTest` for wiring and
  end-to-end checks. Note that context caching across test classes matters enormously, and that a
  `@MockBean` in one class fragments that cache.
- *Then:* "Why did adding one `@MockBean` make the whole suite slower?"

## 18–22 — SQL and persistence

**Q.** What is `LazyInitializationException` and how do you fix it?
- *Shallow:* "Make the relationship eager."
- *Passes:* A lazy proxy was touched after the persistence context closed — typically in a
  controller or a serialiser, outside the transaction. Fixes in order of preference: fetch what you
  need inside the transaction (fetch join or entity graph), or map to a DTO before returning.
  Switching to `EAGER` fixes the symptom and creates an N+1 everywhere else.
- *Then:* "Why is `open-session-in-view` a bad default?" (It hides the problem and holds a
  connection for the whole request.)

**Q.** Propagation `REQUIRED` vs `REQUIRES_NEW`?
- *Passes:* `REQUIRED` joins the caller's transaction, so a rollback anywhere rolls back everything.
  `REQUIRES_NEW` suspends it and starts an independent one — used for audit or logging writes that
  must survive the caller's rollback. It costs a second connection and can deadlock against the
  suspended transaction.
- *Then:* "Default rollback rule?" (Unchecked exceptions and `Error` roll back; **checked
  exceptions do not**, unless `rollbackFor` says so. This one catches nearly everybody.)

**Q.** How do you detect and fix N+1?
- *Passes:* Turn on SQL logging or statistics and look for one query followed by *n*; it comes from
  lazy associations touched in a loop. Fix with a fetch join, an entity graph, or batch fetching —
  and verify by counting queries, not by eyeballing.
- *Then:* "What happens if you fetch-join two collections in one query?" (Cartesian product; use
  `distinct`, batching, or separate queries.)

## 23–27 — Spring core

**Q.** Constructor injection or field injection?
- *Shallow:* "Constructor injection, it's recommended."
- *Passes:* Constructor injection makes dependencies explicit and mandatory, allows `final` fields,
  makes the class instantiable in a plain unit test without a container, and surfaces circular
  dependencies at startup instead of hiding them. Field injection needs reflection to test and lets
  a class accumulate dependencies invisibly.
- *Then:* "What does Spring do with a circular dependency under constructor injection?" (Fails fast
  — and that is the feature.)

**Q.** Default bean scope, and when is it wrong?
- *Shallow:* "Singleton."
- *Passes:* Singleton per container. It is wrong the moment the bean holds mutable per-request
  state — that state is then shared across every thread. This is the most common Spring bug in
  interviews: an instance field on a `@Service`.
- *Then:* "How do you inject a prototype bean into a singleton correctly?" (`ObjectProvider`, lookup
  method, or scoped proxy — not plain injection, which resolves once.)

**Q.** Why does `@Transactional` sometimes do nothing?
- *Shallow:* "The method isn't public."
- *Passes:* Two reasons, and both are proxy consequences. Self-invocation: calling the annotated
  method from another method of the same class goes through `this`, not the proxy, so no advice
  runs. And non-public methods are not advised by the default proxy strategy. The fix is to move
  the method to another bean, self-inject, or use AspectJ weaving.
- *Then:* "JDK proxy or CGLIB — and which does Boot default to?" (CGLIB by default since Boot 2, so
  the class must be non-final with a usable constructor.)

## 30–32 — Spring Boot and web

**Q.** What does `@SpringBootApplication` do?
- *Shallow:* "It marks the main class."
- *Passes:* It composes `@Configuration`, `@ComponentScan` (from the annotated class's package
  down — which is why placement matters), and `@EnableAutoConfiguration`, which loads conditional
  configuration classes registered in `META-INF/spring/...AutoConfiguration.imports` and backs off
  wherever you have defined your own bean.
- *Then:* "How do you find out why a bean you expected is missing?" (The auto-configuration report:
  `--debug`, or the `ConditionEvaluationReport`.)

## 37–40 — Concurrency

**Q.** What does `volatile` guarantee, and what does it not?
- *Shallow:* "It makes the variable thread-safe."
- *Passes:* Visibility and ordering — a write is visible to subsequent reads, and it establishes
  happens-before. It does **not** give atomicity: `count++` is read-modify-write and still races.
  Use it for flags and for the double-checked-locking instance field.
- *Then:* "Make a thread-safe counter without `synchronized`." (`AtomicInteger`, CAS.)

**Q.** Why is double-checked locking broken without `volatile`?
- *Shallow:* "Because of caching."
- *Passes:* The constructor's writes can be reordered with the assignment of the reference, so
  another thread can observe a non-null but partially constructed object. `volatile` on the field
  forbids that reordering — correctly, only since the Java 5 memory model.
- *Then:* "What would you use instead in new code?" (Holder idiom, or an enum singleton.)

**Q.** How do you size a thread pool?
- *Shallow:* "Number of cores."
- *Passes:* CPU-bound: roughly cores + 1. IO-bound: cores × (1 + wait/service time) — much larger.
  Then the questions that matter more than the number: what queue, bounded or not, and what
  rejection policy. An unbounded queue turns backpressure into an `OutOfMemoryError`.
- *Then:* "What does `Executors.newFixedThreadPool` use for its queue?" (Unbounded `LinkedBlockingQueue`
  — which is why production code builds its own `ThreadPoolExecutor`.)

**Q.** How would you diagnose a deadlock in production?
- *Passes:* Thread dump (`jstack`, or `kill -3`); the JVM detects and prints Java-lock deadlocks
  explicitly. Look for threads `BLOCKED` on a monitor held by another blocked thread, in a cycle.
  Fix by imposing a global lock ordering, or by using `tryLock` with a timeout.
- *Then:* "Which deadlocks will a thread dump *not* find?" (Lock-ordering across `ReentrantLock`
  is found; database deadlocks and semaphore/latch cycles are not.)

