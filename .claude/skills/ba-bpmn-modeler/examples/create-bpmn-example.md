# EXAMPLE ONLY — NOT REQUIREMENT EVIDENCE

## Scenario

Request:

> Convert the approved RMS Rescue Approval BRD into a To-Be BPMN diagram.

All BRD content, tickets, findings, and outcomes below are fictitious. They illustrate Mode 1 (Create) skill behavior and must not be used as evidence of actual RMS business logic. This example does not create a real `.bpmn` file.

## 1. Identify System and Feature

System: Rescue Management System → System Key `RMS` (`knowledge/standards/system-registry.md`).
Feature: Rescue Approval.
Diagram type: To-Be, requested explicitly.

## 2. Route to Source Discovery and Current-State Analysis

Because the To-Be depends on the existing approval flow (it changes, not replaces, current behavior), route:

`ba-source-discovery` → resolves `RMS`, searches Jira (`[RMS]` summary pattern, Story/CR/Task), Confluence, and `knowledge/systems/RMS/`. Fictitious result: `RMS-TEST-101` ("[RMS] Rescue Approval — add QA gate"), classified `SELECTED`; a fictitious Confluence page "RMS Rescue Approval — Current Flow" classified `SELECTED`.

`ba-current-state-analyzer` → independently validates both. Fictitious confirmed Current State: request is submitted by a CS Agent, approved or rejected by a Team Leader, no QA gate exists today. Readiness: **READY** (sufficient current-state evidence to define the delta).

## 3. Process Analysis

Using [../templates/process-analysis-template.md](../templates/process-analysis-template.md):

- Trigger: CS Agent submits a rescue request.
- Main flow: Submit → Team Leader review → (new) QA review → Approved / Rejected.
- Decision points: `Approved?` (Team Leader), `QA approved?` (QA).
- Exception paths per the fictitious BRD: a **Canceled** outcome is explicitly defined if the requester withdraws before Team Leader review completes.
- Business rule (fictitious, sourced from `RMS-TEST-101`): QA review is required only when the Team Leader approves; a Team Leader rejection ends the process without QA involvement.

## 4. Clarification

The fictitious BRD does not state whether a QA rejection returns the request to the Team Leader or ends the process. Per [../references/clarification-rules.md](../references/clarification-rules.md), this is material (it changes the outcome/exception handling) — ask:

> "When QA rejects, does the request end as Rejected, or does it return to the Team Leader for another decision?"

This example assumes the fictitious answer: **ends as Rejected** (no rework loop).

## 5. Delegate to camunda-skills:camunda-bpmn

Hand the grounded process analysis (participants, flow, gateways with conditions/defaults, outcomes) to `/camunda-skills:camunda-bpmn` to generate the BPMN 2.0 XML and DI layout: Start → Submit Request (User Task) → Team Leader Review (User Task) → `Approved?` (Exclusive Gateway, default → Rejected) → QA Review (User Task) → `QA approved?` (Exclusive Gateway, default → Rejected) → End Events: Approved, Rejected, Canceled (from an intermediate cancel path off the submit/review stage).

## 6. Validation

`/camunda-skills:camunda-bpmn` runs `c8ctl bpmn lint`. Fictitious result: 0 errors, 0 warnings after adding a `default` flow on both gateways and labeling the Canceled end event.

## 7. Output and Reporting

Would be saved to:

```text
outputs/bpmn/RMS/rescue-approval-to-be.bpmn
outputs/bpmn/RMS/rescue-approval-process-analysis.md
outputs/bpmn/RMS/rescue-approval-validation-report.md
```

Summary reported to the user includes: system/feature, diagram type, files created, sources used (with `SELECTED` classification noted), the QA-rejection clarification and its answer recorded as a confirmed decision (not an assumption), validation result, and impacted-artifact note: "The approved RMS Rescue Approval BRD's Section 6 (Expected Behavior) already describes this flow — no BRD update needed unless this BPMN surfaces a gap." No BRD was modified.
