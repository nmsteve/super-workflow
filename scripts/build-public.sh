#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="$ROOT_DIR/.env"

if [[ -f "$ENV_FILE" ]]; then
  # shellcheck disable=SC1090
  source "$ENV_FILE"
fi

PUBLIC_OUTPUT_DIR="${PUBLIC_OUTPUT_DIR:-$ROOT_DIR/public}"
PRIVATE_CLAUDE_FILE="${PRIVATE_CLAUDE_FILE:-$HOME/.claude/CLAUDE.md}"
PRIVATE_AGENTS_FILE="${PRIVATE_AGENTS_FILE:-$HOME/.codex/AGENTS.md}"
PRIVATE_RULES_FILE="${PRIVATE_RULES_FILE:-$HOME/.claude/hooks/interaction-rules.md}"
PRIVATE_TERMS="${PRIVATE_TERMS:-}"
USE_PRIVATE_SOURCE="${USE_PRIVATE_SOURCE:-false}"

mkdir -p "$PUBLIC_OUTPUT_DIR"

copy_or_template() {
  local source_file="$1"
  local template_file="$2"
  local target_file="$3"

  if [[ -f "$source_file" ]]; then
    cp "$source_file" "$target_file"
  else
    cp "$template_file" "$target_file"
  fi
}

if [[ "$USE_PRIVATE_SOURCE" == "true" ]]; then
  copy_or_template "$PRIVATE_AGENTS_FILE" "$ROOT_DIR/templates/AGENTS.md" "$PUBLIC_OUTPUT_DIR/AGENTS.md"
  copy_or_template "$PRIVATE_CLAUDE_FILE" "$ROOT_DIR/templates/CLAUDE.md" "$PUBLIC_OUTPUT_DIR/CLAUDE.md"
  copy_or_template "$PRIVATE_RULES_FILE" "$ROOT_DIR/templates/interaction-rules.md" "$PUBLIC_OUTPUT_DIR/interaction-rules.md"
else
  cp "$ROOT_DIR/templates/AGENTS.md" "$PUBLIC_OUTPUT_DIR/AGENTS.md"
  cp "$ROOT_DIR/templates/CLAUDE.md" "$PUBLIC_OUTPUT_DIR/CLAUDE.md"
  cp "$ROOT_DIR/templates/interaction-rules.md" "$PUBLIC_OUTPUT_DIR/interaction-rules.md"
fi

"$ROOT_DIR/scripts/sanitize-public.sh" "$PUBLIC_OUTPUT_DIR"

echo "Public workflow files built in $PUBLIC_OUTPUT_DIR"
