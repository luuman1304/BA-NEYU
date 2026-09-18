---
name: ba-bpmn-modeler
description: Create, update, review, explain, compare, and validate BPMN 2.0 process diagrams from BRDs, CR tickets, user stories, or process descriptions. Use for As-Is/To-Be modeling, BPMN review/validation, process- and change-impact analysis, and BPMN explanation. Delegates BPMN XML generation, DI layout, and technical validation to camunda-skills:camunda-bpmn. Do not use for BRD-only, CR-ticket-only, test-case-only, or diagram-less discovery/current-state requests.
---

# BA BPMN Modeler

## Purpose

Manage the Business Analyst side of BPMN 2.0 process modeling: understand the request, resolve As-Is vs. To-Be, ground the diagram in approved sources, analyze process and change impact, ask focused clarification, and produce process-analysis, impact-analysis, and validation reports. This skill does not hand-write BPMN XML or diagram-interchange coordinates — it delegates BPMN technical generation, layout, and technical validation to `/camunda-skills:camunda-bpmn` and consumes its result.

## Trigger

Use this skill when the user asks to:

- Create a BPMN diagram, draw a business process, or model a workflow.
- Convert a BRD, CR ticket, user story, or process description into BPMN.
- Create an As-Is process or a To-Be process.
- Compare As-Is and To-Be.
- Update, review, validate, explain, or correct an existing BPMN.
- Detect missing process paths or analyze process/change impact tied to a diagram.

Do not trigger for a request that only wants a BRD, a CR ticket, test cases, or source discovery / current-state analysis with no diagram involved — hand those to their own skill instead. This skill may report that one of those artifacts is impacted; it must not replace or auto-modify it.

## Relationship to Other Skills

This skill orchestrates; it does not duplicate. It never re-implements Jira/Confluence search, BRD writing, or CR ticket writing, and it never hand-authors BPMN XML.

| Skill | When this skill hands off to it | What this skill must not do instead |
|---|---|---|
| `ba-source-discovery` | The authoritative source is not explicitly identified, or multiple candidate sources may exist. | Run its own Jira/Confluence search. |
| `ba-current-state-analyzer` | An As-Is diagram is requested, or a To-Be/update depends on existing process behavior. | Infer Current State by reversing the requested To-Be. |
| `ba-brd-writer-updater` | The user explicitly asks to create or update a BRD. | Auto-modify a BRD because a BPMN changed — report impact only ([references/impact-analysis-rules.md](references/impact-analysis-rules.md)). |
| `ba-cr-ticket-writer` | The user explicitly asks to create or update a CR ticket. | Auto-modify a CR ticket because a BPMN changed — report impact only. |
| `camunda-skills:camunda-bpmn` | Any time a `.bpmn` file is created, technically edited, laid out, or technically validated. | Hand-write BPMN XML, DI coordinates, or run a lint loop independently of that skill. |

Recommended orchestration flow:

```text
ba-source-discovery
      |
ba-current-state-analyzer   (when required: As-Is, or a To-Be/update depending on existing behavior)
      |
ba-bpmn-modeler process analysis   (this skill)
      |
user clarification   (when materially required)
      |
camunda-skills:camunda-bpmn   (BPMN generation, DI layout, technical validation)
      |
output and impact report
```

Do not invoke a skill the request does not need — e.g., skip `ba-current-state-analyzer` for an isolated new To-Be process with no dependency on existing behavior, and skip `ba-source-discovery` when the user has explicitly supplied the only relevant source.

## Inputs

Identify, when available:

- The request text, and any attached BRD, CR ticket, user story, or process description.
- The explicit `Primary System` or `System`, to be resolved to a System Key via `knowledge/standards/system-registry.md`.
- Diagram type requested: As-Is, To-Be, both, or unspecified.
- An existing `.bpmn` file to update, review, explain, or correct, and its path.
- Approved BRDs, CR tickets, Jira tickets, Confluence pages, meeting minutes, stakeholder emails, and existing system documentation.
- Relevant `knowledge/domain/`, `knowledge/glossary/`, `knowledge/standards/`, `knowledge/systems/{SYSTEM_KEY}/`, and `knowledge/templates/` content.
- Any explicit output path (takes precedence over the default routing convention in [references/naming-and-routing.md](references/naming-and-routing.md)).

Missing input is a gap to raise, not permission to infer.

## System Resolution

