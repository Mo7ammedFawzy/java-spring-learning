---
lab: nama-erp
applies-to: C:\Projects\8080
stack: Java 21, Spring Boot 3.5.8, Spring 6.2.14, Hibernate 6.6.38, Maven multi-module monorepo
---

# Codebase map — where each concept really lives

Anchors for step 4 of a lesson. Every path here was verified to exist; line counts are from the
same check. Paths are repo-relative to `C:\Projects\8080`.

**Read the file before teaching from it.** Files drift. If an anchor no longer shows what this map
claims, search for a current example, teach that, and fix the entry — do not quote code from memory
and attribute it to a file.

**Prefer the small files.** Several anchors below are thousands of lines; those are listed to show
*shape*, and the lesson should quote a 10–40 line extract, never send the user to read the whole
thing.

---

## Repo facts worth knowing before teaching

| Fact | Consequence for lessons |
|---|---|
| Java **21**, Spring Boot **3.5.8**, Spring **6.2.14**, Hibernate **6.6.38** (root `pom.xml`) | Modern enough for records, pattern matching, virtual threads |
| **No Spring Boot parent POM** — Boot is a plain dependency | Most of this codebase is *not* a Spring app |
| Spring lives only in satellite apps: `cloudman`, `kitchenapp`, `pos`, `printing-server`, `delivery-queue`, `infra/nama-mcp` | `cloudman/` (32 files) is the Spring laboratory |
| **No Spring Data JPA.** Persistence is a hand-written generic repo over `EntityManager` | Excellent for teaching *what Spring Data does for you* |
| Most `@Entity` classes are **DSL-generated** (`src/main/generated/`) | Teach from hand-written entities in `src/main/java` only |

### What this repo does *not* contain

Absences are teaching material in their own right — the interview will ask about these, and the
honest answer is "we don't use it here, and here's what we do instead."

| Missing | What the repo uses instead |
|---|---|
| `Optional` as a null strategy | `ObjectChecker` (see topic 11) |
| `@Repository` / Spring Data | Hand-rolled `GenericRepoImpl` |
| `@Value` / `@ConfigurationProperties` / profiles | `nama.properties` + a `GeneralSettings.getInstance()` singleton |
| `@Async` / `@EnableAsync` | Raw `ExecutorService` |
| `sealed` / `permits` — zero occurrences | Abstract base + interface hierarchies |
| Mockito, AssertJ, `@SpringBootTest` | Hand-written fakes (see topic 38) |

---

## Track A — Java core

**04 — Classes, interfaces, abstraction**
- `infra/domain-base/.../infra/domainbase/common/detail/EntityDetailLine.java` (42 lines) — tiny
  abstract base; the right first read.
- `infra/domain-base/.../infra/domainbase/entity/base/MasterFile.java` (406) — readable middle of
  the hierarchy `BaseEntity` → `MasterFile` / `DocumentFile` → concrete entity.
- `infra/domain-base/.../infra/domainbase/entity/base/BaseEntity.java` (4,316) — **show the
  hierarchy, never the file.** Also a live example of what a base class becomes after 15 years.
- `infra/domain-base/.../infra/domainbase/entity/base/EntityAction.java` (339) — `interface
  EntityAction<T>` with ~8 `default` methods and an interface constant. Serves topics 04, 07, 21
  and 39 at once.

**Enums with behaviour (04)**
- `infra/nama-common/.../common/constants/FileContentType.java` (92) — constant-specific class
  bodies overriding a method. Contrast with `common/constants/Language.java` (6 lines) for the
  plain case.

**07 — Generics**
- `infra/nama-common/.../common/utilities/Converter.java` (24) and `Filter.java` (24) — two-line
  generic functional interfaces. The best possible first generics read: roll-your-own `Function`
  and `Predicate`, with a lambda and an anonymous class side by side.
- `infra/domain-base/.../infra/domainbase/persistence/repos/GenericRepo.java` (66) — generic repo
  interface, `<PersistedType extends Savable>`.
- `infra/domain-base/.../infra/domainbase/datafields/DataField.java` (232) —
  `DataField<T extends Comparable<? super T>>`, the classic `super`-bounded idiom.
- `infra/domain-base/.../infra/domainbase/common/processors/AbstractProcessor.java` (298) — two
  bounded params, one **recursively bounded** (`S extends IStatus<S>`). Advanced; save for after
  the basics land.

