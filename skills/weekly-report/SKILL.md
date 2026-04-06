---
name: weekly-report
description: "Use when the user asks to write weekly reports, milestone summaries, staged progress reports, or phase digests from technical artifacts (for example `*report*.md`, changelog notes, test logs, and conversion/run commands). Produce a structured report with: (1) staged conclusions, (2) function-level change mapping by file and function, and (3) copy-paste one-click terminal commands for key milestones."
---

# Weekly Report

## Workflow

1. Collect source artifacts.
- Read the primary report file first (for example `vir-report-v2.md`).
- Read only supporting files needed to verify claims (code, tests, experiments, changelog entries).
- If time range is unclear, infer from dated sections and keep absolute dates in output.

2. Build staged conclusions.
- Split progress into three phases unless user requests another partition.
- Use the default meaning:
  - Phase 1: `刚接手任务时的情况`
  - Phase 2: `已完成的情况`
  - Phase 3: `正在做/后续计划`
- For each phase, always provide:
  - scope/status summary
  - limits/boundaries/risks
  - concise statements with technical scope boundaries

3. Build function-level change map.
- For each key milestone, map to `文件 + 函数 + 关键逻辑`.
- Prefer pass entry patterns and helpers (for MLIR-like repos: `matchAndRewrite`, lowering helpers, legality/preflight checks).
- Describe logic at reviewer granularity: users should understand the implementation impact without opening a PR diff.

4. Provide runnable commands for key nodes.
- Provide at least one copy-paste command per key stage.
- Commands must be directly executable from repo root, include full pipeline, and be self-contained.
- Prefer commands that were actually validated in current workspace.
- If not validated, explicitly mark `未实测`.

5. Emit report in fixed structure (default).
- Unless user overrides, use exactly:
  - `## 1. 阶段化支持结论`
  - `## 2. 函数级关键改动（文件 + 函数）`
  - `## 3. 三个关键节点的一键命令`

## Output SOP

### Section 1: 阶段化支持结论

Use three default phases:
- 阶段一：刚接手任务时的情况（baseline + constraints）
- 阶段二：已完成的情况（implemented + validated results）
- 阶段三：正在做/后续计划（in-progress items + next steps + boundaries）

Rules:
- Do not use analogies or metaphors unless user asks.
- Keep claims falsifiable and bounded (shape/type/op/dialect boundaries).
- Keep statements short and technical.

### Section 2: 函数级关键改动（文件 + 函数）

For each key change, provide:
- 文件路径
- 函数名（or pattern class + method）
- 关键逻辑（3-6 bullets max）
- Optional: line anchor when easy to provide

Recommended format:
- `文件：...`
- `函数：...`
- `作用：...`
- `关键逻辑：...`

### Section 3: 三个关键节点的一键命令

Command requirements:
- Single block per node; user can copy directly.
- Include required conversion pipeline flags.
- Include runtime command (`mlir-runner` or project equivalent) when end-to-end execution is expected.
- Prefer stable test/experiment inputs committed in repo.

Recommended node mapping:
- 节点 1: baseline path for the "接手时" state
- 节点 2: completed milestone path
- 节点 3: in-progress/frontier path (or planned verification command)

## Quality Gate Checklist

Before finalizing, verify all items:
- Every stage includes both capability and boundary.
- Every critical claim maps to concrete files/functions.
- Every key node has a runnable command.
- Command status is clear: `已实测` or `未实测`.
- Terminology is consistent with source report.
- No analogy-style wording unless explicitly requested.

## Fast Template

````markdown
## 1. 阶段化支持结论

### 阶段一
- 刚接手时情况：...
- 主要限制：...

### 阶段二
- 已完成情况：...
- 主要做法/验证结果：...

### 阶段三
- 正在做/后续计划：...
- 剩余边界/风险：...

## 2. 函数级关键改动（文件 + 函数）

- 文件：`...`
- 函数：`...`
- 作用：...
- 关键逻辑：...

## 3. 三个关键节点的一键命令

### 节点一
```bash
...
```

### 节点二
```bash
...
```

### 节点三
```bash
...
```
````
