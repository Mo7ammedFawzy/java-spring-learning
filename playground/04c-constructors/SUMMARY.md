# 04c — Constructors

**Mental model:** a constructor is not a method — it initialises an object `new` already allocated,
belongs to exactly one class, and is never inherited or overridden.

**Key rule:** the first line of every constructor is `super(...)` — yours, or `super()` inserted by javac.

```text
new C() → allocate + zero fields → C(){super();} → B(){super();} → A() → Object()
          prints run on the way back: A, then B        new returns the reference
```

| Modifier | Why illegal |
|---|---|
| `final` | nothing to override — constructors are never inherited |
| `static` | needs a `this` to initialise |
| `abstract` | a subclass cannot supply the parent's constructor body |

Default constructor = `C() { super(); }`, generated **only** when you declare none. It does not give
fields default values — allocation already zeroed them.

**Classic trap:**
```java
class Parent { Parent(String n) {} }
class Child extends Parent { }   // ✗ javac inserts super(); Parent() does not exist
```

**Interview answer (30 s):** Constructors aren't inherited — each class initialises its own part, and
every constructor starts by calling a parent one, implicitly `super()`. So if the parent has only an
arg constructor, the child must call `super(args)` explicitly. They can't be `final`/`static`/`abstract`
because none of those mean anything for code that is never inherited, needs `this`, and must have a body.

**My mistake:** diagnosed the missing-`super` error as "missing field `id`" → the field is inherited;
the failure is the hidden `super()` finding no no-arg constructor. Also said the chain happens at
compile time → it runs at `new`, at runtime. Drill: "not inherited because they can't be overridden"
→ backwards; the reason is that an inherited parent constructor would leave the child's own fields
uninitialised. "Returns the new instance" → the constructor returns nothing; `new` returns the reference.
