# Curriculum — Java + Spring Boot to interview strength

Ordered **Java-heavy first**: the language and the JVM before the framework, because Spring
questions in interviews bottom out in Java, and a candidate strong in Java can reason about a
framework they have not memorised. The reverse is not true.

Work top to bottom by default. Jumping is allowed — `/learn <topic>` goes straight there — but if a
topic's prerequisites are unmet the lesson says so first.

Codebase anchors for each topic live in `references/codebase-map.md`. Where a topic has existing
repo documentation, it is named here and becomes the assigned reading for step 1.

Legend: **★** asked in almost every interview · **☆** asked at senior level

---

## Track A — Java core

| # | Topic | Objective |
|---|---|---|
| 01 | Types, values and references ★ | Primitives vs references, what `=` copies, pass-by-value for object references, autoboxing and the integer cache |
| 02 | Strings ★ | Immutability and why, the string pool, `==` vs `equals`, `StringBuilder`, when concatenation in a loop actually costs |
| 03 | equals and hashCode ★ | The contract in full, why breaking it silently corrupts a `HashMap`, inheritance and symmetry, `instanceof` vs `getClass()` |
| 04 | Classes, interfaces, abstraction ★ | Abstract class vs interface, default and static interface methods, when a base class earns its place, composition over inheritance |
| 05 | Polymorphism and dispatch | Overriding vs overloading, dynamic dispatch, why overload resolution is a compile-time decision, covariant returns |
| 06 | Access, static, final | Encapsulation, static initialisation order, `final` on fields/params/classes, static nested vs inner classes and the hidden outer reference |
| 07 | Generics and erasure ★ | Type parameters, bounded types, PECS and wildcards, what erasure removes, why you cannot create a generic array, bridge methods |
| 08 | Collections ★ | The `List`/`Set`/`Map`/`Queue` landscape, `ArrayList` vs `LinkedList` for real, `HashMap` internals and resizing, `TreeMap` ordering, choosing under pressure |
| 09 | Iteration, Comparable, Comparator | Sorting contracts, comparator chaining, `ConcurrentModificationException` and fail-fast iterators |
| 10 | Streams and lambdas ★ | Lazy pipelines, intermediate vs terminal, `Collectors` including `groupingBy`, functional interfaces, method references, where streams are the wrong tool |
| 11 | Optional and null discipline ★ | The intended use, the anti-patterns (`isPresent`/`get`, `Optional` fields and parameters), and how this repo does it instead with `ObjectChecker` |
| 12 | Exceptions ★ | Checked vs unchecked and the design argument, custom hierarchies, try-with-resources and `AutoCloseable`, suppressed exceptions, swallowing as a defect |
| 13 | Records, sealed types, pattern matching ☆ | Modern Java data modelling, exhaustive switch, when a record is right and when it is not |
| 14 | Immutability and defensive copying ☆ | Building genuinely immutable types, why it buys thread safety for free, and what it costs |

## Track B — JVM, memory and concurrency

| # | Topic | Objective |
|---|---|---|
| 15 | JVM memory model ★ | Heap, stack, metaspace, what lives where, `OutOfMemoryError` vs `StackOverflowError`, reading a stack trace properly |
| 16 | Garbage collection ★ | Generational collection, what makes an object unreachable, why finalizers are gone, GC pauses as a production symptom |
| 17 | Class loading ☆ | Loaders and delegation, static init timing, `NoClassDefFoundError` vs `ClassNotFoundException` |
| 18 | Threads and the Java Memory Model ★ | Reading: the active lab profile's concurrency text, if it declares one. Visibility, happens-before, volatile vs synchronized, instruction reordering |
| 19 | Synchronisation and locks ★ | `synchronized` mechanics, `ReentrantLock`, deadlock and how to prove one from a thread dump, race conditions |
| 20 | Executors and async ★ | Reading: same text, executor sections. Thread pools and sizing, correct shutdown, `CompletableFuture` composition, rejection policies |
| 21 | Concurrent collections, atomics, ThreadLocal ☆ | Reading: same text, concurrent-collection sections. `ConcurrentHashMap` vs a synchronised map, CAS and atomics, `ThreadLocal` leaks in a pooled server |

## Track C — Spring core

| # | Topic | Objective |
|---|---|---|
| 22 | IoC and dependency injection ★ | What the container actually does, why inversion of control matters, the problem DI solves |
| 23 | Beans: definition, scopes, lifecycle ★ | `@Component`/`@Service`/`@Repository`, `@Configuration` plus `@Bean`, singleton vs prototype vs request, lifecycle callbacks and their ordering |
| 24 | Injection styles ★ | Constructor vs field vs setter and why constructor wins, `@Qualifier`, `@Primary`, resolving ambiguity, circular dependencies |
| 25 | Configuration and properties ★ | `@Value`, `@ConfigurationProperties`, profiles, property precedence, externalised config |
| 26 | AOP and proxies ★ | JDK dynamic proxies vs CGLIB, aspects and pointcuts, and **why self-invocation silently defeats `@Transactional` and `@Cacheable`** |
| 27 | Events and listeners ☆ | `ApplicationEvent`, listener registration, synchronous vs asynchronous publication |
| 28 | The container at startup ☆ | Refresh phases, `BeanPostProcessor`, `@Conditional`, what "the context failed to start" really means |

## Track D — Spring Boot, data and web

| # | Topic | Objective |
|---|---|---|
| 29 | Spring Boot auto-configuration ★ | What `@SpringBootApplication` unpacks to, starters, conditional configuration, how to see and override what Boot decided |
| 30 | REST controllers ★ | `@RestController`, mapping and binding, `@RequestBody`/`@PathVariable`/`@RequestParam`, status codes, content negotiation, DTOs vs entities |
| 31 | Error handling ★ | `@ControllerAdvice`, `@ExceptionHandler`, designing an error contract, what must never leak into a response |
| 32 | JPA and Hibernate mapping ★ | Reading: the active lab profile's persistence text, if it declares one. Entities, ids, relationships, the owning side, `@MappedSuperclass` |
| 33 | Persistence context and lazy loading ★ | Reading: same text, persistence-context sections. Entity states, the first-level cache, `LazyInitializationException`, dirty checking |
| 34 | Queries ★ | Reading: same text, query sections. JPQL/HQL, Criteria, native SQL, projections, pagination |
| 35 | Transactions ★ | Reading: same text, transaction sections. `@Transactional`, propagation, isolation, rollback rules, read-only, and the self-invocation trap again |
| 36 | Performance: N+1 and caching ☆ | Diagnosing N+1, fetch joins and entity graphs, first vs second level cache, when caching is the wrong answer |
| 37 | Spring Security basics ☆ | The filter chain, authentication vs authorisation, method security, common misconfigurations |

## Track E — Engineering practice

| # | Topic | Objective |
|---|---|---|
| 38 | Testing ★ | JUnit 5, Mockito, what is worth mocking, unit vs slice vs `@SpringBootTest`, judging the real coverage of whatever codebase the lab profile points at, and what its gaps cost |
| 39 | Design patterns in real code ☆ | Factory, builder, strategy, template method, observer — each identified in this codebase rather than in a textbook |
| 40 | SOLID and review judgement ☆ | The principles as review arguments, plus the coding standards declared by the active lab profile |
| 41 | System design for Java interviews ☆ | Layering, transaction boundaries, idempotency, API versioning — the questions that follow "tell me about a system you built" |

---

## Lab-specific bonus track

Not interview material. When a lab profile is active it may declare its own topics — the
architecture, conventions and generated-code rules of that particular codebase. Read them from the
profile's own "Bonus track" heading. In codebase-free mode there are none.
