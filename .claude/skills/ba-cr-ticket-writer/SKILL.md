---
name: ba-cr-ticket-writer
description: Write source-grounded change request tickets for enhancements, behavior changes, UI fields, statuses, permissions, integrations, reports, exports, dashboards, and validations. Use when drafting or reviewing a CR ticket while preserving an existing approved ticket format when supplied.
---

# BA CR Ticket Writer

## Purpose

Create concise, testable change request tickets grounded only in supplied sources while preserving the structure and style of an approved reference ticket when available.

## Trigger

Use this skill for:

- Enhancements and change requests.
- System behavior changes.
- UI field additions.
- Status changes.
- Permission updates.
- Integrations.
- Reports or exports.
- Dashboards.
- Validation changes.
- Review or revision of an existing CR ticket.

## Inputs

Collect and identify, when available:

- Change request and business objective.
- Existing or approved ticket, screenshot, or ticket format.
- Current behavior evidence.
- Expected behavior and business rules.
- Applied system, module, and GEO.
- UI references, field names, mappings, mockups, or screenshots.
- Integration and validation documentation.
- Legacy or existing-data behavior.
- Dependencies and source URLs.

Missing inputs are gaps, not permission to infer requirements.

## Workflow

Before writing the ticket:

1. When the request changes or reuses existing behavior, use `ba-source-discovery` to discover candidate Jira, Confluence, and local sources, then use `ba-current-state-analyzer` to validate selected evidence and produce a Current-State Analysis.
   - Consume the analyzed Current-State result; do not implement independent Jira or Confluence searches in this writer.
   - Use only its confirmed findings for Current Behavior.
   - If readiness is **PARTIAL**, draft only the supported scope and carry gaps into Open Questions.
   - If readiness is **BLOCKED**, do not produce final requirements; return the required current-state sources and Open Questions.
   - When the request says "same logic as," "align with," "copy," or similar, analyze both the reference and target implementations.
   - For isolated new behavior with no dependency on an existing implementation, record that Current-State Analysis is not applicable.
2. Extract confirmed requirements and associate each with its source.
3. Keep confirmed current behavior separate from the requested expected behavior.
4. Identify expected behavior.
5. Identify explicit business rules.
6. Identify impacted UI, process, data, integration, reporting, validation, and permission areas.
7. Identify missing, ambiguous, or conflicting information.
8. Select the ticket structure:
   - If an existing ticket, ticket screenshot, or approved format is supplied, use it as the primary format.
   - Otherwise, use [references/ticket-template.md](references/ticket-template.md).
9. Generate the ticket using only confirmed requirements.
10. Run all quality checks.

## Rules

### Grounding and classification

- Support every final requirement with a source.
- Distinguish Confirmed Requirements, Assumptions, Recommendations, and Open Questions during analysis.
- Write only confirmed information as ticket requirements.
- Never silently write a recommendation or assumption as a requirement.
- If a formula, logic, rule, permission, or status transition is undefined, state **"Not defined in source."**

### Reference ticket priority

Apply this precedence:

**Reference ticket format > Default ticket template**

When an existing ticket, screenshot of an existing ticket, or approved format is provided:

- Follow its heading order.
- Follow its terminology.
- Preserve its level of detail and writing style.
- Do not introduce unnecessary sections.

### Scope control

- Do not assume GEO, module, user role, permission, API specification, filtering, sorting, export, or legacy-data behavior.
- Preserve existing validation unless the source explicitly requests a change.
- Do not add implementation details unless requested and supported.
- Do not silently merge conflicting requirements.

### Ticket composition

- Separate Current Behavior from Expected Behavior.
- Break complex expected behavior into numbered logical groups.
- Use mapping tables when source-to-display or status mapping is defined.
- Include Business Rules only when useful.
- Include Functional Requirements only when ticket complexity requires them.
- Use concise Given / When / Then acceptance criteria.
- Combine related cases when reasonable; do not create excessive acceptance criteria.
- Include Other Information only when references, mockups, screenshots, or dependencies are provided.
- Include Open Questions / Assumptions only when needed.

## Output Contract

Return a ticket that:

1. Uses the supplied reference format or the default template according to precedence.
2. Has a source-grounded title and applicable system, module, or GEO identifiers only when provided.
3. Separates business context, current behavior, and expected behavior.
4. Includes explicit mappings for applicable integration or display transformations.
5. Includes a user story and concise, traceable acceptance criteria.
6. Labels assumptions and open questions rather than embedding them as requirements.
7. Omits non-applicable sections.

## Quality Checks

1. A Current-State Analysis was completed when the change depends on existing behavior.
2. Source Discovery preceded Current-State Analysis when existing-system sources required discovery.
3. The writer did not independently search Jira or Confluence or treat discovery results as requirements.
4. Current Behavior contains only confirmed findings from that analysis, and its readiness decision is respected.
5. Current Behavior and Expected Behavior are separated.
6. No unsupported requirement is added.
7. Field names match the provided source.
8. Status values match the source.
9. Existing validation is preserved unless a change is explicitly requested.
10. Scope and GEO are not assumed.
11. Integration mapping is explicit when applicable.
12. Legacy or existing-data behavior is stated only when the source defines it.
13. Each acceptance criterion traces to Expected Behavior.
14. Recommendations are not silently written as requirements.
15. Permissions and API specifications are not invented.
16. The reference ticket's structure and style are preserved when supplied.

## Failure Handling

- If current or expected behavior is missing, draft only supported content and list the gap under Open Questions.
- If no usable source supports the requested change, do not produce final requirements; request the required source.
- If sources conflict and precedence is unclear, describe the conflict and raise an Open Question.
- If an image or screenshot is unreadable, identify which structure or content could not be determined.
- If GEO, permissions, mapping, legacy-data handling, or integration details are needed but undefined, state **"Not defined in source."** where applicable and request clarification.
