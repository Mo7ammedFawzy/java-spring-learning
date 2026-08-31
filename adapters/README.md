# Adapters

An adapter is a **pointer**, not a lesson. Each one carries only its agent's trigger metadata plus
"read `core/BOOTSTRAP.md` and follow it". That is what guarantees both agents behave identically:
there is exactly one copy of the methodology, and no adapter contains enough to diverge from it.

If you ever find yourself explaining a teaching step inside an adapter, stop — it belongs in
`core/`.

## Canonical sources

| Agent | Canonical file | Installed to |
|---|---|---|
| Claude Code | `adapters/claude/SKILL.md` | `~/.claude/skills/learn/SKILL.md` |
| OpenCode | `adapters/opencode/learn.md` | `~/.config/opencode/commands/learn.md` |

Installed globally, so `/learn` resolves from **any** directory — including while working inside an
unrelated company repo.

## Install / reinstall

Use the installer at the repo root — it detects the repo path and substitutes it, so the same
checkout works on any machine at any location:

```powershell
.\install.ps1        # or  ./install.sh
```

The manual equivalent, if you prefer (note: this installs the placeholder path verbatim, so it only
works if the repo really is at `C:/Projects/learning-system`):

```bash
# Claude Code
mkdir -p ~/.claude/skills/learn
cp /c/Projects/learning-system/adapters/claude/SKILL.md ~/.claude/skills/learn/SKILL.md

# OpenCode
mkdir -p ~/.config/opencode/commands ~/.config/opencode/command
cp /c/Projects/learning-system/adapters/opencode/learn.md ~/.config/opencode/commands/learn.md
cp /c/Projects/learning-system/adapters/opencode/learn.md ~/.config/opencode/command/learn.md
```

**Why OpenCode gets two directories.** The documented path is `commands/` (plural), but published
sources disagree about whether some builds read `command/` (singular). The adapter is a ~20-line
pointer with no learning content, so writing both spellings guarantees `/learn` resolves whichever
convention the installed build uses. This duplicates a pointer, never content. If you confirm which
one your build reads, delete the other.

## Moving the learning repo

The absolute path appears in exactly **one** line per adapter (the fenced `Learning home:` block).
Edit those two lines, reinstall with the commands above, done.

## Verifying an install

```bash
test -f ~/.claude/skills/learn/SKILL.md && echo "claude adapter installed"
test -f ~/.config/opencode/commands/learn.md && echo "opencode adapter installed"

# installed copies must be byte-identical to canonical
diff -q adapters/claude/SKILL.md   ~/.claude/skills/learn/SKILL.md
diff -q adapters/opencode/learn.md ~/.config/opencode/commands/learn.md
```

In Claude Code the skill is picked up on the next session start. In OpenCode the command appears as
`/learn` in the TUI.

## Adding a third agent

Create `adapters/<agent>/` with whatever entry-point format that agent expects, pointing at
`core/BOOTSTRAP.md` the same way. Do not copy any part of `core/` into it. Then add a row to the
table above.
