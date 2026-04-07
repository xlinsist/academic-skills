#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="${1:-$(pwd)}"
GOAL="${2:-}"
METHOD="${3:-}"
VERIFICATION="${4:-}"
COMPLEXITY="${5:-S}"
NOTES="${6:-}"

QUEUE_FILE="$ROOT_DIR/TASK_QUEUE.md"
RECORD_FILE="$ROOT_DIR/TASK_RECORD.md"
LOCK_FILE="$ROOT_DIR/.task_queue.lock"
ENSURE_CONSUMER="$ROOT_DIR/skills/consumer/scripts/ensure_consumer.sh"

if [[ -z "$GOAL" || -z "$METHOD" || -z "$VERIFICATION" ]]; then
  echo "usage: add_task.sh <root_dir> <goal> <method> <verification> [complexity] [notes]" >&2
  exit 2
fi

if [[ ! -f "$QUEUE_FILE" || ! -f "$RECORD_FILE" ]]; then
  echo "TASK_QUEUE.md or TASK_RECORD.md is missing under $ROOT_DIR" >&2
  exit 1
fi

touch "$LOCK_FILE"

next_task_id() {
  local max_id
  max_id="$({ grep -hEo 'T-[0-9]{4}' "$QUEUE_FILE" "$RECORD_FILE" 2>/dev/null || true; } | sed 's/T-//' | sort -n | tail -n1)"
  if [[ -z "$max_id" ]]; then
    max_id=0
  fi
  printf 'T-%04d' "$((10#$max_id + 1))"
}

append_task_line() {
  local task_line="$1"

  awk -v newline="$task_line" '
    BEGIN { inserted=0 }
    /^- \(empty\)$/ { next }
    /^<!--/ && inserted==0 { print newline; inserted=1 }
    { print }
    END { if (inserted==0) print newline }
  ' "$QUEUE_FILE" > "$QUEUE_FILE.tmp"
  mv "$QUEUE_FILE.tmp" "$QUEUE_FILE"
}

exec 9>"$LOCK_FILE"
flock -w 5 9

TASK_ID="$(next_task_id)"
CREATED="$(date -u '+%Y-%m-%d')"

TASK_LINE="- [ ] ${TASK_ID} | status: todo | owner: consumer | goal: ${GOAL} | method: ${METHOD} | verification: ${VERIFICATION} | complexity: ${COMPLEXITY} | created: ${CREATED}"
if [[ -n "$NOTES" ]]; then
  TASK_LINE+=" | notes: ${NOTES}"
fi

append_task_line "$TASK_LINE"

flock -u 9

if [[ -x "$ENSURE_CONSUMER" ]]; then
  "$ENSURE_CONSUMER" "$ROOT_DIR" >/dev/null 2>&1 || true
fi

printf '%s\n' "$TASK_ID"
