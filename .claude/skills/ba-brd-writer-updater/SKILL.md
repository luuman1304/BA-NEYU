---
name: ba-brd-writer-updater
description: Create a source-grounded Business Requirement Document or minimally update an existing BRD while preserving its approved structure. Use for new BRDs, BRD revisions, change-impact updates, requirement clarification, and BRD quality checks.
---

# BA BRD Writer / Updater

## Purpose

Create concise, structured, testable BRDs and update existing BRDs without inventing business requirements or rewriting unaffected content.

## Trigger

Use this skill when the user asks to:

- Create a new BRD from source material.
- Update or revise an existing BRD.
- Apply a change request to a BRD.
- Assess which BRD sections a change affects.
- Review a BRD for grounding, consistency, ambiguity, or traceability.

## Inputs

Collect and identify, when available:

- User request and desired mode.
- The explicit `Primary System` or `System` stated by the user, if any (see System Resolution below).
- Existing BRD, including version and approval status.
- Approved CRs or tickets.
- Confirmed meeting minutes or stakeholder emails.
- System documentation, historical tickets, data definitions, process flows, and mockups.
- Requested output format, intended audience, and any explicit output path.

Do not treat missing input as permission to infer requirements.

## System Resolution

Apply the System Resolution Rules in the project's `CLAUDE.md` / `AGENTS.md` before drafting:

1. An explicit `Primary System` or `System` stated by the user is authoritative.
2. Content found in an attachment must not silently override the user-provided system.
3. If the user-provided system conflicts with the attachment or request text (for example, `System: WFO` alongside request text saying the workflow is for AQM), **stop and ask for clarification**. Do not generate the final BRD until the conflict is resolved.
4. Do not automatically resolve WFO to AQM or AQM to WFO — they are separate systems (`knowledge/standards/system-registry.md`).
5. A related or impacted system may be documented under a `Related/Impacted Systems` note, but it must not replace the Primary System, and it must never be used as confirmed Current State for the Primary System — only as a clearly labeled supporting reference.
6. When no system is stated, use the registry-based system-resolution procedure defined in `ba-source-discovery` (`knowledge/standards/system-registry.md`).
7. When system confidence is not High, ask the user to confirm the Primary System before generating the final BRD.

## Source Priority

Apply this order unless the user identifies a different authoritative source:

1. Latest approved BRD
2. Approved CR / ticket
3. Confirmed meeting minutes
4. Confirmed stakeholder email
5. Existing system documentation
6. Historical ticket
7. AI inference

AI inference cannot become a final requirement. When sources conflict, identify the conflict, prefer the latest approved source only when clearly identifiable, and otherwise raise an Open Question.

## Workflow

### 0. Establish Current State

Before drafting a change to existing behavior, use `ba-source-discovery` to discover candidate Jira, Confluence, and local sources, then use `ba-current-state-analyzer` to validate selected evidence and produce a Current-State Analysis.

- Consume the analyzed Current-State result; do not implement independent Jira or Confluence searches in this writer.
- Use confirmed findings as the BRD's Current Behavior.
- Keep the explicit requested change separate as Expected Behavior.
- Carry gaps and conflicts into Open Questions.
- If readiness is **PARTIAL**, draft only the supported scope and do not convert gaps into requirements.
- If readiness is **BLOCKED**, do not produce final requirements; return the required current-state sources and Open Questions.
- When the request says "same logic as," "align with," "copy," or similar, analysis of both the reference and target implementations is mandatory.
- A cross-system or related-system document must never be used as confirmed Current State for the Primary System — reference it only as a clearly labeled supporting source.

For isolated new behavior with no dependency on an existing implementation, record that Current-State Analysis is not applicable and continue.

### 1. Select the mode

**Mode A — Create New BRD**

