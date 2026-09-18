# BPMN Modeling Rules (BA-Level)

These are the analysis-level rules this skill enforces before and while directing `/camunda-skills:camunda-bpmn`. That skill separately enforces the XML/DI-level equivalents (its own canonical style, layout rules, and element catalog) via its own lint loop — see `tools/camunda/skills-main/skills/camunda-bpmn/SKILL.md` and its `references/` for that detail. Do not duplicate that skill's XML syntax reference here; this file governs what to ask for and check at the process-design level.

## Structure

1. Every path starts with a Start Event (no incoming flows) and reaches an End Event (no outgoing flows).
2. Use left-to-right layout by default; avoid overlapping nodes, labels, lanes, and flows (delegate the actual coordinate math to `/camunda-skills:camunda-bpmn`).
3. Use stable, meaningful element IDs; preserve them when updating existing diagrams.
4. Use verb-object task names ("Review invoice," "Send notification").
5. Use question-style gateway names ("Approved?", "Amount over threshold?").
6. Label all outgoing gateway branches.
7. Use sequence flows only within the same pool; use message flows between different pools.
8. Use lanes for responsibilities within one participant; do not use pools only for visual grouping — a pool represents a distinct participant/organization, not a visual box.
9. Use collapsed sub-processes for excessive detail; avoid a single oversized, unreadable diagram — split by feature or phase when a diagram would otherwise need extensive scrolling or dense crossing flows.

## Element Selection

Choose the correct type from the request's actual behavior, not habit:

**Tasks** — `User Task`, `Manual Task`, `Service Task`, `Send Task`, `Receive Task`, `Business Rule Task`, `Call Activity`, `Sub-Process`. One atomic action per task.

**Events** — `Start Event`, `End Event`, `Message Event`, `Timer Event`, `Error Event`, `Escalation Event`, `Signal Event`, `Terminate End Event`. Use the event type that matches the actual trigger or outcome (e.g., a message-correlated external trigger is a Message Start Event, not a plain None Start Event).

**Gateways** — `Exclusive Gateway` (XOR: exactly one path), `Parallel Gateway` (AND: all paths, always with a matching join), `Inclusive Gateway` (OR: one or more paths, always with a matching join), `Event-Based Gateway` (branch on which event occurs first). Do not use an Exclusive Gateway for simultaneous activities that should run in parallel.

## Gateway Completeness

- Ensure all split gateways have complete outcomes — every meaningful branch is represented, and an Exclusive Gateway has a `default` flow (see the Camunda BPMN skill's element-catalog rule on binary/enum decisions: default the safer branch, condition only the explicitly selected branch).
- Ensure join behavior matches the preceding split behavior (Parallel fork → Parallel join; Inclusive fork → Inclusive join). Flag a "fake join" — multiple flows converging on a non-gateway element, or a join type that doesn't match its fork — during review.
- Ensure all normal paths reach a valid end state.

## Exception and Alternative Paths

- Model rejection, cancellation, timeout, retry, and failure paths when the source material supports them or the request explicitly asks for them.
- Do not add unsupported exception flows — an invented timeout or retry path is a fabricated business rule (see [clarification-rules.md](clarification-rules.md)).

## Executable Properties

- Do not add Camunda/Zeebe execution properties (`isExecutable="true"`, `zeebe:taskDefinition`, `zeebe:userTask`, etc.) unless workflow automation is explicitly in scope for the request.
- Do not mark a BPMN process as executable unless requested.
- Do not deploy a process under any circumstance from this skill.

## Delegation Boundary

- This skill defines *what* the process is (elements, flow, gateway logic, business meaning) from grounded analysis.
- `/camunda-skills:camunda-bpmn` defines *how* it is expressed (valid BPMN 2.0 XML, DI coordinates, Camunda Modeler compatibility, `c8ctl bpmn lint` technical validation).
- Hand the grounded process analysis to that skill rather than drafting XML by hand; treat its lint result as the technical validation record, and layer the review-checklist business/traceability checks ([review-checklist.md](review-checklist.md)) on top.
