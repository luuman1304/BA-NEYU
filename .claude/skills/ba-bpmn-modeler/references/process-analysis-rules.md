# Process Analysis Rules

Before generating or updating BPMN, establish the applicable dimensions below from grounded sources. Use [../templates/process-analysis-template.md](../templates/process-analysis-template.md) to record them.

## Dimensions

```text
Process name
System
Feature
Diagram type: As-Is or To-Be
Purpose
Business objective
Scope start
Scope end
Trigger
Participants
Pools
Lanes
Systems involved
Preconditions
Main flow
Alternative flows
Exception flows
Business rules
Decision points
Inputs
Outputs
Data exchanged
Statuses and transitions
Notifications
SLA and timers
Integrations
Final outcomes
Assumptions
Open questions
Sources used
```

For a simple process (few steps, one actor, no branching), this analysis may be a short, direct list — do not pad it with empty headings.

For a complex process (multiple actors/systems, several gateways, exception handling), save a sidecar file:

```text
outputs/bpmn/<SYSTEM>/<feature-name>-process-analysis.md
```

## When Not to Proceed to Diagram Generation

Stop and raise a clarification question (per [clarification-rules.md](clarification-rules.md)) instead of generating or updating the diagram when a missing decision would materially change:

- Process scope.
- Actor responsibility.
- Approval sequence.
- A gateway condition.
- A success or failure outcome.
- Exception handling.
- System responsibility (manual vs. automated).
- Timer or SLA behavior.
- A data handoff between actors or systems.

## As-Is vs. To-Be Determination

1. If the user explicitly states As-Is or To-Be, use it.
2. If the request describes an existing process to be documented, treat it as As-Is and route to `ba-current-state-analyzer`.
3. If the request describes a change, enhancement, or new capability, treat it as To-Be, and route to `ba-current-state-analyzer` first when the change depends on existing behavior (reuse, extension, replacement of current logic).
4. If neither is stated and cannot be inferred from context (e.g., "model the request submission process" without saying whether it already exists), ask the user which is intended before analysis proceeds.
5. For Mode 4 (Compare), both are required; build or source each independently before comparing (see [impact-analysis-rules.md](impact-analysis-rules.md)).

## Source Grounding

- Every process-analysis dimension traces to a source (BRD, CR ticket, current-state analysis, Jira/Confluence evidence via `ba-source-discovery`, or an explicit user statement in the current request).
- Never generate Current Behavior by reversing the requested Expected Behavior. A request to "add a QA approval step" does not prove QA approval is currently absent — state **"Current availability of [X] is not verified from available source"** when unverified.
- Requests to use "the same logic as," align with, copy, or emulate another implementation require separate analysis of both the reference and target implementations before the process analysis is drafted (same rule as `ba-current-state-analyzer`).
- Search results and titles are candidate indicators, not requirement evidence — inspect content via `ba-source-discovery` before treating anything as confirmed.

## Create Mode (Mode 1) Detail

1. Identify the system and feature; resolve the System Key via the registry.
2. Determine As-Is vs. To-Be per the rules above.
3. Discover and read relevant sources (`ba-source-discovery` → `ba-current-state-analyzer` when required).
4. Complete the process-analysis dimensions above.
5. Detect contradictions and missing material information.
6. Ask focused clarification questions when required.
7. Hand the grounded process analysis to `/camunda-skills:camunda-bpmn` to generate BPMN 2.0 XML and DI layout.
8. Confirm technical validation.
9. Save the output per [naming-and-routing.md](naming-and-routing.md).
10. Generate or update sidecar reports.
11. Summarize per the SKILL.md Output Contract.

## Update Mode (Mode 2) Detail

1. Read the existing BPMN completely.
2. Read the approved change source.
3. Identify affected and unaffected areas.
4. Perform impact analysis ([impact-analysis-rules.md](impact-analysis-rules.md)).
5. Present material or destructive changes for confirmation (see SKILL.md Change-Control Rules).
6. Preserve existing BPMN element IDs whenever possible.
7. Make targeted changes via `/camunda-skills:camunda-bpmn` instead of recreating the entire diagram.
8. Update BPMN DI coordinates for changed/added elements only.
9. Validate all modified and connected paths.
10. Record the change in [../templates/bpmn-change-log-template.md](../templates/bpmn-change-log-template.md).

## Compare Mode (Mode 4) Detail

1. Identify the current process (via `ba-current-state-analyzer`, or an already-approved As-Is diagram).
2. Identify the proposed future process from the explicit request and supported requirements.
3. Create or review the As-Is and To-Be as separate models/files.
4. Describe added, removed, and changed steps.
5. Identify role, data, system, rule, integration, SLA, reporting, notification, and operational impacts.
6. Highlight migration considerations as Recommendations/Open Questions unless explicitly sourced.
7. Do not combine both processes into one unreadable diagram unless explicitly requested.
