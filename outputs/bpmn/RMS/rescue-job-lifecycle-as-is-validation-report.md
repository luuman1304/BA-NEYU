# BPMN Validation Report — Rescue Job Lifecycle

System: Rescue Management System (RMS)
File reviewed: `outputs/bpmn/RMS/rescue-job-lifecycle-as-is.bpmn`
Prepared: 2026-09-21

Overall result: **Pass with warnings** (technical lint could not be executed in this environment — see Syntax Validation)

## Source Files Reviewed

| Source | Type | Approval / Version |
|---|---|---|
| Confluence 1340801026 — "[BRD] SMG & RMS v2.1 Working Calendar and Auto Rescue Job by SLA" | BRD | v15 (current) |
| Confluence 1299283969 — "RMS v2.1: User Guide - Rescue Distribution Rule" | User Guide | v2 (current) |
| Confluence 1201635331 — "RMS v2.1: User Guide - Rescue Job & Rescue Approval" | User Guide | v1 (current) |

## Syntax Validation

**Not performed via `c8ctl bpmn lint`** — `c8ctl` is not installed in this environment (`c8ctl: command not found`). This is disclosed honestly rather than claiming lint passed.

In its place, the following manual structural checks were run against the file:
- XML well-formedness (parsed successfully with .NET XmlDocument).
- No duplicate element IDs (190 IDs checked).
- Every `sequenceFlow`/`messageFlow` `sourceRef`/`targetRef` resolves to an existing element.
- Every flow-node element has the required `incoming`/`outgoing` cardinality (start events: outgoing only; end events: incoming only; all other nodes: both).
- Every model element has a corresponding `BPMNShape`/`BPMNEdge`, and vice versa (no dangling DI, no missing DI).
- No bounding-box overlap among the 37 flow-node shapes (pairwise geometry check).

One real gap was found and fixed during this check: `Task_ConfigMode` (System Admin) initially had no incoming flow. Fixed by adding a dedicated `StartEvent_AdminConfig` ("Admin sets/changes Distribution Mode") feeding into it, since System Admin's mode configuration is an independent trigger, not part of the per-case Rescue Job flow.

**Recommendation:** run `c8ctl bpmn lint outputs/bpmn/RMS/rescue-job-lifecycle-as-is.bpmn` (or open the file in Camunda Modeler) once `c8ctl` is available, to get the authoritative lint result (bpmnlint rule coverage such as `no-implicit-split`, `conditional-flows`, `label-required` goes beyond what the manual checks above can verify).

## Structural Validation

