---
name: goal-prompt-refiner
description: Turn a vague or detailed long-running project request into one copy-ready, project-grounded, verifiable Codex `/goal` prompt through focused interactive decision refinement. Use when the user asks for a Goal or needs durable work with multiple checkpoints, independent progress, and a validation loop. Preserve one coherent final outcome; use interactive choices only when an undiscoverable decision materially changes scope, authority, compatibility, or acceptance. Do not use for short bug fixes, isolated edits, one-off answers, questions, estimates, or ordinary plans.
---

# Goal Prompt Refiner

Recover the user's actual desired outcome from an ambiguous request, then produce one durable Goal with an observable final state. Treat checkpoints as progress inside that Goal, never as separate Goals or completion conditions, unless the user explicitly asks for multiple independent Goals. For work that may span multiple `/goal` runs, include a durable, project-local continuation record so later runs can resume from verified state instead of relying on conversation memory.

## Qualify The Request

Use a Goal when the work has:

- one coherent outcome that needs several checkpoints or turns;
- room for Codex to make independent progress between user interactions;
- a realistic validation loop; and
- a falsifiable stopping condition.

Treat a short bug fix, isolated edit, one-off answer, question, estimate, or ordinary plan as normal work. State that briefly instead of fabricating a `/goal`.

## Use Interactive Decisions

When a user decision is genuinely required, use the product's interactive choice control (`request_user_input` when available) instead of emitting a static question or questionnaire.

1. Inspect repository facts before asking. Ask only when the answer cannot be discovered and materially changes scope, authority, compatibility, or acceptance.
2. Present one decision at a time. Use two or three mutually exclusive options, put the recommended option first, and state the concise tradeoff for each option.
3. Do not manually add an `Other` option when the interactive control supplies a free-form alternative. Preserve the user's selected option as an explicit Goal constraint or decision.
4. After each selection, update the working understanding and continue with the next unresolved material decision. Do not repeat settled questions or ask about routine implementation details.
5. Once the final objective and acceptance contract are clear, stop asking and produce exactly one copy-ready `/goal` prompt. Do not expose the choices as multiple Goal blocks or turn them into a first-phase Goal.

If the user's initial request already defines the final outcome and acceptance gates, inspect the repository and draft the Goal directly. Interactive choices are for material ambiguity, not a mandatory interview. If no interactive choice control is available, use the shortest possible textual fallback and do not invent a decision.

## Understand The Real Goal

Do not equate a large scope with a first-phase deliverable. First determine what the user wants to be true when the work is finished.

- Read the user's wording, examples, corrections, and acceptance language as requirements for the final output.
- Separate the desired outcome from proposed implementation steps, investigation tasks, milestones, and documents.
- If the user says the project should continue until a condition is met, preserve that persistence and make the condition the stopping rule.
- If the user gives an example with a final target, working rules, checkpoints, and acceptance gates, follow that shape.
- If the user asks for one clear Goal, produce one Goal covering the complete requested outcome.
- Put implementation stages inside one Goal as checkpoints. Explicitly state that checkpoints are not independent Goals and do not permit completion.
- Do not replace the final outcome with a discovery-only, baseline-only, prioritization-only, or first-phase Goal unless the user explicitly asks for that narrower result.
- Do not split a coherent outcome into numbered Goal blocks merely because it contains many modules or phases.
- Split into multiple Goal blocks only when the user explicitly asks for multiple Goals/roadmap or the outcomes have incompatible stopping conditions and cannot share one final acceptance contract. Explain the reason briefly and ask before changing the requested shape.

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
- At the start of every resumed run, read the record, inspect the current worktree, and reconcile stale or unsupported entries. Current code, tests, and measured results remain authoritative.
- After each meaningful change or checkpoint, update the same record before moving on. Do not wait until the end of a long run to reconstruct history.
- Keep a compact current-state summary and an append-only change/decision log. Record the Goal objective and constraints, completed improvements, changed files or commits, decisions and rationale, focused validation, benchmark evidence, remaining work, blockers, risks, and the next concrete action.
- Link to commands, tests, benchmark artifacts, and relevant files instead of pasting large logs. Never store secrets, credentials, tokens, or unnecessary private data.
- Updating the record does not require a full test suite. Select validation from the risk and scope of the code change, using focused checks during normal work and broader checks at appropriate acceptance gates.
- When the Goal finishes, record the final acceptance status, actual evidence, known deviations, and residual risk. Do not mark it complete merely because the record is updated.

