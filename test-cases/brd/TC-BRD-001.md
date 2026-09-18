# TC-BRD-001 — Add Appointment Date to Another Order List

## Skill Under Test

BA BRD Writer / Updater

## Scenario

A stakeholder requests adding **Appointment Date** to another Order List using the same logic as an existing Order List.

## Input Conditions

- The stakeholder request is available.
- The existing Order List logic must be obtained as a required source.
- An existing BRD may or may not be supplied.

## Expected Behavior

- Identify the existing Order List logic as a required authoritative source.
- Do not invent the Appointment Date formula, derivation, field behavior, or data logic.
- Determine from sources whether filtering is defined.
- Determine from sources whether sorting is defined.
- Determine from sources whether export behavior is defined.
- Determine from sources whether timezone behavior is defined.
- Put undefined or ambiguous items into Open Questions.
- If an existing BRD is supplied, preserve its structure, numbering, terminology, and unrelated sections.
- Update only BRD sections impacted by the Appointment Date change.
- State **"Not defined in source."** for applicable undefined logic.

## Forbidden Assumptions

- Automatically assume Appointment Date is included in export.
- Automatically assume filtering is supported.
- Automatically assume sorting is supported.
- Automatically assume timezone conversion or display logic.

## Pass Criteria

The output is source-grounded, requests the existing logic when unavailable, preserves any supplied BRD structure, and records all unsupported behaviors as Open Questions rather than requirements.

