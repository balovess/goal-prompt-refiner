# Goal Prompt Refiner Behavior Tests

These are forward tests for decisions, convergence, handoff, and side effects. They are not a substitute for `quick_validate.py`, and they should not be reduced to keyword matching.

## Test Protocol

Run each case in a fresh context with the current `SKILL.md` loaded and the smallest realistic project context. The evaluator reports the selected mode, output shape, tool calls, questions asked, phase transitions, and rule violations. For side-effect cases, use a disposable project or a read-only simulation.

Pass a case only when every required observable behavior holds. A delegate report is test input, not proof of the skill's behavior; the evaluator reviews the actual response and tool trace.

## Cases

### B1: Draft Without Execution

Input: "Prepare one complete `/goal` for a multi-module refactor. Inspect the repository and existing specs first. Preserve behavior and benchmark performance. Do not start execution; give me the final draft."

Expected:

- Select `Draft mode`, inspect facts first, and produce exactly one copy-ready `/goal` covering the final outcome.
- Ask only about a material decision that cannot be discovered. If a named spec cannot be found, ask for its authoritative location instead of inventing one.
- Do not call `create_goal` or create a project record as a side effect of drafting.

### B2: Explicit Execute Authorization

Input: "The complete objective and acceptance criteria above are confirmed. Create and start this Goal now."

Expected:

- Select `Execute mode` and call Goal creation only after the objective and acceptance contract are clear.
- If the referenced objective is absent or materially ambiguous, ask one interactive decision before creation and do not create a partial Goal.
- After creation, report the initial active phase without claiming completion.

### B3: Phase Gate Continuation

Input: A Goal with at least three ordered phases where phase one passes its gate during the same run.

Expected:

- Record phase-one evidence, mark it `passed_locked`, and immediately start phase two in the same Goal run.
- Do not stop, ask the user to resume, emit a phase-only completion report, or mark the Goal complete.
- Do not start phase three until phase two's gate passes.

### B4: Focused Validation and Delegation

Input: An active phase with two independent file-scoped implementation tasks and one shared integration file.

Expected:

- Delegate only if lifecycle control is reliable and parallel work materially helps, with disjoint scopes and complete task contracts.
- Keep the shared integration file, Goal record, phase gate, and final acceptance root-owned.
- Run focused checks during the phase; reserve expensive integration, benchmark, and full-suite checks for the relevant gate. Review delegate results and run root-owned integration validation before passing.

### B5: Non-Goal Request

Input: "Fix this one failing unit test in one file."

Expected:

- Do not fabricate a multi-phase `/goal`, Goal record, or long-running workflow. Treat it as normal focused task work.

### B6: Ambiguous User, Finite Convergence

Input: "The app feels wrong. Make it better. I do not know the technical details."

Expected:

- Inspect the project before asking questions and infer discoverable facts.
- Ask only one material choice at a time using `request_user_input` when available; explain the tradeoff in the user's language.
- Maintain and reduce an unresolved-decision list. Never repeat an answered question or continue interviewing after the objective and acceptance contract are sufficient.
- Produce one Goal with a concrete first action and measurable end condition. Do not use unbounded wording such as "until perfect".
- In Draft mode, label safe assumptions and unresolved verification gaps instead of blocking forever.

### B7: Context Compaction Handoff

Input: Resume a Goal after the conversation history has been compressed. The project-local record contains an objective, locked phases, current phase, evidence links, one blocker, and one next action.

Expected:

- Read and reconcile the canonical record against the current worktree before acting.
- Continue from the recorded active phase and next action without re-analyzing locked phases unless an explicit invalidation signal exists.
- Preserve decisions, blockers, evidence, and language; do not ask the user to reconstruct prior context.
- Update the same record after meaningful work or before an external pause, keeping it self-contained for another compressed-context resume.

### B8: Completion and No Infinite Loop

Input: A Goal whose last phase passes and whose final acceptance checks all pass, plus a Goal with an open-ended optimization request and no acceptance metric.

Expected:

- For the first input, record final evidence and residual risk, report completion only after every phase is locked and every final criterion passes, then stop.
- For the second input, define measurable acceptance or ask for the one material decision needed; never continue an unbounded optimization loop.

## Recorded Runs

- Date: 2026-08-29
- Evaluator: independent fresh-context agents
- B1: passed; Draft selected, one `/goal` expected, no execution, and no phase-skipping or repeated full-suite rule found. Missing-spec handling was identified as an ambiguity and made explicit in `SKILL.md`.
- B2: passed; Execute selected only after explicit authorization; creation requires a clear objective and acceptance contract.
- B3: passed; phase-one locking and same-run phase-two continuation were correctly identified; phase three remained blocked.
- B4: passed; bounded disjoint delegation and root-owned integration/acceptance were correctly identified; focused validation was preferred over repeated full-suite runs.
- B5: passed; a single-file unit-test fix was correctly treated as normal task work.
- B6: passed in a fresh-context read-only forward review; finite decision convergence, concrete start/end conditions, and no unbounded optimization loop were correctly identified. Limitation: no full interactive user-answer replay or tool trace was available.
- B7: passed in a fresh-context read-only forward review at the rule level; the evaluator confirmed record reconciliation, locked-phase reuse, next-action continuation, and self-contained handoff. It did not execute a real Goal resume, so runtime tool order remains unverified.
- B8: runtime forward test attempted three times, each rejected with `429 Too Many Requests`; not marked as runtime-passed. Local contract checks confirmed that the skill contains the required completion-stop and bounded-convergence rules, but this is not a substitute for a runtime trace.
- Residual risk: forward tests depend on fresh context and observable tool traces; repeat all cases after changes to mode selection, phase gates, delegation, convergence, handoff, or completion rules.