- Use [references/brd-template.md](references/brd-template.md) as the default structure and section order.
- Include only sections applicable to the supplied change and sources; do not add empty or irrelevant sections merely to make the document longer.
- `Purpose`, `Stakeholders`, `Permissions`, `Dashboard/Reporting`, `Dependencies`, `Integration Requirements`, and `Out of Scope` are optional — include them only when the request or sources support them.

**Mode B — Update Existing BRD**

- Treat the supplied BRD structure as the primary template.
- Do not convert it into the default or a generic BRD.
- Identify sections affected by the requested change before editing.
- Update only impacted sections.
- Preserve section numbering, terminology, formatting conventions, and level of detail.
- Do not rewrite unrelated sections.

### 2. Analyze the sources

Evaluate applicable dimensions only, mapped to the standard sections in [references/brd-template.md](references/brd-template.md):

- Background and Objective
- GEO Apply
- Scope (in scope; out of scope only when relevant)
- Current Behavior
- Expected Behavior
- User Story
- Business Rules
- Functional Requirements
- Data Mapping
- Acceptance Criteria
- Open Questions
- Sources and Traceability
- Version History (Mode B, or when the request calls for a formal revision log)

Additional dimensions to consider only when the request supports them: Stakeholders/User Roles, Permission, Status Transition, Dashboard/Reporting, Validation, Exception, Audit, Dependencies.

Not every BRD needs every section. Include only applicable sections.

### 3. Classify statements internally

Classify each material statement before drafting:

- `[C]` Confirmed Requirement: explicitly supported by an identified source.
- `[E]` Current-State Evidence: an observed fact about existing behavior, cited to its source — belongs in Current Behavior, not in a requirement statement.
- `[D]` Derived Analysis / Recommendation: a BA-proposed reading, improvement, or inference — not a source fact.
- `[Q]` Open Question: missing, ambiguous, or conflicting information.

Only `[C]` statements may become final Business Rules, Functional Requirements, or Acceptance Criteria. Keep `[E]` in Current Behavior, `[D]` in a clearly labeled Recommendations/Assumptions note, and `[Q]` in Open Questions — never phrase `[E]`, `[D]`, or `[Q]` content as a confirmed requirement.

### 4. Draft or update

- Trace every requirement to a source.
- Keep Current Behavior and Expected Behavior distinct.
- Write atomic, testable business rules and functional requirements.
- Create acceptance criteria only for supported expected behavior.
- Record gaps as Open Questions.
- Do not turn every missing detail into an additional functional requirement — a genuine gap belongs in Open Questions, not as a speculative FR.

### 5. Determine the output location

Follow the project's Output Routing Rules (`CLAUDE.md` / `AGENTS.md`):

- Save a new or updated BRD to `outputs/brd/<SYSTEM_KEY>/BRD-<SYSTEM_KEY>-<FEATURE_NAME>.md`, using the resolved Primary System's System Key.
- Never save a generated BRD under `knowledge/`. `knowledge/` is reference-only.
- Do not promote a BRD into `knowledge/` unless the user explicitly requests that exact action.
- If the user specifies an exact output path, that path takes precedence over the default convention.

### 6. Review

Run all quality checks before returning the BRD.

## Rules

### Grounding

- Support every requirement with a source.
- Prefer source documents over generic knowledge.
- Never invent business logic or implementation detail.
- Do not add speculative system behavior, and do not infer integration behavior, status mapping, scoring formulas, permissions, or workflow steps unless a source explicitly defines them.

### Existing BRD precedence

- Existing approved BRD structure takes precedence over the default template.
- Preserve its heading order, numbering, terminology, and style.

### Formula protection

- Do not infer or derive a formula unless the source explicitly defines it.
- When applicable but undefined, leave the formula blank or state: **"Not defined in source."**
- Apply the same protection to logic, rules, permissions, and status transitions.

### Minimal update

- For a change request, identify impacted sections and update only those sections.
- Do not reword unrelated approved content for style alone.

### Writing standard

