---
name: producer
description: 与用户对话创建可执行任务；在 plan mode 下明确目标、方法、验证手段并控制复杂度，然后将任务追加到 TASK_QUEUE.md。
---

# Producer

用于“产出任务，不执行任务”。

## 职责边界

- 只负责和用户澄清需求并创建任务。
- 不负责具体实现与收尾。
- 每次创建任务都要控制复杂度，确保消费者可独立闭环。

## 工作流

1. 进入计划阶段
- 与用户对话时使用 plan mode（例如先进入 `/plan` 再收敛任务）。
- 先确认任务是否可在一次闭环中完成；若过大，先切分。

2. 生成任务定义（最小闭环）
- 必填字段：
  - `goal`：目标（可验收）
  - `method`：方法（步骤 2-5 条，避免大而空）
  - `verification`：验证手段（命令/检查点/通过标准）
  - `complexity`：复杂度（S/M/L，默认 S 或 M）
  - `notes`：上下文与限制（可选）

3. 写入队列
- 任务写入仓库根目录 `TASK_QUEUE.md`。
- 新任务统一追加到 `## Queue` 下方，状态固定为 `todo`。
- 任务 ID 使用递增格式：`T-0001`、`T-0002`...
- 写入成功后，自动调用 `skills/consumer/scripts/ensure_consumer.sh` 触发后台消费。

推荐直接使用脚本入队（会自动触发 consumer）：

```bash
bash skills/producer/scripts/add_task.sh \
  /home/zxl/paper/academic-skills \
  "目标描述" \
  "step1; step2; step3" \
  "cmd: <shell command>" \
  "S" \
  "可选备注"
```

## 队列写入格式

使用下面的单行模板追加：

```markdown
- [ ] T-0001 | status: todo | owner: consumer | goal: ... | method: ... | verification: ... | complexity: S | created: YYYY-MM-DD
```

要求：
- `goal/method/verification` 必须具体，避免“优化一下”这类不可执行描述。
- `method` 可以用 `step1; step2; step3` 的紧凑形式。
- 为兼容自动消费，`verification` 建议写成 `cmd: <shell command>`。
- 不向队列写入缺少验证手段的任务。

## 质量门禁

在写入前自检：

- 目标是否可在一次实现中完成。
- 方法是否不超过 5 步。
- 验证是否可执行且有通过标准。
- 复杂度是否为 S/M/L 且与任务规模一致。
- 不与队列中的在途任务重复。
