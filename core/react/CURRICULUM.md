# Curriculum — React to interview and project strength

**ID prefix: `R`.** Topics are `R01`, `R02`, …; the prefix keeps them apart from every other
track's numbers in `state/PROGRESS.md` and in `playground/` directory names.

Taught **by contrast with Vue 3**, because that is what `state/LEARNER.md` records as
production-strength. Each row carries a *From Vue:* note naming the equivalent the lesson opens
from. The lesson spends its time on the difference, not on what transfers unchanged. If the learner
profile ever stops listing Vue, ignore those notes and teach the row cold.

Ordered **React before any library or framework**: the render model first, because every question
about a state library, a data library or Next.js bottoms out in "when does this component render,
and with which values". A candidate who can answer that can reason about a library they have not
memorised.

All code in this track is **TypeScript** (`.tsx`), from the first lesson.

Work top to bottom by default — **row order, not number order**: topics added later take the next
free number but sit in the row where they belong. Jumping is allowed, but if a topic's
prerequisites are unmet the lesson says so first.

Legend: **★** asked in almost every interview · **☆** asked at senior level

## Primary references

This track is built from official documentation. It is the source of truth: when a lesson, an
interview-bank answer or the mentor's memory disagrees with the linked page, the page wins, and the
bank gets corrected.

