# TC-CR-001 — Display Consent Values in TMS

## Skill Under Test

BA CR Ticket Writer

## Scenario

A landing page sends two consent values to TMS, and TMS must display them as read-only fields.

## Required Source Inputs

- Applied GEO.
- Current landing-page and TMS behavior.
- Names of the two source consent values.
- Target TMS screen and field names.
- Source-to-display value mapping.
- Read-only requirement.

## Expected Output

- Applied GEO, using only the provided value.
- Current Behavior separated from Expected Behavior.
- Expected Behavior organized into logical groups.
- A mapping table for the two consent values and their TMS display values.
- A source-grounded User Story.
- Concise Given / When / Then acceptance criteria covering receipt/display, mapping, missing information when defined, and read-only behavior.
- Field and status names that exactly match the source.

## Forbidden Behavior

- Do not invent additional permissions or user roles.
- Do not invent API endpoints, payload schemas, transport protocols, or other API specifications.
- Do not assume a GEO not supplied by the source.
- Do not add validation or existing-data behavior unless the source defines it.

## Pass Criteria

The ticket contains all expected sections and mapping detail, adds no unsupported permissions or API specifications, and traces each acceptance criterion to Expected Behavior.

