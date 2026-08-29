---
name: goal-prompt-refiner
description: Turn an ambiguous or detailed long-running project request into one project-grounded, verifiable Codex `/goal`, either as a draft or, only after explicit authorization, by creating it. Use focused decisions, ordered phase gates, bounded delegation, and resumable evidence. Do not use for short fixes, one-off answers, estimates, or ordinary plans.
---

# Goal Prompt Refiner

Recover the user's desired final state and express it as one Goal with a concrete start, ordered work, evidence-based gates, and a falsifiable finish. Keep fixed rules stable; put project facts, decisions, results, and other changing data after them.

## Mode And Scope

Choose one mode before acting:

- **Draft** (default): inspect context, resolve material decisions, and output exactly one copy-ready `/goal`. Never create or start a Goal, create a Goal record, or modify project files.
- **Execute**: use only when the user explicitly asks to create, start, run, or execute the Goal. Create it only after the final objective and acceptance contract are clear, then continue execution.

Do not infer Execute from automatic discovery, explicit skill invocation, or requests to explain, refine, write, or prepare. If Goal creation is unavailable, return the copy-ready Draft and explain the limitation; never claim execution started. A short fix, isolated edit, one-off answer, question, estimate, or ordinary plan remains normal work.

## Converge On The Real Goal

Inspect repository facts before asking. Treat the user's desired end state, examples, corrections, and acceptance language as requirements; treat proposed steps and documents as means. Preserve one coherent outcome rather than turning a large request into a discovery-only or first-phase Goal.

- Ask only about information that cannot be discovered and would change scope, authority, compatibility, or acceptance.
- Use `request_user_input` when available. Ask one decision at a time, offer two or three meaningful choices with the recommended choice first, and let the control supply `Other`.
- Maintain a short unresolved-decision list. Remove answered items, record decisions or assumptions, never repeat a question, and stop when the objective and acceptance contract are sufficient.
- In Draft, label a least-risk assumption or verification gap. In Execute, pause only when the missing decision is required for the contract. Never loop on missing input.
- If a named authoritative spec, tracker, baseline, or acceptance source cannot be found, ask for its location. Do not silently substitute an inferred source; in Execute, treat a required missing source as a blocker.
- Define a reachable first action, finite or explicitly bounded work, measurable acceptance, and one stopping action. Replace "until perfect" or "keep improving" with evidence gates or a documented residual-risk decision.
- Use the user's dominant/requested language for all user-facing interaction and Goal text. Preserve commands, paths, identifiers, status values, and quoted source text.

## Goal Execution Protocol

The generated prompt must define one final objective, scope and exclusions, authoritative context, validation, performance method when relevant, blocker handling, and final acceptance. For cross-run work, include one canonical project-local record; use an existing tracker when it already serves the Goal, otherwise `.codex/goals/<goal-slug>.md`.

Phases are ordered work packages inside one Goal, not separate Goals:

1. Maintain exactly one active phase with required outcomes, exclusions, evidence, and an exit gate.
2. Use states such as `not_started`, `in_progress`, `blocked`, `passed_locked`, and `reopened`. Any required `missing`, `partial`, or `unverified` item fails the gate.
3. Finish the active phase before starting the next. If blocked, work its direct blockers; do not skip to later or unrelated work without explicit authorization.
4. On a passed gate, record exact evidence, mark the phase `passed_locked`, set the next phase `in_progress`, and immediately continue it in the same Goal run. Do not stop, ask the user to resume, or return a phase-only result.
5. Reopen a locked phase only for an evidenced source/spec/dependency/environment change, invalid evidence, regression, or later contradiction.

The Goal ends only after every phase is `passed_locked` and every final acceptance criterion passes. Record final evidence, deviations, and residual risk, then report completion and stop. A plan, baseline, module, partial test, phase gate, or blocker is never completion.

## Validation And Performance

Use focused checks during implementation and after bounded delegated work. Schedule shared integration, expensive benchmark, and full-suite checks at the relevant phase or final gate; do not run the full suite after every small edit or duplicate expensive checks from every delegate.

When performance matters, require comparable before/after workloads in the same relevant environment and record actual supported metrics such as throughput, latency, CPU, memory, allocation, I/O, lock contention, or concurrency. Never invent targets, results, permissions, compatibility promises, or acceptance evidence.

## Delegation

Use independent Agents only when reliable lifecycle control exists and parallel work materially helps. The root Agent owns the Goal, scope, user decisions, active phase, record, integration, gates, final acceptance, and completion.

Every delegate receives a task ID, objective, deliverable, read scope, exact disjoint write scope, prohibited paths, dependencies, focused validation, result format, and escalation rule. Delegates stay inside the active phase, do not spawn further Agents, update the canonical record, ask the user, change phase state, or declare completion.

Never overlap write scopes. Keep the Goal record, lockfiles, generated files, global configuration, shared fixtures, formatting, and integration entry points root-owned. If isolation or lifecycle control is unreliable, work serially. Before a gate, collect results, close write-capable delegates, confirm the workspace is quiet, inspect changes, and run root-owned integration validation. A delegate report is not gate evidence. Retry a failed delegate at most once with changed scope/context, then take over or record the blocker.

## Durable Record And Resume

Load [references/goal-record-template.md](references/goal-record-template.md) only for work that spans runs. Keep one compact, self-contained record containing the objective and constraints, phase gates, active and locked phases, decisions, changes, focused and broad evidence, benchmarks, blockers, risks, invalidation events, delegation ledger, and exact next action. Link to artifacts instead of pasting logs; never store secrets.

At every resumed run, read and reconcile the record against current code, tests, measurements, and worktree. Continue from the active phase and next action without re-analyzing `passed_locked` work unless an invalidation signal exists. Update the same record after meaningful changes, delegated results, gates, or before an external pause so a fresh context after compaction can continue without reconstructing the conversation.

## Output

In Draft, output exactly one copy-ready code block beginning with `/goal`, in the user's target language, with at most one or two surrounding sentences. In Execute, create the Goal only after authorization and a clear contract; report its initial state, not completion. Use only sections relevant to the project:

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

Before output, verify that the prompt has one final outcome, explicit non-goals, a concrete first action, bounded phases, blocking gates, a completion condition, appropriate validation, and no invented facts. For skill validation or changes, load [references/behavior-tests.md](references/behavior-tests.md); do not load it for ordinary Goal drafting. Use [scripts/measure_prompt_cost.ps1](scripts/measure_prompt_cost.ps1) only when measuring prompt cost or cache layout.
