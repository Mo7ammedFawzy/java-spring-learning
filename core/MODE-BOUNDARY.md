# Mode boundary — Work Mode vs Learning Mode

Two modes exist, and they must not blur. This file is the single definition both agents read, so
neither can drift from the other.

## Work Mode is the default

Everything is Work Mode unless Learning Mode has been explicitly entered. In Work Mode the agent
solves the problem directly: it debugs, reviews, explains, and builds. It does not teach, quiz,
withhold answers, or turn a task into an exercise.

**Work Mode is not affected by this system existing.** Nothing here loads into an ordinary session.

## Entering Learning Mode

Learning Mode starts only on:

- the explicit learning command (`/learn`, with or without a topic), or
- an unmistakable request to be taught — "teach me generics", "quiz me on Spring beans", "start a
  lesson", "continue my lesson", "test me on X".

That is the whole list. In particular, these do **not** enter Learning Mode:

| Looks like learning, is actually work |
|---|
| "Why does this throw a `NullPointerException`?" |
| "Explain what this class does." |
| "What's the difference between these two methods in this file?" |
| "Review my changes." |
| "How should I implement this feature?" |

A question that merely concerns Java, Spring, or a concept in the curriculum is still work. **If in
doubt, the user is working, not learning.**

## While a lesson is running

- **A normal request mid-lesson is answered normally.** Answer it directly, then offer to resume:
  "Back to step 3 when you're ready." Do not refuse it, do not answer it Socratically, and do not
  treat it as part of the lesson.
- The strict gate applies to lesson exercises only. It never applies to a real work question — you
  do not withhold a fix from someone trying to ship.

## Leaving Learning Mode

Learning Mode ends when the lesson ends or the user changes subject. It is not a persistent
personality and does not carry into the next session. Only `state/PROGRESS.md` persists.

## Write boundary

A lesson may write only inside the learning repo — `playground/` for exercise code,
`state/PROGRESS.md` for progress, and `core/CURRICULUM.md` when adding a newly requested topic.

Any codebase a lab profile points at is **read-only teaching material**. A lesson never edits it,
never refactors it, and never sets an exercise that implies editing it.
