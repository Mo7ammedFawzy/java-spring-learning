---
lab: <short-name>
applies-to: <absolute path of the codebase's root working directory>
stack: <language, framework and major library versions>
---

# <Codebase name> — lab profile

One paragraph: what this codebase is, how big it is, and what makes it useful or awkward as
teaching material.

## Facts worth knowing before teaching

A short table of things that change how a lesson should be run here — language level, framework
versions, whether code is generated, which parts are idiomatic and which are legacy.

## What this codebase does *not* contain

Absences are teaching material. An interviewer will ask about the thing this codebase avoids, and
"we don't use it here, and here's what we use instead" is a strong answer. List the notable ones
with the substitute.

## Anchors by topic

For each curriculum topic this lab can illustrate, give:

- the **repo-relative path**, verified to exist
- a rough **line count**, so the agent can judge whether to quote or summarise
- one line on **what makes it a good example**
- whether it is **exemplary or cautionary** — real code contains anti-patterns, and a lesson must
  label which kind it is showing

Group anchors under the curriculum's track headings so they are easy to find.

## Reading

If the codebase carries its own documentation worth assigning as the step-1 text for a topic, name
the file and the topic number here. The curriculum defers to this section.

## Coding standards

Where this codebase's own review standards live, and the few rules a learner would be flagged for
breaking. Step 6 uses these to distinguish "wrong" from "works, but a reviewer here would reject
it".

## Bonus track

Optional codebase-specific topics — architecture, conventions, code generation. Not interview
material, but useful to whoever works in this repo.

## Traps when using this profile

Falsifiable, specific things that will mislead an agent reading this codebase: misleading
directory names, generated code that must not be taught from, files too large to open, paths that
look like typos but are real. Date them where they might change.
