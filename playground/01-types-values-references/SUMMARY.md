# 01 — Types, values and references

Study sheet. Taught 2026-09-01, reviewed 2026-09-06.

**The one sentence:** a variable never holds an object — it holds either a primitive value or the
address of an object, and everything in this topic follows from that.

---

## 1. Two kinds of variable

| | Holds | `=` copies |
|---|---|---|
| primitive (`int`, `double`, `boolean`, …) | the value itself | the value |
| reference (`String`, `List`, any class) | the address of an object on the heap | the **address**, not the object |

```java
int a = 5;  int b = a;         // two independent 5s
List<String> x = new ArrayList<>();
List<String> y = x;            // one list, two names — aliases
```

`y.add("hi")` is visible through `x`. That is aliasing, and it is the source of most of the bugs
below.

## 2. Java is always pass-by-value

There is no pass-by-reference in Java. For an object, the **reference is copied by value**.

Consequences:

- **Mutating through the parameter is visible to the caller.** `list.add(x)` changes the caller list.
- **Reassigning the parameter is invisible to the caller.** `list = new ArrayList<>()` rebinds only
  the local copy of the address.

**The proof — `swap` cannot be written:**

```java
static void swap(String a, String b) {
    String t = a; a = b; b = t;   // rebinds two locals, caller sees nothing
}
```

If Java were pass-by-reference this would work. It cannot be written for any type. That is the
answer to give when an interviewer pushes back.

### Rebinding then mutating

```java
static void f(int[] a) {
    a[0] = 9;                 // hits the caller array
    a = new int[]{7, 7};      // now points somewhere else
    a[0] = 100;               // hits the new array — caller never sees it
}
int[] x = {1, 2};
f(x);                         // x is {9, 2}
```

Rebinding is invisible, but it **changes which object later mutations hit**. Read the whole method
before predicting the output.

## 3. `final` binds the box, not the contents

```java
final List<String> tags = new ArrayList<>();
tags.add("a");            // fine — the object is mutable
tags = new ArrayList<>(); // compile error — the binding is fixed
```

`final` on a field also buys a real guarantee: a final field assigned in the constructor is safely
published, so other threads cannot see it half-built. Non-final fields have no such guarantee.

## 4. Exposing a collection — the core decision

Do not memorise four rows. Ask **two yes/no questions**:

1. Can the caller modify what they got?
2. Does what they got change later?

```
modify: no   change: no    →  List.copyOf(tags)                       ← default for a getter
modify: no   change: yes   →  Collections.unmodifiableList(tags)      ← live read-only window
modify: yes  change: no    →  new ArrayList<>(tags)                   ← caller owns it
modify: yes  change: yes   →  return tags                             ← the leak, never on purpose
```

Vocabulary that matters in an interview:

- **unmodifiable** — *you* cannot change it. It can still change under you.
- **immutable** — *nobody* can change it. `List.copyOf`, `List.of`, `Map.of`.

`Collections.unmodifiableList` is a **view**: it wraps the original and refuses writes, but every
read goes through to the live list. `List.copyOf` is a **snapshot**: frozen at the moment of the
call.

`UnsupportedOperationException` from an unmodifiable list is **not a defect to design around**. It
is the API refusing a caller who is about to write into a list that goes nowhere. Handing back a
mutable copy to silence it makes the bug silent, not fixed. Return a mutable list only when adding
to it is the point.

## 5. Shallow copy

`new ArrayList<>(orders)` gives a **new list containing the same objects**.

```java
void process(List<Order> orders) {
    orders = new ArrayList<>(orders);   // protects the LIST
    orders.get(0).setStatus(CANCELLED); // still hits the caller Order
}
```

Protection from structural change only — adds, removes, sorts. Element mutation still leaks.
A deep copy means copying the elements too, and Java gives you nothing for free there.

## 6. Other views that surprise people

| Expression | Returns |
|---|---|
| `Arrays.asList(arr)` | fixed-size view **backed by the array**; `add`/`remove` throw, `set` writes through to `arr` |
| `list.subList(a, b)` | view backed by the original; changes flow both ways, and structurally modifying the parent invalidates it |
| `List.of(...)` | genuinely immutable, rejects nulls |

`new ArrayList<>(Arrays.asList(x))` is the idiom when you actually want a mutable list from an array.

## 7. Boxing

`Integer a = 100` does not call `new Integer(100)`. The compiler rewrites it to
`Integer.valueOf(100)`, which returns a **cached** object for small values.