Apply the project's System Resolution Rules (`CLAUDE.md`) exactly as the other BA skills do:

1. An explicit `Primary System`/`System` stated by the user is authoritative.
2. Content found in an attachment must not silently override the user-provided system.
3. A conflict between the stated system and the attachment/request text stops diagram generation until the user resolves it.
4. WFO and AQM (or any two distinct registered systems) are never auto-resolved into one another.
5. A related/impacted system may be documented under "Related/Impacted Systems," but never substituted as confirmed Current State for the Primary System.
6. When no system is stated, resolve it via `ba-source-discovery`'s registry procedure (`knowledge/standards/system-registry.md`).
7. When system confidence is not High, confirm the Primary System with the user before generating the final BPMN.

## Source Priority

Apply the order and conflict rules in [references/source-priority.md](references/source-priority.md). AI inference is never a confirmed requirement and must be classified as an Assumption, Recommendation, or Open Question.

## Modes

Select the mode from the request; ask when genuinely ambiguous between modes (e.g., "update" vs. "correct").

### Mode 1 — Create

1. Identify the system and feature; resolve the System Key.
2. Determine whether the requested diagram is As-Is or To-Be (ask if unstated and not inferable from context).
3. Route to `ba-source-discovery`, then `ba-current-state-analyzer` when the diagram is As-Is or the To-Be depends on existing behavior (see Relationship to Other Skills).
4. Perform process analysis using [references/process-analysis-rules.md](references/process-analysis-rules.md) and the [process-analysis-template.md](templates/process-analysis-template.md).
5. Detect contradictions and missing material information per [references/clarification-rules.md](references/clarification-rules.md); ask focused clarification questions when required.
6. Invoke `/camunda-skills:camunda-bpmn` to generate the BPMN 2.0 XML and DI layout from the grounded process analysis.
7. Confirm the Camunda skill's technical validation (lint) result.
8. Save the output under the correct system directory per [references/naming-and-routing.md](references/naming-and-routing.md).
9. Generate the process-analysis sidecar (and impact-analysis sidecar, when applicable) for complex processes.
10. Summarize the result per Output Contract.

### Mode 2 — Update

1. Read the existing `.bpmn` completely (structure, IDs, lanes, flows) before proposing any change.
2. Read the approved change source (CR ticket, BRD delta, stakeholder confirmation).
3. Identify affected and unaffected areas; do not touch unaffected areas.
4. Perform impact analysis per [references/impact-analysis-rules.md](references/impact-analysis-rules.md) and the [impact-analysis-template.md](templates/impact-analysis-template.md).
5. Present material or destructive changes for explicit confirmation before applying them (see Change-Control Rules below).
6. Preserve existing BPMN element IDs whenever possible.
7. Invoke `/camunda-skills:camunda-bpmn` for the targeted edit — never a full regeneration when a targeted change is sufficient.
8. Confirm DI coordinates were updated for moved/added elements only (existing layout preserved elsewhere).
9. Confirm technical validation of modified and connected paths.
10. Record the change in [bpmn-change-log-template.md](templates/bpmn-change-log-template.md).

### Mode 3 — Review

1. Read the BPMN completely.
2. Read the relevant requirement sources (BRD, CR ticket, current-state analysis) when available.
3. Validate syntax, structure, control flow, layout, and traceability per [references/review-checklist.md](references/review-checklist.md).
4. Categorize findings by severity: `Critical`, `High`, `Medium`, `Low`, `Suggestion`.
5. Produce the validation report using [validation-report-template.md](templates/validation-report-template.md).
6. Do not change the BPMN unless the user explicitly requests correction (→ Mode 6).

### Mode 4 — Compare As-Is and To-Be

1. Identify the current process (via `ba-current-state-analyzer` when not already an approved As-Is diagram).
2. Identify the proposed future process from the explicit request and supported requirements.
3. Create or review the As-Is and To-Be as **separate** diagrams/files — do not combine both into one diagram unless explicitly requested.
4. Describe added, removed, and changed steps between them.
5. Identify role, data, system, rule, integration, SLA, reporting, notification, and operational impacts per [references/impact-analysis-rules.md](references/impact-analysis-rules.md).
6. Highlight migration considerations (data, training, cutover, parallel-run needs) as Recommendations or Open Questions — never as confirmed requirements unless sourced.
7. Produce the comparison as part of the process-analysis and impact-analysis reports.

### Mode 5 — Explain

