# EXAMPLE ONLY — NOT REQUIREMENT EVIDENCE

## Scenario

Request:

> Review the WFM Screen Recording BPMN — don't change anything, just tell me what's wrong.

All findings below are fictitious. They illustrate Mode 3 (Review) skill behavior, which never modifies the source file.

## 1. Read the BPMN

Fictitious file: `outputs/bpmn/WFM/screen-recording-as-is.bpmn`. Flow: `Start_AgentLogin` → `Task_StartRecording` (Service Task) → `Task_AgentHandlesCall` (User Task) → `Task_StopRecording` (Service Task) → `End_RecordingSaved`.

## 2. Read Relevant Requirement Sources

Fictitious approved specification "WFM Screen Recording — Functional Spec v2" states recording must pause (not stop) during a fictitious "Hold" sub-state, and must have a documented failure path when storage write fails.

## 3. Validate Against the Checklist

Using [../references/review-checklist.md](../references/review-checklist.md):

| Severity | Finding | Rule |
|---|---|---|
| **High** | No pause/resume handling for the "Hold" sub-state described in the spec — the diagram only models continuous recording. | Flow coverage — alternative flows |
| **High** | No failure path if `Task_StopRecording` fails to persist the file; the diagram assumes it always succeeds. | Flow coverage — exception flows |
| **Medium** | `Task_StartRecording` and `Task_StopRecording` are typed as Service Tasks with no `zeebe:taskDefinition` equivalent noted as out of scope for this As-Is diagram — flagged for consistency, not treated as an execution defect since this diagram is not marked executable. | BPMN semantics |
| **Low** | Gateway-free happy path is fine structurally, but the End Event is unnamed. | Traceability / labeling |
| **Suggestion** | Consider a collapsed sub-process for the recording lifecycle if the Hold/failure paths are added, to avoid crowding the main flow. | Layout |

## 4. Technical Validation

`/camunda-skills:camunda-bpmn` `c8ctl bpmn lint` (fictitious result): 0 errors, 1 warning (`label-required` on the End Event) — reported, not fixed, because this is Review mode.

## 5. Validation Report

Saved to `outputs/bpmn/WFM/screen-recording-validation-report.md` using [../templates/validation-report-template.md](../templates/validation-report-template.md), with **Overall result: Pass with warnings** — two High business-logic gaps against the fictitious spec, one Medium, one Low, one Suggestion; 0 technical errors.

## 6. No File Change

The `.bpmn` file itself is untouched. The report recommends: correct the End Event label (safe, non-business change) and raise the Hold/failure-path gaps with the stakeholder before any correction is applied — pointing the user to Mode 6 (Correct) if they want that done next.
