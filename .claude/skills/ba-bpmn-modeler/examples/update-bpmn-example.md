# EXAMPLE ONLY — NOT REQUIREMENT EVIDENCE

## Scenario

Request:

> Update `outputs/bpmn/TMS/callback-reminder-to-be.bpmn` — an approved CR ticket now says high-priority callbacks must skip the standard queue wait.

All ticket content, IDs, and findings below are fictitious. They illustrate Mode 2 (Update) skill behavior.

## 1. Read the Existing BPMN Completely

Fictitious existing flow: `Start_CallbackDue` → `Task_QueueCallback` (Service Task) → `Task_AgentCallsCustomer` (User Task) → `Gateway_Reached?` (Exclusive, default → `End_Rescheduled`) → `End_Completed` / `End_Rescheduled`. IDs noted for preservation: `Task_QueueCallback`, `Task_AgentCallsCustomer`, `Gateway_Reached`.

## 2. Read the Approved Change Source

Fictitious approved CR ticket `TMS-TEST-207`: "High-priority callbacks (`priority = HIGH`) must route directly to an agent, bypassing the standard queue wait."

## 3. Identify Affected and Unaffected Areas

Affected: the segment between `Start_CallbackDue` and `Task_AgentCallsCustomer` (a new gateway is needed to branch high-priority callbacks around `Task_QueueCallback`). Unaffected: the reach/reschedule/completed logic downstream — left untouched.

## 4. Impact Analysis

Using [../templates/impact-analysis-template.md](../templates/impact-analysis-template.md), fictitious classifications:

| Area | Classification | Rationale |
|---|---|---|
| Business rules | Impacted | New priority-based routing rule per `TMS-TEST-207`. |
| SLA and timers | Potentially impacted | Bypassing the queue may change the queue-wait SLA metric; not confirmed in the CR — raised as an Open Question. |
| Reports and dashboards | Unknown | No source confirms whether the queue-wait dashboard needs a new "bypassed" category. |
| Existing CR tickets | Impacted | `TMS-TEST-207` is the change source. |
| Test cases (`outputs/test-cases/`) | Potentially impacted | Existing queue-wait test cases may need a new high-priority path — reported, not modified. |

## 5. Present for Confirmation

Adding a new gateway and branch is additive, not destructive (no task/lane/outcome is removed), so per [../SKILL.md](../SKILL.md) Change-Control Rules this does not require destructive-change confirmation — but the SLA/dashboard gap is raised as an Open Question before finalizing.

## 6. Preserve IDs and Make a Targeted Change

Insert `Gateway_PriorityCheck` (Exclusive, default → `Task_QueueCallback`) between `Start_CallbackDue` and the existing segment; high-priority branch flows directly into `Task_AgentCallsCustomer`. All three previously noted IDs are preserved unchanged; only new elements get new IDs.

## 7. Delegate to camunda-skills:camunda-bpmn

Hand the targeted change to `/camunda-skills:camunda-bpmn` for an Edit-based (not full-regeneration) update: add the gateway, its two flows, and DI entries only for the new/moved elements — existing layout elsewhere is left untouched per that skill's incremental-layout rule.

## 8. Revalidate

Fictitious `c8ctl bpmn lint` result: 0 errors, 1 warning (missing label on the new gateway's high-priority branch) — fixed by naming the flow "High priority," then 0 errors, 0 warnings.

## 9. Change Log

Recorded in `outputs/bpmn/TMS/callback-reminder-change-log.md` using [../templates/bpmn-change-log-template.md](../templates/bpmn-change-log-template.md):

| Date | Requested Change | Source | Elements Added | Elements Removed | Preserved IDs | Validation Result | Open Questions |
|---|---|---|---|---|---|---|---|
| [fictitious date] | Bypass queue for high-priority callbacks | TMS-TEST-207 | `Gateway_PriorityCheck` + 2 flows | None | `Task_QueueCallback`, `Task_AgentCallsCustomer`, `Gateway_Reached` | 0 errors / 0 warnings | Does bypass affect queue-wait SLA reporting? |

No CR ticket or test case was modified — impact was reported only.
