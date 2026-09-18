# Current-State Analysis Checklist

Use only the dimensions applicable to the requested change. For each applicable dimension, capture separate reference and target findings, source evidence, gaps, and conflicts.

## Context and Scope

- System, module, screen, process, report, field, or integration
- GEO or business scope
- User role or actor
- Reference implementation named by the request
- Approval status and version of each source

## Behavior

- Current purpose and user outcome
- Trigger and preconditions
- Process steps and decision points
- Display, editability, default, and visibility behavior
- Calculation, derivation, transformation, or mapping
- Exception and error behavior
- Existing-data or legacy-data behavior

## Rules and Controls

- Business rules
- Validations
- Permissions and role restrictions
- Status dependencies and transitions
- Mandatory or optional conditions
- Audit or history behavior

## Data and Integration

- Source and target fields
- Data ownership and system of record
- Input/output mappings
- Integration events or dependencies
- Format, timezone, localization, and null behavior

## List, Report, and Dashboard Behavior

- Display location and column behavior
- Filter behavior
- Sort behavior
- Search behavior
- Export behavior
- Aggregation or reporting period

## Evidence Tests

- Is each finding explicitly supported by a cited source?
- Is the source authoritative for the relevant system and scope?
- Is the source current and approved?
- Are reference and target findings documented separately?
- Does a source conflict with another source or observed behavior?
- Is an apparent absence merely undocumented behavior?

For an applicable formula, logic, rule, permission, or status transition that is not defined, state **"Not defined in source."**