Namespaces (`bpmn`, `bpmndi`, `dc`, `di`) present and correctly declared. `isExecutable="false"` on both processes (pure BA/documentation diagram, no Zeebe extensions — correct per this task's scope). DI block present and complete (see Syntax Validation above for the reference-integrity checks performed).

## Control-Flow Validation

- Every path starts from a start event (4 total: 3 SLA/Delivery-Failed triggers + 1 Admin-config trigger in RMS; 1 message start in TMS) and reaches an end event (7 total: Rescue Success, Sales Can't Rescue, Sales Can't Rescue (Refused), Cancelled, Final Rejected, Approved/Resolved, plus TMS's own message end).
- No orphan elements (verified programmatically).
- Deliberate loops (business-sourced, not modeling errors): G3 → Task_OpenUpdate (Uncontactable/Unreachable/Need More Convincing/Wrong Status follow-up), G4 → Task_SelectOption (validation rework), Task_ResubmitApproval → Task_SelectOption (resubmission).
- `Gateway_ForkMain` (parallel split) has no matching join by design: its two branches (case-processing vs. DO-outcome monitoring) terminate independently in separate end events, per the source's description of these as concurrent, independent concerns for the same Rescue Job.
- `EndEvent_FinalRejected` and `Task_CreateUpdateSO` each intentionally have 2 incoming flows (converging alternative paths) — valid BPMN, not a defect.

## BPMN Semantics Validation

- Message events (`Event_ThrowRequestPayment` / `Event_MsgStartPaymentRequest` / `Event_MsgEndPaymentConfirmed` / `Event_CatchPaymentConfirmed`) used correctly for the cross-pool RMS↔TMS handoff, per the source's explicit instruction to model the Accountant/TMS step as a cross-system boundary rather than an RMS-owned lane.
- Two pools (RMS, TMS) connected only by message flows; all RMS-internal routing uses sequence flows across lanes within the single RMS pool — correct pool/lane usage.
- Exclusive gateways each have a `default` attribute set (no FEEL `conditionExpression`s were added, consistent with this being a non-executable descriptive diagram, not a Zeebe-runnable one).
- One parallel gateway (`Gateway_ForkMain`), used for the two independent concerns described above.

## Visual-Layout Validation

No shape overlaps (verified programmatically, see Syntax Validation). The diagram is wide (~4.3k px) given the number of actors and branches; left-to-right reading order is preserved for the main path, with necessary loop-back and cross-lane edges bending as needed. Layout aesthetics were not verified in a rendering tool (Camunda Modeler was not run) — recommend opening the file visually to confirm edge routing readability before presenting to stakeholders.

## Requirement-Traceability Validation

| Diagram Element | Requirement Source | Match? | Notes |
|---|---|---|---|
| 3 SLA/Delivery-Failed start events, Task_GuardCheck, Task_AutoCreate | BRD 1340801026, BR-04/US4/US5 | Yes | |
| Gateway_ForkMain, Task_ConfigMode, Gateway_G2, Task_AutoAssign, Task_ManualAssign | User Guide 1299283969, §III | Yes | Default distribution mode not stated in source — modeled as no-default gateway note |
| Task_OpenUpdate, Gateway_G3 branches, EndEvent_Refused | User Guide 1299283969, §IV–V | Partial | Fine-grained per-sub-status × DO-outcome closure table (§V) had conversion/formatting issues in the retrieved content — see process-analysis sidecar OQ-1 |
| Task_SelectOption, Gateway_G4, business rules | User Guide 1201635331, §3 & §3.1 | Yes | |
| Gateway_ApprovalAction, Task_CancelApproval, Task_ResubmitApproval | User Guide 1201635331, §3.3–3.4 | Yes | |
| Task_TLReview, Gateway_G5, Task_QAReview, Gateway_G6, EndEvent_FinalRejected | User Guide 1201635331, §3.2 | Yes | |
| Gateway_G6b, message events, Task_ConfirmPayment (TMS) | User Guide 1201635331, §3.1 Bank-Transfer-blocked note + cross-system instruction | Yes | Exact confirmation-workflow steps inside TMS not defined in source — Task_ConfirmPayment left as a single labeled step |
| Gateway_G7, EndEvent_RescueSuccess, EndEvent_SalesCantRescue | User Guide 1299283969, §V (general rule only) | Partial | Same §V formatting caveat as above |

## Errors

| Severity | Location | Finding | Rule |
|---|---|---|---|
| (none found) | | | |

## Warnings

| Severity | Location | Finding | Rule |
|---|---|---|---|
| Medium | Whole file | Automated `c8ctl bpmn lint` could not be run (tool not installed) — only manual structural checks were performed | Tooling availability |
| Low | Gateway_G3 / Gateway_G7 | Underlying source table (§V of 1299283969) has ambiguous formatting; general closure rule used, per-reason-code detail not fully verifiable | Source grounding (see process-analysis OQ-1) |

## Open Business Questions

Carried from the process-analysis sidecar (`rescue-job-lifecycle-as-is-process-analysis.md`):
- OQ-1: per-sub-status × DO-outcome closure mapping not fully resolvable from retrieved source formatting.
- OQ-2: trigger/definition of the "Replace (System)" closed state not defined in source (not included in this diagram).
- OQ-3: default Distribution Mode value not defined in source.
- OQ-4: whether "Resend to 3PLs" is CS-initiated or system-auto-triggered not fully specified.

## Recommended Corrections

- Run `c8ctl bpmn lint` once available, and fix any reported issues (particularly check `conditional-flows`/gateway-default-safety rules given no FEEL conditions were authored).
- Re-verify the §V closure table directly in Confluence (rendered view, not markdown export) to confirm/refine per-reason-code closure mapping if that level of detail becomes necessary for a future executable version.
- Confirm with the RMS product owner whether Distribution Mode has a stated default, and whether "Resend to 3PLs" is agent- or system-initiated.

## Status

```text
Generated:              Yes
Reviewed:               Yes (manual structural self-review only)
Technically validated:  No — c8ctl unavailable in this environment; manual checks only (see Syntax Validation)
Business-approved:      Not yet — pending stakeholder confirmation
Deployed:               No — out of scope for this skill
```
