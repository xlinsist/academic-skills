# academic-skills

Reusable Codex skills for academic research, writing, and reporting.

![Skills](https://img.shields.io/badge/skills-11-blue)
![Language](https://img.shields.io/badge/language-zh--CN%20%7C%20en-lightgrey)
![Status](https://img.shields.io/badge/status-active-brightgreen)

## Quick Start

```bash
git clone git@github.com:xlinsist/academic-skills.git
cd academic-skills
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}" && mkdir -p "$CODEX_HOME/skills" && cp -r skills/* "$CODEX_HOME/skills/"
```

Optional quick check (to use deep-research skill):

```bash
python3 skills/deep-research/scripts/verify_openalex.py --query "FlashAttention-3" --per-page 5
```

## Skill Summary

| Category | Skill | Input | Output | Description |
|---|---|---|---|---|
| Academic Reading | `read-paper` | 一篇论文 | 结构化精读笔记 | |
| Academic Reading | `deep-research` | 用户给定调研关键词与调研范围 | 结构化调研报告 | 需要配置 OpenAlex；建议在 `/plan` 模式下输入调研需求，有助于明确细节 |
| Academic Writing | `logic-check` | 一篇论文 | 逻辑问题与改进建议清单 | |
| Academic Writing | `polish` | 一篇论文 | 语言与术语层面的润色建议 | 建议在 `logic-check` 后再做 `polish` |
| Academic Writing | `plot-figure` | 用户提供比较方法和数据 | 一个可直接运行的画图 Python 脚本（基于预设图表参数） | |
| Academic Writing | `weekly-report` | AI生成的实验记录 | 周报结构的模板 |  |
| Repository Analysis | `reproduce` | Github 项目 | 复现仓库得到实验结果 |构建本地环境、先跑 MVP、再沉淀到 RESULT.md |
| Repository Analysis | `create-task` | Github 项目 | 根据已有 bug 创建一个 issue 模板 | 装了 gh 后可以给上游直接提 issue |
| Repository Analysis | `analysis-module` | Github 项目 | 对模块的结构化分析 |  |
| Task Orchestration | `producer` | 对话需求与约束 | SSD 结构化任务条目（写入 `TASK_QUEUE.md`） | |
| Task Orchestration | `consumer` | `TASK_QUEUE.md` 中的 SSD 待办任务 | 闭环执行并归档到 `TASK_RECORD.md` |  |

## Contributing

- Keep skill names lowercase; prefer hyphen style for new skills (example: `read-paper`).
- Each skill folder must include `SKILL.md` and optional `scripts/`, `references/`, `agents/`.
- Update `Skill Summary` when adding or renaming skills.
- Keep instructions concise and execution-oriented.
