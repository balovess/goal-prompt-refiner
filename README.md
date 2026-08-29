# Goal Prompt Refiner

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

Goal Prompt Refiner is a Codex plugin for turning an incomplete long-running
project request into one verified, project-grounded `/goal` prompt. It recovers
the user's actual desired outcome, inspects the available project context,
asks only about material decisions, defines evidence-based completion gates, and
adds ordered phase gates and a durable project-local continuation record for
work that spans runs.

## When to Use It

Use this plugin for a durable objective that needs multiple turns, autonomous
progress, a validation loop, and an explicit stopping condition. Typical
examples include a compatibility migration, a multi-module refactor, or a
measured performance initiative.

Do not use it for a small bug fix, isolated edit, one-shot implementation,
question, estimate, or ordinary plan. Those requests should remain normal
Codex tasks.

## Install

### Codex CLI

Add this repository as a marketplace and install the plugin:

```bash
codex plugin marketplace add balovess/goal-prompt-refiner --ref main
codex plugin add goal-prompt-refiner@goal-prompt-refiner
```

Start a new Codex conversation after installation so it can discover the
bundled Skill.

### Codex Desktop App

Run the marketplace command above in a terminal, then restart the desktop app.
Open the Plugins Directory, select **Goal Prompt Refiner Marketplace**, and
install the **Goal Prompt Refiner** plugin.

### Standalone Skill

For local experimentation without installing the plugin, send this prompt to
Codex:

```text
Use $skill-installer to install https://github.com/balovess/goal-prompt-refiner/tree/main/skills/goal-prompt-refiner
```

## What It Does

1. Determines whether the request warrants a long-running Codex Goal.
2. Supports `Draft mode` by default and `Execute mode` only after explicit user
   authorization to create or start the Goal.
3. Uses interactive choices for material decisions instead of static questions
   or questionnaires.
4. Collects repository facts before asking the user for information available in the project.
5. Resolves only material user decisions, with clear tradeoffs and recommended defaults.
6. Uses the user's target language consistently for interaction, the generated
   Goal, progress, blockers, and final reporting.
7. Enforces ordered phases: the active phase must pass its exit gate before the
   next phase starts, then continues into that phase immediately in the same
   Goal run.
8. Locks verified phases and resumes from the active phase without re-analyzing
   locked work unless an explicit invalidation is detected.
9. Generates one coherent Goal once the desired outcome is clear; it does not
   replace the final outcome with a first-phase Goal.
10. Converts broad quality claims into project-appropriate tests, benchmarks, artifacts, and stopping conditions.
11. Defines one canonical Goal record for resumable work, including changes,
   decisions, validation evidence, remaining work, blockers, and risks.
12. Uses bounded independent agents adaptively inside the active phase when
    they materially help, while keeping Goal ownership and final acceptance in
    the root agent.
13. Reviews delegated results at the root, protects shared write scopes, and
    falls back to serial execution when lifecycle control or isolation is not
    reliable.

## Use

Invoke `$goal-prompt-refiner` or describe a durable project objective in natural
language. It uses `Draft mode` unless the request explicitly says to create or
start the Goal. When a material decision is missing, the skill presents interactive
choices rather than a static question. It does not start a later phase while the
current phase gate is incomplete, and it does not stop at a passed phase
boundary or require a manual resume. When the runtime supports reliable agent
lifecycle controls, it may also delegate independent bounded tasks within the
active phase; delegated results still require root review. User-facing
communication follows the user's target language. For example:

```text
Use $goal-prompt-refiner to prepare a Goal for a full protocol-compatibility migration. It must preserve behavior, update documentation, and prove any performance claims with benchmarks.
```

The final prompt is ready to paste into Codex as `/goal`. Only unresolved
decisions that materially change the scope, authority, compatibility, or
acceptance criteria require confirmation before drafting. For a multi-run Goal,
the default record location is `.codex/goals/<goal-slug>.md` unless the project
already has a canonical tracker.

In `Execute mode`, the runtime creates the Goal only after explicit user
authorization and a complete objective; automatic skill selection alone never
starts a Goal.

## Behavior Testing

The skill includes realistic forward cases in
`skills/goal-prompt-refiner/references/behavior-tests.md`. They cover mode
selection, finite requirement convergence, phase-gate continuation, bounded
delegation, focused validation, context-compaction handoff, completion, and
non-Goal requests. Run them in fresh contexts and inspect the actual response
and tool trace; the cases are not keyword-only tests.

## Repository Layout

```text
.agents/plugins/marketplace.json          Git-backed plugin marketplace
.codex-plugin/plugin.json                 Plugin manifest and UI metadata
skills/goal-prompt-refiner/SKILL.md       Skill instructions and trigger rules
skills/goal-prompt-refiner/references/   Detailed templates loaded when needed
```

## License

Distributed under the MIT License. See [LICENSE](LICENSE).
