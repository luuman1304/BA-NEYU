# Example — Appointment Date on FFM Order List

## Request Context

- Requested change: Add Appointment Date to the FFM Order List using the same logic as the LM Order List.
- Target: FFM Order List.
- Reference: LM Order List.
- Analysis scope: Existing Appointment Date behavior in LM and related existing behavior in FFM.

This example demonstrates classification and failure behavior. It does not define actual LM or FFM business logic.

## Sources Reviewed

| Source | Type | Approval / Version | Scope | Authority Notes |
|---|---|---|---|---|
| Stakeholder request | Change request | Not provided | Requested FFM change | Confirms the requested comparison but does not define LM logic. |

## Confirmed Current State

### Reference — LM Order List

No LM behavior can be confirmed from the available source.

### Target — FFM Order List

No existing FFM Appointment Date behavior can be confirmed from the available source.

## Existing Rules and Constraints

| Category | Finding | Applies To | Source |
|---|---|---|---|
| Appointment Date logic | **Not defined in source.** | LM and FFM | Stakeholder request |
| Validation | **Not defined in source.** | LM and FFM | Stakeholder request |
| Permission | **Not defined in source.** | LM and FFM | Stakeholder request |
| Status dependency | **Not defined in source.** | LM and FFM | Stakeholder request |
| Filter, sort, and export | **Not defined in source.** | LM and FFM | Stakeholder request |

## Reference-to-Target Comparison

A source-grounded comparison cannot be completed. The phrase "same logic as LM Order List" identifies LM as the reference but does not establish what that logic is or whether FFM already has related behavior.

## Gaps and Conflicts

| Type | Description | Impact | Required Resolution |
|---|---|---|---|
| Missing source | No authoritative LM Appointment Date definition or behavior was provided. | The reference logic cannot be translated into requirements. | Provide an approved LM BRD, ticket, specification, or other authoritative source. |
| Missing source | No authoritative FFM Order List current-state source was provided. | Existing FFM behavior and change impact cannot be established. | Provide current FFM documentation or other authoritative evidence. |

## Assumptions

None. The request does not support assuming derivation, display, validation, permission, status, filter, sort, export, format, or timezone behavior.

## Recommendations

Obtain and compare authoritative LM and FFM sources before drafting the final BRD or CR ticket.

## Open Questions

1. Which approved source defines Appointment Date on the LM Order List?
2. Which source documents the existing FFM Order List?
3. Are filter, sort, export, format, timezone, validation, permission, and status-dependent behaviors defined in those sources?

## Readiness Decision

- Status: **BLOCKED**
- Supported drafting scope: The business request and named reference/target may be recorded as context only.
- Unsupported drafting scope: Appointment Date logic and all dependent current- or expected-state behavior.
- Required additional sources: Authoritative LM Appointment Date behavior and current FFM Order List behavior.
