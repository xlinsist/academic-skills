---
name: create_task
description: Create a GitHub issue that assigns a developer a concrete PR-sized task. Use when the user wants an issue/task description with Deliverables, Background, Task Description, and Timeline so an engineer can execute and submit a specific PR.
---

# Create Task

Use this skill when the user wants a GitHub issue written for a repository and the issue should be actionable enough that a developer can follow it and produce a named PR outcome.

## Output Goal

Write a GitHub issue in Markdown with exactly these sections, in this order:

1. `## Deliverables`
2. `## Background`
3. `## Task Description`
4. `## Timeline`

The issue should read like a scoped engineering assignment, not a brainstorming note.

## Style

- Default to English unless the user explicitly asks for another language.
- Keep the tone direct, concrete, and execution-oriented.
- Prefer repository-specific nouns, paths, tests, operators, or subsystems over generic wording.
- Write tasks that can realistically be completed in one PR.
- Do not add extra sections unless the user explicitly asks for them.

## Required Content

### Deliverables

- Start with `Submit a PR on ...`
- State the exact PR outcome the developer must deliver.
- If there are supporting outputs such as docs, tests, benchmark results, or root-cause notes, mention them in the same section.

### Background

- Explain the current state of the repository or feature.
- Explain what already exists.
- Explain what is missing, weak, unvalidated, or not yet production-ready.
- Keep this section short: usually one paragraph or 2 short bullets.

### Task Description

- Use flat bullet points.
- Use no more than 5 steps.
- Break the work into execution steps a developer can follow in order.
- Default structure:
  - step 1: build / baseline setup
  - step 2: execute or benchmark the target case
  - step 3: execute analysis, inspection, or comparison work
  - step 4: make the code change and submit a PR
  - step 5: specify exactly what evidence must be written in the PR description
- Keep the final step focused on the PR description requirements.

### Timeline

- `Development period:` must span exactly two weeks.
- `Code review starts:` must be the day after the development period ends.
- Use concrete absolute dates, not relative dates.
- If the user provides a start date, use it.
- Otherwise, use the current date as the development start date.
- Treat the two-week development period as 14 calendar days inclusive of the start date, so:
  - `development_start = chosen start date`
  - `development_end = development_start + 13 days`
  - `code_review_starts = development_end + 1 day`
- Format dates as `Month D, YYYY`.

## Writing Workflow

1. Identify the repository, the desired PR outcome, and any hard constraints.
2. Extract or infer the current-state background from the user's prompt, repo context, linked issue/PR text, or provided notes.
3. Convert the desired outcome into at most 5 concrete task bullets, following the default structure when it fits.
4. Add verification expectations so the assignee knows what must pass before opening the PR.
5. Compute the timeline with exact dates.
6. Print the finished issue Markdown unless the user asks for alternatives.
7. After printing the issue, proactively ask whether the user wants help submitting it to the upstream repository as a GitHub issue.

## GitHub Submission Follow-up

- When asking the follow-up, name the inferred target repository and proposed issue title if they are known.
- If the user agrees, prefer `gh issue create --repo <owner>/<repo> --title <title> --body-file <file>`.
- Before submission, check `gh auth status` and repository access with `gh repo view <owner>/<repo>`.
- Write the issue body to a temporary Markdown file and pass it with `--body-file` to preserve formatting.
- If `gh` is missing or not authenticated, tell the user exactly what is missing and stop before attempting submission.
- After successful submission, return the created issue URL.

## Default Template

```md
## Deliverables

- Submit a PR on <exact PR goal>.

## Background

<brief explanation of current implementation and why it is not sufficient yet>

## Task Description

- <baseline validation step>
- <run or benchmark the target case>
- <analyze IR / logs / behavior against the reference path>
- <implement the change and submit a PR>
- <state the required PR-description evidence>

## Timeline

- Development period: <Month D, YYYY> - <Month D, YYYY>
- Code review starts: <Month D, YYYY>
```

## Quality Bar

- The PR target must be specific enough that two different engineers would produce roughly the same scope.
- Background must justify the work, not repeat Deliverables.
- Task bullets must be executable, observable, reviewable, and limited to 5 steps or fewer.
- Timeline must be internally consistent.
