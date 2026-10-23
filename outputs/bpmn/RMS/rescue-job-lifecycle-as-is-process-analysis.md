# Process Analysis — Rescue Job Lifecycle

System: Rescue Management System (RMS)
Feature: Rescue Job Lifecycle (creation → distribution → processing → approval → closure)
Diagram type: As-Is
Prepared: 2026-09-21

## 1. Purpose and Objective

Purpose: Document how RMS currently creates, assigns, processes, approves, and closes a Rescue Job for a failing/at-risk Delivery Order (DO), so Customer Service (CS) can recover the order and improve Delivery Rate.
Business objective: Recover rejected/at-risk orders (via discount or payment-method change) while keeping approval control and audit traceability.

## 2. Scope

Scope start: A Delivery Order becomes eligible for rescue (SLA breach or Delivery Failed).
Scope end: The Rescue Job reaches a terminal state — Rescue Success, Sales Can't Rescue, or Final Rejected.
Out of scope (per source BRD 1340801026): Approval Notification Flow (no notification task is modeled — not defined in source), Pre-Delivery Workflow, exact SLA duration values, exact GEO-by-GEO SLA matrix.

## 3. Trigger and Preconditions

Trigger: A scheduled system job evaluates each Delivery Order and creates a Rescue Job when the **first** of the following becomes true:
- Packed Time + configured SLA reached, OR
- Ready to Pick Time + configured SLA reached (Colombia only), OR
- DO Status = Delivery Failed

Preconditions:
- No Rescue Job already linked to the DO (duplicate prevention).
- DO status is not Delivered, Returned, or Canceled.
- Distribution mode (Manual/Auto) has been configured by System Admin.

## 4. Participants and Structure

Participants: System/Scheduler, System Admin, CS Agent, Team Leader, QA, Accountant (TMS — external system).
Pools:
- **RMS** (own process) — lanes: System/Scheduler, System Admin, CS Agent, Team Leader, QA.
- **TMS** (collaborating pool, cross-system) — lane: Accountant. Connected to RMS only via message flow (per Source 3: "flag this handoff to TMS as a cross-system boundary, not to be modeled in RMS-owned lanes").
Lanes: System/Scheduler, System Admin, CS Agent, Team Leader, QA (in RMS pool); Accountant (in TMS pool).
Systems involved: RMS (primary), TMS (payment confirmation for Bank Transfer rescues only).

## 5. Main Flow

1. System/Scheduler detects SLA breach or Delivery Failed on a DO and auto-creates a Rescue Job (guarded by duplicate-prevention and DO-status preconditions); system logs a history message stating which condition triggered creation.
2. System Admin's configured Distribution Mode determines assignment: **Auto** → System assigns exactly one job at a time to a CS Agent when that agent opens "My Rescue" (priority-ranked); **Manual** → Team Leader/Manager manually assigns (and may override Auto).
3. CS Agent opens the assigned Rescue Job and updates CS Status/Sub-status based on customer contact outcome.
4. If the case needs a Rescue option (Discount and/or Change to Bank Transfer): CS Agent sets Sub-status = "Request for approval", selects the option(s), fills discount/bank details, and chooses SO handling (Create New SO vs. Update Existing SO), then saves & submits.
5. System validates business rules (discount ≤10% cumulative, max 2 discounts/Lead, Bank-Transfer SO blocks both options) before accepting submission.
6. On valid submission, system auto-creates an "Approval Rescue" request → Team Leader (first-level, own team only) reviews → if approved, QA (final level) reviews.
7. On final QA approval: if the rescue involves Bank Transfer, RMS sends a message to TMS; Accountant confirms payment in TMS before the Rescue Job is treated as resolved on the RMS side. Otherwise, system creates/updates the SO per the chosen option (A/B) directly.
8. Independently of the approval sub-flow, the DO's own delivery outcome drives auto-closure: DO Delivered → Rescue Job auto-closes as "Rescue Success"; DO Returned/Canceled → auto-closes as "Sales Can't Rescue".

## 6. Alternative Flows

