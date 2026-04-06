# academic-skills

Reusable Codex skills for academic research, writing, and reporting.

![Skills](https://img.shields.io/badge/skills-6-blue)
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
| Academic Writing | `logic-check` | 一篇论文 | 逻辑问题与改进建议清单 | |
| Academic Writing | `polish` | 一篇论文 | 语言与术语层面的润色建议 | 建议在 `logic-check` 后再做 `polish` |
| Academic Reading | `read-paper` | 一篇论文 | 结构化精读笔记 | |
| Academic Reading | `deep-research` | 用户给定调研关键词与调研范围 | 结构化调研报告 | 需要配置 OpenAlex；建议在 `/plan` 模式下输入调研需求，有助于明确细节 |
| Group Meeting Preparation | `plot-figure` | 用户提供比较方法和数据 | 一个可直接运行的画图 Python 脚本（基于预设图表参数） | 示例：`triton-riscv` vs `triton-cpu` 在 matmul 输入尺寸 `128/256/512` 下执行时间；数据输入格式不限 |
| Group Meeting Preparation | `weekly-report` | 一份实验记录 | 周报结构的模板 | 实验记录文件一般为 AI 开发过程记录 |

## Contributing

- Keep skill names lowercase with hyphen style (example: `read-paper`).
- Each skill folder must include `SKILL.md` and optional `scripts/`, `references/`, `agents/`.
- Update `Skill Summary` when adding or renaming skills.
- Keep instructions concise and execution-oriented.
