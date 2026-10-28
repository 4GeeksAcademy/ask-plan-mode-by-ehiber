#!/usr/bin/env bash
# Genera los adaptadores por herramienta a partir de prompts-agnostic/.
# Fuente de verdad: prompts-agnostic/*.md. No edites adapters/ a mano.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$ROOT/prompts-agnostic"
OUT="$ROOT/adapters"

rm -rf "$OUT/claude-code" "$OUT/cursor" "$OUT/copilot"
mkdir -p "$OUT/claude-code/.claude/agents" "$OUT/cursor/.cursor/rules" "$OUT/copilot/.github/chatmodes"

# role | source file | description | read-only? (1/0)
ROLES=(
  "ask-architect|01-ask-architect.md|Analiza contexto, dependencias y edge cases. Nunca escribe código.|1"
  "plan-spec|02-plan-spec.md|Convierte el análisis en un plan con pasos atómicos y contratos. Espera aprobación humana.|1"
  "agent-executor|03-agent-executor.md|Implementa un plan aprobado, un paso a la vez, sin salirse del plan.|0"
)

for entry in "${ROLES[@]}"; do
  IFS='|' read -r name file desc readonly <<<"$entry"
  body="$SRC/$file"

  if [ "$readonly" = "1" ]; then
    claude_tools="Read, Grep, Glob"
    copilot_tools="['codebase', 'search', 'usages']"
  else
    claude_tools="Read, Edit, Write, Bash, Grep, Glob"
    copilot_tools="['codebase', 'search', 'usages', 'editFiles', 'runCommands']"
  fi

  # Claude Code: subagente con herramientas limitadas
  {
    printf -- '---\nname: %s\ndescription: %s\ntools: %s\n---\n\n' "$name" "$desc" "$claude_tools"
    cat "$body"
  } >"$OUT/claude-code/.claude/agents/$name.md"

  # Cursor: regla que se activa manualmente (@)
  {
    printf -- '---\ndescription: %s\nglobs:\nalwaysApply: false\n---\n\n' "$desc"
    cat "$body"
  } >"$OUT/cursor/.cursor/rules/$name.mdc"

  # GitHub Copilot: modo de chat con herramientas limitadas
  {
    printf -- "---\ndescription: %s\ntools: %s\n---\n\n" "$desc" "$copilot_tools"
    cat "$body"
  } >"$OUT/copilot/.github/chatmodes/$name.chatmode.md"
done

echo "Adaptadores generados en $OUT"
