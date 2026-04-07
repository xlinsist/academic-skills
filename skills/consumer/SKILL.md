---
name: consumer
description: 从 TASK_QUEUE.md 循环拉取任务并执行；闭环后从队列移除，并将完整过程沉淀到 TASK_RECORD.md。
---

# Consumer

用于“执行任务并归档结果”，与 `producer` 配合使用。

## 自动托管规则

- 调用 `consumer` skill 时，不要求用户手动运行任何命令。
- 消费循环默认由 `skills/consumer/scripts/ensure_consumer.sh` 静默拉起（`tmux` 后台会话）。
- 当连续空闲超过 `IDLE_EXIT_SECONDS`（默认 180 秒）时，`consumer_loop.sh` 自动退出并释放会话。
- `producer` 在成功入队后应自动调用 `ensure_consumer.sh`，实现“写入即触发消费”。

## 职责边界

- 只从 `TASK_QUEUE.md` 获取任务并执行。
- 任务闭环后必须从队列移除，不保留已完成项。
- 每个已完成任务都要写入 `TASK_RECORD.md`。

## 循环执行流程

1. 拉取任务
- 打开仓库根目录 `TASK_QUEUE.md`，从上到下读取第一条 `status: todo` 任务。
- 将该任务临时标记为 `status: doing`（避免并行冲突）。

2. 执行任务
- 严格按 `goal/method/verification` 执行。
- 若发现任务定义不完整（缺目标或缺验证），停止执行并回写 `blocked` 说明，等待 `producer` 重新产出。

3. 验证闭环
- 必须运行或检查任务中定义的验证手段。
- 验证失败则继续迭代；必要时记录失败原因与下一步。

4. 出队与归档
- 验证通过后，将该任务从 `TASK_QUEUE.md` 删除。
- 在 `TASK_RECORD.md` 追加一条完整记录（含目标、方法、验证、结果、产物路径、时间戳）。

5. 继续循环
- 继续读取下一条 `todo` 任务，直到队列为空。

## 脚本执行语义

- `consumer_loop.sh` 会周期扫描 `TASK_QUEUE.md`，并使用 `.task_queue.lock` 做互斥。
- 每次只抢占一条 `todo` 任务，先改为 `doing`，避免并发重复消费。
- 调用 handler 执行任务：
  - 返回 `0`：视为闭环成功，出队并写 `TASK_RECORD.md`。
  - 非 `0`：改为 `blocked`，等待人工或 `producer` 修复任务定义。
- 当队列持续无可消费任务达到空闲阈值后，消费者自动退出。
- 默认 handler 只自动执行 `verification` 中可提取的命令：
  - `verification: cmd: <shell command>`
  - 或 `verification` 含反引号命令（例如 `` `pytest -q` ``）

## 记录模板（追加到 TASK_RECORD.md）

```markdown
## T-0001 | YYYY-MM-DD HH:MM UTC
- goal: ...
- method:
  - step1 ...
  - step2 ...
- verification:
  - command/check: ...
  - pass criteria: ...
- result: pass/fail
- artifacts: ...
- notes: ...
```

## 并行协同约束

- 允许与 `producer` 并行对话与行动。
- `producer` 只追加任务，`consumer` 只消费任务，职责不交叉。
- 发生冲突时以 `TASK_QUEUE.md` 当前文件内容为准，先读后写，避免覆盖。
