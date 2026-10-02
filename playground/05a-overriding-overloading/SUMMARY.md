# 05a — Overriding vs overloading, static hiding

**Mental model:** The compiler picks the *signature* from declared types; the JVM picks the *body*
from the real object — and only for instance methods.

**Key rule:**

| | Decided by | Looks at |
|---|---|---|
| Overload (same name, different parameters) | compiler | declared type of the arguments |
| `static` method (hiding) | compiler | declared type of the receiver |
| Override (same signature, instance method) | JVM at runtime | actual object of the receiver |

Put `@Override` on every intended override. It is a compiler check, not a note for the reader.

**Classic trap:**

```java
public boolean equals(Tag other) { ... }    // an OVERLOAD, not an override
List.of(new Tag("java")).contains(new Tag("java"));   // false
```

`contains` calls `equals(Object)`. Nobody overrode that one, so `Object.equals` runs, which is `==`.

**Interview answer (30 s):** Overloading is resolved at compile time from the declared argument
types; overriding is resolved at runtime from the receiver's actual object. Static methods cannot be
overridden, only hidden: a static call is bound to the declared type and never dispatched. So when
behaviour must vary by runtime type, it goes in an overridden instance method on the receiver.

**My mistake:** Said the subclass's static method lost because it "only exists in the parent" → it
exists in both; the compiler bound the call to the declared type. And my `equals(Object)` cast
without a type check → use `obj instanceof Tag t && name.equals(t.name)`, with `@Override`.
