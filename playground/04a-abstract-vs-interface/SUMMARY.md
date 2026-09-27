# 04a — Abstract class vs interface

**Mental model:** an interface is a *type* a class can take on as many times as it likes; an abstract
class is a *partial implementation with state*, and a class gets exactly one.

## Rules

| | Abstract class | Interface |
|---|---|---|
| Per-instance state | Yes — instance fields | **No** — every field is implicitly `public static final` |
| Constructors | Yes (run via `super(...)`) | No |
| How many per class | **One** (`extends`) | Any number (`implements`) |
| Method bodies | Any | `default`, `static`, `private` (Java 9+) |
| Member visibility | Any | Abstract/default/static are `public`; `private` only for helpers |

## Decision

- Need shared **state** or a constructor, and the implementors have no other superclass → abstract class.
- Need a **capability** that unrelated classes (ones that already extend something) can take on → interface.
- Need both → interface for the type; the default method reaches state through an **abstract accessor**
  (`increaseExport()`, `exported()`) that each class implements with its own field.

## Traps

- `int count = 0;` in an interface is a shared constant, not a field. `count++` → *cannot assign a value
  to static final variable*.
- Fixing that with a `static` field in the class compiles but shares one count across all instances.
- `private` interface method: callable **only inside the interface body**, never by an implementor. It
  must have a body, so it can't be the abstract hook.
- Diamond (two defaults with the same signature): the class must override and pick with `A.super.who()`.
- The accessor pattern's price: the hooks are `public`, so any caller can bump the counter, and the field
  is duplicated in every implementor.

## Mistakes actually made

- **Step 2:** read a `private` interface method as a `default` one and said an implementor can call it
  (two rounds, capped). It can't — `private` means inside the interface only.
- **Step 3:** first proposed moving `exported` into `FileSink`. Wrong twice over: `JsonExporter` doesn't
  extend `FileSink`, and `Exporter`'s default method can't see a field of a class that implements it.
  Then solved it cleanly: abstract hooks in the interface, own field per class. The reason came out right:
  `CsvExporter` already spends its one `extends` on `FileSink`.
