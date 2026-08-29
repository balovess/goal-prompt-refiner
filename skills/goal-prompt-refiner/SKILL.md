---
name: goal-prompt-refiner
description: Turn a vague or detailed long-running project request into one project-grounded, verifiable Codex `/goal`, either as a copy-ready draft or, only with explicit user authorization, by creating and starting the Goal. Use focused interactive decision refinement, ordered phase gates, adaptive bounded agent delegation, and resumable evidence. Do not use for short bug fixes, isolated edits, one-off answers, questions, estimates, or ordinary plans.
---

# Goal Prompt Refiner

Recover the user's actual desired outcome from an ambiguous request, then produce one durable Goal with an observable final state. Put implementation work into ordered phases with hard transition gates inside that Goal; a passed phase gate must immediately start the next phase in the same Goal run and never completes the whole Goal. For work that may span multiple `/goal` runs, include a durable, project-local continuation record so later runs can resume from verified state instead of relying on conversation memory.

## Select The Mode

Choose exactly one mode before drafting or executing:

- `Draft mode` is the default. Analyze the request and project, resolve only material decisions, then output exactly one copy-ready `/goal` prompt. Do not create or start a Goal.
- `Execute mode` is available only when the user explicitly asks to create, start, run, or execute the Goal. Resolve material decisions first, then create the single Goal with the final objective and continue under its phase, delegation, validation, and completion rules.
- Do not infer `Execute mode` from a request to explain, refine, write, or prepare a Goal. Do not call `create_goal` merely because the skill was automatically selected or explicitly invoked.
- If the user asks to execute but the final objective or acceptance contract still has material ambiguity, use interactive choices first. Do not create a partial Goal.
- If the runtime cannot create a Goal, return to `Draft mode`, provide the copy-ready prompt, and explain the limitation in the target language; do not claim execution started.

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
- In `Draft mode`, once the final objective and acceptance contract are clear, produce exactly one copy-ready `/goal` prompt.
- In `Execute mode`, once the final objective and acceptance contract are clear, use the runtime's Goal creation capability to start the one Goal, then report the created Goal and its initial active phase.

If the initial request already defines the final outcome and acceptance gates, draft directly. Interactive choices are for material ambiguity, not a mandatory interview. If no choice control is available, use the shortest textual fallback and do not invent a decision.

## Match The Goal Language

Use the user's target language as the primary language for all user-facing communication. Prefer an explicitly requested output language; otherwise use the dominant language of the current request and its examples.

- Use the target language for clarification, interactive choices, progress updates, blocker explanations, the generated `/goal`, phase reports, and the final result.
- If the user explicitly switches language or asks for a translation, follow the new instruction from that point onward.
- Keep code, commands, file paths, API names, identifiers, status values, and quoted source text unchanged unless the user asks to translate them.
- Do not mix languages for convenience. If a technical term must remain in its original form, explain it in the target language.
- If the target language cannot be inferred and the choice materially affects the deliverable, ask one interactive language choice before drafting; otherwise infer it without interrupting the workflow.

## Understand The Real Goal

Do not equate a large scope with a first-phase deliverable. First determine what the user wants to be true when the work is finished.

- Read the user's wording, examples, corrections, and acceptance language as requirements for the final output.
- Separate the desired outcome from proposed implementation steps, investigation tasks, milestones, and documents.
- If the user says the project should continue until a condition is met, preserve that persistence and make the condition the stopping rule.
- If the user gives an example with a final target, working rules, ordered phases, and acceptance gates, follow that shape.
- If the user asks for one clear Goal, produce one Goal covering the complete requested outcome.
- Put implementation stages inside one Goal as ordered phases with blocking exit gates. A passed phase gate immediately starts the next phase in the same Goal run but does not complete the Goal.
- Do not replace the final outcome with a discovery-only, baseline-only, prioritization-only, or first-phase Goal unless the user explicitly asks for that narrower result.
- Do not split a coherent outcome into numbered Goal blocks merely because it contains many modules or phases.
- Split into multiple Goal blocks only when the user explicitly asks for multiple Goals/roadmap or the outcomes have incompatible stopping conditions and cannot share one final acceptance contract. Explain the reason briefly and ask before changing the requested shape.

## Enforce Sequential Phase Gates

For multi-phase work, treat phases as ordered work packages with blocking exit gates, not as loose progress markers.

