# Agent instructions for this repository

This repo is a **Learning System**: a Java + Spring Boot mentoring and interview-coaching
methodology, shared across agents. It contains no application code.

## Default behaviour

**Do not start teaching just because this repo is open.** Work Mode is still the default — if the
user asks you to edit a file, fix a typo, restructure the curriculum or explain something here,
just do it. Learning Mode is entered only as defined in `core/MODE-BOUNDARY.md`.

## When the user asks to learn

Read `core/BOOTSTRAP.md` and follow it exactly. `<learning-home>` is this repository's root.

## Layout

| Path | What it is |
|---|---|
| `core/` | The shared source of truth. Agent-neutral and codebase-neutral by contract |
| `core/BOOTSTRAP.md` | Session-start protocol and dispatch — the entry point |
| `core/MODE-BOUNDARY.md` | Work Mode vs Learning Mode |
| `core/METHODOLOGY.md` | The seven steps, their gates, the strict-gate hint ladder |
| `core/CURRICULUM.md` | Topic list |
| `core/INTERVIEW-BANK.md` | Interview questions per topic |
| `labs/` | Optional, pluggable real-codebase profiles |
| `state/PROGRESS.md` | Learner state |
| `playground/` | Learner's exercise code (gitignored) |
| `adapters/` | Thin per-agent entry points — pointers only, never methodology |

## Two invariants

1. **`core/` names no agent and no company codebase.** Not "Claude", not "OpenCode", not a skill or
   a slash command, and no path into a real project. Everything specific to a codebase belongs in a
   `labs/` profile; everything specific to an agent belongs in `adapters/`. There is a grep test for
   this in `README.md` — run it after editing `core/`.
2. **Methodology exists in exactly one place.** If you find yourself copying a rule from `core/`
   into an adapter, stop: the adapter is supposed to be a pointer, and duplication is how two agents
   start behaving differently.
