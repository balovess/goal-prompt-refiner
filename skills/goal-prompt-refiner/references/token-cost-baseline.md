# Token Cost Baseline

This record compares the compact entrypoint with the last committed `0.5.7` entrypoint. It is an evidence record, not ordinary Goal context; load it only when reviewing prompt cost or cache layout.

## Measured Results

| Artifact | `0.5.7` baseline | `0.5.8` result | Change |
|---|---:|---:|---:|
| `SKILL.md` bytes | 26,723 | 8,345 | -68.8% |
| `SKILL.md` lines | 284 | 95 | -66.5% |
| Stable prefix before `## Mode And Scope` | not measured | 671 bytes | structural baseline |
| `goal-record-template.md` bytes | 1,420 | 1,420 | unchanged |
| `behavior-tests.md` bytes | 6,909 | 6,909 before this validation update | reference-only |

The baseline bytes are UTF-8 Git blob content. The result was measured by
`scripts/measure_prompt_cost.ps1`; line endings and filesystem metadata are not
treated as model token counts.

## Interpretation

- No compatible tokenizer was available, so no true token count is claimed.
- Cache behavior is validated structurally: stable operating rules precede dynamic project data, and the measurement script can hash a marked prefix.
- Cache hit percentage and cost savings depend on the runtime and are not inferred from bytes.
- Repeat the measurement with the same prompt fixture after changes to the entrypoint or prompt assembly.
