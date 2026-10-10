# Interview bank — React

Questions for the interview drill (step 5), keyed to `core/react/CURRICULUM.md` topic IDs. Each
entry is written as the interviewer sees it:

- **Q** — the question as asked
- **Shallow** — the answer that sounds right, is technically true, and does not get the job
- **Passes** — what a strong candidate says
- **Then** — the follow-up, because the real signal is in the second question

Ask the questions first and wait for answers. Only then reveal Shallow/Passes/Then. Which question
opens, and whether a probe comes before the reveal, adapts to the learner — see step 5 in
`core/METHODOLOGY.md`. This file is a starting set, not a ceiling — generate more in the same shape
when a topic needs deeper drilling, and add any question the user is asked in a real interview.

Answers follow the official pages linked from each curriculum row. If one of them disagrees with
the page, the page is right: fix the entry.

A "Vue answer" is a recurring Shallow here: a statement that is true of Vue's reactivity and false
of React. Name it as such when it appears; it is the learner's most predictable mistake.

---

## R01 — JSX

**Q.** What is JSX, and what does the browser receive?
- *Shallow:* "HTML inside JavaScript."
- *Passes:* Syntax that a compiler turns into function calls producing plain objects that describe
  UI. The browser never sees JSX. Because it is an expression, it can be stored in a variable,
  returned from a function or passed as a prop.
- *Then:* "Why must a component return a single root?" (One function call returns one value. A
  fragment `<>…</>` groups siblings without adding a DOM node.)

**Q.** Why `className` and `htmlFor`, not `class` and `for`?
- *Shallow:* "Because React renamed them."
- *Passes:* JSX attributes become keys of a JavaScript object, and `class` and `for` are reserved
  words; the names follow the DOM property names.
- *Then:* "What can go inside `{}`?" (Any expression — not a statement, so no `if` or `for`.)

**Q.** How do you write `v-if` and `v-for` in React?
- *Shallow:* "React has its own directives for that."
- *Passes:* There are no directives. Conditions are JavaScript (`&&`, a ternary, an early return)
  and lists are `array.map(...)` returning elements with a `key`.
- *Then:* "And `v-show`?" (No equivalent; toggle a style or class yourself. The difference from a
  condition is that the element stays mounted and keeps its state.)

## R02 — Components and props

**Q.** Can a component change its own props?
- *Shallow:* "No, props are immutable."
- *Passes:* Props are a snapshot for that render, owned by the parent. To change what it shows, a
  component asks the parent through a callback prop and the parent sets its own state, which
  produces new props on the next render.
- *Then:* "How does a child notify its parent, with no `emit`?" (The parent passes a function prop,
  for example `onChange`; the child calls it.)

**Q.** What is `children`?
- *Shallow:* "The child components."
- *Passes:* An ordinary prop holding whatever JSX was nested between the component's tags. The
  receiving component decides where, and whether, to render it.
- *Then:* "Who renders that JSX — the wrapper or the component that wrote it?" (The elements are
  created by the component that wrote them, so they do not re-render when only the wrapper's own
  state changes.)

**Q.** When is a component function called?
- *Shallow:* "Once, when it mounts." (The Vue answer — true of `setup()`.)
- *Passes:* On every render: the first one, and again whenever its state changes or its parent
  re-renders. Everything declared in the function body is recreated each time.
- *Then:* "So where can a value live between calls?" (State, a ref, or outside the component.)

## R03 — State with `useState`

**Q.** Why not use a local variable instead of state?
- *Shallow:* "Because React would not know it changed."
- *Passes:* Two separate reasons. A local variable does not survive the next call of the function,
  and assigning to it does not ask React to render again. `useState` gives both: memory between
  renders and a setter that triggers one.
- *Then:* "Two copies of the same component on screen — do they share state?" (No. State is held
  per position in the tree.)

**Q.** `const [count, setCount] = useState(0)`. After `setCount(5)`, what is `count` on the next line?
- *Shallow:* "5." (The Vue answer — true of `ref.value`.)
- *Passes:* Still 0. `count` is a constant belonging to this render. The setter schedules a new
  render in which `count` will be 5.
- *Then:* "How do you run something with the new value?" (Compute it into a local variable first
  and use that; or do it in the next render.)

**Q.** `useState(expensive())` versus `useState(expensive)` or `useState(() => expensive())`?
- *Shallow:* "They are the same."
- *Passes:* The initial value is used only on the first render, but in the first form the call
  still executes on every render and the result is thrown away. Passing a function makes React call
  it once.
- *Then:* "Does changing a prop that fed the initial value update the state?" (No — the initial
  value is read once. Deriving it, or resetting with a `key`, are the fixes.)

## R04 — The render model

**Q.** What does "rendering" mean in React?
- *Shallow:* "Updating the DOM."
- *Passes:* React calling your component functions to find out what the UI should be. Touching the
  DOM is the later commit phase, and it happens only where the result differs from last time. A
  render can occur with no DOM change at all.
- *Then:* "What triggers a render?" (The initial render, a state update in the component or an
  ancestor, or a context value it reads changing.)

**Q.** A parent re-renders. Do its children?
- *Shallow:* "Only the ones whose props changed." (The Vue answer.)
- *Passes:* All of them, by default, recursively — props changed or not. Skipping is opt-in
  (`memo`, or the compiler). That is normally fine because rendering is a calculation, not a DOM
  write.
- *Then:* "Then why is React not slow?" (Rendering is cheap when components are pure; the commit
  touches only what differs.)

**Q.** A click handler sets state, then starts a three-second timer that alerts the state. The user
changes it again meanwhile. What does the alert show?
- *Shallow:* "The latest value."
- *Passes:* The value from the render in which the handler was created. Each render's handlers
  close over that render's state — a snapshot.
- *Then:* "When is that the behaviour you want?" (Usually: the user confirmed what was on screen
  when they clicked. A ref is the escape hatch when you really need the latest.)

## R05 — Updating state: immutability and batching