Explain an existing BPMN in business language without changing the source file. Cover: process purpose, scope, trigger, participants, main flow, alternative flows, exception flows, decision points, business rules, inputs/outputs, system interactions, end states, assumptions, and open questions. Base every statement on what the diagram and its linked sources actually show — do not infer unstated business rules from element names alone.

### Mode 6 — Correct

1. Produce review findings first (Mode 3) if not already available.
2. Separate technical corrections (syntax, layout, lint-flagged structure) from business-logic changes (gateway conditions, approval sequence, scope).
3. Apply safe technical corrections directly, only when they do not change business meaning.
4. Ask for explicit confirmation before changing business logic (see Change-Control Rules).
5. Preserve IDs and existing valid content whenever possible.
6. Invoke `/camunda-skills:camunda-bpmn` to apply and technically validate the correction.

## BPMN Modeling Delegation

Full BPMN modeling rules (task/event/gateway selection, layout conventions, pools/lanes vs. message flows, executable-property restrictions) are in [references/bpmn-modeling-rules.md](references/bpmn-modeling-rules.md) — this skill enforces them at the analysis level; `/camunda-skills:camunda-bpmn` enforces them at the XML/DI level via its own lint loop. Always invoke `/camunda-skills:camunda-bpmn` for the actual `.bpmn` file work (Modes 1, 2, 6); never write raw BPMN XML directly from this skill.

Do not mark a process `isExecutable="true"` or add Zeebe/Camunda execution properties unless workflow automation is explicitly in scope. Do not deploy any BPMN process under any circumstance in this skill.

## Process Analysis

Before generating or updating a BPMN, establish the process-analysis dimensions in [references/process-analysis-rules.md](references/process-analysis-rules.md) using [process-analysis-template.md](templates/process-analysis-template.md). Keep the analysis concise for simple processes. For complex processes, save a sidecar file at `outputs/bpmn/<SYSTEM>/<feature-name>-process-analysis.md`.

Do not proceed to diagram generation when a missing decision would materially change scope, actor responsibility, approval sequence, a gateway condition, a success/failure outcome, exception handling, system responsibility, manual-vs-automated processing, timer/SLA behavior, or a data handoff — raise it per [references/clarification-rules.md](references/clarification-rules.md) instead.

## Clarification Rules

Apply [references/clarification-rules.md](references/clarification-rules.md): search approved local sources and system knowledge first, ask only for material ambiguity, never block for cosmetic or layout-only decisions, and never invent business rules, thresholds, sequences, permissions, actors, status transitions, formulas, SLA values, timer durations, exception handling, integration behavior, notification recipients, or production behavior.

## Impact Analysis

For every BPMN update or To-Be design, analyze the areas and classification levels (`Impacted`, `Potentially impacted`, `Not impacted`, `Unknown`) in [references/impact-analysis-rules.md](references/impact-analysis-rules.md) using [impact-analysis-template.md](templates/impact-analysis-template.md). Save a detailed report as `outputs/bpmn/<SYSTEM>/<feature-name>-impact-analysis.md` when required. Report — never automatically apply — impact to BRDs, CR tickets, and `outputs/test-cases/`.

## Naming and Output Routing

Apply [references/naming-and-routing.md](references/naming-and-routing.md) for system-folder routing, filename conventions, and sidecar-report naming. If the system is unknown or ambiguous, ask before saving. Do not save BPMN files outside `outputs/bpmn/` unless the user explicitly provides another destination.

## Change-Control Rules

When updating or correcting an existing BPMN (Modes 2 and 6):

- Require explicit user confirmation before: removing a task, role, or lane; removing a business outcome or exception flow; replacing a major process section; changing an approval sequence or gateway condition; changing process scope; converting As-Is into To-Be; overwriting an approved BPMN; or changing business meaning based only on an assumption.
- Do not silently remove tasks, roles, lanes, events, gateways, outcomes, or flows.
- Do not regenerate the complete diagram when a targeted change is sufficient.
- Record every update in [bpmn-change-log-template.md](templates/bpmn-change-log-template.md), including preserved IDs, impact summary, assumptions, validation result, and open questions.

## Validation

After creating, updating, or correcting a BPMN:

