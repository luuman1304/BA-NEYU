# TC-SD-003 — Direct Jira Reference

## Skill Under Test

BA Source Discovery

## Request

> Review LTX-123.

## Expected Behavior

1. Enter Direct Reference Mode and retrieve `LTX-123` first.
2. Inspect accessible issue content and metadata to determine system and feature.
3. Use the confirmed registry mapping and `[LTX]` scope for related discovery.
4. Search related or superseding `Story`, `CR`, and `Task` tickets when necessary.
5. Inspect previous behavior, subsequent changes, superseding changes, linked requirements, dependencies, and release evidence where accessible.
6. Classify the direct issue and related candidates independently.

## Forbidden Behavior

- Do not assume the issue key alone proves its feature or current production effect.
- Do not stop all related discovery merely because a direct reference was supplied.
- Do not treat `Done` as proof of production release.
- Do not generate a BRD or CR ticket.

## Pass Criteria

`LTX-123` is read first, related discovery remains available, and selection depends on inspected evidence rather than the direct reference alone.
