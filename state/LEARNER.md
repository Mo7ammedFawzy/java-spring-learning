# Learner profile — what I already know

Read at the start of every learning session, in every track. It answers one question for the
mentor: **what can this lesson assume, and what can it build on?**

## How to use this file

- **Bridge, do not re-teach.** When a lesson's concept has an equivalent in a *production* row
  below, open from that equivalent and spend the time on the difference.
- **This file is claimed; `state/PROGRESS.md` is measured.** Where they disagree, PROGRESS wins.
  Production use of a technology proves it was shipped, not that every mechanism under it can be
  explained in an interview — several Java-core topics are marked `shaky` there despite daily
  production Java.
- **Levels** — `production`: used daily in shipped work, for more than a year. `project`: used in
  personal projects only. `none`: not used.
- The learner edits this file. A lesson never does; gaps a lesson finds go to PROGRESS as weak
  spots.

Source: the learner's own profile document, last extracted 2026-10-10.

## Frontend

| Technology | Level | Evidence | Use it to teach |
|---|---|---|---|
| Vue 3, Composition API, `<script setup>` | production | Main client of a large ERP: 57 components and views written, core grid component owned | Every React topic. The primary bridge for the React track |
| Vue reactivity internals — how `ref`, `computed` and `watch` track dependencies | project | Not self-rated: assumed. Used correctly every day, but the mechanism (dependency tracking, why destructuring loses reactivity, why `computed` is lazy) is unverified | R03–R04 (state, the render model) open with a two-minute check of the Vue side before building the contrast on it. Raise this to `production` if that check is clean |
| TypeScript | production | 26 modules written; typed props, generics, composables | React is taught in TypeScript from the first lesson; type syntax is never explained |
| Pinia | production | Daily | Zustand (R29), and what a store is at all |
| Composables, VueUse | production | Daily | Custom hooks (R17) |
| Vue Router | production | Route gating, authorisation-aware UI | React Router (R32), Next.js routing (R33) |
| Quasar, SCSS, light/dark theming | production | Theming and icon system built | Styling is never a lesson topic; assume it |
| AG Grid Enterprise, AG Charts | production | Top contributor to the grid component; major-version upgrades, custom renderers, server-side filtering | Performance topics (R23): a real case of rendering thousands of rows |
| Monaco, FullCalendar | production | SQL console with custom completion; booking screen | Wrapping a non-framework widget: refs and effects (R12, R13) |
| i18n, RTL (Arabic/English) | production | Every feature shipped bilingual | Context (R11): locale is the textbook use |
| Nuxt | project | Portfolio and marketing sites | Next.js (track RF): file routing and SSR are known ideas; Server Components are not |
| Tailwind, Nuxt UI, Vuetify, Bootstrap | project | Personal projects | — |
| React, Next.js | none | — | The React track starts at R01 |
| Redux, Zustand, TanStack Query | none | — | — |

## Backend

| Technology | Level | Evidence | Use it to teach |
|---|---|---|---|
| Java 21 | production | 168 files written in an ERP backend | The language is used daily, but its mechanisms are being rebuilt from topic 01 — see PROGRESS, not this row |
| Jakarta EE: Servlets, JAXB | production | Web-service contracts and implementations | Spring MVC by contrast: what the framework adds over a servlet |
| JPA, Hibernate, Criteria API | production | 10 entities and about 21 detail entities designed; `GROUP BY` support added to a Criteria query builder | Persistence topics start above the basics: mapping and queries are known, the persistence context and transactions are to be verified |
| SQL Server, T-SQL | production | Versioned data migration; schema introspection through `INFORMATION_SCHEMA` | SQL topics; the dialect in examples |
| Jackson, Apache POI, HttpClient, JasperReports | production | Integrations and a build-time code generator | — |
| Design patterns: Factory, Adapter, Builder, Template Method, Singleton, Registry | production | Applied in feature work | System-design topics: ask for the instance already built, not a textbook one |
| Spring Boot, Spring Security | project | A layered CRUD service (controller → service → repository → DTO → mapper); hit and fixed a security misconfiguration | **Spring is not production knowledge.** The production backend is Jakarta EE on a proprietary framework. Teach Spring from the start; the layering vocabulary is known |
| JUnit 5, Mockito (including `MockedStatic`) | project | Unit tests for that service | Testing topics: syntax known, habits not — there is no test suite at work |
| Node.js, Express | project | A small API | — |

## Practices and tooling

| Area | Level | Note |
|---|---|---|
| Git, trunk-based workflow | production | — |
| Full-stack feature delivery: entity → service contract → UI | production | Ask for the whole path when a topic spans layers |
| Working in a large multi-module codebase; root-cause debugging | production | Symptom-driven exercises suit this |
| REST/SOAP-style service contracts | production | — |
| IntelliJ IDEA, VS Code, Postman | production | — |
| Automated tests in CI, CI/CD pipelines, containers, microservices | none | Not used at work. Do not assume them in examples; explain when they appear |
