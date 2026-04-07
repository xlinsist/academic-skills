#!/usr/bin/env bash
set -euo pipefail

# Inputs are provided via environment variables by consumer_loop.sh.
# Required: TASK_ID, TASK_GOAL, TASK_METHOD, TASK_VERIFICATION

extract_backtick_cmd() {
  local text="$1"
  # Extract first `...` segment if present.
  if [[ "$text" =~ \`([^\`]*)\` ]]; then
    printf '%s' "${BASH_REMATCH[1]}"
    return 0
  fi
  return 1
}

run_cmd() {
  local cmd="$1"
  if [[ -z "$cmd" ]]; then
    return 10
  fi
  bash -lc "$cmd"
}

verification="${TASK_VERIFICATION:-}"
cmd=""

if [[ "$verification" == cmd:* ]]; then
  cmd="${verification#cmd:}"
  cmd="${cmd# }"
elif cmd_candidate="$(extract_backtick_cmd "$verification")"; then
  cmd="$cmd_candidate"
fi

if [[ -n "$cmd" ]]; then
  run_cmd "$cmd"
  echo "verification command passed: $cmd"
  exit 0
fi

echo "no executable verification command found; expected 'cmd: <command>' or a backticked command in verification" >&2
exit 10