- **Manual distribution override**: Team Leader/Manager assigns a job directly regardless of Auto ranking.
- **Resubmit for Approval**: CS Agent may resubmit only if no approval is currently "Processing" and no prior approval was already granted with Create-New-SO.
- **Cancel Approval**: CS Agent may cancel only while the approval is in "Processing" status.
- **Follow-up loop**: Sub-statuses Uncontactable, Unreachable, Need More Convincing, Wrong Status/Resend to 3PL route the job back to the **same** CS Agent for a later follow-up attempt (time/priority-ranked per the distribution rule), rather than ending the case.

## 7. Exception Flows

- **Customer Refused**: terminal sub-status; source states this closes as "Sales can't rescue" regardless of the DO's later delivery outcome.
- **Rejected at any approval stage** (Team Leader or QA): terminal "Final Rejected"; source requires a comment on rejection.
- **Blocked Rescue options**: if the SO already has Payment Method = Bank Transfer, the system blocks both the Discount and Change-to-Bank-Transfer options at submission time (validation failure, case remains with CS Agent).

## 8. Decision Points

| Gateway | Question | Branches | Default | Source |
|---|---|---|---|---|
| G1 | Which rescue-eligibility condition fired first? | SLA breach (Packed/Ready-to-Pick) / Delivery Failed | N/A (system evaluates, not a user default) | Confluence 1340801026, BR-04 |
| G2 | Distribution mode? | Auto / Manual | Not defined in source (depends on System Admin configuration; no stated default) | Confluence 1299283969, §III |
| G3 | CS contact outcome (sub-status)? | Uncontactable / Unreachable / Need More Convincing / Customer Refused / Wrong Status–Resend to 3PL / Request for Approval | Not defined in source | Confluence 1299283969, §IV–V |
| G4 | Rescue option validation passes? | Valid → Approval Rescue created / Invalid → blocked, case stays with CS | N/A | Confluence 1201635331, §3.1 Step 5 |
| G5 | Team Leader decision | Approve → to QA / Reject → Final Rejected | N/A | Confluence 1201635331, §3.2 |
| G6 | QA decision | Approve → SO creation/update (+ Accountant confirmation if Bank Transfer) / Reject → Final Rejected | N/A | Confluence 1201635331, §3.2 |
| G7 | DO final delivery outcome | Delivered → Rescue Success / Returned or Canceled → Sales Can't Rescue | N/A | Confluence 1299283969, §V |

## 9. Business Rules

| Rule | Description | Source |
|---|---|---|
| BR-Dup | Only one Rescue Job may exist per Delivery Order. | Confluence 1340801026, BR-04 |
| BR-DiscountCap | Cumulative Rescue Discount ≤ 10% of original order value; max 2 Rescue Discounts per Lead; no 3rd discount or resubmission after 2 approved discounts. | Confluence 1201635331, §3 Key Business Rules |
| BR-BankTransferBlock | If the SO already has Payment Method = Bank Transfer, Discount and Change-to-Bank-Transfer options are both blocked. | Confluence 1201635331, §3 Key Business Rules |
| BR-TLScope | A Team Leader may only approve requests created by CS in their own team. | Confluence 1201635331, §2 |
| BR-NoEdit | Once submitted, CS cannot edit rescue data. | Confluence 1201635331, §2 |
| BR-Resubmit | Resubmission allowed only if no approval is Processing and none was already approved with Create-New-SO. | Confluence 1201635331, §3.3 |
| BR-Cancel | Cancel allowed only while approval status = Processing. | Confluence 1201635331, §3.4 |
| BR-AutoClose | DO Delivered → Rescue Success; DO Returned/Canceled → Sales Can't Rescue; Customer Refused → Sales Can't Rescue regardless of later DO outcome. | Confluence 1299283969, §V |

## 10. Inputs, Outputs, and Data Exchanged

| Data Element | Direction | Source / Target | Notes |
|---|---|---|---|
| Delivery Order status/timestamps | In | Logistics/DO system → RMS | Drives auto-creation and auto-closure |
| Rescue Job (case) | Created/updated | RMS internal | Core case record |
| Approval Rescue request | Created | RMS internal | One per submitted rescue option |
| Payment confirmation | Out/In (message) | RMS → TMS (Accountant) → RMS | Only for Bank Transfer rescues |
| Sales Order (SO) | Created/Updated | RMS → TMS/Order system | Per Option A (new) or B (update) |

