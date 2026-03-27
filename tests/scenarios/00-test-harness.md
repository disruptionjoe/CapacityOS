# Test Harness

## Test method

For each scenario:

1. seed a starting runtime state
2. run the scenario in Cowork and Codex
3. compare lifecycle outcome
4. compare queue visibility
5. compare morning/review visibility
6. record results

## Recording format

Use `tests/results/acceptance-matrix.md` and append:

- date
- scenario id
- wave
- platform
- expected outcome
- actual outcome
- pass/fail
- notes

## Failure rule

If a scenario passes in one platform but not the other, treat it as a harness
boundary failure until proven otherwise.
