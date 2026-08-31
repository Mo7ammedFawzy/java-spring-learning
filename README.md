# Learning System

A Java + Spring Boot mentoring and interview-coaching system, shared across coding agents. One
methodology, one curriculum, one progress file — usable from Claude Code and OpenCode, with real
codebases plugged in as optional "labs".

Independent of any company codebase: delete `labs/` and the system still works.

## Using it

```
/learn                 resume where you left off, or start topic 01
/learn generics        jump to a topic by name or number
/learn next            advance to the next uncompleted topic
/learn review          re-test only the things you were shaky on
```

Works the same from either agent. Also triggered by unmistakable phrasings — "teach me X", "quiz me
on X", "start a lesson". A normal question ("why is this service throwing?") does **not** trigger
it; see `core/MODE-BOUNDARY.md`.

## The seven steps

Each topic runs the same loop, one step per message:

1. Teach one concept
2. Check understanding with questions
3. Hands-on exercise — **no solution until you attempt it**
4. The same concept in real code from the active lab
5. A small real-world task
6. Review of your implementation, with each mistake and the failure it causes
7. Interview questions, with the shallow answer, the passing answer, and the follow-up

Strict mode is on: hints escalate in three levels, and the answer appears only after an attempt or
an explicit "show me". Saying "show me" is not cheating — it is the mode working as configured.

## Layout

```
core/            the shared source of truth — agent-neutral, codebase-neutral
  BOOTSTRAP.md     session-start protocol and dispatch (the entry point)
  MODE-BOUNDARY.md Work Mode vs Learning Mode
  METHODOLOGY.md   the seven steps, their gates, the hint ladder
  CURRICULUM.md    41 topics, Java-heavy first
  INTERVIEW-BANK.md questions with shallow / passing / follow-up answers
labs/            optional pluggable codebase profiles (INDEX, TEMPLATE, one file per codebase)
state/PROGRESS.md your progress, weak spots, and what to revisit
playground/      your exercise code (gitignored)
adapters/        thin per-agent entry points — pointers only
```

## Architecture in one rule

**Methodology lives in exactly one place.** `core/` never names an agent or a company codebase.
Agent-specific plumbing lives in `adapters/`; codebase-specific facts live in `labs/`. Both agents
read the same `core/`, which is why they cannot drift apart.

The grep test that enforces it — run after editing `core/`:

```bash
grep -rniE 'claude|opencode|anthropic|8080|namasoft|\bnama\b|dev-docs|\bskill\b' core/
```

It must return nothing.

## Install

Get this repo onto the machine, then run the installer from inside it:

```powershell
.\install.ps1          # Windows PowerShell
```
```bash
./install.sh           # Git Bash / macOS / Linux
```

It detects where the repo lives, writes the adapters into the global agent config directories with
that path substituted, verifies they resolve, and reports whether `java`, `claude` and `opencode`
are present. Re-run it any time you move the repo. `--uninstall` / `-Uninstall` removes the
adapters and touches nothing else.

**Requirements:** Claude Code and/or OpenCode, plus a JDK 21+ if you want to run the exercises
(`java`, `javac`, `jshell`). Nothing else — the system is plain markdown.

The adapters are pointers back to this repo, so keep the repo where you installed it from.
Details and manual steps: `adapters/README.md`.

## Labs

A lab is a real codebase used as the laboratory for steps 4 and 5. `labs/INDEX.md` maps a working
directory to a profile; if none matches, lessons run in **codebase-free mode** with self-contained
examples, and say so. Add one by copying `labs/TEMPLATE.md`.

Currently: `nama-erp` (Java 21 / Spring Boot 3.5 / Hibernate 6 ERP monorepo at `C:\Projects\8080`).

## Maintenance

- Progress is written after step 7. Grade honestly — a `solid` on a topic you fumbled makes the file
  worthless.
- If a path in a lab profile has drifted, the lesson finds a current example and fixes the entry
  rather than quoting stale code.
- To reset: empty `state/PROGRESS.md` back to "not started" and delete `playground/*`.