- Define one active phase at a time. Record each phase's required outcomes, exclusions, validation evidence, and exit gate before starting it.
- Use explicit phase states such as `not_started`, `in_progress`, `blocked`, `passed_locked`, and `reopened`. A phase containing any required `missing`, `partial`, or `unverified` item cannot become `passed_locked`.
- Finish the active phase completely before starting the next phase. Do not advance because a subset is complete, because another module is independent, or because the current phase is inconvenient.
- If the active phase is blocked, work on its direct blockers and their validation. Do not switch to later phases or unrelated modules unless the user explicitly authorizes parallel tracks.
- When the phase gate passes, record the exact evidence and relevant commit or artifact, mark the phase `passed_locked`, set the next phase to `in_progress`, and immediately begin that phase in the same Goal run. A phase boundary is never a stopping point: do not return control, ask the user to resume, pause, or produce a final completion report there. A locked phase is not re-analyzed on every resumed run.
- Reopen a locked phase only when its source, specification, dependency, or environment changes; its evidence becomes invalid; a regression appears; or later integration exposes a concrete contradiction.
- Use validation proportional to the phase risk. A phase gate may require focused checks; updating a record or making a small edit does not by itself require the full test suite.

## Continue Until Goal Completion

Treat phase completion as an internal transition, not as Goal completion.

- Continue executing the next ordered phase immediately after the current phase is `passed_locked`; do not wait for a new user message or a manual `/goal resume`.
- The Goal may end only after every phase is `passed_locked` and every final acceptance criterion passes.
- Do not emit a final result, completion claim, or phase-only handoff while any phase or final criterion remains incomplete.
- If an unavoidable external blocker prevents continuation, keep the Goal incomplete, record the blocker and the next unblock action, and do not claim that the Goal is complete. A phase boundary alone is never an external blocker.

## Use Independent Agents Safely

Use adaptive, manager-style delegation when the runtime exposes reliable agent lifecycle controls and the active phase contains independent work that materially benefits from parallel execution. Do not delegate merely to increase activity; otherwise continue serially.

- The initiating/root agent remains the sole owner of the one Goal, active phase, user communication, canonical record, scope decisions, phase gates, integration, final acceptance, and completion. Delegates never change phase state, update the canonical record, ask the user, expand the Goal, or declare completion.
- Delegate only concrete tasks within the active phase. Each task must state a task ID, objective, deliverable, read scope, exact write scope, prohibited paths, dependencies, focused validation, expected result format, and blocker or escalation rule. Do not delegate later-phase implementation or validation before the active phase gate passes.
- Allow read-only exploration, bounded implementation, and task-specific focused checks. A delegate's `completed` report is input to review, not phase-gate evidence.
- Do not run concurrent write tasks with overlapping scopes. Treat the Goal record, lockfiles, global configuration, generated outputs, repository-wide formatting, shared fixtures, and integration entry points as root-owned. If reliable isolation is unavailable, serialize write tasks; read-only tasks may still run in parallel.
- Do not let delegates spawn further agents unless the root explicitly authorizes it for that task. Respect the runtime's reported capacity; do not hard-code a concurrency count.
- Use asynchronous write delegation only when the runtime can reliably wait for required agents and close agents that may still write. Before a phase gate, collect every required result, close remaining write-capable agents, confirm the workspace is quiet, inspect the changes, and run root-owned integration validation.
- Delegates must return structured status such as `completed`, `blocked`, or `needs_root_decision`, with changed files, evidence, failures, assumptions, risks, and next action. They must return material decisions to the root instead of asking the user directly.
- Retry a failed delegated task at most once with a changed scope or context. After another failure, let the root take over or record the blocker; never silently skip the required task or retry indefinitely.
- Use focused checks for delegated changes. Schedule shared, expensive, integration, benchmark, and full-suite checks at the appropriate phase or final gate; do not duplicate them after every small change.

If reliable agent lifecycle controls or write isolation are unavailable, continue serially rather than using asynchronous write delegation.

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
- The root agent updates the same record after each meaningful change, delegated result, or phase gate before moving on. Do not wait until the end of a long run to reconstruct history.
- Keep a compact current-state summary and an append-only change/decision log. Record the Goal objective and constraints, ordered phases, active phase, passed and locked phases, completed improvements, changed files or commits, decisions and rationale, focused validation, benchmark evidence, remaining work, blockers, risks, invalidation events, and the next concrete action.
- When delegation is used, keep a compact delegation ledger in the same record: task ID, owning phase, agent status, files changed, validation evidence, root review result, blockers, and decisions needed. Delegates do not update this record directly.
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
11. adaptive delegation rules, root ownership, task boundaries, lifecycle, and result review when agent support is available;
12. final acceptance gates and one explicit stopping condition.

