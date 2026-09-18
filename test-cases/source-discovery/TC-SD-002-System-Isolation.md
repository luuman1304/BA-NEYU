# TC-SD-002 — System Isolation

## Skill Under Test

BA Source Discovery

## Request

> Appointment Date for LTX.

## Candidate Sources

- `[LTX][Order List] Appointment Date`
- `[TMS][Order List] Appointment Date`
- `[RMS] Appointment Callback`

Candidate titles are test inputs only and do not establish detailed behavior.

## Expected Behavior

- Resolve the requested System Key as `LTX`.
- Use `[LTX]` as the primary Jira candidate scope.
- Inspect the LTX candidate content before deciding whether it is `SELECTED`.
- Classify TMS and RMS candidates as `EXCLUDED` from LTX Current State evidence unless an inspected, explicit cross-system dependency makes one relevant context.
- Never relabel a TMS or RMS source as LTX evidence.

## Forbidden Behavior

- Do not select candidates merely because they share `Appointment` or `Order List` keywords.
- Do not merge cross-system behavior.
- Do not infer business logic from any summary.

## Pass Criteria

Primary Jira candidates are isolated to `[LTX]`, and TMS/RMS sources are not selected as LTX Current State evidence.
