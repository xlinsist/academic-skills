# academic-skills

Shareable Codex skills for academic workflows.

This repository currently includes:
- `deep-research`: topic-driven literature survey workflow (OpenAlex-first + structured report).
- `report`: staged technical reporting workflow (phase conclusions + function-level changes + runnable commands).

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
```

## Install to Codex (for other users)

From this repo root:

```bash
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
mkdir -p "$CODEX_HOME/skills"
cp -r skills/deep-research "$CODEX_HOME/skills/"
cp -r skills/report "$CODEX_HOME/skills/"
```

## Quick Check

```bash
python3 skills/deep-research/scripts/verify_openalex.py --query "FlashAttention-3" --per-page 5
```

## Notes

- `deep-research` expects topic folders with `GUIDE.md` and `report.md` as defined in its `SKILL.md`.
- `report` output format and quality gate are documented in `skills/report/SKILL.md`.
