---
name: goal-prompt-refiner
description: Turn a vague or detailed long-running project request into one copy-ready, project-grounded, verifiable Codex `/goal` prompt through focused interactive decision refinement and ordered phase gates. Use when the user asks for a Goal or needs durable work with multiple phases, independent progress, and a validation loop. Preserve one coherent final outcome; use interactive choices only when an undiscoverable decision materially changes scope, authority, compatibility, or acceptance. Do not use for short bug fixes, isolated edits, one-off answers, questions, estimates, or ordinary plans.
---

# Goal Prompt Refiner

Recover the user's actual desired outcome from an ambiguous request, then produce one durable Goal with an observable final state. Put implementation work into ordered phases with hard transition gates inside that Goal; a passed phase gate permits the next phase but never completes the whole Goal. For work that may span multiple `/goal` runs, include a durable, project-local continuation record so later runs can resume from verified state instead of relying on conversation memory.

## Qualify The Request

Use a Goal when the work has:

- one coherent outcome that needs several ordered phases or turns;
- room for Codex to make independent progress between user interactions;
- a realistic validation loop; and
- a falsifiable stopping condition.

Treat a short bug fix, isolated edit, one-off answer, question, estimate, or ordinary plan as normal work. State that briefly instead of fabricating a `/goal`.

## Ask Material Decisions

Ask only when the answer cannot be discovered, materially changes scope, authority, compatibility, or acceptance, and a reasonable default risks the wrong outcome. Inspect repository facts first.

- Use `request_user_input` when available instead of a static question or questionnaire.
- Present one decision at a time with two or three mutually exclusive options; put the recommended option first and state each tradeoff concisely.
- Do not manually add `Other` when the control supplies a free-form alternative. Preserve the selected option as an explicit Goal constraint or decision.
- After each selection, update the working understanding. Do not repeat settled questions or ask about routine implementation details.
- Once the final objective and acceptance contract are clear, produce exactly one copy-ready `/goal` prompt.

If the initial request already defines the final outcome and acceptance gates, draft directly. Interactive choices are for material ambiguity, not a mandatory interview. If no choice control is available, use the shortest textual fallback and do not invent a decision.

## Understand The Real Goal

Do not equate a large scope with a first-phase deliverable. First determine what the user wants to be true when the work is finished.

- Read the user's wording, examples, corrections, and acceptance language as requirements for the final output.
- Separate the desired outcome from proposed implementation steps, investigation tasks, milestones, and documents.
- If the user says the project should continue until a condition is met, preserve that persistence and make the condition the stopping rule.
- If the user gives an example with a final target, working rules, ordered phases, and acceptance gates, follow that shape.
- If the user asks for one clear Goal, produce one Goal covering the complete requested outcome.
- Put implementation stages inside one Goal as ordered phases with blocking exit gates. A passed phase gate permits the next phase but does not complete the Goal.
- Do not replace the final outcome with a discovery-only, baseline-only, prioritization-only, or first-phase Goal unless the user explicitly asks for that narrower result.
- Do not split a coherent outcome into numbered Goal blocks merely because it contains many modules or phases.
- Split into multiple Goal blocks only when the user explicitly asks for multiple Goals/roadmap or the outcomes have incompatible stopping conditions and cannot share one final acceptance contract. Explain the reason briefly and ask before changing the requested shape.

## Enforce Sequential Phase Gates

For multi-phase work, treat phases as ordered work packages with blocking exit gates, not as loose progress markers.

- Define one active phase at a time. Record each phase's required outcomes, exclusions, validation evidence, and exit gate before starting it.
- Use explicit phase states such as `not_started`, `in_progress`, `blocked`, `passed_locked`, and `reopened`. A phase containing any required `missing`, `partial`, or `unverified` item cannot become `passed_locked`.
- Finish the active phase completely before starting the next phase. Do not advance because a subset is complete, because another module is independent, or because the current phase is inconvenient.
- If the active phase is blocked, work on its direct blockers and their validation. Do not switch to later phases or unrelated modules unless the user explicitly authorizes parallel tracks.
- When the phase gate passes, record the exact evidence and relevant commit or artifact, mark the phase `passed_locked`, and advance to the next phase. A locked phase is not re-analyzed on every resumed run.
- Reopen a locked phase only when its source, specification, dependency, or environment changes; its evidence becomes invalid; a regression appears; or later integration exposes a concrete contradiction.
- Use validation proportional to the phase risk. A phase gate may require focused checks; updating a record or making a small edit does not by itself require the full test suite.

