#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(pwd)"
if [[ "${1:-}" != "" && "${1:-}" != --* ]]; then
  ROOT_DIR="$1"
  shift
fi

GOAL=""
SCOPE_IN=""
SCOPE_OUT=""
CONSTRAINTS=""
METHOD=""
VERIFICATION=""
DONE_DEFINITION=""
RISK=""
COMPLEXITY="S"
NOTES=""

usage() {
  cat >&2 <<USAGE
usage:
  add_task.sh [root_dir] \
    --goal "..." \
    --scope-in "..." \
    --scope-out "..." \
    --constraints "..." \
    --method "step1; step2" \
    --verification "cmd: <shell command>" \
    --done-definition "..." \
    --risk "..." \
    [--complexity S|M|L] \
    [--notes "..."]
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --goal) GOAL="${2:-}"; shift 2 ;;
    --scope-in) SCOPE_IN="${2:-}"; shift 2 ;;
    --scope-out) SCOPE_OUT="${2:-}"; shift 2 ;;
    --constraints) CONSTRAINTS="${2:-}"; shift 2 ;;
    --method) METHOD="${2:-}"; shift 2 ;;
    --verification) VERIFICATION="${2:-}"; shift 2 ;;
    --done-definition) DONE_DEFINITION="${2:-}"; shift 2 ;;
    --risk) RISK="${2:-}"; shift 2 ;;
    --complexity) COMPLEXITY="${2:-}"; shift 2 ;;
    --notes) NOTES="${2:-}"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *)
      echo "unknown argument: $1" >&2
      usage
      exit 2
      ;;
  esac
done

QUEUE_FILE="$ROOT_DIR/TASK_QUEUE.md"
RECORD_FILE="$ROOT_DIR/TASK_RECORD.md"
LOCK_FILE="$ROOT_DIR/.task_queue.lock"
ENSURE_CONSUMER="$ROOT_DIR/skills/consumer/scripts/ensure_consumer.sh"

if [[ ! -f "$QUEUE_FILE" || ! -f "$RECORD_FILE" ]]; then
  echo "TASK_QUEUE.md or TASK_RECORD.md is missing under $ROOT_DIR" >&2
  exit 1
fi

require_non_empty() {
  local name="$1"
  local value="$2"
  if [[ -z "$value" ]]; then
    echo "missing required field: $name" >&2
    exit 2
  fi
}

reject_delimiter() {
  local name="$1"
  local value="$2"
  if [[ "$value" == *"|"* ]]; then
    echo "field '$name' must not contain '|'" >&2
    exit 2
  fi
}

require_non_empty "goal" "$GOAL"
require_non_empty "scope_in" "$SCOPE_IN"
require_non_empty "scope_out" "$SCOPE_OUT"
require_non_empty "constraints" "$CONSTRAINTS"
require_non_empty "method" "$METHOD"
require_non_empty "verification" "$VERIFICATION"
require_non_empty "done_definition" "$DONE_DEFINITION"
require_non_empty "risk" "$RISK"

if [[ ! "$VERIFICATION" =~ ^cmd:[[:space:]]+.+$ ]]; then
  echo "verification must be in format: cmd: <shell command>" >&2
  exit 2
fi

if [[ "$COMPLEXITY" != "S" && "$COMPLEXITY" != "M" && "$COMPLEXITY" != "L" ]]; then
  echo "complexity must be one of S/M/L" >&2
  exit 2
fi

if [[ "$COMPLEXITY" == "L" && "${ALLOW_COMPLEXITY_L:-0}" != "1" ]]; then
  echo "complexity L requires ALLOW_COMPLEXITY_L=1" >&2
  exit 2
fi

for pair in \
  "goal:$GOAL" \
  "scope_in:$SCOPE_IN" \
  "scope_out:$SCOPE_OUT" \
  "constraints:$CONSTRAINTS" \
  "method:$METHOD" \
  "verification:$VERIFICATION" \
  "done_definition:$DONE_DEFINITION" \
  "risk:$RISK" \
  "complexity:$COMPLEXITY" \
  "notes:$NOTES"; do
  name="${pair%%:*}"
  value="${pair#*:}"
  reject_delimiter "$name" "$value"
done

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

TASK_LINE="- [ ] ${TASK_ID} | status: todo | owner: consumer | goal: ${GOAL} | scope_in: ${SCOPE_IN} | scope_out: ${SCOPE_OUT} | constraints: ${CONSTRAINTS} | method: ${METHOD} | verification: ${VERIFICATION} | done_definition: ${DONE_DEFINITION} | risk: ${RISK} | complexity: ${COMPLEXITY} | created: ${CREATED}"
if [[ -n "$NOTES" ]]; then
  TASK_LINE+=" | notes: ${NOTES}"
fi

append_task_line "$TASK_LINE"
flock -u 9

if [[ -x "$ENSURE_CONSUMER" ]]; then
  "$ENSURE_CONSUMER" "$ROOT_DIR" >/dev/null 2>&1 || true
fi

printf '%s\n' "$TASK_ID"
