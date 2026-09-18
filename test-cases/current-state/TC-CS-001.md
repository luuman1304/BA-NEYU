# TC-CS-001 — Analyze Appointment Date Before FFM Change

## Skill Under Test

BA Current State Analyzer

## Test Purpose

Verify that the Current State Analyzer establishes the existing LM and FFM behavior before any BRD or CR ticket is produced.

This test does not authorize generation of a BRD, CR ticket, expected-state requirements, or implementation design.

## Scenario

### Existing System

The LM Order List already has Appointment Date.

### New Request

> Add Appointment Date to FFM Order List using the same logic as the Appointment Date in LM Order List.

The phrase "same logic" identifies LM as the reference implementation. It does not define the underlying Appointment Date logic.

## Source Conditions

- The new request is available as a stakeholder request.
- The fact that Appointment Date exists on the LM Order List is confirmed by the scenario.
- Detailed LM Appointment Date behavior must be obtained from available authoritative existing-system sources.
- Existing FFM Order List behavior must be obtained from available authoritative existing-system sources.
- A behavior is confirmed only when an identified source explicitly supports it.
- Missing documents or missing details are gaps, not permission to infer behavior.

## Analysis Scope

The analyzer must search or review available sources and assess:

1. Current behavior of Appointment Date in LM.
2. Current behavior of Appointment Date in FFM.
3. Existing business rules.
4. Existing validations.
5. Existing display behavior.
6. Existing filter behavior.
7. Existing sorting behavior.
8. Existing export behavior.
9. Permissions, when documented.
10. Unknown, ambiguous, or conflicting information.

Reference and target behavior must be analyzed separately before comparison.

## Expected Classifications

### Confirmed Current State

Use only for behavior explicitly supported by an identified source. Each confirmed finding must include its source or evidence.

At minimum, the supplied scenario confirms that Appointment Date exists on the LM Order List. It does not confirm derivation, format, timezone, visibility, validation, filter, sort, export, permission, or status-dependent behavior.

### Unknown Current State

Use for applicable behavior that cannot be established from the available sources. The analyzer must identify the specific unknown dimension and must not convert it into an assumption or requirement.

### Conflicting Information

Use when available sources define the same behavior differently and source precedence does not resolve the conflict. Preserve each conflicting statement, identify its source, and raise the conflict for resolution.

### Required Additional Source

Use when missing evidence prevents confirmation of LM reference behavior, FFM target behavior, or a material comparison. Identify the minimum additional source needed and why it is required.

## Expected Output

The Current-State Analysis must:

- Identify LM Order List as the reference implementation and FFM Order List as the target.
- List the sources reviewed or searched, including authority, version, or scope limitations when known.
- Document LM and FFM findings separately.
- Provide source evidence for every Confirmed Current State finding.
- Classify unsupported applicable behavior as Unknown Current State.
- Record source conflicts without silently resolving or merging them.
- Identify Required Additional Sources for material gaps.
- Assess every dimension in the Analysis Scope as confirmed, unknown, conflicting, or not applicable based on source evidence.
- Produce an appropriate readiness decision based on the available evidence.
- Stop after Current-State Analysis without generating a BRD, CR ticket, or expected-state requirements.

## Forbidden Behavior

- Do not treat "same logic as LM" as a definition of Appointment Date logic.
- Do not assume that FFM has no related behavior merely because none is documented in the stakeholder request.
- Do not invent Appointment Date derivation, mapping, formatting, timezone, or null behavior.
- Do not invent business rules, validations, permissions, status dependencies, or user roles.
- Do not assume display position, editability, visibility, or default behavior.
- Do not assume filtering, sorting, searching, or export behavior.
- Do not use this test case or an illustrative example as authoritative existing-system evidence beyond the facts explicitly declared under Source Conditions.
- Do not generate future-state requirements, acceptance criteria, a BRD, or a CR ticket.

## Pass Criteria

The test passes when the analyzer produces a source-grounded Current-State Analysis that:

1. Separates LM reference behavior from FFM target behavior.
2. Assesses all ten analysis dimensions.
3. Cites evidence for every confirmed finding.
4. Uses the required classifications correctly.
5. Exposes missing and conflicting information without inference.
6. Requests the minimum additional sources needed for material gaps.
7. Does not invent unavailable behavior.
8. Does not produce a BRD, CR ticket, or expected-state requirements.
