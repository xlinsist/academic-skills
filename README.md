# academic-skills

Reusable Codex skills for academic research, writing, and reporting.

![Skills](https://img.shields.io/badge/skills-6-blue)
![Language](https://img.shields.io/badge/language-zh--CN%20%7C%20en-lightgrey)
![Status](https://img.shields.io/badge/status-active-brightgreen)

## Why this repo

- Consistent outputs: each skill has stable input/output expectations.
- Reusable templates: copy-ready structure for common academic workflows.
- Academic-focused: tuned for paper reading, polishing, logic checking, reporting, and figure plotting.

## Quick Start (30s)

```bash
git clone git@github.com:xlinsist/academic-skills.git
cd academic-skills
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}" && mkdir -p "$CODEX_HOME/skills" && cp -r skills/* "$CODEX_HOME/skills/"
```

Optional quick check:

```bash
python3 skills/deep-research/scripts/verify_openalex.py --query "FlashAttention-3" --per-page 5
```

## Skill I/O Summary

| Skill | Input | Output |
|---|---|---|
| `plot-figure` | 用户提供比较方法和数据（例如 `triton-riscv` vs `triton-cpu` 在 matmul 的输入尺寸 `128/256/512` 下执行时间） | 一个可直接运行的画图 Python 脚本（基于模板） |
| `deep-research` | 用户在 `/plan` 模式下给定调研关键词与范围（参考 `skills/deep-research/references/GUIDE.md`） | 结构化调研报告（`report.md`） |
| `weekly-report` | 一个实验记录文件（如 `EXPER.md`）及必要补充上下文 | 按周报固定结构浓缩后的报告 |
| `logic-check` | 一篇论文（PDF/LaTeX/Word） | 逻辑问题与改进建议清单 |
| `polish` | 一篇论文（PDF/LaTeX/Word） | 语言与术语层面的润色建议（或按请求给出修改稿） |
| `read-paper` | 一篇论文（PDF/LaTeX） | 结构化精读笔记（含审稿人视角问题汇总） |

## Workflow Shape

```text
Input artifacts (paper / EXPER.md / metrics)
        -> select skill
        -> structured output (report / notes / script / suggestions)
```

## Repository Layout

```text
academic-skills/
  skills/
    deep-research/
      SKILL.md
      scripts/
        verify_openalex.py
      references/
        GUIDE.md
    weekly-report/
      SKILL.md
      agents/
        openai.yaml
      references/
        report-skeleton.md
    plot-figure/
      SKILL.md
      scripts/
        plot_figure_template.py
      references/
        template_notes.md
    logic-check/
      SKILL.md
    polish/
      SKILL.md
    read-paper/
      SKILL.md
```

## Install to Codex (manual)

```bash
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
mkdir -p "$CODEX_HOME/skills"
cp -r skills/deep-research "$CODEX_HOME/skills/"
cp -r skills/weekly-report "$CODEX_HOME/skills/"
cp -r skills/plot-figure "$CODEX_HOME/skills/"
cp -r skills/logic-check "$CODEX_HOME/skills/"
cp -r skills/polish "$CODEX_HOME/skills/"
cp -r skills/read-paper "$CODEX_HOME/skills/"
```

## Contributing

- Keep skill names lowercase with hyphen style (example: `read-paper`).
- Each skill folder must include `SKILL.md` and optional `scripts/`, `references/`, `agents/`.
- Update `Skill I/O Summary` and `Repository Layout` when adding or renaming skills.
- Keep instructions concise and execution-oriented.
