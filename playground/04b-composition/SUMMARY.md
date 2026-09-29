# 04b — Composition over inheritance

**Mental model:** inheritance ties you to how the parent is *implemented*; composition ties you only
to what it *promises*.

## The failure: fragile base class

Overriding `add` makes you depend on whether the parent's *other* methods call `add`. The docs don't
say, and it goes both ways:

| Parent | `addAll` does | Your `add` override |
|---|---|---|
| `HashSet` (via `AbstractCollection`) | loops `this.add(e)` | runs **twice** → count doubles (6, not 3) |
| `ArrayList` | `System.arraycopy` in bulk | runs **zero** times → limit bypassed |

```text
extends:  parent.addAll ──► this.add  ──► YOUR add     (calls back into you — or doesn't)
has-a:    inner.addAll  ──► inner.add                  (never comes back to the wrapper)
```

## When `extends` is allowed — both must hold

1. **is-a**: every subclass can stand in for the parent.
2. The parent is **designed and documented for extension** (says which methods call which, like
   `AbstractList`), **or you own it**.

is-a says inheritance is *allowed*. A parent built for extension says it is *safe*.

## Association / aggregation / composition

All three are just a field holding a reference. The difference is **lifecycle — who else can reach it**.

| Relation | Java shape | Outlives the whole? |
|---|---|---|
| Association | uses it (parameter / non-owning field) | n/a |
| Aggregation | field set from outside (`Team(List<Player>)`) | yes |
| Composition | created inside, **never leaks** | no — dies with it |

It's about **objects** at runtime. The class design only decides whether composition is *guaranteed*.

## Traps

- `new` inside is half of composition. A getter returning the part turns it into aggregation:
  `Engine e = new Car().getEngine();` → the `Car` is collectable, the `Engine` is not (`e` holds it).
- Getter for an internal collection → `List.copyOf(list)`. The `UnsupportedOperationException` on
  `add`/`clear` is the class refusing a bad caller, not a bug to avoid.
- `public final List<> list` still leaks. `final` freezes the **reference**, not the object:
  `cart.list.addAll(...)` still works. The field must be `private`.
- A wrapper is **not** the wrapped object: if `inner` passes `this` to a callback, the callback skips
  the wrapper.
- In a composed class, route `addAll` through **your own** `add` on purpose. Now the self-use is yours
  and known.

## Mistakes actually made

- **Set size.** Predicted `3 3` for `addAll([a, b, a])` on a counting `HashSet`. `count` counts
  *calls* (3), `size` counts *stored* elements (2).
- **A leaking getter called "composition"**, because `new` was inside. The re-test left GC reachability
  unanswered: a leaked part outlives its owner.
- **"Inheritance is fine when is-a holds"**: missed the second condition (designed for extension)
  twice. `CountingSet` *is* a `Set` and still broke.
- **Exercise:** made the field `public`, then `public final`, before `private`.
- **Why `ArrayList` skipped the limit:** said "a different method with return type boolean". Wrong
  reason. `addAll` copies the array in bulk and never calls `add`.
