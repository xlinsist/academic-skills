# TASK_QUEUE

用于维护待执行任务队列。`producer` 负责追加，`consumer` 负责消费并移除已完成任务。

## Rules

- 新任务只允许追加到 `## Queue`。
- 每条任务必须包含：`goal`、`method`、`verification`、`complexity`、`created`。
- 状态仅允许：`todo`、`doing`、`blocked`。
- 任务完成后，`consumer` 必须将该任务从本文件移除，并把细节写入 `TASK_RECORD.md`。

## Queue


- (empty)
<!--
Template:
- [ ] EXAMPLE-ID | status: todo | owner: consumer | goal: ... | method: step1; step2; step3 | verification: ... | complexity: S | created: YYYY-MM-DD
-->
