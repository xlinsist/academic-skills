#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="${1:-$(pwd)}"
QUEUE_FILE="$ROOT_DIR/TASK_QUEUE.md"
RECORD_FILE="$ROOT_DIR/TASK_RECORD.md"
LOCK_FILE="$ROOT_DIR/.task_queue.lock"
POLL_SECONDS="${POLL_SECONDS:-3}"
IDLE_EXIT_SECONDS="${IDLE_EXIT_SECONDS:-180}"
HANDLER="${CONSUMER_HANDLER:-$ROOT_DIR/skills/consumer/scripts/default_handler.sh}"

if [[ ! -f "$QUEUE_FILE" ]]; then
  echo "TASK_QUEUE.md not found at: $QUEUE_FILE" >&2
  exit 1
fi
if [[ ! -f "$RECORD_FILE" ]]; then
  echo "TASK_RECORD.md not found at: $RECORD_FILE" >&2
  exit 1
fi
if [[ ! -x "$HANDLER" ]]; then
  echo "handler is not executable: $HANDLER" >&2
  exit 1
fi

touch "$LOCK_FILE"

log() {
  local level="$1"
  shift
  printf '[%s] [%s] %s\n' "$(date -u '+%Y-%m-%d %H:%M:%S UTC')" "$level" "$*"
}

trim() {
  sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//'
}

extract_field() {
  local line="$1"
  local key="$2"
  printf '%s\n' "$line" | awk -v k="$key" -F' [|] ' '
    {
      for (i = 1; i <= NF; i++) {
        if ($i ~ ("^" k ": ")) {
          sub("^" k ": ", "", $i)
          print $i
          exit
        }
      }
    }
  '
}

claim_task() {
  local line_no line claimed
  line_no="$(grep -nE '^- \[ \] T-[0-9]{4} \| status: todo \|' "$QUEUE_FILE" | head -n1 | cut -d: -f1 || true)"
  if [[ -z "$line_no" ]]; then
    return 1
  fi

  line="$(sed -n "${line_no}p" "$QUEUE_FILE")"
  claimed="${line/status: todo/status: doing}"

  awk -v ln="$line_no" -v repl="$claimed" 'NR==ln {$0=repl} {print}' "$QUEUE_FILE" > "$QUEUE_FILE.tmp"
  mv "$QUEUE_FILE.tmp" "$QUEUE_FILE"

  printf '%s\n%s\n%s\n' "$line_no" "$line" "$claimed"
}

remove_claimed_line() {
  local line_no="$1"
  awk -v ln="$line_no" 'NR!=ln {print}' "$QUEUE_FILE" > "$QUEUE_FILE.tmp"
  mv "$QUEUE_FILE.tmp" "$QUEUE_FILE"
  ensure_empty_marker
}

ensure_empty_marker() {
  if grep -qE '^- \[ \] T-[0-9]{4} \|' "$QUEUE_FILE"; then
    return 0
  fi
  awk '
    BEGIN { inserted=0 }
    /^- \(empty\)$/ { next }
    /^<!--/ && inserted==0 { print "- (empty)"; inserted=1 }
    { print }
    END { if (inserted==0) print "- (empty)" }
  ' "$QUEUE_FILE" > "$QUEUE_FILE.tmp"
  mv "$QUEUE_FILE.tmp" "$QUEUE_FILE"
}

mark_blocked() {
  local line_no="$1"
  local current_line blocked_line
  current_line="$(sed -n "${line_no}p" "$QUEUE_FILE")"
  blocked_line="${current_line/status: doing/status: blocked}"
  awk -v ln="$line_no" -v repl="$blocked_line" 'NR==ln {$0=repl} {print}' "$QUEUE_FILE" > "$QUEUE_FILE.tmp"
  mv "$QUEUE_FILE.tmp" "$QUEUE_FILE"
}

append_record_pass() {
  local task_id="$1"
  local goal="$2"
  local method="$3"
  local verification="$4"
  local complexity="$5"
  local created="$6"
  local notes="$7"
  local ts
  ts="$(date -u '+%Y-%m-%d %H:%M UTC')"

  cat >> "$RECORD_FILE" <<REC

## ${task_id} | ${ts}
- goal: ${goal}
- method: ${method}
- verification:
  - command/check: ${verification}
  - pass criteria: command exits with code 0
- result: pass
- artifacts: N/A
- notes: complexity=${complexity}; created=${created}; ${notes}
REC
}

while true; do
  now_ts="$(date +%s)"
  if [[ -z "${last_active_ts:-}" ]]; then
    last_active_ts="$now_ts"
  fi

  # Phase 1: claim a task under lock.
  claimed_blob=""
  exec 9>"$LOCK_FILE"
  if flock -w 2 9; then
    claimed_blob="$(claim_task || true)"
    flock -u 9
  fi

  if [[ -z "$claimed_blob" ]]; then
    if (( now_ts - last_active_ts >= IDLE_EXIT_SECONDS )); then
      log INFO "idle timeout (${IDLE_EXIT_SECONDS}s) reached; exiting"
      exit 0
    fi
    sleep "$POLL_SECONDS"
    continue
  fi

  last_active_ts="$now_ts"

  line_no="$(printf '%s\n' "$claimed_blob" | sed -n '1p')"
  original_line="$(printf '%s\n' "$claimed_blob" | sed -n '2p')"
  task_id="$(printf '%s\n' "$original_line" | sed -nE 's/^- \[ \] (T-[0-9]{4}) .*/\1/p')"
  goal="$(extract_field "$original_line" 'goal' | trim)"
  method="$(extract_field "$original_line" 'method' | trim)"
  verification="$(extract_field "$original_line" 'verification' | trim)"
  complexity="$(extract_field "$original_line" 'complexity' | trim)"
  created="$(extract_field "$original_line" 'created' | trim)"

  if [[ -z "$task_id" || -z "$goal" || -z "$verification" ]]; then
    log WARN "task parse failed (line $line_no), moving to blocked"
    exec 9>"$LOCK_FILE"
    if flock -w 2 9; then
      mark_blocked "$line_no"
      flock -u 9
    fi
    sleep "$POLL_SECONDS"
    continue
  fi

  log INFO "claimed ${task_id}; running handler"

  set +e
  handler_output="$(
    TASK_ID="$task_id" \
    TASK_GOAL="$goal" \
    TASK_METHOD="$method" \
    TASK_VERIFICATION="$verification" \
    TASK_COMPLEXITY="$complexity" \
    TASK_CREATED="$created" \
    ROOT_DIR="$ROOT_DIR" \
    "$HANDLER"
  2>&1)"
  rc=$?
  set -e

  exec 9>"$LOCK_FILE"
  if flock -w 2 9; then
    if [[ "$rc" -eq 0 ]]; then
      remove_claimed_line "$line_no"
      append_record_pass "$task_id" "$goal" "$method" "$verification" "$complexity" "$created" "${handler_output}"
      log INFO "${task_id} completed and removed from queue"
    else
      mark_blocked "$line_no"
      log WARN "${task_id} blocked (handler rc=${rc}): ${handler_output}"
    fi
    flock -u 9
  fi

  sleep "$POLL_SECONDS"
done