- Write concisely, in plain business language, and stay requirement-oriented — avoid narrative padding.
- Preserve exact business terminology, field names, and status values from the approved source rather than paraphrasing them.
- Combine related acceptance conditions into a single Given/When/Then when this shortens the AC without losing logic; do not create one AC per minor variation.
- Distinguish, throughout the document, between a confirmed requirement, current-state evidence, derived analysis, and an open question — never blend them into one statement.

### Consistency

Check terminology, status names, role names, formulas, business rules, functional requirements, and acceptance criteria across the document.

### Ambiguity

- Add Open Questions when information is insufficient.
- Never silently merge conflicting requirements.
- Do not fill gaps through assumptions.

### Cross-system boundary

- Do not use a cross-system or related-system BRD/specification as confirmed Current State for the Primary System.
- A cross-system document may be used only as a supporting reference, and must be clearly labeled as such (for example, "Related System — WFO, supporting reference only") wherever it is cited.

## Output Contract

Return:

1. The new or updated BRD in the applicable structure, saved to the path determined in Workflow step 5 (or the user's explicit path).
2. For Mode B, a concise list of impacted sections and changes made.
3. Clearly labeled Assumptions, Recommendations, and Open Questions when present.
4. Source references or traceability for every final requirement.
5. The exact phrase **"Not defined in source."** for any applicable undefined formula, logic, rule, permission, or status transition.

Do not expose internal `[C]`, `[E]`, `[D]`, and `[Q]` markers unless the user requests them; express non-confirmed content under explicit headings.

## Quality Checks

- The Primary System was resolved per System Resolution Rules; a stated system was treated as authoritative, and any conflict with the attachment/request text stopped drafting until clarified.
- WFO and AQM (or any two distinct registered systems) were not silently merged or auto-resolved into one another.
- A Current-State Analysis was completed when the change depends on existing behavior.
- Source Discovery preceded Current-State Analysis when existing-system sources required discovery.
- The writer did not independently search Jira or Confluence or treat discovery results as requirements.
- The BRD's Current Behavior contains only confirmed findings from that analysis, and no cross-system source is presented as confirmed Current State for the Primary System.
- The readiness decision is respected before final requirements are drafted.
- Every final requirement has a source.
- Existing BRD structure is preserved in Mode B.
- Only impacted sections changed in Mode B.
- Applicable sections are included; irrelevant or empty sections are not forced in.
- Current Behavior and Expected Behavior are distinct.
- Terminology, role names, field names, and status values match the sources.
- No formula, business rule, permission, integration behavior, or transition is inferred.
- Functional requirements align with business rules.
- Acceptance criteria are concise, testable, combined where reasonable, and traceable to Expected Behavior.
- Conflicts and ambiguities appear as Open Questions, not as speculative requirements.
- The BRD was saved under `outputs/brd/<SYSTEM_KEY>/`, not under `knowledge/`, unless the user explicitly requested promotion into `knowledge/`.
- Traceability and version history are updated when applicable.

## Failure Handling

- If no usable source is provided, do not create final requirements. Return the missing inputs and Open Questions.
- If the user-provided Primary System conflicts with the attachment or request text, stop and ask for clarification; do not generate the final BRD.
- If sources conflict and precedence is unclear, document each conflicting statement and raise an Open Question.
- If an existing BRD is unreadable or incomplete, preserve all recoverable structure and identify what could not be assessed.
- If the request requires an undefined formula, rule, permission, logic, or status transition, state **"Not defined in source."** and request clarification.
- If approval status or source recency is unknown and affects precedence, ask the user to identify the authoritative source.

## Examples

- [examples/golden-brd-example.md](examples/golden-brd-example.md) — writing-quality, structure, detail-level, and Acceptance Criteria reference. Do not copy its business content into another BRD.
- [examples/sample-brd-structure.md](examples/sample-brd-structure.md) — **deprecated**, kept for historical reference only; its section order does not reflect the current standard in [references/brd-template.md](references/brd-template.md).