**10 — Streams and collections**
- `modules/basic/basic-services/.../services/base/impl/bi/EChartOptionBuilder.java` (270) —
  stream-first, readable, modern. The whole `impl/bi/` package is the most idiomatic-modern-Java
  corner of the repo (records, streams, `Collectors`).
- `infra/nama-common/.../common/utilities/CollectionsUtility.java` (601) — what the team wrote
  *before* streams. Good "why does this exist now that we have streams?" discussion.

**11 — Null discipline — the signature lesson of this repo**
- `infra/nama-common/.../common/utilities/ObjectChecker.java` (918) — `isEmptyOrNull`,
  `isNotEmptyOrNull`, `areEqual`, `getFirstNotNullObj`, `toStringOrEmpty`. `CLAUDE.md` **mandates**
  it over raw null checks.
- Real call site: `cloudman/.../man/services/ApiTokenFilter.java` uses
  `ObjectChecker.getFirstNotEmptyObj(header, param)` — a one-line coalesce to set directly against
  `Optional.ofNullable(...).orElseGet(...)`.
- Teach both, and the trade-off: a large legacy codebase can rationally prefer a null utility over
  retrofitting `Optional` across a million lines.

**12 — Exceptions**
- `kitchenapp/.../kitchen/services/KitchenAppException.java` + `KitchenUnauthorizedException.java`
  — a clean two-level `RuntimeException` hierarchy, ~40 and ~10 lines. Pair with the
  `@RestControllerAdvice` in topic 31 to teach exception → HTTP status end to end.
- `infra/nama-common/.../common/exceptions/NaMaServiceExcepption.java` — carries structured fault
  info. **The class name is genuinely misspelled in the codebase**; a good aside on why names are
  hard to fix once published.
- `infra/domain-base/.../infra/domainbase/util/NaMaFailureResultException.java` — wraps a `Result`.
  This repo does *both* exceptions and result objects; that tension is the lesson.

**13 — Records**
- `kitchenapp/.../kitchen/dtos/KitchenItem.java`,
  `modules/basic/basic-services/.../impl/bi/datacontext/DataPointIndex.java` — compact value types.
  ~35 files use records.

## Track B — JVM and concurrency

Primary text for topics 18–21: `dev-docs/docs/java-threading-concurrency-presentation.md` (829
lines). It already cites this codebase, **including a section named "Areas for Improvement"** —
use those as cautionary examples, clearly labelled.

- `attcron/.../attcron/common/TaskExecutorHolder.java` (369) — the best single concurrency read:
  `ExecutorService`, lifecycle, shutdown, try-with-resources. `attcron` is 24 files total, so the
  whole module is graspable.
- `infra/domain-base/.../infra/domainbase/entity/base/EntityAction.java` — a
  `ConcurrentHashMap<Object, AtomicBoolean>` used as a re-entrancy guard. Compact and real.
- `infra/domain-base/.../domain/caching/NamaLFRUCache.java` — `ConcurrentHashMap` caching plus
  eviction on an executor.
- `infra/domain-base/.../infra/domainbase/common/requests/TransactionalQueueProcessor.java` — a
  worker pool over a database queue; executors and transactions together.
- `infra/common-gui/.../erp/gui/server/GUIAsyncTasks.java` — async by raw `ExecutorService`.
  Contrast with `@Async`, which this repo never uses.

## Track C — Spring core

**`cloudman/` is the laboratory.** 32 Java files, its own `pom.xml` and `application.properties`.

- `cloudman/.../man/services/CloudManSecurityConfig.java` (76) — the best Spring config file here:
  `@Configuration`, three `@Bean` methods, **method-argument injection**, the modern lambda DSL.
- `kitchenapp/.../kitchen/KitchenApp.java` (58) — `@SpringBootApplication`, extends
  `SpringBootServletInitializer` for WAR deployment, `@EnableScheduling`, two `@Bean`s including
  an anonymous `WebMvcConfigurer`. The best Boot entry point to teach from.
- `cloudman/.../man/services/InstallerService.java`, `TomcatService.java` — plain `@Service`.
- `cloudman/.../man/services/WindowsStatusChecker.java` — `@Component` + `@Scheduled`. Only three
  files in the repo use `@Scheduled`.

**24 — Injection styles: teach this as a contrast, not a model.**
This repo is almost entirely **field injection via `@Autowired`** —
`cloudman/.../man/controllers/rest/CloudInstaller.java`, `CloudTomcatApi.java`,
`CloudWindowsApi.java`, `kitchenapp/.../controllers/rest/KitchenCustomerController.java`.
Constructor injection appears only as method injection on `@Bean` methods. Show the real code, then
show why constructor injection is what an interviewer wants to hear — testability without a
container, `final` fields, and circular dependencies failing fast instead of hiding.

