# Process Analysis — Rescue Approval

System: Rescue Management System (RMS)
Feature: Rescue Approval
Diagram type: To-Be (modeled directly from the current approved specification; no separate change request was supplied)
Prepared: 2026-09-16

## 1. Purpose and Objective

Purpose: Support CS in recovering at-risk orders (via Discount and/or Change to Bank Transfer) through a controlled, multi-level approval workflow before the change takes effect.
Business objective: Prevent unauthorized or excessive discounting/payment-method changes while giving CS a structured recovery path. *(Source: Confluence "RMS v2.1: User Guide - Rescue Job & Rescue Approval", §1 Overview)*

## 2. Scope

Scope start: CS selects Rescue Options and submits a Rescue Job for approval.
Scope end: Final approval outcome (Approved / Rejected / Cancelled) is reached.
Out of scope: Payment confirmation on TMS by the Accountant, and SO/shipping synchronization after approval — these occur on a related system (TMS) and are noted under Related/Impacted Systems, not modeled here. Resubmission is described but not diagrammed (see Open Questions).

## 3. Trigger and Preconditions

Trigger: CS opens a Rescue Job and sets CS Status = "Need to be updated" / CS Sub-status = "Request for approval". *(Source: Confluence guide, §3.1 Step 1–2)*
Precondition: The order's current Payment Method must not already be Bank Transfer (otherwise Discount and Change to Bank Transfer are both blocked). *(Source: Confluence guide, §3 Key Business Rules)*

## 4. Participants and Structure

Participants: CS (creator), Team Leader (first-level approver, own team only), QA (final approver). Accountant and Manager/Admin are named roles in the source but are not active participants in the approval sequence itself — Accountant confirms payment on TMS (a related system, after approval); Manager/Admin only view and report. *(Source: Confluence guide, §2 User Roles & Permissions)*
Pool: RMS Rescue Approval.
Lanes: CS, Team Leader, QA.
Systems involved: RMS (primary). TMS — related/impacted, receives synchronized results post-approval; not confirmed as part of this process's own control flow beyond the overview statement. *(Source: Confluence guide, §1 Overview)*

## 5. Main Flow

1. CS selects Rescue Options (Discount and/or Change to Bank Transfer), fills in amount/bank details/reason, chooses SO handling method (Create New SO vs. Update Existing SO), and saves & submits — system validates discount ≤ limit, no conflicting prior discount, and attempt limit.
2. System automatically creates the Approval Rescue record.
3. Team Leader performs first-level review (own team only).
4. If Team Leader approves, QA performs final review.
5. If QA approves, the request reaches a final Approved outcome.
*(Source: Confluence guide, §3.1–3.2)*

## 6. Alternative Flows

- **Resubmit for Approval (CS):** described in source §3.3 but not diagrammed — see Open Questions (conflicting eligibility condition).
- SO handling method (Create New SO vs. Update Existing SO) changes downstream Lead/SO Status behavior after approval, but does not change the approval sequence itself. *(Source: Confluence guide, §3.1 Step 4, Options A/B)*

## 7. Exception Flows

- **Cancel (CS):** allowed only while the request is in "Processing" (i.e., pending at either Team Leader or QA stage); not allowed once a final status (Approved/Rejected) is reached; the cancellation is logged in history. Modeled as an interrupting boundary event on both the Team Leader and QA review tasks. *(Source: Confluence guide, §3.4)*
- **Reject (Team Leader or QA):** ends the process as Final Rejected at whichever stage rejects; a comment is required on rejection (data-entry rule, not a separate path). *(Source: Confluence guide, §3.2 Approval Rules)*

## 8. Decision Points

| Gateway | Question | Branches | Default | Source |
|---|---|---|---|---|
| Gateway_TLApproved | Team Leader Approved? | Approve → QA Review; Reject → Rejected | Reject | Confluence guide §3.2 |
| Gateway_QAApproved | QA Approved? | Approve → Approved; Reject → Rejected | Reject | Confluence guide §3.2 |

## 9. Business Rules

