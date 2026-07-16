#!/usr/bin/env bash
set -euo pipefail

TARGET_DIR="${1:-public}"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="$ROOT_DIR/.env"

if [[ -f "$ENV_FILE" ]]; then
  # shellcheck disable=SC1090
  source "$ENV_FILE"
fi

PRIVATE_TERMS="${PRIVATE_TERMS:-}"

if [[ ! -d "$TARGET_DIR" ]]; then
  echo "Target directory does not exist: $TARGET_DIR" >&2
  exit 1
fi

if [[ -n "$PRIVATE_TERMS" ]]; then
  IFS=',' read -r -a terms <<< "$PRIVATE_TERMS"
  for term in "${terms[@]}"; do
    term="${term#"${term%%[![:space:]]*}"}"
    term="${term%"${term##*[![:space:]]}"}"
    [[ -z "$term" ]] && continue
    find "$TARGET_DIR" -type f -name '*.md' -print0 | xargs -0 sed -i "s/${term}/PRIVATE_DETAIL/g"
  done
fi

blocked_patterns='(ssh |scp |~/.ssh|HostName |IdentityFile |github.com[:/][^[:space:]]+/[^[:space:]]+|[0-9]{1,3}(\.[0-9]{1,3}){3})'

if find "$TARGET_DIR" -type f -name '*.md' -print0 | xargs -0 grep -En "$blocked_patterns"; then
  echo "Potential private operational details found. Review and sanitize before publishing." >&2
  exit 1
fi

echo "Sanitization check passed for $TARGET_DIR"