## Ground The Conversation

For a repository or workspace request, collect facts before drafting. Read the applicable `AGENTS.md`, root manifests, project documentation and specs, accepted ADRs/RFCs, tests, CI configuration, benchmarks, active plans, and relevant source modules. Do not modify files while discovering context.

Record only facts that affect the Goal:

- project boundaries, packages, modules, public interfaces, and supported workflows;
- current behavior and known behavior gaps;
- documented requirements, accepted decisions, proposed designs, and their status;
- existing tests, CI commands, benchmark workloads, and validation limitations;
- active worktree changes and user-owned files;
- actual constraints such as platform, toolchain, permissions, and unavailable dependencies.

Do not invent facts, commands, metrics, deadlines, permissions, compatibility promises, performance targets, or acceptance evidence. Treat benchmark claims in plans as hypotheses until measured. Distinguish accepted requirements from proposals and aspirational designs.

Preserve dirty worktrees. Do not revert user changes. If before/after comparison is required, describe a recoverable baseline using a temporary copy, worktree, or snapshot.

## Establish Durable Goal Memory

For a Goal that can continue across turns or conversations, define one canonical project-local Goal record in the generated prompt. This is a continuation aid and evidence index, not hidden model memory, a second requirements system, or a completion condition.

- Reuse an existing project tracker or progress document when it clearly serves this Goal. Do not create a duplicate merely because a new default path is available.
- If no suitable record exists, use `.codex/goals/<goal-slug>.md`. Choose a repository-aligned alternative only when the project convention requires it.
- Create this record only for work that genuinely spans turns or conversations. Keep it proportional: record meaningful changes, completed improvements, decisions, evidence, and risks, not every file read or trivial edit.
- At the start of every resumed run, read the record, identify the active phase, inspect the current worktree for invalidation signals, and reconcile stale or unsupported entries. Current code, tests, and measured results remain authoritative.
- Do not re-analyze a `passed_locked` phase during normal resume. Reopen it only under the invalidation rules above, and record the reason.
- After each meaningful change or phase gate, update the same record before moving on. Do not wait until the end of a long run to reconstruct history.
- Keep a compact current-state summary and an append-only change/decision log. Record the Goal objective and constraints, ordered phases, active phase, passed and locked phases, completed improvements, changed files or commits, decisions and rationale, focused validation, benchmark evidence, remaining work, blockers, risks, invalidation events, and the next concrete action.
- Link to commands, tests, benchmark artifacts, and relevant files instead of pasting large logs. Never store secrets, credentials, tokens, or unnecessary private data.
- Updating the record does not require a full test suite. Select validation from the risk and scope of the code change, using focused checks during normal work and broader checks at appropriate acceptance gates.
- When the Goal finishes, record the final acceptance status, actual evidence, known deviations, and residual risk. Do not mark it complete merely because the record is updated.

Use [references/goal-record-template.md](references/goal-record-template.md) for the durable record unless the repository already defines an equivalent. Load it only for Goals that span runs.

## Define The Contract

Before output, ensure the single Goal states:

1. final objective and in-scope domains;
2. explicit exclusions and non-goals;
3. authoritative files/specs to read first;
4. a canonical progress matrix or tracking artifact when the work spans modules;
5. ordered phases, one active phase, and an explicit exit gate for every phase;
6. one durable Goal record with active-phase, lock, resume, and invalidation rules;
7. rules for preserving behavior, simplicity, performance, and user changes;
8. focused validation during work and broader validation at phase and final gates;
9. a real benchmark protocol whenever performance matters;
10. pause conditions and blocker handling;
11. final acceptance gates and one explicit stopping condition.

