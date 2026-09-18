# Business Requirement Document

Default section order. Include only sections applicable to the supplied change and sources — do not add empty or irrelevant sections merely to make the document longer. `Stakeholders`, `Permissions`, `Dashboard/Reporting`, `Dependencies`, `Integration Requirements`, and `Out of Scope` are optional and appear only when the request or sources support them.

## 1. Background

Business context and the problem or opportunity driving the request.

## 2. Objective

What the change is meant to achieve, in business terms.

## 3. GEO Apply

The GEO(s) this requirement applies to. Omit if the request is not GEO-scoped.

## 4. Scope

### 4.1 In Scope

### 4.2 Out of Scope

Include 4.2 only when an explicit exclusion is meaningful; do not force it.

## 5. Current Behavior

Confirmed, source-grounded description of existing behavior. Every statement traces to a source. Do not reverse the requested Expected Behavior to infer Current Behavior — where availability is not verified, state so explicitly.

## 6. Expected Behavior

The requested change, grounded in the explicit source (request, attachment, approved CR, etc.). Kept distinct from Current Behavior.

## 7. User Story

As a [role],
I want [capability],
so that [outcome].

## 8. Business Rules

Only when applicable.

| Rule ID | Business Rule | Source |
|---|---|---|
| | | |

## 9. Functional Requirements

Only when applicable.

| FR ID | Requirement | Business Rule Ref | Source |
|---|---|---|---|
| | | | |

If a formula is applicable:

| FR ID | Metric / Function | Definition | Formula | Data Scope | Data Period | Source |
|---|---|---|---|---|---|---|
| | | | | | | |

**Important:** If a formula is not explicitly available in the provided source, leave it blank or state **"Not defined in source."** Never invent formulas. Apply the same protection to logic, rules, permissions, and status transitions.

## 10. Data Mapping

Only when applicable.

| Source Field | Target Field | Transformation | Notes |
|---|---|---|---|
| | | | |

## 11. Acceptance Criteria

Use concise Given/When/Then. Combine related acceptance conditions into one AC when this shortens it without losing logic — do not create one AC per minor variation.

## 12. Open Questions

Only when applicable. Missing, ambiguous, or conflicting information that blocks a confirmed requirement.

## 13. Sources and Traceability

| Requirement | Business Rule | Functional Requirement | Acceptance Criteria | Source |
|---|---|---|---|---|
| | | | | |

## 14. Version History

Only when updating an existing BRD.

| Version | Date | Change | Author |
|---|---|---|---|
| | | | |