For performance work, require a reproducible before/after comparison using comparable inputs and the same relevant environment. Record actual throughput, latency/tail latency, CPU, memory, allocation, I/O, lock contention, or concurrency metrics when the workload supports them. Never promise a percentage improvement without a measured baseline.

For compatibility or migration work, require a matrix that maps source behavior or specification to implementation, tests, known differences, risk, and status. Do not treat compilation, one module, a generated plan, or a partial test suite as completion.

## Produce The Goal

In `Draft mode`, once the user's actual outcome is clear enough, answer in the user's target language and lead with exactly one copy-ready code block beginning with `/goal`. Keep any surrounding explanation to one or two sentences.

In `Execute mode`, create the Goal only after explicit user authorization and a clear final objective. Do not output a draft as a substitute for execution or claim that execution started before the Goal creation call succeeds. After successful creation, report the Goal's initial state in the target language; the created Goal, not this skill response, owns ongoing implementation and completion.

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

## Delegation and Agent Execution
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
- after a phase gate passes, record evidence, mark that phase `passed_locked`, and immediately start the next phase in the same Goal run; do not stop at a phase boundary, do not ask the user to resume, and do not return a phase-only result;
- when agent support is available and useful, delegate bounded independent tasks within the active phase under root-agent ownership; delegation never creates a second Goal or bypasses a phase gate;
- use the user's target language for all user-facing Goal communication, while preserving commands, paths, identifiers, status values, and quoted source text;
- every delegated task has an explicit read scope, write scope, prohibited paths, dependencies, focused validation, and result format;
- never run overlapping write scopes concurrently; serialize writes when reliable isolation is unavailable;
- if reliable agent lifecycle controls or write isolation are unavailable, continue serially;
- before a phase gate, wait for required delegates, close remaining write-capable delegates, confirm the workspace is quiet, and have the root review and validate their results;
- delegate reports are not acceptance evidence by themselves, and agents must return material user decisions to the root;
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
- delegate an entire Goal, phase ownership, final acceptance, or canonical-record updates to a child agent;
- spawn agents without a bounded task, disjoint write scope, reliable lifecycle control, or a material benefit;
- allow concurrent agents to modify shared records, lockfiles, generated files, global configuration, fixtures, or integration entry points;
- treat an agent's completion report as proof that a change or phase passed without root review and validation;
- retry a failed agent indefinitely or run duplicate expensive checks from every delegated task;
- treat a partial or unverified phase as passed, or begin a later phase before the active phase gate passes;
- stop, pause, ask the user to resume, or report completion merely because a phase gate passed;
- switch to unrelated work merely because the active phase is blocked;
- re-analyze a passed and locked phase without an explicit invalidation signal;
- create multiple progress or memory files for one Goal, or treat a stale record as authoritative without checking the repository;
- store secrets or paste large raw logs into the Goal record;
- make a roadmap or progress document the final deliverable;
- declare the Goal complete because one phase gate, module, or milestone passed, or because one subsystem is blocked.
- end the Goal before every phase is locked and every final acceptance criterion has passed.

## Final Check

Before returning the Goal, verify that it:

- represents one durable outcome rather than an arbitrary collection of tasks;
- follows the user's requested shape and language;
- uses the user's target language consistently across interaction, generated Goal text, progress, blockers, and final reporting;
- captures the user's actual desired final state, not merely the easiest first step;
- is grounded in discovered project facts and confirmed user decisions;
- distinguishes authoritative requirements from proposals and measurements from claims;
- defines ordered phases with blocking exit gates without turning them into separate Goals;
- prevents later phases from starting before the active phase gate passes;
- requires immediate same-run continuation after a passed phase and forbids phase-boundary stopping or manual-resume handoff;
- defines adaptive bounded delegation without requiring agents for every task;
- keeps root-agent ownership of scope, records, phase gates, integration, and completion;
- defines task contracts, write-scope isolation, lifecycle collection, failure retry, and structured result review;
- records passed and locked phases plus explicit invalidation conditions;
- uses focused validation during work and appropriate broad validation at final gates;
- has a reproducible benchmark protocol when performance matters;
- defines one resumable Goal record when the work can span runs, with reconciliation and update rules;
- has a falsifiable stopping condition and explicit residual-risk reporting;
- permits Goal completion only after every phase and final acceptance gate passes; and
- contains no invented facts or unnecessary complexity.
