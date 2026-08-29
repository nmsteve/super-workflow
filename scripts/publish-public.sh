#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="$ROOT_DIR/.env"

if [[ -f "$ENV_FILE" ]]; then
  # shellcheck disable=SC1090
  source "$ENV_FILE"
else
  echo "Missing .env. Copy .env.example to .env and configure PUBLIC_REPO_URL." >&2
  exit 1
fi

PUBLIC_OUTPUT_DIR="${PUBLIC_OUTPUT_DIR:-$ROOT_DIR/public}"
PUBLIC_REPO_URL="${PUBLIC_REPO_URL:-}"
PUBLIC_REPO_BRANCH="${PUBLIC_REPO_BRANCH:-main}"

if [[ -z "$PUBLIC_REPO_URL" ]]; then
  echo "PUBLIC_REPO_URL is not set in .env" >&2
  exit 1
fi

if ! command -v git >/dev/null 2>&1; then
  echo "git is required to publish. Install git, then rerun this script." >&2
  exit 1
fi

"$ROOT_DIR/scripts/build-public.sh"

workdir="$(mktemp -d)"
trap 'rm -rf "$workdir"' EXIT

git clone "$PUBLIC_REPO_URL" "$workdir/repo"
cd "$workdir/repo"
git switch "$PUBLIC_REPO_BRANCH" 2>/dev/null || git switch -c "$PUBLIC_REPO_BRANCH"

rsync -rlt --delete --exclude=".git/" "$PUBLIC_OUTPUT_DIR"/ "$workdir/repo"/

git add .
if git diff --cached --quiet; then
  echo "No public workflow changes to publish."
  exit 0
fi

git commit -m "Update public super workflow"
git push origin "$PUBLIC_REPO_BRANCH"
