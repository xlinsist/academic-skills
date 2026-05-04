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

| Category | Skill | Input | Output | Note |
|---|---|---|---|---|
| Academic Reading | `read-paper` | 一篇论文 | 结构化精读笔记 | |
| Academic Reading | `deep-research` | 用户给定调研关键词与调研范围 | 结构化调研报告 | 需要配置 OpenAlex；建议在 `/plan` 模式下输入调研需求，有助于明确细节 |
| Academic Writing | `logic-check` | 一篇论文 | 逻辑问题与改进建议清单 | |
| Academic Writing | `polish` | 一篇论文 | 语言与术语层面的润色建议 | 建议在 `logic-check` 后再做 `polish` |
| Academic Writing | `plot-figure` | 用户提供比较方法和数据 | 一个可直接运行的画图 Python 脚本（基于预设图表参数） | 示例：`triton-riscv` vs `triton-cpu` 在 matmul 输入尺寸 `128/256/512` 下执行时间；数据输入格式不限 |
| Academic Writing | `weekly-report` | 一份实验记录 | 周报结构的模板 | 实验记录文件一般为 AI 开发过程记录 |
| Repository Analysis | `reproduce` | Github 项目 | 可复现的环境、实验结果与结果文档 | 适合构建本地环境、先跑 MVP、再沉淀 `RESULT.md` |
| Repository Analysis | `create-task` | Github 项目 | 可直接提交到 GitHub 的 issue 草稿 | 固定输出 `Deliverables / Background / Task Description / Timeline` 四段 |
| Repository Analysis | `analysis-module` | Github 项目 | 按“接口-数据-监督-模型-训练-动机-风险-设计空间”展开的结构化分析 | 适合 AI 仓库的模块级系统理解与设计复盘 |
| Task Orchestration | `producer` | 对话需求与约束 | SSD 结构化任务条目（写入 `TASK_QUEUE.md`） | 建议在 `/plan` 模式下创建任务，强制字段校验 |
| Task Orchestration | `consumer` | `TASK_QUEUE.md` 中的 SSD 待办任务 | 闭环执行并归档到 `TASK_RECORD.md` | 由系统自动拉起后台监听，空闲一段时间后自动退出 |

## Contributing

- Keep skill names lowercase; prefer hyphen style for new skills (example: `read-paper`).
- Each skill folder must include `SKILL.md` and optional `scripts/`, `references/`, `agents/`.
- Update `Skill Summary` when adding or renaming skills.
- Keep instructions concise and execution-oriented.
