# BPMN Validation Report — Rescue Approval

System: Rescue Management System (RMS)
File reviewed: `outputs/bpmn/RMS/rescue-approval-to-be.bpmn`
Prepared: 2026-09-16

Overall result: **Pass with warnings**

## Source Files Reviewed

| Source | Type | Approval / Version |
|---|---|---|
| "RMS v2.1: User Guide - Rescue Job & Rescue Approval" (Confluence 1201635331) | Existing system documentation | Current, 2026-01-09 |
| TM-7403–TM-7409, TM-7396 | Jira Story, Done | Released |
| TM-7608 | Jira Bug, Done | Released |
| TM-7867 | Jira Task, Done | Implemented, production release unverified |

## Syntax Validation

Performed via `c8ctl bpmn lint`. Result: **0 errors, 3 warnings** (all three warnings are the same category: each User Task lacks a `zeebe:FormDefinition` — see Errors/Warnings below).

## Structural Validation

Namespaces, DI presence, ID/reference integrity, and sequence-flow source/target validity all confirmed by lint. The `bpmn:message` used by both Cancel boundary events required and now includes `zeebe:subscription correlationKey` (fixed during generation).

## Control-Flow Validation

- No unreachable nodes, no orphan elements, no dead ends.
- No uncontrolled loops (Resubmit was intentionally not diagrammed — see Open Questions in the process analysis).
- Both Exclusive Gateways (`Team Leader Approved?`, `QA Approved?`) have a `default` flow to Rejected and a condition only on the Approve branch, per the binary-decision default-flow rule.
- Both Cancel boundary events are interrupting (cancel the pending review task) and route to a dedicated Cancelled end event.

## BPMN Semantics Validation

- Task types: User Task (CS submit, Team Leader review, QA review) and Service Task (automatic Approval Rescue record creation) match the source's described actors and automation.
- Event types: None Start, message-correlated interrupting Boundary Events (Cancel), None End Events (Approved/Rejected/Cancelled) — all match source behavior; no Terminate End Event used since Cancel and Reject are ordinary distinct outcomes, not whole-instance termination signals.
- Gateway type: Exclusive, correctly used for the binary Approved/Rejected decisions.
- Pool/lane consistency: one pool ("RMS Rescue Approval"), three lanes (CS, Team Leader, QA), every flow node assigned to the lane matching its actual actor.
- No message flows used (single participant/pool; TMS/Accountant interaction is out of scope per the process analysis, not a second pool here).

## Visual-Layout Validation

No overlap on first lint pass; canonical `c8ctl bpmn format` round-trip produced zero diff — the file is already in canonical bpmn-js form.

## Requirement-Traceability Validation

| Diagram Element | Requirement Source | Match? | Notes |
|---|---|---|---|
| Submit Rescue Job for Approval | Confluence guide §3.1 Steps 1–5 | Yes | Validation logic (discount limit, attempt cap) described in source, embedded in the task rather than modeled as a separate gateway (no distinct actor/path for validation failure) |
| Create Approval Rescue Record | Confluence guide §3.1 Step 5 | Yes | Modeled as automatic Service Task |
| Team Leader Reviews / QA Reviews | Confluence guide §2, §3.2 | Yes | Own-team restriction (BR-01) and required reject comment (BR-05) are business rules, not separate diagram paths |
| Team Leader Approved? / QA Approved? gateways | Confluence guide §3.2 | Yes | Default = Reject, matches "reject at any stage = Final Rejected" |
| Cancel Requested boundary events | Confluence guide §3.4 | Yes | "Allowed only when status = Processing" |
| Approved / Rejected / Cancelled end events | Confluence guide §3.2, §3.4 | Yes | Three distinct terminal outcomes, matching the Approval Status Bar |
| Resubmit for Approval | Confluence guide §3.3 vs. TM-7867 | **Not diagrammed** | Conflicting/unreconciled eligibility condition — see Open Questions |

## Errors

None.

## Warnings

| Severity | Location | Finding | Rule |
|---|---|---|---|
| Medium | `Task_SubmitRescueJob` | Missing `zeebe:FormDefinition` | `zeebe:FormDefinition` (lint) |
| Medium | `Task_TeamLeaderReview` | Missing `zeebe:FormDefinition` | `zeebe:FormDefinition` (lint) |
| Medium | `Task_QAReview` | Missing `zeebe:FormDefinition` | `zeebe:FormDefinition` (lint) |

These were not fixed because building `.form` files was not requested and would require inventing field layouts not described in any source (see `camunda-forms` skill if this is wanted next).

## Open Business Questions

Carried from the process-analysis report:
1. Confirmed Resubmit-for-Approval eligibility condition (guide §3.3 vs. TM-7867).
2. Whether TMS integration (payment confirmation, SO/shipping sync) should be modeled as a message flow to a second pool.
3. Whether Notifications and SLA/timers are in scope for a future revision.

## Recommended Corrections

None required for technical validity. Optional: add `zeebe:FormDefinition` + corresponding `.form` files via `camunda-forms` if this diagram is intended to become executable.

## Status

```text
Generated:              Yes
Reviewed:               Yes (this report)
Technically validated:  Yes — 0 errors, 3 warnings (form-definition gap only)
Business-approved:      Not yet — pending stakeholder confirmation, especially on Open Questions 1–3
Deployed:               No — out of scope for this skill
```
