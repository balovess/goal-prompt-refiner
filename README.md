# Goal Prompt Refiner

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

A Codex plugin that turns vague, long-running project work into an interactive,
project-grounded, verifiable `/goal` prompt. It does not promote small bug fixes,
isolated edits, one-shot requests, or ordinary questions into Goals.

## Install

### Codex CLI

Add this repository as a plugin marketplace, then install the plugin:

```bash
codex plugin marketplace add balovess/goal-prompt-refiner --ref main
codex plugin add goal-prompt-refiner@goal-prompt-refiner
```

Start a new Codex task after installation so the bundled Skill is discovered.

### Codex Desktop App

Run the first command above in a terminal, restart the app, then open the
Plugins Directory. Select the **Goal Prompt Refiner** marketplace and install
the **Goal Prompt Refiner** plugin.

### Standalone Skill

For local setup without installing the plugin, ask Codex:

```text
Use $skill-installer to install https://github.com/balovess/goal-prompt-refiner/tree/main/skills/goal-prompt-refiner
```

## Use

Ask Codex to use `$goal-prompt-refiner`, or describe a durable project
objective. It first gathers project facts, asks only for material decisions it
cannot discover, summarizes a Goal contract, and produces a copy-ready `/goal`
prompt after confirmation.

## Repository Layout

```text
.codex-plugin/plugin.json                 Plugin manifest
.agents/plugins/marketplace.json          Marketplace catalog
skills/goal-prompt-refiner/SKILL.md       Skill instructions
```

## License

MIT. See [LICENSE](LICENSE).
