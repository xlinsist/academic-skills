# TASK_QUEUE

用于维护待执行任务队列。`producer` 负责按 SSD 字段追加，`consumer` 负责消费并移除已完成任务。

## Rules

- 新任务只允许追加到 `## Queue`。
- 每条任务必须包含：`goal`、`scope_in`、`scope_out`、`constraints`、`method`、`verification`、`done_definition`、`risk`、`complexity`、`created`。
- `verification` 必须是 `cmd: <shell command>`。
- 状态仅允许：`todo`、`doing`、`blocked`。
- 任务完成后，`consumer` 必须将该任务从本文件移除，并把细节写入 `TASK_RECORD.md`。

## Queue


- (empty)
<!--
Template:
- [ ] EXAMPLE-ID | status: todo | owner: consumer | goal: ... | scope_in: ... | scope_out: ... | constraints: ... | method: step1; step2; step3 | verification: cmd: <shell command> | done_definition: ... | risk: ... | complexity: S | created: YYYY-MM-DD
-->
