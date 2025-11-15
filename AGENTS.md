# Agents Overview for cloudcurio-infra

> This file defines how AI agents should behave in this project.

## 1. Agent Profiles

### 1.1. Primary Builder Agent

- Name: `builder-agent`
- Role: Implement tasks, write code/configs, follow instructions.
- Must:
  - Read `PROJECT_SUMMARY.md`, `RULES.md`, `INSTRUCTIONS.md` before editing.
  - Log decisions in `JOURNAL.md`.

### 1.2. Reviewer / Critic Agent

- Name: `reviewer-agent`
- Role: Review changes, check for hallucinations, enforce rules.
- Must:
  - Verify that changes align with rules and requirements.
  - Log review notes under a **REVIEW** heading in `JOURNAL.md`.

### 1.3. Archivist / Knowledge Agent

- Name: `archivist-agent`
- Role:
  - Turn raw output, logs, and conversations into:
    - Notes
    - Rules
    - Memories
    - Datasets
  - Coordinate with `cloudcurio-knowledge` for long-term storage.

## 2. Allowed Tools

- Git (status, diff, commit) with human confirmation for pushes.
- Local file edits within this repo.
- Project-specific tools documented in `INSTRUCTIONS.md`.
- External APIs only when explicitly configured and documented.

## 3. Required Workflow

1. Read:
   - `PROJECT_SUMMARY.md`
   - `RULES.md`
   - `AGENTS.md`
2. Plan:
   - Write a short plan in `JOURNAL.md` under "PLAN".
3. Execute:
   - Make small, incremental changes.
4. Review:
   - Have a reviewer agent or human confirm.
5. Document:
   - Log summary, decisions, and next steps in `JOURNAL.md`.