- The JLS **requires** caching for `-128..127` (also `Boolean`, `Byte`, `Character` ≤ 127, `Short`).
- Above that, every call allocates a new object.
- The upper bound is tunable: `-XX:AutoBoxCacheMax=1000` makes `Integer c = 1000, d = 1000; c == d`
  print `true`. **The same code behaves differently on two JVMs.**

```java
Integer a = 127, b = 127;   a == b   // true   — same cached object
Integer c = 128, d = 128;   c == d   // false  — two objects
c.equals(d)                          // true   — compares values
```

So `==` on boxed types is never correct. Use `equals`, or `Objects.equals` when either side can be
null.

### Unboxing NPE — the most common NPE in Java

```java
int n = counts.get(key);
```

If the key is absent, `get` returns `null`, and the compiler inserted `.intValue()` you cannot see.
NPE on a line with no visible method call. Java 14+ says so: *"Cannot invoke
java.lang.Integer.intValue() because the return value of java.util.Map.get(Object) is null."*

Fix: `counts.getOrDefault(key, 0)` when absent means zero; an `Integer` plus an explicit branch when
absent means something else. Assigning to `Integer` alone is **not** a fix — it just moves the NPE
downstream.

`Integer` is immutable. `x++` on an `Integer` is: unbox → increment the `int` → **rebox into a new
object** → reassign the local. The caller `Integer` is untouched.

### Normalise once

If two methods each handle "absent" their own way, they will disagree:

```java
limitFor("ghost")                 // 0        — absent normalised to 0
onSameTier("ghost", "freetier")   // false    — Objects.equals(null, 0)
```

Define one in terms of the other — `return limitFor(a) == limitFor(b);` — and the contradiction
cannot arise. Both sides are `int`, so no boxing question remains either.

---

## Interview answers

**Is Java pass-by-value or pass-by-reference?**
Always pass-by-value. For objects the reference is copied by value, so mutation through it is
visible and reassignment is not. *Follow-up:* "write `swap`" — it cannot be done, and that is the
proof.

**`Integer a = 127, b = 127; a == b`? And 128?**
`true`, then `false`. `valueOf` caches −128..127. *Follow-up:* "is the boundary guaranteed?" — the
lower range is required by the JLS, the top is tunable with `-XX:AutoBoxCacheMax`.

**Your class holds a `List`. How do you expose it?**
Two questions — can the caller modify it, does it change under them — then the four rows, with
`List.copyOf` as the default and the raw field never on purpose.

**`unmodifiableList` vs `copyOf` — when is `unmodifiableList` right?**
When the caller must see later changes: a dashboard or monitor reading config that reloads.
`copyOf` freezes at the call and the screen silently goes stale. *Risk of the view:* the owner can
no longer write freely — someone is iterating, and that is a `ConcurrentModificationException`.

**`orders = new ArrayList<>(orders)` at the top of a method — does it work?**
Yes for structural protection, and the rebinding is invisible to the caller. *Follow-up:* it is a
**shallow** copy — the `Order` objects are shared, so element mutation still leaks.

**`==` on boxed Integers "works, we tested it".**
It works below 128 and fails on the first real id. Passing tests is the *worst* property of this
bug. Use `equals` / `Objects.equals`.

---

## Mistakes actually made, and the correction

| Mistake | Correction |
|---|---|
| "Objects are passed by reference" | Always by value; the *reference* is what is copied |
| Predicted `1,2` where the answer was `1,100` | Rebinding redirects which object later mutations hit |
| Returned `new ArrayList<>(items)` where the caller must not modify | `List.copyOf` — a mutable copy protects the owner, not the API |
| Called `unmodifiableList` "immutable" | Unmodifiable is not immutable; it is a live window |
| Said `Integer 127 == 127` is `false` | `true` — cached. `false` at 128 |
| Proposed a mutable copy to avoid `UnsupportedOperationException` (twice) | The throw is the feature; silence it and the bug goes silent, not away |
| Answered "defensive copy, it works" and stopped | It is *shallow*; volunteer that before the interviewer asks |
| `if (v == null) return 0; else return map.get(key);` | Two lookups, dead variable — `getOrDefault(key, 0)` |

## Code in this folder

- `Main.java` — the step-3 exercise (`OrderBasket`)
- `task/Main.java` — the step-5 task (`CurrencyRegistry`, ticket PAY-1042)
- `../review-01-values-and-views/Main.java` — the review exercise (`Inventory`)
- `../review-01-values-and-views/task/Main.java` — the review task (ticket PAY-2207)
