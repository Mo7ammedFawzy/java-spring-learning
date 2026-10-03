# 05b — Dynamic dispatch, the four OOP concepts, varargs

**Mental model:** A method runs where it is written, but `this` is always the real object — so an
instance call is dispatched on the object, wherever the calling code sits.

**Key rule:**

| Concept | Hides | Java tool |
|---|---|---|
| Encapsulation | state — the class guards its own rules | `private` field + methods that validate |
| Abstraction | how it is done | `abstract` method, interface |
| Inheritance | nothing, it reuses | `extends` |
| Polymorphism | which body runs | overriding + dynamic dispatch |

Dispatch covers instance methods only. `static`, `private` and fields bind to the declared type.
Varargs `T... xs` is a `T[]` built by the compiler: last parameter, one per method, tried last —
phase 1 exact/widening, phase 2 boxing, phase 3 varargs. First phase with a match wins.

**Classic trap:**

```java
class Config     { String env() { return "prod"; }  String show() { return env(); } }
class TestConfig extends Config { @Override String env() { return "test"; } }
new TestConfig().show();                     // "test": env() is this.env()
Arrays.asList(new int[]{1, 2, 3}).size();    // 1: an int[] is one object
```

**Interview answer (30 s):** Encapsulation keeps state private and lets the class enforce its own
invariants; abstraction exposes what without how; inheritance reuses a parent; polymorphism lets one
call site run different bodies. The mechanism is dynamic dispatch: the compiler checks the method
exists on the declared type, the JVM picks the body from the object's actual class at runtime.

**My mistake:** Said a call inside a parent method stays in the parent → an unqualified call is
`this.call()` and dispatches. Said `private` + getter/setter is encapsulation → a raw setter is a
public field; the setter must enforce the rule. Said `f(5)` picks `int...` as "closest", and that an
`int` is an object → boxing (phase 2) beats varargs; `7` becomes an `Integer`. Left `@Override` off.