## Track D — Spring Boot, data and web

**30–31 — Web**
- `kitchenapp/.../kitchen/services/GlobalExceptionHandler.java` (92) — `@RestControllerAdvice`,
  four `@ExceptionHandler` methods mapping exception types to `ResponseEntity` + status, with the
  error DTO in the same file. Self-contained and close to ideal.
- `cloudman/.../man/services/GlobalExceptionHandler.java` — a second, smaller one for comparison.
- `cloudman/.../man/controllers/rest/CloudTomcatApi.java`, `CloudWindowsApi.java` — clean
  `@RestController` endpoints.
- `cloudman/.../man/dtos/` — 12 tiny DTOs; a whole DTO layer readable in ten minutes.

**32–35 — Persistence**
Primary text: `dev-docs/docs/hibernate-presentation.md` (921 lines), including a long walkthrough of
this repo's own `Persister`.
- `infra/domain-base/.../infra/domainbase/persistence/repos/GenericRepo.java` (66) — start here,
  then `GenericRepoImpl.java` (515) for `EntityManager`, JPQL and `@Transactional`.
- `infra/domain-base/.../persistence/repos/DecoratedGenericRepo.java` — the Decorator pattern on a
  repository.
- `infra/domain-base/.../infra/domainbase/common/criteria/CriteriaBuilder.java` (388) — the house
  query builder; also the Builder anchor for topic 39.
- Hand-written entities (not generated):
  `modules/supplychain/supplychaindomain/.../domain/entities/SalesDocument.java`,
  `modules/hr/hrdomain/.../domain/entities/SalarySheet.java`.
- `infra/domain-base/.../bus/NamaTransactionTemplate.java` — programmatic transactions; set against
  declarative `@Transactional`, and against the self-invocation trap.
- `infra/domain-base/.../persistence/util/EntityLifeCyclerListener.java` — JPA lifecycle callbacks;
  doubles as the Observer anchor.

**37 — Security** (only `cloudman` has it)
- `cloudman/.../man/services/CloudManSecurityConfig.java` — `SecurityFilterChain`, form login,
  `InMemoryUserDetailsManager`, a `{noop}` password with a comment explaining why. **Also an
  excellent security code-review exercise**: hardcoded remember-me key, `permitAll` on `/api/**`,
  CSRF disabled. Use it that way once the concepts land.
- `cloudman/.../man/services/ApiTokenFilter.java` (55) — `OncePerRequestFilter`; short enough to
  read whole, and shows the chain contract (`doFilter` vs short-circuit 401).
- `kitchenapp/.../kitchen/security/KitchenCustomerTokenInterceptor.java` — a Spring MVC
  `HandlerInterceptor`. Filter vs interceptor is a common interview question; both are here.

## Track E — Practice

**38 — Testing.** 27 test files in the entire monorepo. No Mockito, no AssertJ, no
`@SpringBootTest`. That is itself the lesson.
- `modules/ai/aidomain/src/test/.../remote/CustomerServerAddressTest.java` (96) — JUnit 4, pure
  functions, behaviour-named methods (`defaultsToHttpsWhenNoSchemeIsTyped`). Best small starter.
- `modules/supplychain/supplychaindomain/src/test/.../invrequest/cost/` — the richest example
  here: six JUnit 5 test classes plus a hand-built `harness/` package — `InMemoryCostBackend` (a
  hand-written fake doing exactly what Mockito would), `CostScenarioBuilder` (builder for test
  data), `CostAssertions`, `TestRepoProvider`. A masterclass in testing without a Spring context.
- JUnit 5 lives in `supplychaindomain` and `accountingdomain`; JUnit 4 in `domain-base` and the
  `ai` modules. Note the JPMS run-configuration trap in `CLAUDE.md` before running any of them.