| Source | Covers |
|---|---|
| [react.dev](https://react.dev/) — Learn and Reference | Tracks RA, RB, RD. Row order follows its Learn path: Describing the UI → Adding Interactivity → Managing State → Escape Hatches |
| [react.dev/learn/typescript](https://react.dev/learn/typescript) and the [TypeScript Handbook](https://www.typescriptlang.org/docs/handbook/intro.html) | Track RC |
| [Zustand](https://zustand.docs.pmnd.rs/), [Redux Toolkit](https://redux-toolkit.js.org/), [TanStack Query](https://tanstack.com/query/latest), [React Router](https://reactrouter.com/home) | Track RE |
| [nextjs.org/docs](https://nextjs.org/docs) — App Router | Track RF. Written against Next.js 16; check the version banner on the page before teaching |

Each row ends with *Read:* and the exact page for that topic. That page is the assigned reading for
step 1, and the lesson cites it.

---

## Track RA — Core, by contrast

| # | Topic | Objective |
|---|---|---|
| R01 | JSX | JSX is JavaScript that returns a description of UI, not a template compiled with directives: `{}` for expressions, `className`, one root, fragments. *From Vue:* `<template>` with `v-if`/`v-for`/`:prop`; here control flow is plain JavaScript. *Read:* [Writing markup with JSX](https://react.dev/learn/writing-markup-with-jsx), [JavaScript in JSX](https://react.dev/learn/javascript-in-jsx-with-curly-braces) |
| R02 | Components and props | A component is a function called on every render; props are its arguments, read-only, typed with a plain interface. `children` is a prop. *From Vue:* SFC with `defineProps`; there is no `emit`, a callback prop does that job. *Read:* [Passing props to a component](https://react.dev/learn/passing-props-to-a-component) |
| R03 | State with `useState` ★ | State is memory React keeps between calls of the component function. `setX` requests a re-render; it does not change the variable in the running function. *From Vue:* `ref()` — but there is no `.value` and no proxy; nothing is tracked. *Read:* [State: a component's memory](https://react.dev/learn/state-a-components-memory) |
| R04 | The render model ★ | Trigger → render → commit. A render is a snapshot: props, state and handlers all belong to that one call. Why reading state right after setting it gives the old value. *From Vue:* fine-grained reactivity re-runs only the effects that read a changed ref; React re-runs the whole component function and its children. *Prereq: R03.* *Read:* [Render and commit](https://react.dev/learn/render-and-commit), [State as a snapshot](https://react.dev/learn/state-as-a-snapshot) |
| R05 | Updating state: immutability and batching ★ | Mutating an object or array in state changes nothing on screen, because React compares by reference. Copy-then-replace for objects and arrays; updater functions (`setN(n => n + 1)`); batching. *From Vue:* `state.items.push(x)` works there because of the proxy. Here it is the single most common bug a Vue developer writes. *Prereq: R04.* *Read:* [Queueing a series of state updates](https://react.dev/learn/queueing-a-series-of-state-updates), [Updating objects in state](https://react.dev/learn/updating-objects-in-state), [Updating arrays in state](https://react.dev/learn/updating-arrays-in-state) |
| R06 | Events and controlled inputs | Handlers are props (`onClick={fn}`, not `onClick={fn()}`); synthetic events; a controlled input is `value` + `onChange`, and omitting one of them is a bug with a known symptom. *From Vue:* `@click` and `v-model`; there is no two-way binding, you write both directions. *Read:* [Responding to events](https://react.dev/learn/responding-to-events), [`<input>`](https://react.dev/reference/react-dom/components/input) |
| R07 | Lists, keys and conditional rendering | `map` with a stable `key`; why the index is the wrong key; `&&` and its `0` trap, ternaries, early return. *From Vue:* `v-for` with `:key`, `v-if`/`v-else`, `v-show` (no built-in equivalent). *Read:* [Rendering lists](https://react.dev/learn/rendering-lists), [Conditional rendering](https://react.dev/learn/conditional-rendering) |
| R08 | Purity and Strict Mode | Rendering must be a pure calculation: same inputs, same JSX, no side effects. Strict Mode calls components and effects twice in development to expose the ones that are not. *From Vue:* `setup()` runs once, so impure setup code goes unnoticed; here the function body runs on every render. *Prereq: R04.* *Read:* [Keeping components pure](https://react.dev/learn/keeping-components-pure), [`<StrictMode>`](https://react.dev/reference/react/StrictMode) |

## Track RB — State and hooks

| # | Topic | Objective |
|---|---|---|
| R09 | Structuring and lifting state ★ | Avoid redundant, duplicated and contradictory state; derive during render instead of storing. Lift state to the closest common parent; "controlled" vs "uncontrolled" component. *From Vue:* `computed` for derived values, props down and `emit` up. *Read:* [Choosing the state structure](https://react.dev/learn/choosing-the-state-structure), [Sharing state between components](https://react.dev/learn/sharing-state-between-components) |
| R10 | `useReducer` | State transitions as a pure `(state, action) => state` function; when it beats several `useState` calls; typing actions as a union. *From Vue:* a Pinia store's actions, minus the mutation. *Read:* [Extracting state logic into a reducer](https://react.dev/learn/extracting-state-logic-into-a-reducer) |
| R11 | Context ★ | `createContext`, a provider, `useContext`. It is dependency injection, not a state manager: every consumer re-renders when the value changes, and an inline object value changes on every render. *From Vue:* `provide`/`inject`, where an injected ref updates only its readers. *Read:* [Passing data deeply with context](https://react.dev/learn/passing-data-deeply-with-context), [Scaling up with reducer and context](https://react.dev/learn/scaling-up-with-reducer-and-context) |
| R12 | Refs | `useRef` holds a mutable value that survives renders and does not trigger one; DOM refs; `ref` as a prop. Never read or write `ref.current` during render. *From Vue:* template refs for the DOM half; for the value half, a plain variable in `setup()` — which React cannot have, because the function re-runs. *Read:* [Referencing values with refs](https://react.dev/learn/referencing-values-with-refs), [Manipulating the DOM with refs](https://react.dev/learn/manipulating-the-dom-with-refs) |
| R13 | `useEffect` ★ | An effect synchronises the component with something outside React: setup, cleanup, dependency array. Think "start and stop synchronising", not "mounted and unmounted". Why it runs twice in development. *From Vue:* `watchEffect` plus `onMounted`/`onUnmounted`; dependencies are declared by hand rather than tracked. *Prereq: R04, R08.* *Read:* [Synchronizing with effects](https://react.dev/learn/synchronizing-with-effects), [Lifecycle of reactive effects](https://react.dev/learn/lifecycle-of-reactive-effects) |
| R14 | You might not need an effect ★ | The effects that should not exist: deriving state, resetting state on a prop change, reacting to a user event, chains of effects. What to write instead. Data fetching in an effect and its race condition. *From Vue:* the reflex to reach for `watch`; most of those become a calculation during render or code in an event handler. *Prereq: R13.* *Read:* [You might not need an effect](https://react.dev/learn/you-might-not-need-an-effect) |
| R15 | Rules of hooks, dependencies and stale closures ★ | Hooks only at the top level, only in components and hooks, and why (call order is the identity). Every reactive value an effect reads is a dependency; a stale closure is a snapshot captured by an old render. Removing a dependency by changing the code, not by lying to the linter; `useEffectEvent`. *From Vue:* none of this exists, since `setup()` runs once and refs are live. *Prereq: R04, R13.* *Read:* [Rules of hooks](https://react.dev/reference/rules/rules-of-hooks), [Removing effect dependencies](https://react.dev/learn/removing-effect-dependencies), [Separating events from effects](https://react.dev/learn/separating-events-from-effects) |
| R16 | `useMemo` and `useCallback` ★ | Caching a calculation or a function identity between renders. They are performance tools with a cost, useful only when something downstream compares by reference. What the React Compiler changes. *From Vue:* `computed` is cached by default and tracked automatically; here caching is opt-in and the dependencies are yours. *Prereq: R05.* *Read:* [`useMemo`](https://react.dev/reference/react/useMemo), [`useCallback`](https://react.dev/reference/react/useCallback) |
| R17 | Custom hooks ★ | Extracting stateful logic into a `use…` function. Hooks share logic, not state: two callers get two independent states. *From Vue:* composables — the closest match in the whole track, with one difference: a composable runs once, a hook runs on every render. *Prereq: R15.* *Read:* [Reusing logic with custom hooks](https://react.dev/learn/reusing-logic-with-custom-hooks) |

## Track RC — TypeScript in React

| # | Topic | Objective |
|---|---|---|
| R18 | Typing components, events and hooks | Props as an interface; `React.ReactNode` for children; `React.ChangeEvent<HTMLInputElement>` and friends; `useState<T>`, `useRef<T>(null)`, typed context with a non-null guard. Why `React.FC` is not needed. *From Vue:* `defineProps<T>()` and `defineEmits<T>()`. *Read:* [Using TypeScript](https://react.dev/learn/typescript) |
| R19 | Generic components | A component whose prop types are linked by a type parameter, e.g. `List<T>` with `items: T[]` and `render: (item: T) => ReactNode`. *From Vue:* `<script setup generic="T">`. *Prereq: R18.* *Read:* [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html) |
| R20 | Discriminated unions for state and props ☆ | Modelling loading / error / success as one union so impossible states cannot be represented; narrowing on the discriminant; props that depend on each other. *Prereq: R18.* *Read:* [Narrowing — discriminated unions](https://www.typescriptlang.org/docs/handbook/2/narrowing.html) |

## Track RD — Patterns and performance

| # | Topic | Objective |
|---|---|---|
| R21 | Composition with `children` and render props | Passing JSX as a prop is the whole slot mechanism. Named slots are extra props; a scoped slot is a function prop. Composition as the fix for prop drilling before reaching for context. *From Vue:* default, named and scoped slots. *Read:* [Passing JSX as children](https://react.dev/learn/passing-props-to-a-component#passing-jsx-as-children), [Thinking in React](https://react.dev/learn/thinking-in-react) |
| R22 | Reconciliation: preserving and resetting state ☆ | State belongs to a position in the render tree, not to the component function. Same component at the same position keeps its state; a different `key` resets it. Why a component defined inside another loses its state on every render. *From Vue:* `:key` on a component forces a remount there too, but the "position" rule is new. *Prereq: R07.* *Read:* [Preserving and resetting state](https://react.dev/learn/preserving-and-resetting-state) |
| R23 | `memo` and when it does nothing ☆ | `memo` skips a re-render when props are shallowly equal — so an inline object, array or function prop defeats it. Measure first; fixes that need no memoisation (move state down, pass children). *From Vue:* children do not re-render unless their own dependencies change, so this problem never appears. *Prereq: R16.* *Read:* [`memo`](https://react.dev/reference/react/memo) |
| R24 | Suspense, `lazy` and transitions | A Suspense boundary shows a fallback while something below it is not ready; `lazy` for code splitting; `useTransition` and `useDeferredValue` to keep the UI responsive during a non-urgent update. *From Vue:* `<Suspense>` with async `setup`, and `defineAsyncComponent`. *Read:* [`<Suspense>`](https://react.dev/reference/react/Suspense), [`lazy`](https://react.dev/reference/react/lazy), [`useTransition`](https://react.dev/reference/react/useTransition) |
| R25 | Error boundaries | A boundary catches errors thrown during rendering below it and shows a fallback. What it does not catch: event handlers, async code. Still a class component, or a library wrapper. *From Vue:* `onErrorCaptured`. *Read:* [Catching rendering errors with an error boundary](https://react.dev/reference/react/Component#catching-rendering-errors-with-an-error-boundary) |
| R26 | Portals | `createPortal` renders children into a different DOM node while keeping them in the React tree — so context still works and events still bubble to the React parent. *From Vue:* `<Teleport>`. *Read:* [`createPortal`](https://react.dev/reference/react-dom/createPortal) |
| R27 | Forms and actions | `<form action={fn}>`, `useActionState`, `useFormStatus`, `useOptimistic`; controlled vs uncontrolled forms and when each is right. *From Vue:* `v-model` on every field plus a submit handler. *Prereq: R06.* *Read:* [`<form>`](https://react.dev/reference/react-dom/components/form), [`useActionState`](https://react.dev/reference/react/useActionState) |
| R28 | React 19 and the compiler ☆ | What changed and what it removed: `use`, actions, `ref` as a prop, and the React Compiler, which memoises automatically and makes most hand-written `useMemo`/`useCallback`/`memo` unnecessary. What the compiler requires of your code (the rules from R08 and R15). *Prereq: R16, R23.* *Read:* [React 19](https://react.dev/blog/2024/12/05/react-19), [React Compiler](https://react.dev/learn/react-compiler), [`use`](https://react.dev/reference/react/use) |

## Track RE — State and data libraries

| # | Topic | Objective |
|---|---|---|
| R29 | Zustand | A store is a hook; components subscribe with a selector and re-render only when the selected value changes. Selector identity and the object-selector trap. *From Vue:* Pinia — the nearest equivalent, without `storeToRefs` because nothing is reactive; the selector does that job. *Prereq: R11.* *Read:* [Zustand — introduction](https://zustand.docs.pmnd.rs/learn/getting-started/introduction) |
| R30 | Redux Toolkit ★ | Store, slices, actions, reducers, selectors, `useSelector`/`useDispatch`; why reducers look mutable (Immer) and are not; thunks. Asked because it is in most existing codebases, not because it is the default choice today. *From Vue:* Vuex, more than Pinia. *Prereq: R10.* *Read:* [RTK quick start](https://redux-toolkit.js.org/tutorials/quick-start), [Redux essentials](https://redux.js.org/tutorials/essentials/part-1-overview-concepts) |
| R31 | TanStack Query ★ | Server state is not client state: it is a cache of something you do not own. Query keys, `staleTime` vs `gcTime`, background refetch, mutations and invalidation, optimistic updates. Why it replaces the fetch-in-effect from R14. *From Vue:* `useFetch`/`useAsyncData` in Nuxt, or a hand-written composable with `loading` and `error` refs. *Prereq: R14.* *Read:* [Overview](https://tanstack.com/query/latest/docs/framework/react/overview), [Important defaults](https://tanstack.com/query/latest/docs/framework/react/guides/important-defaults), [Query keys](https://tanstack.com/query/latest/docs/framework/react/guides/query-keys) |
| R32 | React Router | Routes, nested routes and `<Outlet>`, params, navigation, loaders; its three modes (declarative, data, framework). *From Vue:* Vue Router and `<RouterView>`; there are no navigation guards, a loader or a wrapper route does that. *Read:* [React Router](https://reactrouter.com/home), [Picking a mode](https://reactrouter.com/start/modes) |

## Track RF — Next.js

| # | Topic | Objective |
|---|---|---|
| R33 | The App Router | File conventions: `page`, `layout`, `loading`, `error`, route groups, dynamic segments; `<Link>` and prefetching. *From Vue:* Nuxt `pages/` and `layouts/`; here layouts nest by folder and persist across navigation. *Read:* [Project structure](https://nextjs.org/docs/app/getting-started/project-structure), [Layouts and pages](https://nextjs.org/docs/app/getting-started/layouts-and-pages), [Linking and navigating](https://nextjs.org/docs/app/getting-started/linking-and-navigating) |
| R34 | Server and Client Components ★ | Components are Server Components by default: they run only on the server, can be `async`, and ship no JavaScript. `'use client'` marks a boundary, not a single file. What can cross it (serialisable props, and Server Components as `children`). *From Vue:* nothing equivalent in production Nuxt; every Nuxt component hydrates. *Prereq: R21.* *Read:* [Server and Client Components](https://nextjs.org/docs/app/getting-started/server-and-client-components), [Server Components](https://react.dev/reference/rsc/server-components) |
| R35 | Fetching, caching and revalidating ☆ | Fetch in an `async` Server Component; stream with Suspense. With Cache Components, nothing is cached unless marked: `'use cache'` + `cacheLife`, tags with `cacheTag`, on-demand revalidation. Know that the previous model cached differently, and say which one you are describing. *From Vue:* `useAsyncData` and Nitro route rules. *Prereq: R24, R34.* *Read:* [Fetching data](https://nextjs.org/docs/app/getting-started/fetching-data), [Caching](https://nextjs.org/docs/app/getting-started/caching), [Revalidating](https://nextjs.org/docs/app/getting-started/revalidating) |
| R36 | Server Functions and mutations | `'use server'`: a function the client calls like a local one and the framework turns into a POST. Using one as a form action; validating input, because it is a public endpoint; revalidating after the write. *From Vue:* a Nuxt server route called with `$fetch`. *Prereq: R27, R34.* *Read:* [Mutating data](https://nextjs.org/docs/app/getting-started/mutating-data), [Server Functions](https://react.dev/reference/rsc/server-functions) |
| R37 | Rendering strategies ★ | CSR, SSR, SSG, ISR and Partial Prerendering as one spectrum: what is produced at build time, what at request time, and what streams. The static shell; `generateStaticParams`; hydration and hydration mismatches. *From Vue:* Nuxt's `ssr`, `prerender` and `swr`/`isr` route rules. *Prereq: R35.* *Read:* [Caching — prerendering](https://nextjs.org/docs/app/getting-started/caching#prerendering), [ISR](https://nextjs.org/docs/app/guides/incremental-static-regeneration) |
| R38 | Proxy, metadata and error handling | Proxy (called Middleware before Next.js 16) runs before a request completes: redirects, rewrites, headers — and why it is not the place for authorisation logic. The Metadata API; `error.tsx` and `not-found.tsx`. *From Vue:* Nuxt route middleware, `useHead`/`useSeoMeta`, `error.vue`. *Read:* [Proxy](https://nextjs.org/docs/app/getting-started/proxy), [Metadata and OG images](https://nextjs.org/docs/app/getting-started/metadata-and-og-images), [Error handling](https://nextjs.org/docs/app/getting-started/error-handling) |

## Track RG — Build

Three cumulative milestones on one project. Each is a single session: the brief is the step-3
exercise, larger than usual, and the other four steps shrink around it. There is no new concept to
teach, so step 1 is a five-minute plan review, and step 5 is "walk me through what you built and
why". They have no interview-bank section.

| # | Topic | Objective |
|---|---|---|
| R39 | Milestone 1 — a client-side app | A typed, filterable list with add, edit and delete, using only React: derived state, lifted state, one custom hook, no effect that R14 would remove. *Prereq: tracks RA–RC.* |
| R40 | Milestone 2 — state and data | The same app against a real HTTP API: TanStack Query for server state with an optimistic mutation, one small store for client state, routing with a detail page. *Prereq: R39, track RE.* |
| R41 | Milestone 3 — move it to Next.js | The same app on the App Router: the list as a Server Component, the mutation as a Server Function, one cached and one streamed region, and a written note on what stayed a Client Component and why. *Prereq: R40, track RF.* |
