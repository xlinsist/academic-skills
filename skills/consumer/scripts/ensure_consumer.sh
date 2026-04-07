#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="${1:-$(pwd)}"
SESSION_NAME="${CONSUMER_SESSION_NAME:-consumer-loop}"
POLL_SECONDS="${POLL_SECONDS:-3}"
IDLE_EXIT_SECONDS="${IDLE_EXIT_SECONDS:-180}"
LOG_FILE="${CONSUMER_LOG_FILE:-$ROOT_DIR/.consumer_loop.log}"

if ! command -v tmux >/dev/null 2>&1; then
  exit 0
fi

if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
  exit 0
fi

cmd="cd '$ROOT_DIR' && POLL_SECONDS='$POLL_SECONDS' IDLE_EXIT_SECONDS='$IDLE_EXIT_SECONDS' bash '$ROOT_DIR/skills/consumer/scripts/consumer_loop.sh' '$ROOT_DIR' >> '$LOG_FILE' 2>&1"
tmux new-session -d -s "$SESSION_NAME" "$cmd"
