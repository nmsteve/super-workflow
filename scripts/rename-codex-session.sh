#!/usr/bin/env bash
set -euo pipefail

readonly RESPONSE_TIMEOUT_SECONDS="${CODEX_RENAME_TIMEOUT_SECONDS:-15}"

usage() {
  echo "Usage: codex-rename-session <session-name>" >&2
}

if [[ "$#" -ne 1 ]]; then
  usage
  exit 2
fi

session_name="$1"
thread_id="${CODEX_THREAD_ID:-}"

if [[ -z "$session_name" ]]; then
  echo "Session name must not be empty." >&2
  exit 2
fi

if [[ "$session_name" =~ [[:cntrl:]] ]]; then
  echo "Session name must not contain control characters." >&2
  exit 2
fi

if (( ${#session_name} > 255 )); then
  echo "Session name must be 255 characters or fewer." >&2
  exit 2
fi

if [[ -z "$thread_id" ]]; then
  echo "CODEX_THREAD_ID is not set; run this helper from an active Codex session." >&2
  exit 2
fi

for dependency in codex jq; do
  if ! command -v "$dependency" >/dev/null 2>&1; then
    echo "$dependency is required but was not found in PATH." >&2
    exit 127
  fi
done

if [[ ! "$RESPONSE_TIMEOUT_SECONDS" =~ ^[1-9][0-9]*$ ]]; then
  echo "CODEX_RENAME_TIMEOUT_SECONDS must be a positive integer." >&2
  exit 2
fi

error_log="$(mktemp)"
server_pid=""
server_input=""
server_output=""

cleanup() {
  if [[ -n "$server_input" ]]; then
    eval "exec ${server_input}>&-" 2>/dev/null || true
  fi

  if [[ -n "$server_output" ]]; then
    eval "exec ${server_output}<&-" 2>/dev/null || true
  fi

  if [[ -n "$server_pid" ]] && kill -0 "$server_pid" 2>/dev/null; then
    kill "$server_pid" 2>/dev/null || true
    wait "$server_pid" 2>/dev/null || true
  fi

  rm -f -- "$error_log"
}
trap cleanup EXIT

coproc CODEX_APP_SERVER { codex app-server 2>"$error_log"; }
server_pid="$CODEX_APP_SERVER_PID"
server_output="${CODEX_APP_SERVER[0]}"
server_input="${CODEX_APP_SERVER[1]}"

send_message() {
  local message="$1"
  printf '%s\n' "$message" >&"$server_input"
}

read_response() {
  local expected_id="$1"
  local response

  while IFS= read -r -t "$RESPONSE_TIMEOUT_SECONDS" response <&"$server_output"; do
    if ! jq -e . >/dev/null 2>&1 <<<"$response"; then
      continue
    fi

    if [[ "$(jq -r '.id // empty' <<<"$response")" != "$expected_id" ]]; then
      continue
    fi

    if jq -e '.error != null' >/dev/null <<<"$response"; then
      jq -r '"Codex App Server error " + (.error.code | tostring) + ": " + .error.message' <<<"$response" >&2
      return 1
    fi

    if ! jq -e 'has("result")' >/dev/null <<<"$response"; then
      echo "Codex App Server returned an unsuccessful response." >&2
      return 1
    fi

    return 0
  done

  echo "Timed out waiting for Codex App Server response ${expected_id}." >&2
  if [[ -s "$error_log" ]]; then
    sed -n '1,20p' "$error_log" >&2
  fi
  return 1
}

send_message "$(jq -cn '{method:"initialize",id:1,params:{clientInfo:{name:"super_workflow_session_renamer",title:"Super Workflow Session Renamer",version:"1.0.0"}}}')"
read_response "1"

send_message "$(jq -cn '{method:"initialized",params:{}}')"
send_message "$(jq -cn --arg thread_id "$thread_id" --arg name "$session_name" '{method:"thread/name/set",id:2,params:{threadId:$thread_id,name:$name}}')"
read_response "2"

echo "Renamed Codex session to $session_name"
