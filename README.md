# academic-skills

Shareable Codex skills for academic workflows.

This repository currently includes:
- `deep-research`: topic-driven literature survey workflow (OpenAlex-first + structured report).
- `report`: staged technical reporting workflow (phase conclusions + function-level changes + runnable commands).
- `plot_figure`: standardized grouped-bar plotting template for baseline comparisons.
- `logic-check`: thesis logic consistency and argument completeness checklist.
- `polish`: academic thesis polishing rules for LaTeX/PDF/Word-style drafts.
- `read-paper`: structured deep-reading workflow for academic papers (PDF/LaTeX).

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
    report/
      SKILL.md
      agents/
        openai.yaml
      references/
        report-skeleton.md
    plot_figure/
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

## Install to Codex (for other users)

From this repo root:

```bash
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
mkdir -p "$CODEX_HOME/skills"
cp -r skills/deep-research "$CODEX_HOME/skills/"
cp -r skills/report "$CODEX_HOME/skills/"
cp -r skills/plot_figure "$CODEX_HOME/skills/"
cp -r skills/logic-check "$CODEX_HOME/skills/"
cp -r skills/polish "$CODEX_HOME/skills/"
cp -r skills/read-paper "$CODEX_HOME/skills/"
```

## Quick Check

```bash
python3 skills/deep-research/scripts/verify_openalex.py --query "FlashAttention-3" --per-page 5
```

## Notes

- `deep-research` expects topic folders with `GUIDE.md` and `report.md` as defined in its `SKILL.md`.
- `report` output format and quality gate are documented in `skills/report/SKILL.md`.
