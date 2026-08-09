# Goal Prompt Refiner

A Codex skill that turns a vague long-running project request into an interactive, project-grounded, verifiable `/goal` prompt.

It is intended for durable work with multiple checkpoints, independent progress, a validation loop, and a falsifiable stopping condition. It deliberately does not turn small bug fixes, isolated edits, one-shot requests, or ordinary questions into Goals.

## Install

Clone this repository, then copy its contents into Codex's skills directory:

```powershell
git clone https://github.com/balovess/goal-prompt-refiner.git
Copy-Item -Recurse -Force .\goal-prompt-refiner "$env:USERPROFILE\.codex\skills\goal-prompt-refiner"
```

Restart Codex after installation so it discovers the skill.

## Use

Ask Codex to use `$goal-prompt-refiner`, or describe a durable project objective. The skill first grounds itself in the project, then asks only for material decisions it cannot discover, summarizes the Goal contract, and produces a copy-ready `/goal` prompt after confirmation.

## License

MIT. See [LICENSE](LICENSE).
