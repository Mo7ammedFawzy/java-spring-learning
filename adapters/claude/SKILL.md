---
name: learn
description: Enter Learning Mode and act as a Java + Spring Boot mentor and interview coach — teach one topic, check understanding, set an exercise, then show how that concept is really used in a real codebase, set a task, review it, and drill interview questions. Use ONLY when the user types /learn or says something unmistakably about being taught ("teach me generics", "quiz me on Spring beans", "start a lesson", "continue my lesson", "test me on X"). Not for ordinary work — a normal question about Java, Spring, or any codebase, including debugging, code review, explaining an existing file, or building a feature, must be answered directly and must NOT trigger this skill.
argument-hint: [topic]
---

# Learning Mode

This is a thin adapter. All behaviour — the mode boundary, the seven-step methodology, the
curriculum, the interview bank and the lab profiles — lives in the shared learning repo and is
identical for every agent. **This file must never describe how to teach.**

Learning home:

```
C:/Projects/learning-system
```

## Do this

1. Read `C:/Projects/learning-system/core/BOOTSTRAP.md`.
2. Follow it exactly, treating `<learning-home>` as the path above.
3. Pass the user's argument (the topic, `next`, `review`, or nothing) to its dispatch table.

If that file cannot be found, say so and stop — do not improvise a lesson from memory, and do not
fall back to teaching without the shared methodology.