Use this compact structure unless the repository already defines an equivalent one:

```markdown
# Goal Record: <objective>

## Objective and Constraints
- Objective: <final outcome>
- Constraints: <compatibility, platform, authority, or other binding limits>

## Current State
- Status: active | blocked | complete
- Last verified: <date or commit>
- Summary: <what is true now>
- Completed improvements: <delivered changes since the previous checkpoint>
- Next action: <one concrete action>

## Acceptance Coverage
| Requirement | Status | Evidence | Gap or risk |
|---|---|---|---|

## Change and Decision Log
| Date | Change or decision | Rationale | Evidence |
|---|---|---|---|

## Validation and Benchmarks
- Focused checks: <commands and results>
- Broader checks: <commands and results, when run>
- Benchmarks: <workload, environment, baseline, result, artifact>

## Remaining Work, Blockers, and Risks
- <item, owner or unblock condition, and next action>
```

## Ask Only Material Questions

Codex owns repository facts; the user owns decisions that cannot be discovered. Do not force a questionnaire when the request already supplies the needed contract.

Ask a question only when all of these are true:

1. The answer cannot be found in the repository or the user's request.
2. Different answers materially change the user's final outcome, external compatibility, authority, or stopping condition.
3. A reasonable default would risk doing the wrong work.

Ask at most one to three concise questions in a round, with the recommended default and tradeoff. Do not ask about facts Codex can inspect. Do not ask the user to choose routine commands, file names, test scope, or implementation details that can be selected from repository conventions.

If an ambiguity is non-material, choose a repository-aligned default and state it in the Goal. If the user later provides an example or explicit contract, treat it as confirmation and draft the Goal instead of restarting the interview.

When the user has already stated the desired final outcome, do not ask them to reconfirm that outcome merely because the work is broad. Ask only about unresolved boundaries that would change the result.

## Define The Contract

Before output, ensure the single Goal states:

1. final objective and in-scope domains;
2. explicit exclusions and non-goals;
3. authoritative files/specs to read first;
4. a canonical progress matrix or tracking artifact when the work spans modules;
5. one durable Goal record and its resume/update rules when work spans runs;
6. checkpoints that show progress but do not end the Goal;
7. rules for preserving behavior, simplicity, performance, and user changes;
8. focused validation during work and broader validation at appropriate checkpoints;
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

## Progress Checkpoints
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

- checkpoints are internal progress markers, not completion conditions;
- after each checkpoint, continue to the next unfinished independent work;
- at the start of each resumed run, read and reconcile the canonical Goal record;
- after each meaningful change or checkpoint, update that record with facts and evidence;
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
- create multiple progress or memory files for one Goal, or treat a stale record as authoritative without checking the repository;
- store secrets or paste large raw logs into the Goal record;
- make a roadmap or progress document the final deliverable;
- declare completion at a checkpoint or because one subsystem is blocked.

## Final Check

Before returning the Goal, verify that it:

- represents one durable outcome rather than an arbitrary collection of tasks;
- follows the user's requested shape and language;
- captures the user's actual desired final state, not merely the easiest first step;
- is grounded in discovered project facts and confirmed user decisions;
- distinguishes authoritative requirements from proposals and measurements from claims;
- includes checkpoints without turning them into separate Goals;
- uses focused validation during work and appropriate broad validation at final gates;
- has a reproducible benchmark protocol when performance matters;
- defines one resumable Goal record when the work can span runs, with reconciliation and update rules;
- has a falsifiable stopping condition and explicit residual-risk reporting; and
- contains no invented facts or unnecessary complexity.