**39 — Patterns in the wild**
| Pattern | Anchor |
|---|---|
| Static factory | `infra/domain-base/.../infra/domainbase/util/ResultFactory.java` — smallest, read first |
| Factory + registry | `infra/domain-base/.../domain/factories/DomainReferenceFactory.java` |
| Builder | `.../common/criteria/CriteriaBuilder.java`; `kitchenapp/.../utils/KitchenUrlBuilder.java` (small) |
| Strategy | `.../entity/base/EntityAction.java` + the `EA*` implementations |
| Template method | `.../common/processors/AbstractProcessor.java` → `AbstractBizRequestQueueProcessor` |
| Observer | `.../persistence/util/EntityLifeCyclerListener.java`; `.../domain/caching/CacheEvictionListener.java` |
| Singleton | `infra/nama-common/.../common/utils/GeneralSettings.java` — set against Spring's singleton beans |
| Decorator | `.../persistence/repos/DecoratedGenericRepo.java` |
| Adapter | `.../entity/base/DataHolderXmlAdapter.java` |

**B2 — JPMS**
- `delivery-queue/src/main/java/module-info.java` (**11 lines**) — the whole module system in one
  screen. Start here.
- `infra/nama-common/src/main/java/module-info.java` (89) — a real library module.
- `infra/domain-base/src/main/java/module-info.java` (185) — `requires transitive` and
  `opens ... to` at scale.

---

## Traps when using this map

1. **`com/namasoft/infor/` is a real package**, sitting beside `com/namasoft/infra/`. It is a
   misspelling that stuck — `infra/domain-base/src/main/java/com/namasoft/infor/domainbase/util/actions/`
   genuinely exists. Do not "correct" it in a path, and do not assume a file is missing because the
   spelling looks wrong.
2. **`src/main/generated/` is machine-written.** Never teach style from a generated file, and never
   set an exercise that implies editing one.
3. **Some anchors are cautionary, not exemplary** — field injection everywhere, `{noop}` passwords,
   CSRF disabled, near-zero test coverage. Real code, worth studying, but say which kind it is.
   Presenting `CloudManSecurityConfig` as a security model to copy would be actively harmful.
4. **The generated-vs-handwritten split governs entity lessons.** 4,797 files contain `@Entity`;
   almost all are generated from the DSL. Only the hand-written ones listed above teach anything
   about JPA mapping decisions.

---

## Reading

This codebase carries two substantial teaching documents that already cite its own code. Where a
curriculum topic says "the active lab profile's text", these are it — assign the reading for step 1,
then run steps 2–7 on top of it rather than restating the explanation.

| Topic | Assigned reading |
|---|---|
| 18 Threads and the JMM | `dev-docs/docs/java-threading-concurrency-presentation.md` — section 1 (JMM, happens-before, volatile vs synchronized, reordering) |
| 20 Executors and async | same file — sections 2, 6, 7 |
| 21 Concurrent collections, atomics, ThreadLocal | same file — sections 4, 5, 8. Note its **"Areas for Improvement"** section: cautionary examples, label them as such |
| 32 JPA and Hibernate mapping | `dev-docs/docs/hibernate-presentation.md` — sections 1–2 |
| 33 Persistence context and lazy loading | same file — sections 3–4 |
| 34 Queries | same file — sections 5 and 9, plus the `Persister` walkthrough |
| 35 Transactions | same file — section 6 |

## Coding standards

`CLAUDE.md` at the repo root is the authority, with `UI-GUIDELINES.md` for the frontend. The rules a
learner is most likely to be flagged for at step 6:

- **Null and empty checks** go through `ObjectChecker` (`isEmptyOrNull`, `isNotEmptyOrNull`,
  `areEqual`, `getFirstNotNullObj`), and numeric/boolean data fields through `DecimalDF`,
  `IntegerDF`, `BooleanDF` helpers — never raw `x != null && !x.isEmpty()`.
- **No comments that restate the code.** The fix for an explanatory comment is an extracted,
  well-named method. Comments that explain *why* are correct and expected.
- **No hardcoded user-facing text.** Translation keys only, in both `cmn-ar-2.properties` and
  `cmn-en-2.properties`; DSL fields use `@TranslateField`.
- **A DSL change must be accompanied by regenerated output**, and schema migrations need a matching
  `DATABASE_VERSION` bump.

Use these to separate "wrong" (it breaks) from "flagged" (it works, but a reviewer here rejects it).

## Bonus track

Codebase-specific, not interview material. Worth doing once curriculum Track D is solid.

| # | Topic | Objective |
|---|---|---|
| B1 | The DSL and code generation | Reading: `dev-docs/docs/Entity-Creation-Guide.md`. Why the DSL exists, what the generators produce, the layered 5-module structure |
| B2 | JPMS in this repo | `module-info.java`, why running tests needs "do not use module path", split packages |
| B3 | Accounting effects | Reading: `dev-docs/docs/LEDGER_TRANSACTION_PATTERNS.md` |
