# Jira Search Rules

## Discovery Mode

Use this sequence:

1. **System Resolution:** resolve a case-insensitive System Key, System Name, or Alias through `knowledge/standards/system-registry.md`, then use that row's Jira Summary Pattern.
2. **Issue Type:** limit the default candidate scope to `Story`, `CR`, and `Task`.
3. **Feature Relevance:** rank candidates using feature, entity, module, screen, reference behavior, and business keywords.
4. **Read Issue Content:** inspect accessible content and metadata.
5. **Evidence Selection:** classify and select only relevant, inspectable sources.

Do not start with a global feature-keyword search and then guess the system.

Primary candidates must match the resolved Jira Summary Pattern. A source from another system is not target-system evidence unless its inspected content explicitly documents an integration or dependency. Classify that exception as `CROSS_SYSTEM_SUPPORTING_SOURCE` and keep its requirements separate.

Default discovery excludes `Bug`, `Epic`, `Spike`, and `Sub-task` unless one is explicitly referenced by a selected Story/CR/Task, required to understand a dependency, or explicitly requested by the user.

## Direct Reference Mode

When an issue key or Jira URL is provided:

1. Retrieve the referenced issue first.
2. Determine system and feature from accessible content; do not infer them from an ambiguous key alone.
3. Search related system-scoped `Story`, `CR`, and `Task` issues when necessary.
4. Look for previous behavior, subsequent or superseding changes, linked requirements, dependencies, and release evidence.

Direct reference does not disable related discovery.

## Candidate Inspection

Inspect where accessible:

- Issue key, summary, issue type, status, and resolution
- Description, Current Behavior, and Expected Behavior
- Business Rules and Acceptance Criteria
- Created and updated dates
- Linked issues and dependencies
- Fix version and release information

A matching System Key or title alone is insufficient for selection as behavior evidence.

## Lifecycle and Release Classification

Classify relevant Jira sources where evidence permits as:

- Proposed
- Approved
- In Development
- Implemented
- Released
- Cancelled
- Historical
- Unknown

Do not hardcode company-specific workflow mappings unless an authoritative mapping is supplied. `Done` does not automatically mean `Released`. If deployment or release evidence is insufficient, set `Release Status: Unknown`.

A newer ticket is not automatically Current Production State.
