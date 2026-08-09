# Goal Prompt Refiner

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

Goal Prompt Refiner is a Codex plugin for turning an incomplete long-running
project request into a verified, project-grounded `/goal` prompt. It qualifies
the request, inspects the available project context, interviews the user about
material decisions, and defines evidence-based completion gates.

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
2. Collects repository facts before asking the user for information available in the project.
3. Resolves only material user decisions, with clear tradeoffs and recommended defaults.
4. Confirms a compact Goal contract before generating the final `/goal` prompt.
5. Converts broad quality claims into project-appropriate tests, benchmarks, artifacts, and stopping conditions.

## Use

Invoke `$goal-prompt-refiner`, or describe a durable project objective in
natural language. For example:

```text
Use $goal-prompt-refiner to prepare a Goal for a full protocol-compatibility migration. It must preserve behavior, update documentation, and prove any performance claims with benchmarks.
```

The final prompt is ready to paste into Codex as `/goal` after you confirm the
proposed contract.

## Repository Layout

```text
.agents/plugins/marketplace.json          Git-backed plugin marketplace
.codex-plugin/plugin.json                 Plugin manifest and UI metadata
skills/goal-prompt-refiner/SKILL.md       Skill instructions and trigger rules
```

## License

Distributed under the MIT License. See [LICENSE](LICENSE).
