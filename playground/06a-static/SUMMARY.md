# 06a — `static` and class initialisation

**Mental model:** A static member belongs to the class, and the class is initialised once, top to
bottom, by the JVM on its first active use.

**Key rule:**

| Step | What happens |
|---|---|
| 1 | Static fields get defaults (`0`, `null`, `false`) |
| 2 | Static initialisers and `static { }` blocks run in textual order, **once** |
| 3 | Only then: `main`, the constructor, or the static method that was called |

First active use = `new`, a static method call, a non-constant static field read or write, or being
the main class. Reading a constant variable (`static final` primitive or `String`, initialised in
its declarator with a constant expression) triggers nothing: `javac` inlines the value.
A static method has no `this`, so it cannot touch instance members and is never dispatched.
`static public void main` compiles: modifier order is only a convention.

**Classic trap:**

```java
static final Registry INSTANCE = new Registry();  // constructor runs: count 0 -> 1
static int count = 10;                            // then overwritten: count is 10, not 11
```

**Interview answer (30 s):** `static` means one copy owned by the class, not by each object. The JVM
initialises a class once, on first active use, running static field initialisers and static blocks
in the order they are written — that is how code runs before `main`. Static methods cannot be
overridden, only hidden, because the compiler binds the call to the declared class.

**My mistake:** Said static initialisation re-runs on every `new` → it runs once per class; the JVM
remembers. Said reading `Lib.A` triggers the static block → a constant variable is inlined, the
class is never touched. Said "the compiler initialises statics" → the JVM does, at runtime.
