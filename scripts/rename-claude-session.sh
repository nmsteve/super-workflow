#!/usr/bin/env bash
# claude-rename-session <new-name>
#
# Renames the Claude Code session that this process is running inside, by
# writing "name"/"nameSource" into ~/.claude/sessions/<pid>.json.
#
# Verified behaviour (Claude Code 2.1.251): the running process merges its
# heartbeat (status/updatedAt) into the existing file and PRESERVES an
# externally written name, so the change sticks on disk and is what peer
# sessions and the resume picker read. The current terminal tab title and the
# session's own in-memory identity are NOT updated until the session restarts.
#
# There is no supported programmatic rename; this pokes undocumented state.
# If a future version stops honouring it, the script says so instead of
# reporting a silent success.
set -uo pipefail

SESSIONS_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/sessions"

die() { printf 'claude-rename-session: %s\n' "$1" >&2; exit 1; }

[ $# -eq 1 ] || die "usage: claude-rename-session <new-name>"
NEW_NAME="$1"
[ -n "$NEW_NAME" ] || die "name must not be empty"
case "$NEW_NAME" in *$'\n'*) die "name must not contain a newline";; esac
[ -d "$SESSIONS_DIR" ] || die "no sessions directory at $SESSIONS_DIR"

# Find the session file by walking up the process tree from this script.
find_session_file() {
  local pid=$PPID hops=0 f
  while [ "$pid" -gt 1 ] && [ "$hops" -lt 20 ]; do
    f="$SESSIONS_DIR/$pid.json"
    [ -f "$f" ] && { printf '%s\n' "$f"; return 0; }
    pid=$(ps -o ppid= -p "$pid" 2>/dev/null | tr -d ' ')
    [ -n "$pid" ] || return 1
    hops=$((hops + 1))
  done
  return 1
}

SESSION_FILE=$(find_session_file) \
  || die "no ancestor process has a session file in $SESSIONS_DIR (not running inside Claude Code?)"

OLD_NAME=$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1])).get("name",""))' "$SESSION_FILE") \
  || die "could not read $SESSION_FILE"

# Read-modify-write, atomically, keeping every other field untouched.
python3 - "$SESSION_FILE" "$NEW_NAME" <<'PY' || die "write failed"
import json, os, sys, time
path, name = sys.argv[1], sys.argv[2]
with open(path) as fh:
    d = json.load(fh)
d["name"] = name
d["nameSource"] = "user"
d["nameSince"] = int(time.time() * 1000)
tmp = path + ".rename.tmp"
with open(tmp, "w") as fh:
    json.dump(d, fh, separators=(",", ":"))
os.chmod(tmp, 0o664)
os.replace(tmp, path)
PY

# Verify the value survives at least one heartbeat from the running session.
BEFORE_UPDATED=$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1])).get("updatedAt",0))' "$SESSION_FILE")
verdict="unconfirmed"
for _ in $(seq 1 10); do
  sleep 2
  cur_name=$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1])).get("name",""))' "$SESSION_FILE" 2>/dev/null)
  cur_updated=$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1])).get("updatedAt",0))' "$SESSION_FILE" 2>/dev/null)
  [ "$cur_name" = "$NEW_NAME" ] || { verdict="clobbered"; break; }
  [ "$cur_updated" != "$BEFORE_UPDATED" ] && { verdict="confirmed"; break; }
done

case "$verdict" in
  confirmed)
    echo "renamed session: '$OLD_NAME' -> '$NEW_NAME' ($SESSION_FILE)"
    echo "note: the current terminal tab title keeps the old name until this session restarts."
    ;;
  clobbered)
    echo "claude-rename-session: the running session overwrote the name (now '$cur_name')." >&2
    echo "This Claude Code version no longer honours an external rename; use /rename $NEW_NAME instead." >&2
    exit 1
    ;;
  *)
    echo "renamed session on disk: '$OLD_NAME' -> '$NEW_NAME' ($SESSION_FILE)"
    echo "note: no heartbeat seen within 20s, so persistence is unconfirmed; the terminal tab title also keeps the old name until restart."
    ;;
esac