1. Use `/camunda-skills:camunda-bpmn` (its `c8ctl bpmn lint` loop) for technical generation and validation — parseability, namespaces, DI presence, ID/reference integrity, sequence-flow validity, gateway completeness.
2. Independently check, per [references/review-checklist.md](references/review-checklist.md): unreachable nodes, orphan elements, dead ends, uncontrolled loops, pool/lane consistency, sequence-flow vs. message-flow usage, naming quality, and traceability of the diagram back to its requirement sources.
3. Report warnings honestly; do not claim validation passed unless it was actually performed.
4. Produce the validation report using [validation-report-template.md](templates/validation-report-template.md), saved as `outputs/bpmn/<SYSTEM>/<feature-name>-validation-report.md` when a detailed report is warranted.

A technically valid diagram is not automatically business-approved — always distinguish `Generated`, `Reviewed`, `Technically validated`, `Business-approved`, and `Deployed` in reports and summaries.

## Safety Rules

- A review-only or explain-only request must not modify any file.
- Never deploy a BPMN process, connect to, or modify a Camunda runtime — that is out of scope for this skill entirely (see `camunda-process-mgmt` if the user separately authorizes it).
- Never write to Jira or Confluence without explicit instruction, per the project's Atlassian Safety Rules.
- Never overwrite an approved business document; never change a BRD, CR ticket, or test case automatically — report impact only.
- Never expose credentials or connector configuration.
- Never bypass Windows or organizational security controls.
- Never treat a generated BPMN as business-approved.
- Never silently infer material business rules.
- Never modify unrelated files, and never delete source documents.

## Output Contract

After every run, report:

```text
Operation performed
System
Feature
Diagram type (As-Is / To-Be / Both)
Files created
Files updated
Sources used
Main process decisions
Changes made
Assumptions
Open questions
Validation result
Impacted related artifacts
Recommended next action
```

Use workspace-relative paths. Do not paste full BPMN XML into the conversation unless explicitly requested. Keep the user-facing summary concise; keep complete detail in the saved reports.

## Quality Checks

- The Primary System was resolved per System Resolution Rules, and any conflict stopped generation until clarified.
- Source Discovery and Current-State Analysis preceded diagram generation whenever the request required them, and this skill did not run an independent Jira/Confluence search.
- Current State was never inferred by reversing the requested To-Be.
- As-Is and To-Be were kept as separate diagrams unless the user explicitly asked for a single combined view.
- Every material ambiguity was raised as a clarification question, not silently assumed.
- No business rule, threshold, sequence, permission, SLA, or timer value was invented.
- `/camunda-skills:camunda-bpmn` was used for all BPMN XML/DI generation and technical validation — none was hand-written by this skill.
- Existing BPMN IDs, lanes, and unaffected sections were preserved during updates and corrections.
- Destructive or business-logic changes were confirmed with the user before being applied.
- BRDs, CR tickets, and test cases were only reported as impacted, never auto-modified.
- Output was saved under `outputs/bpmn/<SYSTEM>/` (or the user's explicit path), never under `knowledge/`.
- No BPMN process was deployed and no Camunda runtime was touched.
- The validation report honestly reflects what was actually checked.

## Failure Handling

- If the requested system cannot be resolved or confidence is not High, ask the user to confirm it before generating the final BPMN.
- If source discovery/current-state analysis reports `BLOCKED`, do not produce a final BPMN; report the required sources and Open Questions instead.
- If sources conflict and precedence is unclear, document the conflict and raise an Open Question rather than merging it silently.
- If an existing `.bpmn` is malformed or unreadable, report what could not be assessed and request a usable copy before attempting Modes 2, 3, 5, or 6.
- If `/camunda-skills:camunda-bpmn` reports lint errors or warnings that this skill cannot resolve through the defined workflow, report them verbatim rather than declaring validation passed.
- If a requested correction would change business logic and no source supports the change, state **"Not defined in source"** and ask for clarification instead of applying it.

## Examples

- [examples/create-bpmn-example.md](examples/create-bpmn-example.md) — Mode 1, RMS Rescue Approval To-Be.
- [examples/update-bpmn-example.md](examples/update-bpmn-example.md) — Mode 2, TMS Callback Reminder update.
- [examples/review-bpmn-example.md](examples/review-bpmn-example.md) — Mode 3, WFM Screen Recording review.
- [examples/compare-as-is-to-be-example.md](examples/compare-as-is-to-be-example.md) — Mode 4, LTX As-Is vs. To-Be comparison.

All examples are fictitious walkthroughs illustrating skill behavior. They are not requirement evidence and their business content must not be copied into a real deliverable.