**Q.** `items.push(x); setItems(items);` — nothing updates. Why?
- *Shallow:* "State updates are asynchronous."
- *Passes:* The array was mutated in place, so the reference passed to the setter is the one React
  already holds. It compares with `Object.is`, sees no change and skips the render. Create a new
  array: `setItems([...items, x])`.
- *Then:* "Same question for one field of a nested object." (Copy every level on the path to the
  change; a spread is shallow.)

**Q.** `setCount(count + 1)` three times in one handler. Result?
- *Shallow:* "It adds three."
- *Passes:* Adds one. `count` is the same snapshot in all three calls. `setCount(c => c + 1)`
  queues a function that receives the pending value, so three of those add three.
- *Then:* "How many renders happen?" (One. Updates are batched until the handler finishes — and
  since React 18 also inside promises and timeouts.)

**Q.** Why does React insist on immutable updates when Vue does not?
- *Shallow:* "It is a functional-programming preference."
- *Passes:* React has no proxy observing writes; a new reference is its only signal that something
  changed. The same reference comparison underlies `memo`, effect dependencies and `useMemo`, so a
  mutation silently breaks all of them.
- *Then:* "What do you use when the copying gets painful?" (Flatten the state, or use Immer.)

## R06 — Events and controlled inputs

**Q.** `onClick={handleClick()}` — what is wrong?
- *Shallow:* "It needs to be an arrow function."
- *Passes:* That calls the function during render and passes its return value as the handler. Pass
  the function itself, `onClick={handleClick}`, or wrap it when it needs arguments.
- *Then:* "What happens if `handleClick` sets state?" (It sets state during render, which triggers
  a render, which calls it again: an infinite loop.)

**Q.** What is a controlled input?
- *Shallow:* "An input bound to state, like `v-model`."
- *Passes:* An input whose displayed value is always the `value` prop. Typing does nothing by
  itself; `onChange` must update the state that feeds `value`. React owns the value, not the DOM.
- *Then:* "You pass `value` and no `onChange`. What happens?" (The field is read-only and React
  warns. Use `defaultValue` for an uncontrolled field.)

**Q.** "A component is changing an uncontrolled input to be controlled." Cause?
- *Shallow:* "A missing `onChange`."
- *Passes:* `value` started as `undefined` (often a field not loaded yet) and later became a
  string. `undefined` means uncontrolled. Initialise with `''`.
- *Then:* "When would you choose uncontrolled on purpose?" (When you only need the value on submit,
  for instance with a form action and `FormData`.)

## R07 — Lists, keys and conditional rendering

**Q.** What is `key` for?
- *Shallow:* "To remove the warning", or "for performance."
- *Passes:* Identity. It tells React which element in the new list corresponds to which in the old
  one, so state and DOM nodes follow the item rather than the position.