| Rule | Description | Source |
|---|---|---|
| BR-01 | Team Leader can only approve requests created by CS in their own team. | Confluence guide §2 |
| BR-02 | CS cannot edit rescue data once submitted. | Confluence guide §2 |
| BR-03 | If the order's Payment Method is already Bank Transfer, Rescue Discount and Change to Bank Transfer are both blocked. | Confluence guide §3 |
| BR-04 | Cumulative Rescue Discount ≤ 10% of original order value (or the GEO-configured limit, e.g., 15% for ID4); at most twice per Lead. | Confluence guide §3; CR-RMS-Increase-Rescue-Discount-Limit-ID4.md |
| BR-05 | Rejection at any stage is final (Final Rejected) and requires a comment. | Confluence guide §3.2 |
| BR-06 | Cancel is allowed only while status = Processing; not allowed after a final status. | Confluence guide §3.4 |
| BR-07 | The current Team Leader ("first approver") approve/reject action is gated by a specific, independently toggleable permission. | TM-7608 (bug fix confirms this permission exists and is enforced) |

## 10. Inputs, Outputs, and Data Exchanged

| Data Element | Direction | Source / Target | Notes |
|---|---|---|---|
| Rescue Option (Discount / Bank Transfer / Both) | Input | CS → Approval Rescue record | Confluence guide §3.1 Step 3 |
| Discount amount, bank details, reason | Input | CS → Approval Rescue record | Confluence guide §3.1 Step 3 |
| SO handling method (Create New SO / Update Existing SO) | Input | CS → downstream SO/Lead status logic | Confluence guide §3.1 Step 4 |
| Approval decision + comment (on reject) | Input | Team Leader / QA → Approval Rescue record | Confluence guide §3.2 |

## 11. Statuses and Transitions

Approval Status Bar: Requested → Approved (1/2, 2/2) → Rejected / Cancelled. *(Source: Confluence guide §3.2)*

## 12. Notifications

Not defined in source beyond "Full audit trail & notifications" (§1 Overview) — no specific recipient, channel, or trigger is documented.

## 13. SLA and Timers

Not defined in source.

## 14. Integrations

Approved results are synchronized with TMS (Sales Orders); Accountant confirms payment for the Bank Transfer flow on TMS. Exact integration mechanism, timing, and failure handling are not defined in source. *(Source: Confluence guide §1 Overview)*

## 15. Final Outcomes

Approved, Rejected, Cancelled — three distinct terminal outcomes. *(Source: Confluence guide §3.2, §3.4)*

## 16. Sources Used

| Source | Type | Approval / Version | Scope |
|---|---|---|---|
| "RMS v2.1: User Guide - Rescue Job & Rescue Approval" (Confluence page 1201635331) | Existing system documentation | Current, last updated 2026-01-09, authored by the requesting user | Full Rescue Approval workflow |
| TM-7403, TM-7404, TM-7405, TM-7406, TM-7407, TM-7408, TM-7409, TM-7396 | Jira Story, Done | Released (implementation indicated; production release not independently verified) | Corroborate guide's core flow and data behavior |
| TM-7608 | Jira Bug, Done | Released | Confirms Team Leader approve/reject permission gating |
| TM-7867 | Jira Task, Done, 2026-04-14 | Implemented but unverified production; postdates the guide | Refines Resubmit blocking condition — see Open Questions |
| CR-RMS-Increase-Rescue-Discount-Limit-ID4.md | Approved CR ticket (local) | Ready | Corroborates discount-limit rule structure |

## 17. Assumptions

None presented as confirmed. The reconciliation of the Resubmit condition (guide vs. TM-7867) is recorded only as an Open Question, not as an assumption baked into the diagram.

## 18. Open Questions

1. What is the current, confirmed condition for blocking "Resubmit for Approval"? The guide (§3.3) and TM-7867 (2026-04-14, after the guide) describe what appear to be additive but never-reconciled conditions (approved with Create New SO vs. approved with Bank Transfer). This is not diagrammed until confirmed.
2. Is the integration with TMS (payment confirmation, SO/shipping sync) a synchronous step that should appear in this diagram as a message flow to a TMS pool, or is it fully out of scope for an RMS-only Rescue Approval diagram?
3. Are Notifications and SLA/timers in scope for a future revision of this diagram, or intentionally out of scope for this feature?

## Readiness

**READY** for the core Submit → Team Leader → QA → Approved/Rejected/Cancelled flow. Resubmit is **PARTIAL** (structurally acknowledged, not diagrammed pending Q1).