For performance work, require a reproducible before/after comparison using comparable inputs and the same relevant environment. Record actual throughput, latency/tail latency, CPU, memory, allocation, I/O, lock contention, or concurrency metrics when the workload supports them. Never promise a percentage improvement without a measured baseline.

For compatibility or migration work, require a matrix that maps source behavior or specification to implementation, tests, known differences, risk, and status. Do not treat compilation, one module, a generated plan, or a partial test suite as completion.

## Produce The Goal

Once the user's actual outcome is clear enough, answer in the user's language. Lead with exactly one copy-ready code block beginning with `/goal`. Keep any surrounding explanation to one or two sentences.

Use only sections relevant to the project, typically:

```text
/goal

In <repository or artifact>, complete <single final outcome>.

## Final Objective
...

## Starting Context
...

## Ordered Phases and Gates
...

## Working Rules
...

## Validation and Benchmarks
...

## Durable Goal Record
...

## Pause and Blocker Handling
...

## Final Acceptance Criteria
...
```

The prompt must make the final state, not the plan, the deliverable. Include language equivalent to:

- phases are ordered work packages inside one Goal, not separate Goals;
- each phase has a blocking exit gate and the next phase cannot start until the current gate passes;
- `missing`, `partial`, or `unverified` required work means the current phase has failed its gate;
- when a phase is blocked, continue with its direct blockers instead of skipping to later or unrelated phases;
- after a phase gate passes, record evidence, mark that phase `passed_locked`, and advance to the next phase;
- on resume, continue from the active phase and skip normal re-analysis of passed and locked phases;
- reopen a locked phase only when an explicit invalidation condition is evidenced;
- at the start of each resumed run, read and reconcile the canonical Goal record;
- after each meaningful change or phase gate, update that record with facts and evidence;
- do not stop because a plan, baseline, module, partial test, or milestone is complete;
- continue until every final acceptance gate is satisfied;
- the final report lists delivered work, validation evidence, benchmark results, unresolved deviations, and residual risk.

## Correct Common Failure Modes

Do not:

- turn a coherent repository-wide objective into a discovery-only first Goal;
- output several sequential Goal blocks when the user requested one Goal;
- keep interviewing after the user has supplied a complete target and acceptance style;
- ask the user to decide facts that repository inspection can establish;
- invent hard performance numbers, deadlines, compatibility guarantees, or permissions;
- prescribe a technology such as io_uring, lock-free structures, or a new dependency before evidence supports it;
- make full-suite testing the default after every edit when focused validation is sufficient;
- treat a partial or unverified phase as passed, or begin a later phase before the active phase gate passes;
- switch to unrelated work merely because the active phase is blocked;
- re-analyze a passed and locked phase without an explicit invalidation signal;
- create multiple progress or memory files for one Goal, or treat a stale record as authoritative without checking the repository;
- store secrets or paste large raw logs into the Goal record;
- make a roadmap or progress document the final deliverable;
- declare the Goal complete because one phase gate, module, or milestone passed, or because one subsystem is blocked.

## Final Check

Before returning the Goal, verify that it:

- represents one durable outcome rather than an arbitrary collection of tasks;
- follows the user's requested shape and language;
- captures the user's actual desired final state, not merely the easiest first step;
- is grounded in discovered project facts and confirmed user decisions;
- distinguishes authoritative requirements from proposals and measurements from claims;
- defines ordered phases with blocking exit gates without turning them into separate Goals;
- prevents later phases from starting before the active phase gate passes;
- records passed and locked phases plus explicit invalidation conditions;
- uses focused validation during work and appropriate broad validation at final gates;
- has a reproducible benchmark protocol when performance matters;
- defines one resumable Goal record when the work can span runs, with reconciliation and update rules;
- has a falsifiable stopping condition and explicit residual-risk reporting; and
- contains no invented facts or unnecessary complexity.
