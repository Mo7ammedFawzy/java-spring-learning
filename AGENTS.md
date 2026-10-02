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
| `core/METHODOLOGY.md` | The five steps, their gates and time budget, the strict-gate hint ladder |
| `core/CURRICULUM.md` | Topic list |
| `core/INTERVIEW-BANK.md` | Interview questions per topic |
| `labs/` | Optional, pluggable real-codebase profiles. `labs/INDEX.md` maps a working directory to a profile; no match means codebase-free mode |
| `state/PROGRESS.md` | Learner state |
| `state/SOURCES.md` | Priority checklist: every question in the `sources/` PDFs, mapped to a topic |
| `sources/` | Interview-prep PDFs the learner wants finished first |
| `playground/` | Learner's exercise code (gitignored) |
| `adapters/` | Thin per-agent entry points — pointers only, never methodology |

## Two invariants

1. **`core/` names no agent and no company codebase.** Not "Claude", not "OpenCode", not "Codex",
   not a skill or a slash command, and no path into a real project. Everything specific to a
   codebase belongs in a `labs/` profile; everything specific to an agent belongs in `adapters/`.
   The grep test for this is under *Commands* below — run it after editing `core/`.
2. **Methodology exists in exactly one place.** If you find yourself copying a rule from `core/`
   into an adapter, stop: the adapter is supposed to be a pointer, and duplication is how two agents
   start behaving differently.

## Commands

There is no build, no test suite and no application code — the system is plain markdown.

```bash
# Invariant check: core/ must name no agent and no company codebase. Must return nothing.
grep -rniE 'claude|opencode|codex|anthropic|8080|namasoft|\bnama\b|dev-docs|\bskill\b' core/
```

```powershell
.\install.ps1              # write adapters into the global agent config dirs (-Uninstall removes)
```
```bash
./install.sh               # same, Git Bash / macOS / Linux (--uninstall)
```

Re-run the installer after moving the repo — the adapters are absolute pointers back to it.

## Arabic text output

Some clients do not set RTL paragraph direction (the Claude Code remote client is one), so Arabic
lines start from the left and embedded English/numbers land in the wrong place. Wrap **every** line
of Arabic output in RTL embedding controls — prefix `U+202B` (RLE), suffix `U+202C` (PDF):

```
‫الملف README.md موجود في المجلد core/ ويحتاج إلى 3 تعديلات.‬
```

`U+2067` (RLI) … `U+2069` (PDI) works equally well. Apply per line, not per block.
