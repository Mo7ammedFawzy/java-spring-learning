#!/usr/bin/env bash
# Installs the Learning System adapters so /learn works from any directory.
#
# Detects this repo's location automatically and writes the per-agent adapters into the
# global config directories, substituting the detected path. Nothing in this repo is
# modified, so the same checkout installs correctly on any machine at any path.
#
# Safe to re-run.  Usage:  ./install.sh  [--uninstall]
#
# The adapters are pointers back to this repo — learning content is never copied — so the
# repo must stay where it is after installing. Move it, and just re-run this script.

set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# On Git Bash / MSYS, `pwd` yields /c/Projects/... which the agents' file tools cannot open on
# Windows. cygpath -m converts it to C:/Projects/... Without this the adapters install with a
# path that silently fails to resolve.
if command -v cygpath >/dev/null 2>&1; then
  REPO="$(cygpath -m "$REPO")"
fi
PLACEHOLDER='C:/Projects/learning-system'

CLAUDE_DST="$HOME/.claude/skills/learn/SKILL.md"
# OpenCode's documented folder is "commands"; some builds read "command". Both get the same
# ~25-line pointer so /learn resolves either way. Duplicates a pointer, never content.
OPEN_DSTS=("$HOME/.config/opencode/commands/learn.md" "$HOME/.config/opencode/command/learn.md")

if [ "${1:-}" = "--uninstall" ]; then
  for f in "$CLAUDE_DST" "${OPEN_DSTS[@]}"; do
    [ -f "$f" ] && rm -f "$f" && echo "removed  $f"
  done
  echo; echo "Uninstalled. This repo was not touched."
  exit 0
fi

install_adapter() {
  local src="$1" dst="$2"
  [ -f "$src" ] || { echo "missing canonical adapter: $src" >&2; exit 1; }
  mkdir -p "$(dirname "$dst")"
  sed "s|$PLACEHOLDER|$REPO|g" "$src" > "$dst"
  echo "installed  $dst"
}

echo "Learning System"
echo "repo: $REPO"
echo

install_adapter "$REPO/adapters/claude/SKILL.md" "$CLAUDE_DST"
for d in "${OPEN_DSTS[@]}"; do
  install_adapter "$REPO/adapters/opencode/learn.md" "$d"
done

# --- verify the installed copies actually point back here ---
echo
fail=0
for f in "$CLAUDE_DST" "${OPEN_DSTS[@]}"; do
  grep -qF "$REPO/core/BOOTSTRAP.md" "$f" || { echo "FAILED - does not point at this repo: $f" >&2; fail=1; }
done
[ "$fail" -eq 0 ] || exit 1
echo "verified: all adapters resolve to $REPO/core/BOOTSTRAP.md"

# --- environment report (informational, never fatal) ---
echo
echo "Environment:"
if command -v java >/dev/null 2>&1; then
  echo "  java     $(java -version 2>&1 | head -1)"
else
  echo "  java     NOT FOUND - install a JDK (21+) or exercises cannot be run"
fi
command -v claude   >/dev/null 2>&1 && echo "  claude   found"   || echo "  claude   not on PATH"
command -v opencode >/dev/null 2>&1 && echo "  opencode found"   || echo "  opencode not on PATH"

if [ -d "/c/Projects/8080" ] || [ -d "C:/Projects/8080" ]; then
  echo "  lab      nama-erp available"
else
  echo "  lab      nama-erp not present - lessons run in codebase-free mode (this is fine)"
fi

echo
echo "Done. Start a new agent session and type /learn"
