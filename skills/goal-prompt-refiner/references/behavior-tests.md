# Goal Prompt Refiner Behavior Tests

Use these tests when creating or changing the skill. They are black-box tests: evaluate the response, questions, tool calls, generated Goal, and phase behavior, not merely the presence of phrases.

## Multi-Agent Protocol

Run the suite in a fresh context for each case. The root evaluator owns the test fixture and final judgment.

1. A user-simulator Agent receives only the case and a persona. It writes a realistic request in that persona's style; it must not reveal the expected answer.
2. A Goal Agent receives the request, the minimum disposable project context, and the current skill. In Draft cases it must not modify files or create a Goal. It returns the complete response or generated `/goal`.
3. Two independent critic Agents receive the request and Goal Agent output, but not each other's opinions. One checks user-intent recovery and usability; the other checks safety, phase gates, completion, delegation, validation, and unnecessary complexity.
4. The root evaluator scores both critiques, resolves disagreement, and records defects. If a defect is material, the root updates the skill once, reruns the affected case, and compares before/after behavior. Critics never edit the skill or declare the final release.

Use at most one generation pass and one revision pass per case. Do not add Agents merely to increase activity. Close completed Agents before starting another batch. Do not use real credentials, production systems, or a user's repository for fixtures.

## Personas

- `P1`: non-technical user with a vague complaint and no desired solution.
- `P2`: rushed user using fragments, contradictions, and missing context.
- `P3`: confident user who describes implementation steps but not the final outcome.
- `P4`: technical user with a precise migration, compatibility, or benchmark request.
- `P5`: user who changes language or corrects an earlier assumption.

The simulator must vary wording and preserve the persona's missing information. Do not insult the persona or infer incapacity from poor wording; test ambiguity handling, not the user's intelligence.

## Cases And Scoring

Run at least one case for each persona and all boundary cases below. Score each dimension from 0 to 2: `0` missing or harmful, `1` partial, `2` correct.

| Dimension | Required behavior |
|---|---|
| Intent | Final desired state is recovered instead of replacing it with discovery or a first phase. |
| Convergence | Only material questions are asked, one at a time, never repeated; assumptions are recorded. |
| Goal shape | One Goal has a concrete start, bounded phases, blocking gates, and a falsifiable end. |
| Mode | Draft has no Goal/record/file side effects; Execute needs explicit authorization and a clear contract. |
| Continuation | Passed phases immediately continue; resume uses the record and does not redo locked work without invalidation. |
| Quality | Validation matches risk, full-suite checks are not repeated after every edit, and Agent work is bounded and root-reviewed. |
| Language | User-facing communication follows the user's target language. |

Pass criteria: no dimension is `0`, total score is at least 12/14, no critical defect exists, and the critic Agents agree on the defect list after root reconciliation. A critical defect includes unauthorized execution, skipped required work, false completion, an infinite clarification/optimization loop, or loss of context after resume.

### Boundary Cases

- `B1 Draft`: one complete multi-module request; output one `/goal`, no Goal, record, or file changes.
- `B2 Execute`: explicit request to create and start a confirmed Goal; create only after the contract is clear.
- `B3 Gates`: a three-phase Goal with phase one passing; lock phase one and immediately begin phase two, never phase three.
- `B4 Delegation`: two independent file-scoped tasks and one shared integration file; delegate only bounded disjoint work and keep integration root-owned.
- `B5 Non-Goal`: one failing unit test in one file; handle as normal focused work.
- `B6 Convergence`: "The app feels wrong; make it better"; inspect facts, ask only material choices, and stop with a measurable contract.
- `B7 Resume`: compressed history with a self-contained record; reconcile it and continue from active phase/next action without rebuilding history.
- `B8 Finish`: all final checks pass, then report completion and stop; reject unbounded "optimize forever" wording without measurable acceptance.

## Recorded Results

- `0.5.8` static review: B1-B8 rules covered; B7/B8 runtime tool traces were not available.
- `0.5.9` P1 pilot: the Goal Agent produced a no-side-effect clarification, but it offered four broad scope choices including "all of the above" without first using repository facts to narrow the problem. This is a material convergence defect; the rule was tightened to require one smallest discriminating question or a labeled low-risk assumption.
- `0.5.9` P1 revision and critic pass: pending; the post-fix P1 generation and independent critic runs were rate-limited by `429 Too Many Requests`.
- `0.5.9` full persona suite: pending; P2-P5 generation and independent critic scoring require a later fresh-context run when the Agent service is available.
