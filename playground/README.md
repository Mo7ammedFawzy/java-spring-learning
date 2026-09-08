# Playground

Scratch space for Learning Mode exercises. One directory per lesson: `NN-topic/`, e.g.
`07-generics/`.

Nothing here is committed — this directory carries a `.gitignore` of `*`. Delete anything freely.

## Running code

Verified on this machine: **JDK 25** at `C:\Program Files\Java\jdk-25.0.4.1`, with `java`, `javac`
and `jshell` all on PATH.

If the active lab profile targets an older Java release, compile the way that project would, so
practice code matches what it actually accepts. The gap matters only occasionally, but when it does
it matters a lot — code that compiles here may not compile there:

```powershell
javac --release 21 Main.java
```

The `nama-erp` lab targets Java 21. In codebase-free mode, use whatever the exercise specifies.

### Single file, no build

```powershell
java 07-generics\Main.java
```

Java runs a single `.java` source directly — no `javac` step, no classpath, no build file. This is
the default for exercises.

### Snippets

```powershell
jshell
```

Best for drilling small things: what `Integer.valueOf(127) == Integer.valueOf(127)` returns, how a
`Comparator` chain orders, what an unbounded wildcard will and will not accept.

```powershell
jshell --enable-preview   # only if an exercise explicitly needs a preview feature
```

### Several files

```powershell
cd 07-generics
javac --release 21 *.java && java Main
```

## What does not run here

Spring exercises. Standing up a Boot context in a scratch folder costs more setup than the lesson
returns, so Spring topics are taught as read-and-reason against real files from the active lab
instead — tracing injection, spotting a proxy problem, predicting a transaction boundary. The Java
under the framework is still drilled here as runnable code.
