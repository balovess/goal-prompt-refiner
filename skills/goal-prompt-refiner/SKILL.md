---
name: goal-prompt-refiner
description: Interview vague long-running project work into a verified, project-grounded Codex `/goal` prompt. Use for durable objectives that require multiple turns, autonomous progress, a validation loop, and an explicit stopping condition. Do not use for bug fixes, isolated edits, one-shot tasks, questions, estimates, or ordinary plans.
---

# Goal Prompt Refiner

Build a Goal through a conversation, not by expanding vague language. Preserve the user's intent. Do not invent project facts, commands, metrics, permissions, deadlines, or acceptance criteria.

## Qualify The Request

Decide before interviewing whether `/goal` is appropriate.

Use a Goal only when the work has all of these properties:

- one durable outcome that needs several checkpoints or turns;
- room for Codex to make independent progress between user interactions;
- a realistic validation loop; and
- a verifiable stopping condition.

Treat a single bug fix, a small isolated edit, a one-off answer, or a narrow implementation request as normal work, not a Goal. State that conclusion briefly and explain why; do not generate a `/goal` prompt merely because the user used the word "goal".

## Ground The Conversation

For a workspace or repository request, collect facts before asking the user for them. Read the applicable `AGENTS.md`, project documentation, root manifests, task or issue context, test and CI configuration, and relevant source modules. Respect permissions and do not modify files while discovering context.

Record only facts that affect the Goal: current behavior, project boundaries, supported workflows, validation commands, existing plans, active changes, and known constraints. If no project context is available, ask the user for the project location or the primary artifact before continuing.

## Interview To A Shared Contract

Build a decision tree. Facts are Codex's responsibility; decisions are the user's responsibility.

In each round, ask every independent material decision whose prerequisites are known. Number the questions, explain the tradeoff, and give a recommended default. Do not ask questions whose answer can be found in the project, and do not ask downstream questions until their prerequisite decisions are settled. Wait for the user's response before the next round.

Resolve these decisions as needed:

1. Final outcome and exclusions
2. Compatibility, safety, quality, performance, cost, and time constraints
3. Required artifacts and documentation
4. Validation evidence and benchmark protocol when performance matters
5. Authority boundaries and the exact cases that require a pause
6. Stopping condition and acceptable residual risk

When the frontier is empty, summarize the proposed Goal contract in a compact form and ask for confirmation. Do not create the final `/goal` until the user confirms or corrects that contract.

## Make Completion Verifiable

Translate vague language into project-appropriate evidence:

| Vague request | Required evidence |
| --- | --- |
| "high quality" | named quality criteria, review method, and acceptance standard |
| "complete migration" | scoped compatibility matrix with no required unverified entries |
| "make it faster" | reproducible before-and-after benchmark using comparable inputs and recorded metrics |
| "no regression" | named behavior preserved by relevant tests, scenarios, or comparisons |
| "update docs" | authoritative documentation matches delivered behavior and known limits |

Use only evidence relevant to the project. Do not promise a performance improvement without a measured baseline. Do not treat a completed plan, a compile, a single module, or a partial test suite as final completion.

## Produce The Goal

After confirmation, answer in the user's language and lead with one copy-ready code block beginning with `/goal`. Include only project-relevant sections:

1. Objective, scope, and exclusions
2. Files, documentation, tests, or project evidence to read first
3. Checkpoints and compact progress reporting
4. Constraints and non-goals
5. Validation commands, artifacts, tests, or benchmarks
6. Pause conditions and blocker handling
7. Final acceptance gates and explicit stopping condition

For several independent durable outcomes, explain that they require sequential Goals. If the user asks for one Goal, produce only the first bounded discovery or prioritization Goal. If the user asks for multiple Goals or a roadmap, produce numbered, independent Goal blocks.

Require the final report to list delivered work, validation evidence, unresolved deviations, and residual risk when applicable.

## Final Check

Before returning a Goal, verify that it:

- is justified as long-running work rather than a short task;
- is grounded in discovered project facts and confirmed user decisions;
- has one observable outcome and a falsifiable stopping condition;
- distinguishes checkpoints from completion;
- uses validation appropriate to the project; and
- contains no invented facts or unnecessary complexity.
