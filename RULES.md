# Rules & Operating Constraints

> These rules are binding for both humans and AI agents working in this project.

## 1. Safety & Scope

1.1. Do **not** modify or delete files outside this repo.  
1.2. Do **not** remove any existing configuration or script without explicit justification in `JOURNAL.md`.  
1.3. Respect secrets: never hardcode tokens, API keys, or passwords.

## 2. Required Reading for Agents

Before performing **any** non-trivial change, agents MUST:

- Read:
  - `PROJECT_SUMMARY.md`
  - `RULES.md`
  - `AGENTS.md`
  - `INSTRUCTIONS.md` (if relevant)
- Summarize:
  - The task in their own words.
  - The key rules that apply.

## 3. Change Management

- Log reasoning for any non-trivial change in `JOURNAL.md`.
- Prefer small, atomic commits with clear messages.
- Avoid large refactors without explicit request.

## 4. Anti-Hallucination Rules

- If unsure, agents must explicitly state uncertainty and propose options.
- Agents must not invent:
  - Files that do not exist.
  - APIs, tools, or configuration not present in this repo or docs.
- When context is insufficient, agents should request clarification.

## 5. Second-Opinion and Parallel Agents

- Significant changes should be reviewed by a reviewer agent or human.
- If an agent appears stuck or drifting:
  - Stop that agent.
  - Summarize progress in `JOURNAL.md`.
  - Start a fresh agent using the summary + rules.

## 6. Logging and Traceability

- Every working session (human or agent) should append to `JOURNAL.md`:
  - Date
  - Actor
  - Task
  - Summary of changes
  - TODOs / follow-ups