- *Then:* "What breaks with the index as key?" (After an insert, delete or reorder, item state —
  an input's text, a checkbox — stays at the position and attaches to the wrong item.)

**Q.** `{items.length && <List />}` with an empty array. What renders?
- *Shallow:* "Nothing."
- *Passes:* `0`. `&&` returns its left side when falsy, and React renders the number zero. Use
  `items.length > 0 &&` or a ternary.
- *Then:* "Which values render nothing?" (`false`, `null`, `undefined`, `true`.)

**Q.** Is the key passed to the component as a prop?
- *Shallow:* "Yes, `props.key`."
- *Passes:* No. `key` is consumed by React. If the component needs the id, pass it again under
  another name.
- *Then:* "Must keys be globally unique?" (Only among siblings.)

## R08 — Purity and Strict Mode

**Q.** What does it mean for a component to be pure?
- *Shallow:* "It has no state."
- *Passes:* Given the same props, state and context it returns the same JSX, and it changes nothing
  that existed before the call. It may create and mutate local values. Side effects belong in event
  handlers, or in effects as a last resort.
- *Then:* "Why does React care?" (It may render a component more than once, pause it, or discard a
  render; that is only safe if rendering has no side effects.)

**Q.** My component logs twice and my effect runs twice in development. Bug?
- *Shallow:* "Yes, remove Strict Mode."
- *Passes:* Strict Mode does it on purpose, in development only: it double-invokes render to expose
  impure components and runs setup → cleanup → setup to expose effects with missing cleanup.
- *Then:* "What is the right fix when the double run causes a visible problem?" (Fix the cleanup
  or the impurity. The second run found a real bug.)

**Q.** Is `const id = Math.random()` in a component body a problem?
- *Shallow:* "No, it is just a variable."
- *Passes:* It makes the render impure: a new value on every render, different between server and
  client. Use `useId` for ids, or create the value once in state or in an event handler.
- *Then:* "What about `new Date()`?" (Same problem.)

## R09 — Structuring and lifting state

**Q.** State holds `firstName`, `lastName` and `fullName`. Comment.
- *Shallow:* "Fine, keep them in sync with an effect."
- *Passes:* `fullName` is redundant. Anything computable from props or other state is calculated
  during render, which cannot fall out of sync.
- *Then:* "And if the calculation is expensive?" (Wrap it in `useMemo`. Still not state.)

**Q.** Two sibling components need the same value. Where does it live?
- *Shallow:* "In a store."
- *Passes:* In their closest common parent, passed down as props with a callback to change it.
  A store or context comes in only when the passing becomes a real burden.
- *Then:* "What do 'controlled' and 'uncontrolled' mean for a component?" (Driven by props, or
  owning its own state.)

**Q.** A list holds `items` and `selectedItem` (a copy of one of them). What goes wrong?
- *Shallow:* "Nothing."
- *Passes:* Duplicated state: edit the item in `items` and the copy is stale. Store `selectedId`
  and derive the item during render.
- *Then:* "What other state shapes do you avoid?" (Contradictory flags such as `isSending` plus
  `isSent` — use one status; and deep nesting — flatten it.)

## R10 — `useReducer`

**Q.** When would you choose `useReducer` over `useState`?
- *Shallow:* "When the state is complex."
- *Passes:* When several handlers update the same state in related ways, or the next state depends
  on the previous in ways worth naming. The reducer collects every transition in one pure function
  that can be tested without rendering anything.
- *Then:* "What must a reducer never do?" (Mutate its argument, or perform side effects.)

**Q.** How do you type the actions?
- *Shallow:* "`{ type: string; payload: any }`."
- *Passes:* A discriminated union, one member per action, each with its own payload. A `switch` on
  `type` narrows it, and an exhaustiveness check makes a forgotten case a compile error.
- *Then:* "Is `dispatch` a new function on each render?" (No, its identity is stable.)

**Q.** Is `useReducer` the same thing as Redux?
- *Shallow:* "Yes, it is built-in Redux."
- *Passes:* Same reducer idea, different scope: the state is local to one component, with no
  global store, middleware or dev tools. Sharing it takes context.
- *Then:* "What does a reducer plus context still lack compared with a store?" (Selective
  subscription: every consumer re-renders on any change.)

## R11 — Context

**Q.** What problem does context solve?
- *Shallow:* "Global state."
- *Passes:* Prop drilling: handing a value to distant descendants without threading it through
  every level. It transports a value; it does not manage one. The state still lives in some
  component's `useState` or `useReducer`.
- *Then:* "What would you try before context?" (Passing JSX as `children`, so the intermediate
  layers never see the data.)

**Q.** When do context consumers re-render?
- *Shallow:* "When the part they use changes." (The Vue answer — true of an injected ref.)
- *Passes:* Whenever the provider's `value` changes by reference, for every consumer, whichever
  field it reads. An object literal built in the provider's render is new every time.
- *Then:* "How do you limit it?" (Split into several contexts; keep the value identity stable;
  or use a store with selectors.)

**Q.** `useContext` returns the default value even though a provider exists. Why?
- *Shallow:* "The provider is broken."
- *Passes:* The component is not below that provider in the tree — often the provider is rendered
  in the same component that reads it — or two copies of the context object exist.
- *Then:* "How do you make that mistake loud in TypeScript?" (Default to `null` and read through a
  custom hook that throws when it gets `null`.)

## R12 — Refs

**Q.** State versus ref?
- *Shallow:* "Refs are for DOM elements."
- *Passes:* Both persist across renders. Setting state triggers a render; writing `ref.current`
  does not. A ref suits values that do not affect the output: a timer id, a DOM node, a previous
  value.
- *Then:* "Can you read `ref.current` in JSX?" (Do not read or write it during render. The screen
  will not update when it changes, and the render is no longer pure.)

**Q.** How do you focus an input when a button is clicked?
- *Shallow:* "`document.querySelector`."
- *Passes:* `useRef<HTMLInputElement>(null)`, attach it with `ref={inputRef}`, call
  `inputRef.current?.focus()` in the handler.
- *Then:* "And if the input is inside your own component?" (Accept `ref` as a prop and forward it.
  Since React 19 that needs no `forwardRef`.)

**Q.** Why can a ref be `null` when you read it?
- *Shallow:* "It should not be."
- *Passes:* React sets it during commit. During the first render, and after the element unmounts,
  it is `null`. Read it in handlers or effects.
- *Then:* "How do you keep refs to a list of items?" (A ref callback filling a `Map`; hooks cannot
  be called in a loop.)

## R13 — `useEffect`

**Q.** What is `useEffect` for?
- *Shallow:* "Running code when the component mounts or updates."
- *Passes:* Synchronising the component with a system outside React: a subscription, a timer, a
  non-React widget, the network. The setup starts the synchronisation, the cleanup stops it, and
  the dependency array says when to re-synchronise.
- *Then:* "When does the cleanup run?" (Before the effect re-runs with new dependencies, and on
  unmount.)

**Q.** No dependency array, `[]`, and `[a, b]` — what does each mean?
- *Shallow:* "Always, once, when `a` or `b` change."
- *Passes:* Same words, but with the reason: the array is the list of reactive values the effect
  reads, and you do not choose it — the code does. `[]` is correct only when the effect reads none.
- *Then:* "Is `[]` the same as `onMounted`?" (Not quite: in development Strict Mode it runs, cleans
  up and runs again, so it must be written to survive that.)

**Q.** How does this differ from Vue's `watch`?
- *Shallow:* "It is the same thing."
- *Passes:* Vue tracks dependencies automatically and passes old and new values. React needs them
  declared, compares them by reference after each render, and runs the effect after the commit. An
  object or function created during render is a dependency that changes every time.
- *Then:* "So an effect depending on an inline object…" (…re-runs on every render. Move the object
  inside the effect or depend on its primitive fields.)

## R14 — You might not need an effect

**Q.** An effect computes `filtered` from `items` and `query` and stores it in state. Review it.
- *Shallow:* "It works."
- *Passes:* Unnecessary. It renders once with a stale list, then again after the effect. Compute
  `filtered` during render; add `useMemo` only if measurement says so.
- *Then:* "What is the general test for 'should this be an effect'?" (Is it caused by the component
  being on screen, or by a specific user action? The second belongs in the event handler.)

**Q.** How do you reset a form's state when the `userId` prop changes?
- *Shallow:* "An effect watching `userId` that clears the fields."
- *Passes:* Give the component `key={userId}`. A different key is a different component instance,
  so all its state starts fresh, with no intermediate render showing the old user's data.
- *Then:* "And to adjust only part of the state?" (Prefer deriving it; storing an id rather than
  an object usually removes the need.)

**Q.** What is wrong with fetching in an effect?
- *Shallow:* "Nothing, that is how you fetch."
- *Passes:* It works, with known holes: a race when a slower earlier response overwrites a newer
  one (fix with an `ignore` flag in the cleanup), no caching, no deduplication, a waterfall between
  parent and child, and nothing on the server. That is why a framework or a query library is the
  usual recommendation.
- *Then:* "Show me the race-condition fix." (`let ignore = false`; set state only if `!ignore`;
  cleanup sets `ignore = true`.)

## R15 — Rules of hooks, dependencies and stale closures

**Q.** Why can hooks not be called inside a condition or a loop?
- *Shallow:* "It is a rule; the linter complains."
- *Passes:* React identifies each hook by its call order in the component. If the order differs
  between renders, the state stored for call number two is handed to a different hook.
- *Then:* "How do you make a hook's behaviour conditional, then?" (Call it unconditionally and put
  the condition inside it. `use` is the one API that may be called conditionally.)

**Q.** An interval inside an effect with `[]` always logs the initial count. Why, and what are the fixes?
- *Shallow:* "State is asynchronous."
- *Passes:* A stale closure: the callback was created in the first render and captured that
  render's `count`. Fixes, best first: use the updater form so the effect does not read `count` at
  all; or declare `count` as a dependency and let the interval restart.
- *Then:* "And when the effect must read the latest value without re-running?" (`useEffectEvent`.)

**Q.** The linter demands a dependency you do not want. What do you do?
- *Shallow:* "Disable the rule for that line."
- *Passes:* Never suppress it; the list describes the code. Change the code so the value is no
  longer read reactively: move an object or function inside the effect or out of the component, use
  an updater function, split one effect into two, or move the logic to an event handler.
- *Then:* "Why is suppressing it worse than a redundant re-run?" (It produces stale values that
  appear only in certain sequences of events.)

## R16 — `useMemo` and `useCallback`

**Q.** What do `useMemo` and `useCallback` do, and how do they differ?
- *Shallow:* "They make components faster."
- *Passes:* Both cache between renders while dependencies are unchanged. `useMemo` caches the
  result of calling a function; `useCallback` caches the function itself. `useCallback(fn, d)` is
  `useMemo(() => fn, d)`.
- *Then:* "Is it like Vue's `computed`?" (`computed` is automatic and tracked. This is manual,
  opt-in, and React may discard the cache.)

**Q.** Should every function passed as a prop be wrapped in `useCallback`?
- *Shallow:* "Yes, it prevents re-renders."
- *Passes:* It helps only when something compares the function's identity: a child wrapped in
  `memo`, or a dependency array. Otherwise the child re-renders anyway and you have paid for a
  comparison and harder code.
- *Then:* "What changes with the React Compiler?" (It inserts equivalent memoisation
  automatically, so hand-written memoisation becomes the exception.)

**Q.** May you rely on `useMemo` for correctness — for example to make something run once?
- *Shallow:* "Yes, with `[]`."
- *Passes:* No. It is a performance hint and the code must work without it. For a value that must
  be created exactly once, use state with an initialiser function, or a ref.
- *Then:* "How do you decide whether a calculation is worth memoising?" (Measure it.)

## R17 — Custom hooks

**Q.** What makes a function a custom hook?
- *Shallow:* "Its name starts with `use`."
- *Passes:* It calls other hooks. The `use` prefix is the convention that lets the linter apply the
  rules of hooks to it. A function that calls no hooks should not have the prefix.
- *Then:* "Can a custom hook return JSX?" (It can, but then it is probably a component.)

**Q.** Two components call `useCounter()`. Do they share the count?
- *Shallow:* "Yes, it is the same hook."
- *Passes:* No. A hook shares logic, not state; each call gets its own. Sharing state means lifting
  it, context, or a store.
- *Then:* "A Vue composable with a ref declared at module level does share. What is the React
  equivalent?" (An external store, read with `useSyncExternalStore` or a library.)

**Q.** A custom hook returns `{ data, refetch }`. What should the caller watch for?
- *Shallow:* "Nothing."
- *Passes:* The hook body runs on every render of its caller, so a fresh object and a fresh
  `refetch` are returned each time. Used as dependencies they re-trigger effects unless the hook
  keeps their identity stable.
- *Then:* "How is that different from a composable?" (`setup()` runs once, so identities are
  stable for free.)

## R18 — Typing components, events and hooks

**Q.** How do you type a component's props and its children?
- *Shallow:* "`React.FC<Props>`."
- *Passes:* An interface or type for the props and a plain function: `function Card({ title }: Props)`.
  Children are an explicit `children: React.ReactNode`. `React.FC` is unnecessary and gets in the
  way of generic components.
- *Then:* "`ReactNode` versus `ReactElement`?" (`ReactNode` is anything renderable, including
  strings, numbers and `null`. `ReactElement` is only a JSX element.)

**Q.** Type the event in an input's `onChange` handler.
- *Shallow:* "`any`", or the DOM `Event` type.
- *Passes:* `React.ChangeEvent<HTMLInputElement>`. Written inline, it is inferred and needs no
  annotation; the annotation is needed only when the handler is declared separately.
- *Then:* "And a form submit?" (`React.FormEvent<HTMLFormElement>`.)

**Q.** `useState(null)` for a user loaded later, and `useRef(null)` for a DOM node. Type both.
- *Shallow:* "Leave them; TypeScript infers."
- *Passes:* Inference gives `null` only. `useState<User | null>(null)` and
  `useRef<HTMLDivElement>(null)`. Reads then need a null check, which is correct.
- *Then:* "How do you avoid the null check on a context that always has a provider?" (A custom hook
  that throws on `null` and returns the non-null type.)

## R19 — Generic components

**Q.** Write the props for a `Select` whose `onChange` receives the same type as its `options`.
- *Shallow:* "`options: any[]`."
- *Passes:* `function Select<T>({ options, onChange }: { options: T[]; onChange: (v: T) => void })`.
  `T` is inferred at the call site from `options`, so the handler is typed without annotation.
- *Then:* "How do you require every option to have an `id`?" (A constraint: `<T extends { id: string }>`.)

**Q.** Why does `const List = <T>(props: Props<T>) => …` fail in a `.tsx` file?
- *Shallow:* "Arrow functions cannot be generic."
- *Passes:* The parser reads `<T>` as a JSX tag. Use a function declaration, or write `<T,>`.
- *Then:* "Does a generic component still work wrapped in `memo`?" (The type parameter is lost
  unless you cast the wrapped result.)

**Q.** When is a generic component the wrong tool?
- *Shallow:* "Never; more generic is better."
- *Passes:* When the types are not actually related, or there is exactly one caller. A type
  parameter that appears once in the signature links nothing and should be removed.
- *Then:* "What does a type parameter have to do to earn its place?" (Appear at least twice.)

## R20 — Discriminated unions for state and props

**Q.** State has `isLoading`, `error` and `data`. What is wrong with that shape?
- *Shallow:* "Nothing, that is standard."
- *Passes:* It permits states that cannot exist, such as loading with an error and data together.
  Model one union: `{ status: 'loading' } | { status: 'error'; error: Error } | { status: 'success'; data: T }`.
  TypeScript then allows `data` only where `status` is `'success'`.
- *Then:* "How do you make the compiler catch a new status you forgot to handle?" (A `default`
  branch assigning the value to `never`.)

**Q.** A `Button` takes either `href` or `onClick`, never both. Type it.
- *Shallow:* "Make both optional."
- *Passes:* A union of two prop shapes, each excluding the other's field (`href?: never`). The
  caller gets a compile error for both or neither.
- *Then:* "What must not happen to the props for narrowing to keep working?" (Narrow before
  destructuring the discriminant away from the rest.)

**Q.** What makes a union "discriminated"?
- *Shallow:* "It is a union of object types."
- *Passes:* Every member has a common property with a distinct literal type. Checking that property
  narrows the whole object to one member.
- *Then:* "Can the discriminant be a boolean?" (Yes — `true` and `false` are literal types.)

## R21 — Composition with `children` and render props

**Q.** How do you do slots in React?
- *Shallow:* "React does not have slots."
- *Passes:* Props. The default slot is `children`; a named slot is another prop holding JSX
  (`header={<Title />}`); a scoped slot is a prop that is a function receiving data and returning
  JSX — a render prop.
- *Then:* "What does a render prop give that `children` as plain JSX cannot?" (Data owned by the
  wrapper, passed to the caller's markup.)

**Q.** A prop is passed through four layers that do not use it. Options?
- *Shallow:* "Context."
- *Passes:* First, composition: have the top component build the leaf element and pass it down as
  `children`, so the middle layers never see the data. Context when composition does not fit.
- *Then:* "What is the cost of each?" (Composition moves knowledge upward; context hides the
  dependency and widens re-renders.)

**Q.** `<Layout><Expensive /></Layout>` — `Layout` has its own state that changes. Does `Expensive` re-render?
- *Shallow:* "Yes, its parent re-rendered."
- *Passes:* No. The `<Expensive />` element was created by whoever rendered `Layout`, and `Layout`
  receives the same element object again, so React skips it.
- *Then:* "How is that useful for performance?" (Moving state down into a wrapper and passing the
  rest as `children` avoids re-renders without `memo`.)

## R22 — Reconciliation: preserving and resetting state

**Q.** What decides whether a component keeps its state between renders?
- *Shallow:* "Whether it is the same component."
- *Passes:* The same component type at the same position in the tree, with the same key. Change the
  type, the position or the key and React destroys the old instance and its state.
- *Then:* "`{isA ? <Counter /> : <Counter />}` — does toggling reset the count?" (No: same type,
  same position. Give them different keys to reset.)

**Q.** Why should a component never be defined inside another component's body?
- *Shallow:* "It is bad style."
- *Passes:* The inner function is a new function on every render of the outer one, so React sees a
  different component type each time, unmounts the old subtree and mounts a new one. All state
  below is lost and the DOM is rebuilt.
- *Then:* "What symptom would you see?" (An input losing focus on every keystroke.)

**Q.** How do you deliberately reset a component's state?
- *Shallow:* "Set every state variable back in an effect."
- *Passes:* Change its `key`. React treats it as a new instance.
- *Then:* "And how do you keep the state of something that is hidden?" (Keep it mounted and hide it
  with CSS, or lift the state to a parent that stays mounted.)

## R23 — `memo` and when it does nothing

**Q.** What does `memo` do?
- *Shallow:* "It caches the component."
- *Passes:* When the parent re-renders, React compares the new props with the previous ones using
  `Object.is` per prop, and skips rendering if all are equal. It does not stop re-renders caused by
  the component's own state or by context.
- *Then:* "A memoised child still re-renders every time. First thing you check?" (A prop that is an
  object, array or function created inline in the parent.)

**Q.** How do you make a slow screen faster without `memo`?
- *Shallow:* "You cannot."
- *Passes:* Move state down so fewer components are below it; pass the expensive part as
  `children` so it is not re-created; fix an effect chain that causes extra renders; virtualise a
  long list. Then profile.
- *Then:* "How do you find out what is slow?" (The React DevTools Profiler, on a production build.)

**Q.** Is a re-render a problem in itself?
- *Shallow:* "Yes, re-renders are bad."
- *Passes:* No. A render is a function call; React commits only the differences. It becomes a
  problem when a specific component is measurably slow to render or renders very often.
- *Then:* "Why not wrap everything in `memo`?" (The comparison has a cost and the code gets
  harder; with the compiler it is done for you.)

## R24 — Suspense, `lazy` and transitions

**Q.** What does a `<Suspense>` boundary do?
- *Shallow:* "It shows a spinner while data loads."
- *Passes:* It renders a fallback while something below it is not ready — lazily loaded code, or
  data read through a Suspense-enabled source such as `use` or a framework. It does not detect a
  fetch inside an effect.
- *Then:* "Where do you place boundaries?" (Around parts that should appear together; each boundary
  is a separate loading state.)

**Q.** How do you code-split a route?
- *Shallow:* "Dynamic `import()`."
- *Passes:* `const Page = lazy(() => import('./Page'))`, declared at module level, rendered inside
  a Suspense boundary. The module must have a default export.
- *Then:* "Why not declare the `lazy` call inside a component?" (A new component type on every
  render, which resets state — the R22 rule.)

**Q.** What is a transition?
- *Shallow:* "An animation."
- *Passes:* A state update marked non-urgent with `startTransition`. React keeps the current UI
  interactive, renders the update in the background and can abandon it if a newer one arrives.
  `isPending` lets you show that work is in progress.
- *Then:* "Why can a controlled input's own value not be updated in a transition?" (Typing must
  update synchronously; defer the derived value with `useDeferredValue` instead.)

## R25 — Error boundaries

**Q.** A component throws while rendering. What happens with no error boundary?
- *Shallow:* "That component disappears."
- *Passes:* React unmounts the whole tree: a blank page. A boundary limits the damage to its
  subtree and shows a fallback.
- *Then:* "How do you write one?" (A class component with `static getDerivedStateFromError`, and
  optionally `componentDidCatch` for logging — or a library wrapper. There is no hook for it.)

**Q.** Which errors does a boundary not catch?
- *Shallow:* "It catches everything below it."
- *Passes:* Errors in event handlers, in asynchronous code such as a timeout or a promise callback,
  during server rendering, and in the boundary itself.
- *Then:* "So how do you surface an error from an event handler?" (Catch it and put it in state.)

**Q.** How do you let the user retry after a boundary caught an error?
- *Shallow:* "Reload the page."
- *Passes:* Reset the boundary's error state — commonly by changing its `key` — so the subtree
  mounts again.
- *Then:* "Where do you put boundaries?" (Around independent regions, so one failing widget does
  not take the page with it.)

## R26 — Portals

**Q.** What is a portal for?
- *Shallow:* "Rendering outside the root."
- *Passes:* Rendering children into a different DOM node — usually under `body` — so a modal,
  tooltip or dropdown escapes an ancestor's `overflow: hidden` or stacking context.
- *Then:* "What is the Vue equivalent?" (`<Teleport>`.)

**Q.** A click inside a portalled modal — does the React parent's `onClick` fire?
- *Shallow:* "No, it is elsewhere in the DOM."
- *Passes:* Yes. Events propagate through the React tree, not the DOM tree, and context works the
  same way.
- *Then:* "When does that bite?" (A click inside the modal triggers a click-outside handler on an
  ancestor.)

**Q.** What does a portal not solve?
- *Shallow:* "Nothing, it handles modals."
- *Passes:* Accessibility: focus trapping, restoring focus, `aria-modal`, closing on Escape are
  still yours — or the native `<dialog>` element's.
- *Then:* "Would you use `<dialog>` instead?" (Often yes; it provides the top layer and focus
  handling natively.)

## R27 — Forms and actions

**Q.** Controlled or uncontrolled form — how do you choose?
- *Shallow:* "Always controlled."
- *Passes:* Controlled when the UI must react to each keystroke: live validation, dependent
  fields, formatting. Uncontrolled, reading `FormData` on submit, when it does not; it is less code
  and fewer renders.
- *Then:* "What does a large fully controlled form cost?" (A render of the form on every
  keystroke.)

**Q.** What does `<form action={fn}>` do?
- *Shallow:* "It is the HTML `action` attribute."
- *Passes:* React calls `fn` with the form's `FormData` on submit, treats it as a transition and
  resets uncontrolled fields when it succeeds. `useActionState` supplies the returned state and a
  pending flag; `useFormStatus` exposes pending to a child such as the submit button.
- *Then:* "Where must `useFormStatus` be called?" (In a component rendered inside the `<form>`,
  not in the one that renders the form.)

**Q.** What is an optimistic update?
- *Shallow:* "Updating the UI quickly."
- *Passes:* Showing the expected result before the server confirms, then reconciling with the real
  result or rolling back on failure. `useOptimistic` holds the temporary value for the duration of
  the action.
- *Then:* "What is hard about the rollback?" (Telling the user why something they saw has gone.)

## R28 — React 19 and the compiler

**Q.** What does the React Compiler do?
- *Shallow:* "It makes React faster."
- *Passes:* A build-time tool that memoises components and values automatically, at a finer grain
  than hand-written `useMemo`, `useCallback` and `memo`. It assumes the code follows the rules of
  React and skips components where it cannot verify that.
- *Then:* "Do you delete your existing `useMemo` calls?" (No need to; leave them. New code can omit
  them, keeping the manual hooks as an escape hatch where precise control is required.)

**Q.** What is `use`, and how does it differ from other hooks?
- *Shallow:* "A hook for fetching."
- *Passes:* An API that reads a promise or a context during render. With a promise it suspends
  until the promise resolves, working with Suspense and error boundaries. Unlike hooks, it may be
  called inside conditions and loops.
- *Then:* "Can you create the promise inside the component that calls `use`?" (Not in a Client
  Component: it would be a new promise on every render. Create it in a Server Component or a cache.)

**Q.** Name changes in React 19 that remove boilerplate.
- *Shallow:* "Server Components."
- *Passes:* `ref` is an ordinary prop, so `forwardRef` is no longer needed; a context object can be
  rendered directly as the provider; form actions with `useActionState`, `useFormStatus` and
  `useOptimistic`; document metadata tags rendered from components.
- *Then:* "Which of these would you see first in a code review?" (`ref` as a prop.)

## R29 — Zustand

**Q.** How does a component read from a Zustand store without re-rendering on every change?
- *Shallow:* "`const state = useStore()`."
- *Passes:* With a selector: `useStore(s => s.count)`. The component re-renders only when the
  selected value changes by strict equality. Calling the hook without a selector subscribes to the
  whole state.
- *Then:* "Compare with Pinia." (Pinia tracks property access through reactivity; here the selector
  is the explicit declaration of what you depend on.)

**Q.** `useStore(s => ({ a: s.a, b: s.b }))` — what is the problem?
- *Shallow:* "None."
- *Passes:* The selector returns a new object each time, so the equality check always fails and the
  component re-renders on every store change. Select the two values separately, or wrap the
  selector with `useShallow`.
- *Then:* "Why is selecting an action always safe?" (Action functions keep the same identity.)

**Q.** How do you update state in a store?
- *Shallow:* "Mutate it, like Pinia."
- *Passes:* `set` with a partial object or a function of the previous state. It shallow-merges at
  the top level; nested objects must be copied by you, unless you add the Immer middleware.
- *Then:* "Does Zustand need a provider?" (No. The store is a module-level object.)

## R30 — Redux Toolkit

**Q.** Describe the Redux data flow.
- *Shallow:* "Actions go to the store."
- *Passes:* One store holds the state. A component dispatches an action describing what happened.
  A reducer computes the next state from the current state and the action. Subscribed components
  read through selectors and re-render if their selected value changed.
- *Then:* "Why one direction?" (Every change has one traceable cause, which is what makes the dev
  tools and time-travel debugging possible.)

**Q.** In `createSlice`, a reducer does `state.items.push(x)`. Is that not mutation?
- *Shallow:* "Redux allows mutation now."
- *Passes:* The reducer receives an Immer draft. Immer records the changes and produces a new
  immutable state. It works only inside `createSlice` and `createReducer`.
- *Then:* "Classic mistake in such a reducer?" (Both mutating the draft and returning a new value,
  or reassigning `state` itself, which changes nothing.)

**Q.** When does `useSelector` re-render a component?
- *Shallow:* "When the store changes."
- *Passes:* The selector runs after every dispatched action; the component re-renders when its
  result differs by reference from the last one. A selector that builds a new array or object
  therefore re-renders every time — memoise it with `createSelector`.
- *Then:* "Would you put server data in Redux today?" (Prefer RTK Query or TanStack Query; keep
  Redux for client state.)

## R31 — TanStack Query

**Q.** What is the difference between server state and client state?
- *Shallow:* "Where it is stored."
- *Passes:* Server state is owned remotely, fetched asynchronously, shared with other users and can
  be out of date the moment you have it. What the client holds is a cache. Client state — a modal
  being open, a selected tab — is owned by the app and always current.
- *Then:* "What does treating it as a cache buy you?" (Deduplication, background refresh,
  invalidation, and no loading or error flags to hand-write.)

**Q.** `staleTime` versus `gcTime`?
- *Shallow:* "Both are cache durations."
- *Passes:* `staleTime` is how long data counts as fresh; while fresh, no refetch happens. The
  default is 0. `gcTime` is how long an unused query's data stays in memory after its last
  observer unmounts; the default is five minutes.
- *Then:* "With defaults, when does a query refetch?" (On mount of a new observer, on window focus
  and on reconnect, because the data is already stale.)

**Q.** After a mutation, how does the list update?
- *Shallow:* "Call `refetch`."
- *Passes:* Invalidate the relevant key with `queryClient.invalidateQueries`, which marks matching
  queries stale and refetches the active ones. Alternatives: write the response into the cache
  with `setQueryData`, or update optimistically and roll back on error.
- *Then:* "What must a query key contain?" (Every variable the query function uses; a changed key
  is a different query.)

## R32 — React Router

**Q.** How do nested routes render?
- *Shallow:* "Each route replaces the page."
- *Passes:* A parent route renders its element with an `<Outlet />` where the matching child
  appears. The parent layout stays mounted while children change.
- *Then:* "Vue equivalent?" (A nested `<RouterView>`.)

**Q.** How do you protect a route, with no navigation guards?
- *Shallow:* "Check in an effect and navigate away."
- *Passes:* Before rendering: a loader or middleware that redirects, or a layout route that renders
  either the `<Outlet />` or a redirect. An effect runs after the protected content has already
  rendered.
- *Then:* "Is that security?" (No. It is user experience; the server must authorise every request.)

**Q.** What are React Router's modes?
- *Shallow:* "Browser and hash."
- *Passes:* Declarative (components only), data (a router object with loaders and actions), and
  framework (file-based routing, rendering strategies, type safety). Each adds features on the
  previous one.
- *Then:* "What does a loader change about data fetching?" (Data is fetched before the route
  renders, in parallel across nested routes, not in effects after it.)

## R33 — The App Router

**Q.** `layout.tsx` versus `page.tsx`?
- *Shallow:* "A layout is a wrapper."
- *Passes:* A page is the UI unique to a route. A layout is shared by a segment and everything
  below it, receives the page as `children`, and is not re-rendered on navigation between its
  children, so its state is preserved.
- *Then:* "Which layout is required?" (The root layout, containing `<html>` and `<body>`.)

**Q.** What do `loading.tsx` and `error.tsx` do?
- *Shallow:* "They are special pages."
- *Passes:* They wrap the segment automatically: `loading` in a Suspense boundary, `error` in an
  error boundary. `error` must be a Client Component.
- *Then:* "Does an `error.tsx` catch an error thrown in the layout of the same segment?" (No; the
  boundary sits inside that layout. The parent segment's catches it.)

**Q.** Why `<Link>` and not `<a>`?
- *Shallow:* "It is the framework's way."
- *Passes:* Client-side navigation without a full reload, keeping shared layouts and their state,
  with prefetching of the destination when the link enters the viewport.
- *Then:* "What is a route group?" (A folder in parentheses: organises routes or scopes a layout
  without adding a URL segment.)

## R34 — Server and Client Components

**Q.** What is a Server Component?
- *Shallow:* "A component that is server-side rendered."
- *Passes:* A component that runs only on the server: it can be `async`, read a database or secrets
  directly, and its code is never sent to the browser. It has no state, effects or event handlers.
  Client Components are also rendered to HTML on the server first; the difference is that they
  hydrate and run again in the browser.
- *Then:* "So what is SSR, in that vocabulary?" (Producing HTML from the tree. Both kinds take part.)

**Q.** What does `'use client'` mean?
- *Shallow:* "This component renders only in the browser."
- *Passes:* It marks a boundary in the module graph: this file and everything it imports are part
  of the client bundle. It is still pre-rendered on the server. Place it as low in the tree as
  possible.
- *Then:* "Can a Client Component render a Server Component?" (Not by importing it — that pulls it
  into the client bundle. It can receive one as `children` or another prop.)

**Q.** What can be passed as props from a Server Component to a Client Component?
- *Shallow:* "Anything."
- *Passes:* Serialisable values, since they cross the network: plain objects, arrays, primitives,
  dates, promises, JSX. Not ordinary functions or class instances. Server Functions are the
  exception: they are passed as references.
- *Then:* "How do you keep server-only code out of the client bundle by accident?" (The
  `server-only` package makes the import a build error.)

## R35 — Fetching, caching and revalidating

**Q.** How do you fetch data in the App Router?
- *Shallow:* "`useEffect` with fetch", or "`getServerSideProps`."
- *Passes:* In an `async` Server Component, awaiting the data directly — any source, not only
  `fetch`. Wrap slow parts in Suspense so the rest of the page streams first. Client-side fetching
  remains available, with `use` or a query library.
- *Then:* "Two sibling components each await a slow call. Sequential or parallel?" (Parallel, as
  separate components. Two awaits in one component are sequential unless started together.)

**Q.** What is cached in Next.js?
- *Shallow:* "`fetch` is cached by default" — true of an older version.
- *Passes:* State the version first. With Cache Components, nothing is cached implicitly: you opt
  in with `'use cache'` on a function or component, set its lifetime with `cacheLife`, and tag it
  with `cacheTag`. Arguments form the cache key. Uncached async work must sit behind a Suspense
  boundary. The previous model used `fetch` options and route segment config.
- *Then:* "Why can a `'use cache'` function not call `cookies()`?" (Its result is shared across
  requests. Read the cookie outside and pass the value in as an argument.)

**Q.** A user edits a product. How does the cached product page update?
- *Shallow:* "Wait for the cache to expire."
- *Passes:* On-demand revalidation from the Server Function that performed the write, by tag or by
  path. Time-based revalidation through the cache lifetime is the fallback.
- *Then:* "Tag or path — which do you prefer?" (Tags: they follow the data wherever it is used.)

## R36 — Server Functions and mutations

**Q.** What is a Server Function?
- *Shallow:* "A function that runs on the server."
- *Passes:* An async function marked `'use server'`. The client receives a reference; calling it
  sends a POST to an endpoint the framework generates. Used as a form `action` or called from an
  event handler, it is called a Server Action.
- *Then:* "What can its arguments and return value be?" (Serialisable values only.)

**Q.** Does a Server Function need validation and an authorisation check, given that it is your own function?
- *Shallow:* "No, it is only called by my form."
- *Passes:* Yes. It is a public HTTP endpoint that anyone can call with any arguments. Validate the
  input and check the session and permissions inside the function, every time.
- *Then:* "And values captured in a closure?" (They are sent to the client and back; never rely on
  them being secret or unmodified.)

**Q.** After the write succeeds, how does the page show the new data?
- *Shallow:* "Refresh the page."
- *Passes:* The function revalidates the affected cache entries by tag or path, or redirects. The
  framework returns the updated UI in the same round trip.
- *Then:* "Would you use Server Functions to fetch data?" (No. They are designed for mutations and
  run one at a time; fetch in Server Components.)

## R37 — Rendering strategies

**Q.** Explain CSR, SSR, SSG and ISR.
- *Shallow:* A definition of each acronym.
- *Passes:* They differ in when the HTML is produced. CSR: in the browser, after JavaScript loads.
  SSR: on the server, per request. SSG: once, at build time. ISR: static, then regenerated in the
  background after a time or an event. The trade is freshness and personalisation against speed
  and cost.
- *Then:* "Does a page have to pick one?" (Not any more — see the next question.)

**Q.** What is Partial Prerendering?
- *Shallow:* "A faster SSR."
- *Passes:* One route, mixed: a static shell, containing everything static or cached plus the
  Suspense fallbacks, is prerendered and served immediately; the request-dependent parts stream
  into those boundaries. It is the default behaviour with Cache Components.
- *Then:* "What decides what ends up in the shell?" (Whatever completes at build time without
  request data. The deeper the request-dependent read sits in the tree, the larger the shell.)

**Q.** What is hydration, and what is a hydration mismatch?
- *Shallow:* "Loading the JavaScript."
- *Passes:* React attaching event handlers and state to HTML the server already produced, by
  rendering the Client Components again and expecting the same output. A mismatch is the client's
  first render differing from the server's — a date, a random value, `window`, the locale.
- *Then:* "How do you render something browser-only without a mismatch?" (Render the same thing on
  both first, then switch after mount; or exclude that component from server rendering.)

## R38 — Proxy, metadata and error handling

**Q.** What is Proxy (Middleware), and what is it for?
- *Shallow:* "Code that runs before every request."
- *Passes:* A single file that runs before a request completes, for matched paths: redirect,
  rewrite, set headers or respond directly. Good for locale routing and optimistic redirects. It
  was called Middleware before Next.js 16.
- *Then:* "Why is it not where authorisation lives?" (It is a coarse early check. The real check
  belongs next to the data, in the Server Component or Server Function that reads or writes it.)

**Q.** How do you set a page's title and Open Graph tags?
- *Shallow:* "A `<head>` tag in the component."
- *Passes:* Export a `metadata` object, or a `generateMetadata` function for values that depend on
  params or fetched data, from a layout or page. Server Components only. Nested segments merge and
  override.
- *Then:* "The page and `generateMetadata` need the same record. Two requests?" (Deduplicate the
  read with React's `cache`.)

**Q.** How do you handle "not found" and unexpected errors?
- *Shallow:* "Try/catch in the page."
- *Passes:* Expected failures are return values, shown as normal UI. Unexpected ones are thrown and
  caught by the nearest `error.tsx`. `notFound()` renders the nearest `not-found.tsx` with a 404.
  Errors in the root layout need `global-error.tsx`.
- *Then:* "What does the user see of a server error's message in production?" (A generic message
  and a digest; details stay in the server log.)
