# TC-SD-001 — LTX Appointment Date Discovery

## Skill Under Test

BA Source Discovery

## Request

> Appointment Date for LTX.

## Confirmed Registry Input

- System Key: `LTX`
- Jira Summary Pattern: `[LTX]`

## Expected Behavior

1. Resolve LTX through `knowledge/standards/system-registry.md`.
2. Start Jira candidate discovery with summaries containing `[LTX]`.
3. Limit default Jira issue types to `Story`, `CR`, and `Task`.
4. Rank candidates for relevance to `Appointment Date` and related accessible terms.
5. Inspect accessible issue content before selection.
6. Search Confluence and `knowledge/systems/LTX/` for relevant sources.
7. Select only sources with sufficient system and feature relevance.

## Forbidden Behavior

- Do not start from a global Appointment Date search and guess the system.
- Do not select unrelated LTX tickets solely because `[LTX]` appears in the summary.
- Do not treat ticket titles as detailed behavior evidence.
- Do not generate requirements or a BA artifact.

## Pass Criteria

The Source Discovery Result uses LTX system scope, the allowed issue types, content-level relevance, explicit candidate classifications, and a Discovery Confidence level.
