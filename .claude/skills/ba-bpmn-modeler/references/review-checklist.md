# BPMN Review Checklist

Used by Mode 3 (Review), Mode 5 (Explain — read-only subset), and Mode 6 (Correct — to produce findings before fixing). Categorize every finding by severity:

```text
Critical    — breaks execution/parseability, or reverses business meaning
High        — missing exception/outcome path, wrong gateway logic, unresolved lint error
Medium       — incomplete labeling, unclear traceability, lint warning
Low          — naming/style inconsistency, non-blocking layout issue
Suggestion   — optional improvement, no defect
```

## Checklist

**Scope and classification**
- Correct process scope (matches the requested/approved boundary).
- Correct As-Is or To-Be classification.
- Correct trigger.
- Correct participants.

**Structure**
- Correct pools and lanes.
- Correct task ownership (task sits in the lane of the actor who performs it).
- Correct task types (User/Manual/Service/Send/Receive/Business Rule/Call Activity/Sub-Process — matches actual behavior).
- Correct event types (Start/End/Message/Timer/Error/Escalation/Signal/Terminate).
- Correct gateway types (Exclusive/Parallel/Inclusive/Event-Based).
- Complete gateway outcomes (every branch represented; Exclusive Gateways have a `default`).
- Clearly labeled flows (verb-object tasks, question-style gateways, named branches).
- Valid message flows (only between different pools).
- Valid sequence flows (only within the same pool).

**Flow coverage**
- Main flow is present and traceable end to end.
- Alternative flows are present where the source requires them.
- Exception flows are present where the source requires them.
- Rejection paths.
- Cancellation paths.
- Timeout paths.
- Retry behavior.
- Valid final outcomes (every normal path reaches a valid End Event).

**Integrity**
- No unreachable nodes.
- No orphan nodes.
- No unintended infinite loops.
- No unsupported business assumptions (every rule/condition traces to a source).
- Correct status transitions.
- Correct system interactions.

**Traceability and layout**
- Requirement traceability (diagram behavior matches its cited BRD/CR/current-state source).
- Readable layout, left-to-right by default.
- No visual overlap (nodes, labels, lanes, flows).

## Technical vs. Business Findings

- Technical findings (parseability, DI presence, ID/reference integrity, lint errors/warnings) are the responsibility of `/camunda-skills:camunda-bpmn`'s validation — confirm its result rather than re-deriving it.
- Business findings (wrong gateway logic vs. source, missing exception path required by source, incorrect task ownership vs. source) are this skill's responsibility and must cite the source that establishes the correct behavior.
- In Mode 6 (Correct), apply only technical corrections that do not change business meaning without confirmation; anything that changes business meaning requires explicit user confirmation first (see SKILL.md Change-Control Rules).

## Status Labels

Always distinguish, in review output and summaries:

```text
Generated              — produced by this skill / camunda-bpmn, not yet reviewed
Reviewed               — checked against this checklist
Technically validated  — passed camunda-bpmn's lint loop with zero errors (warnings noted if any remain)
Business-approved      — explicitly confirmed by the user/stakeholder as correct business logic
Deployed                — out of scope for this skill; never claim this status
```

A technically valid diagram is not automatically business-approved.
