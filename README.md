# academic-skills

Shareable Codex skills for academic workflows.

This repository currently includes:
- **Academic Writing**
  - `logic-check`: thesis logic consistency and argument completeness checklist.
  - `polish`: academic thesis polishing rules for LaTeX/PDF-style drafts.
- **Academic Reading**
  - `deep-research`: topic-driven literature survey workflow (OpenAlex-first + structured report).
  - `read-paper`: structured deep-reading workflow for academic papers (PDF/LaTeX).
- **Preparation for Group Meeting**
  - `plot-figure`: standardized grouped-bar plotting template for baseline comparisons.
  - `weekly-report`: staged technical weekly report workflow.

## Skill Usage

| Skill | Input | Output | Note |
|---|---|---|---|
| `logic-check` | 一篇论文 | 逻辑问题与改进建议清单 | |
| `polish` | 一篇论文 | 语言与术语层面的润色建议| 建议在logic-check后再做polish |
| `deep-research` | 用户给定调研关键词与调研范围 | 结构化调研报告 | 需要配置openalex；建议在 `/plan` 模式下使用，有助于明确调研细节 |
| `read-paper` | 一篇论文 | 结构化精读笔记 | |
| `plot-figure` | 用户提供比较方法和数据 | 一个可直接运行的画图 Python 脚本（基于预设的图表参数） | 一个比较方法的示例： `triton-riscv` vs `triton-cpu` 在 matmul 的输入尺寸 `128/256/512` 下执行时间；数据输入的格式不 |
| `weekly-report` | 一份实验记录 | 周报结构的模板 | 这个实验记录文件一般为 AI 开发过程的记录 |

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

## Install to Codex

From this repo root:

```bash
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
mkdir -p "$CODEX_HOME/skills"
cp -r skills/logic-check "$CODEX_HOME/skills/"
cp -r skills/polish "$CODEX_HOME/skills/"
cp -r skills/deep-research "$CODEX_HOME/skills/"
cp -r skills/read-paper "$CODEX_HOME/skills/"
cp -r skills/plot-figure "$CODEX_HOME/skills/"
cp -r skills/weekly-report "$CODEX_HOME/skills/"
```

## Quick Check

To test the validation of `openalex` in deep-research:
```bash
python3 skills/deep-research/scripts/verify_openalex.py --query "FlashAttention-3" --per-page 5
```
