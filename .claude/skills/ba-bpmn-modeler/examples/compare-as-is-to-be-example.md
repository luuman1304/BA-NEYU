# EXAMPLE ONLY — NOT REQUIREMENT EVIDENCE

## Scenario

Request:

> Compare the current LTX Order Exception process with the proposed process from the new CR ticket.

All ticket content, findings, and process detail below are fictitious. They illustrate Mode 4 (Compare) skill behavior.

## 1. Identify the Current Process (As-Is)

Route through `ba-source-discovery` → `ba-current-state-analyzer` for LTX Order Exception handling. Fictitious confirmed Current State: an exception is flagged manually by a CS Agent; a Supervisor reviews and either resolves it or escalates to Ops, with no SLA timer.

## 2. Identify the Proposed Process (To-Be)

From the fictitious CR ticket `LTX-TEST-315`: exceptions are auto-flagged by a system rule; a Supervisor has a 4-hour SLA timer before automatic escalation to Ops; Ops resolution is logged for audit.

## 3. Build Separate Diagrams

Per [../references/process-analysis-rules.md](../references/process-analysis-rules.md), these are modeled and saved as two distinct files — not combined:

```text
outputs/bpmn/LTX/order-exception-as-is.bpmn
outputs/bpmn/LTX/order-exception-to-be.bpmn
```

Each is generated via `/camunda-skills:camunda-bpmn` and independently validated.

## 4. Process Differences

| Element | As-Is | To-Be | Change |
|---|---|---|---|
| Exception flagging | Manual (CS Agent) | Automatic (system rule) | Changed |
| SLA timer | None | 4-hour Supervisor timer | Added |
| Escalation trigger | Supervisor discretion | Automatic on SLA breach | Changed |
| Audit logging | Not confirmed in source | Explicit Ops resolution log | Added |

## 5. Impact Analysis

Using [../templates/impact-analysis-template.md](../templates/impact-analysis-template.md), fictitious classifications:

| Area | Classification | Rationale |
|---|---|---|
| Actors and responsibilities | Impacted | CS Agent no longer manually flags; Supervisor now works against a timer. |
| SLA and timers | Impacted | New 4-hour timer per `LTX-TEST-315`. |
| Audit logs | Impacted | New Ops resolution log requirement. |
| Integrations | Potentially impacted | Auto-flagging implies a new system rule/trigger source not fully specified in the CR — raised as an Open Question. |
| Existing CR tickets | Impacted | `LTX-TEST-315` is the source. |
| Test cases (`outputs/test-cases/`) | Potentially impacted | New timer-based escalation path likely needs new test cases — reported, not authored. |

## 6. Migration Considerations

Recorded as Recommendations/Open Questions, not confirmed requirements: whether in-flight exceptions at cutover follow As-Is or To-Be rules is not defined in source — raised as an Open Question rather than assumed.

## 7. Output and Reporting

Both diagrams, a shared impact-analysis report (`outputs/bpmn/LTX/order-exception-impact-analysis.md`), and the difference table above are returned to the user. No BRD or CR ticket was modified; the impact on `LTX-TEST-315`'s own linked BRD (if any) is reported for the user to route to `ba-brd-writer-updater` explicitly.
