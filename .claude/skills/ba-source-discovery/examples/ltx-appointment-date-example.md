# EXAMPLE ONLY — NOT REQUIREMENT EVIDENCE

## Scenario

Request:

> Add Appointment Date to FFM Order List for LTX using the same logic as LM Order List.

All ticket keys, pages, metadata, and results below are fictitious. They illustrate discovery behavior and must not be used as evidence of actual LTX behavior.

## 1. Search Scope

System: Latam Express
System Key: LTX
GEO: Unknown
Module: FFM target; LM reference
Screen: Order List
Feature: Appointment Date

Registry mapping: `Latam Express → LTX`; Jira Summary Pattern: `[LTX]`.

## 2. Search Terms

Primary: Appointment Date, Appointment
Secondary: FFM, LM, Order List

## 3. Jira Candidate Discovery

Candidate scope starts with summaries containing `[LTX]` and issue types `Story`, `CR`, or `Task`, then applies feature relevance.

| Issue | Summary | Type | Inspection Result | Selection |
|---|---|---|---|---|
| LTX-TEST-001 | [LTX][LM] Appointment Date on Order List | Story | Fictitious content appears relevant to the LM reference; release metadata is Unknown. | SELECTED |
| LTX-TEST-002 | [LTX][FFM] Order List change | CR | Fictitious content mentions FFM but does not establish Appointment Date behavior. | UNVERIFIED |
| LTX-TEST-003 | [LTX] Unrelated billing task | Task | Content is unrelated to Appointment Date or Order List. | EXCLUDED |

Selection is based on inspected fictitious content, not the `[LTX]` prefix alone.

## 4. Confluence Discovery

Fictitious searches include:

- LTX Appointment Date
- Latam Express Appointment Date
- LTX Order List
- LTX LM Order List
- LTX FFM Order List

| Page | Type | Inspection Result | Selection |
|---|---|---|---|
| LTX Order List Specification — EXAMPLE | Functional Specification | Fictitious page may document LM behavior; approval and effective status are Unknown. | UNVERIFIED |

The latest edit date would not establish production status.

## 5. Local Knowledge Fallback

Search:

- `knowledge/systems/LTX/BRD`
- `knowledge/systems/LTX/CR`
- `knowledge/systems/LTX/Decisions`
- `knowledge/systems/LTX/Specifications`

If no relevant local files exist, record that result without assuming the behavior is absent.

## 6. Source Selection and Handoff

Pass the accessible content of fictitious `LTX-TEST-001` as `SELECTED` to Current State Analyzer. Pass the Confluence page and `LTX-TEST-002` as `UNVERIFIED` discovery context until their authority or content is sufficient. Do not pass `LTX-TEST-003` as LTX Appointment Date evidence.

Current State Analyzer must independently determine whether selected content supports Documented Baseline, Pending Change, Released Change, Current Production State, or Unknown / Unverified Behavior.

No Appointment Date business logic is defined by this example.
