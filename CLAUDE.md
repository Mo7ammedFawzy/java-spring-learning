# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Read this first

`AGENTS.md` holds the project instructions for every agent — default behaviour, when Learning Mode
is entered, the layout table, and the two invariants. Read it; do not duplicate it here.

## Commands

There is no build, no test suite and no application code — the system is plain markdown.

```bash
# Invariant check: core/ must name no agent and no company codebase. Must return nothing.
grep -rniE 'claude|opencode|anthropic|8080|namasoft|\bnama\b|dev-docs|\bskill\b' core/
```

```powershell
.\install.ps1              # write adapters into the global agent config dirs (-Uninstall removes)
```
```bash
./install.sh               # same, Git Bash / macOS / Linux (--uninstall)
```

Re-run the installer after moving the repo — the adapters are absolute pointers back to it.

## Architecture

Three layers, separated so two agents cannot drift apart:

- `core/` — the methodology, and the only place it exists. Agent-neutral and codebase-neutral **by
  contract**, enforced by the grep test above. `BOOTSTRAP.md` is the entry point; `METHODOLOGY.md`
  defines the five steps, their gates, the 20–30 min budget and the strict-gate hint ladder.
- `labs/` — optional profiles for real codebases a lesson can draw on. `labs/INDEX.md` maps a
  working directory to a profile; no match means codebase-free mode. Delete `labs/` and the system
  still works.
- `adapters/` — per-agent entry points. Pointers only. Copying a rule out of `core/` into an adapter
  is the bug this layer exists to prevent.

State lives in `state/PROGRESS.md`; learner exercise code in `playground/` (gitignored).

## Arabic text output

The Claude Code remote client does not set RTL paragraph direction, so Arabic lines start from the
left and embedded English/numbers land in the wrong place. Wrap **every** line of Arabic output in
RTL embedding controls — prefix `U+202B` (RLE), suffix `U+202C` (PDF):

```
‫الملف README.md موجود في المجلد core/ ويحتاج إلى 3 تعديلات.‬
```

`U+2067` (RLI) … `U+2069` (PDI) works equally well. Apply per line, not per block.
