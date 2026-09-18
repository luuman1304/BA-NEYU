# Impact Analysis Rules

For every BPMN update or To-Be design, analyze the areas below and classify each as:

```text
Impacted
Potentially impacted
Not impacted
Unknown
```

Use [../templates/impact-analysis-template.md](../templates/impact-analysis-template.md).

## Areas to Analyze

```text
Upstream process
Downstream process
Related features
Actors and responsibilities
Roles and permissions
Business rules
Status transitions
Data
APIs and integrations
Notifications
Reports and dashboards
Audit logs
SLA and timers
Exception paths
Existing BRDs
Existing CR tickets
Test cases
User guides
Operational procedures
Training materials
```

Only assess areas relevant to the change — do not force every area into every report; mark clearly irrelevant areas `Not impacted` rather than omitting them silently when a reviewer would expect them to be considered.

## Reporting, Not Modifying

- If a detailed report is required, save it as `outputs/bpmn/<SYSTEM>/<feature-name>-impact-analysis.md`.
- Do not automatically modify related documents (BRDs, CR tickets, test cases, user guides, operational procedures, training materials). Report the impact and let the user route it to `ba-brd-writer-updater` or `ba-cr-ticket-writer` explicitly.
- If test cases may be affected, report the impact on `outputs/test-cases/` (the BA deliverable test-case output location). Only modify test cases when explicitly requested, and only through the appropriate flow — this skill does not author test cases itself.
- Do not confuse `outputs/test-cases/` (BA deliverable test-case output) with the workspace-root `test-cases/` directory (internal skill-verification fixtures for the BA skills themselves) — never write to the latter.

## Grounding

- Classify `Impacted` only when a source (existing BPMN, BRD, CR ticket, or current-state analysis) or explicit request content supports it.
- Classify `Potentially impacted` when a plausible dependency exists but is not confirmed — explain why in one line.
- Classify `Unknown` rather than guessing when the necessary source was not available; do not default to `Not impacted` to avoid an Open Question.
- Do not infer downstream/upstream process impact from element naming alone; trace it to the diagram's actual flows, message flows, or documented integration points.

## Migration Considerations (Mode 4 — Compare)

When comparing As-Is and To-Be, additionally cover, only where supported by sources or explicitly requested:

- Data migration or backfill needs.
- Training or communication needs for changed actor responsibilities.
- Cutover sequencing or parallel-run needs.
- Rollback considerations if the To-Be fails validation in production.

Record these as Recommendations or Open Questions, never as confirmed requirements, unless an approved source defines them.