## 11. Statuses and Transitions

Job Status: New → Urgent / Follow Up → Need to be updated → (sub-statuses) → Closed.
CS Sub-status set (from source): Uncontactable, Unreachable, Need More Convincing, Customer Refused, Wrong Status, Request for approval, Resend to 3PLs.
Approval status: Requested → Approved (1/2) → Approved (2/2) | Rejected | Cancelled.
Closed reasons: Rescue Success, Sales Can't Rescue, Final Rejected, Replace (system).

## 12. Notifications

Not defined in source for this flow — the source BRD (1340801026) explicitly lists "Approval Notification Flow" as **Out of Scope**. No notification task is included in the diagram.

## 13. SLA and Timers

SLA trigger conditions are named (Packed Time + SLA, Ready to Pick Time + SLA, Delivery Failed) but exact SLA durations, the Working-Calendar exclusion mechanics, and Cut-Off-Time values are configuration data, not fixed values — modeled as a labeled gateway/condition only, not a fabricated duration.

## 14. Integrations

RMS ↔ TMS: Accountant payment confirmation for Bank Transfer rescues (message flow, cross-system, per Source 3 explicit instruction not to model Accountant inside an RMS lane).
RMS ↔ Delivery/Logistics data: DO status and timestamps feed the trigger and auto-close logic (source only states the data dependency, not the integration mechanism — not modeled as a separate system pool since no source names a distinct "Logistics System").

## 15. Final Outcomes

- **Rescue Success** (Closed) — DO ultimately Delivered.
- **Sales Can't Rescue** (Closed) — DO ultimately Returned/Canceled, or Customer Refused.
- **Final Rejected** (Closed) — rejected at Team Leader or QA approval stage.
- **Replace** (Closed, system) — named in source table but its trigger condition is not defined in source; included as a labeled terminal state only, not elaborated.

## 16. Sources Used

| Source | Type | Approval / Version | Scope |
|---|---|---|---|
| Confluence 1340801026 — "[BRD] SMG & RMS v2.1 Working Calendar and Auto Rescue Job by SLA" | BRD | v15 (current) | Auto-creation trigger (BR-04, US4/US5) |
| Confluence 1299283969 — "RMS v2.1: User Guide - Rescue Distribution Rule" | User Guide | v2 (current) | Distribution/assignment, sub-status branches, auto-close mapping |
| Confluence 1201635331 — "RMS v2.1: User Guide - Rescue Job & Rescue Approval" | User Guide | v1 (current) | CS processing, rescue options, approval workflow |

## 17. Assumptions

- A1: "System/Scheduler" is modeled as a single lane representing the automated SLA-check job; the source does not name a distinct scheduler/batch-job system, so no separate pool was created for it.
- A2: The Working Calendar/SLA-configuration steps (BR-01/BR-02/BR-03 — System Admin configuring calendars in SMG) are treated as prior configuration, not drawn as per-instance steps inside this case-level diagram, since they configure the SLA value used by the trigger rather than participate in a single Rescue Job's runtime flow.

## 18. Open Questions

- OQ-1: The Source 2 "Auto update logic – final CS status" table (§V) is only partially resolvable from the retrieved content — several rows appear to have shifted/merged columns (a likely Confluence-table-to-markdown conversion artifact), so the fine-grained per-sub-status × DO-outcome closure mapping could not be fully verified for every reason code. The diagram uses the clearly-stated general rule (Delivered → Rescue Success; Returned/Canceled → Sales Can't Rescue) plus the explicit Customer-Refused override; the remaining row-level detail is **not fully defined in source** as retrieved and should be re-verified directly against the live Confluence table if per-reason-code precision is required.
- OQ-2: The exact trigger/definition of the "Replace (System)" closed state is not defined in the retrieved sources.
- OQ-3: Distribution Mode's default value (Manual or Auto) when first configured is not defined in source.
- OQ-4: Whether "Resend to 3PLs" is initiated by CS or auto-triggered by system is not fully specified; modeled as a CS Agent sub-status update per Source 2's classification-tab framing.
