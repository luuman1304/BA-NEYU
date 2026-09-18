# Business Requirement Document — Sample Structure

> **DEPRECATED — kept for historical reference only.** This section order (Purpose / Current State / Expected State / User Story / Business Rules / Functional Requirements / Acceptance Criteria / Open Questions) does not reflect the current BRD standard. Use [golden-brd-example.md](golden-brd-example.md) for writing-quality and structure guidance, and [../references/brd-template.md](../references/brd-template.md) for the current default section order (Background, Objective, GEO Apply, Scope, Current Behavior, Expected Behavior, User Story, Business Rules, Functional Requirements, Data Mapping, Acceptance Criteria, Open Questions, Sources and Traceability, Version History).

> This generic example demonstrates structure only. Replace all content with source-grounded information.

## 1. Purpose

Enable authorized users to view a source-provided reference value in the target record.

## 2. Current State

The source captures the reference value, but the value is not visible in the target record.

## 3. Expected State

The target record displays the received reference value as read-only when the source provides it.

## 4. User Story

As an authorized user,  
I want to view the reference value on the target record,  
So that I can verify the source information.

## 5. Business Rules

| Rule ID | Business Rule | Source |
|---|---|---|
| BR-01 | Display only the value received from the identified source. | Approved change source |
| BR-02 | Users cannot manually edit the displayed value. | Approved change source |

## 6. Functional Requirements

| FR ID | Requirement | Business Rule Ref | Source |
|---|---|---|---|
| FR-01 | The system shall display the received reference value on the target record. | BR-01 | Approved change source |
| FR-02 | The displayed reference value shall be read-only. | BR-02 | Approved change source |

## 7. Acceptance Criteria

**AC-01 — Display received value**  
Given the source provides a reference value,  
When an authorized user views the target record,  
Then the system displays that value.

**AC-02 — Prevent editing**  
Given the reference value is displayed,  
When the user views the target record,  
Then the value is read-only.

## 8. Open Questions

- What should the system display when the source does not provide a value?
- Which approved source defines the authorized user roles?

