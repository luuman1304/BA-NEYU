---
name: ba-current-state-analyzer
description: Analyze and document existing system behavior from available sources before an existing feature, process, field, rule, integration, report, or permission is changed or reused. Use before drafting a BRD or CR ticket when the request depends on current behavior.
---

# BA Current State Analyzer

## Purpose

Establish a source-grounded baseline of existing behavior before a change is defined. This skill analyzes current state; it does not design expected behavior or write a BRD or CR ticket.

## Trigger

Use this skill before drafting requirements when a request:

- Changes, extends, replaces, or reuses existing behavior.
- Refers to another system, module, screen, process, field, report, or integration as the model.
- Uses phrases such as "same logic as," "align with," "copy," or "similar to."
- Depends on existing rules, validations, permissions, status transitions, filters, sorting, exports, calculations, mappings, or legacy-data behavior.

For isolated new behavior with no dependency on an existing implementation, record that current-state analysis is not applicable and why.

## Inputs

Identify, when available:

- The requested change and business objective.
- Explicitly provided source documents and references.
- The `Source Discovery Result`, including `SELECTED` sources and discovery limitations.
- The resolved System Key and System Name from `knowledge/standards/system-registry.md`.
- Selected Jira, Confluence, and Local sources, kept separate by channel.
- Target system, module, screen, process, report, field, or integration.
- Named reference implementation.
- Approved BRDs, CRs, tickets, meeting minutes, and stakeholder emails.
- System documentation, data definitions, mappings, process flows, mockups, and historical tickets.
- Source approval status, version, date, and scope.

Missing input is a gap, not permission to infer behavior.

## Source Priority

Apply this order unless the user identifies a different authoritative source:

1. Latest approved BRD
2. Approved CR / ticket
3. Confirmed meeting minutes
4. Confirmed stakeholder email
5. Existing system documentation
6. Historical ticket
7. AI inference

AI inference cannot establish Current State. If approval status or recency is unknown and affects authority, report it as a gap. Never silently merge conflicting sources.

## Workflow

### 1. Receive Source Discovery handoff

For a request that changes or investigates existing behavior, use `ba-source-discovery` before Current State Analysis.

- Receive explicitly provided sources and only sources classified `SELECTED` by Source Discovery as candidate evidence.
- Receive the canonical System Key and System Name resolved by Source Discovery through `knowledge/standards/system-registry.md`, plus separate selected Jira, Confluence, and Local source lists.
- Treat the registry as the source of system identity. Do not independently guess aliases or remap the system. If the handoff reports `UNKNOWN_SYSTEM_KEY`, preserve that result rather than inventing a system identity.
- Receive `RELATED`, `UNVERIFIED`, `INACCESSIBLE`, excluded sources, connection failures, and conflicts as context only.
- Do not automatically treat any search result or `SELECTED` source as confirmed evidence.
- Independently inspect and validate source content, authority, scope, lifecycle, and release evidence before confirming Current State.
- If discovery could not run, record the unavailable channels and continue only with explicitly provided usable sources.

### 2. Decompose the request

Identify the target, requested change, named reference behavior, and the current-state facts required to define the change safely.

### 3. Assess sources

Review the candidate sources for both the target and any reference implementation. Record each source's identifier, type, approval or version status, scope, relevant evidence, authority limitations, and release evidence where applicable.

Use [references/current-state-checklist.md](references/current-state-checklist.md) to select applicable analysis dimensions. Do not force dimensions unrelated to the request.

### 4. Analyze reference and target separately

When the request says to reuse or align with another implementation:

- Establish the reference implementation's behavior from its sources.
- Establish the target implementation's existing behavior from its sources.
- Compare them only after each baseline is documented.
- Do not interpret "same logic" as a complete requirement.

### 5. Classify source lifecycle and findings

Distinguish where supported:

- **Documented Baseline:** behavior defined by an authoritative baseline document, without assuming production deployment.
- **Pending Changes:** proposed or approved changes without sufficient implementation and release evidence.
- **Implemented but unverified production changes:** implementation is indicated, but production release is not verified.
- **Released Changes:** release or deployment evidence supports production release.
- **Current Production State:** the best-supported effective behavior after reconciling baseline documentation, released changes, and release evidence.
- **Unknown / Unverified Behavior:** evidence is missing, inaccessible, insufficient, or lacks production verification.
- **Conflicting Information:** sources disagree and authority or lifecycle does not resolve the conflict.

A possible Current Production State may be supported by an authoritative Confluence baseline plus a released Jira change and sufficient release evidence. Do not use "newest Jira ticket wins," and do not treat Jira `Done` as automatic production release.

Classify every material statement as:

- **Confirmed Requirement:** explicitly supported by an identified source.
- **Assumption:** plausible but not confirmed.
- **Recommendation:** proposed BA treatment or improvement.
- **Open Question:** missing, ambiguous, or conflicting information.

Only confirmed findings may define Current State. Keep assumptions and recommendations out of confirmed behavior.

### 6. Identify gaps and conflicts

Record missing reference or target documentation, unknown authority, conflicting definitions, undefined behavior, and differences between sources. Absence from reviewed sources is not proof that behavior does not exist.

If a formula, logic, rule, permission, or status transition is applicable but undefined, state **"Not defined in source."**

### 7. Determine readiness

Assign one status:

- **READY:** applicable current behavior is sufficiently supported to define the requested change safely.
- **PARTIAL:** some current behavior is confirmed, but material gaps limit which requirements can be drafted.
- **BLOCKED:** the requested change depends on current behavior that cannot be established from available sources.

## Output Contract

Return a **Current-State Analysis** containing:

1. **Request Context** — requested change, target, named reference, and analysis scope.
2. **Sources Reviewed** — source, type, approval/version, scope, and authority notes.
3. **Confirmed Current State** — separate findings for the reference and target when both apply, with a source for every finding.
4. **Existing Rules and Constraints** — applicable rules, validations, permissions, status dependencies, data behavior, and other confirmed constraints.
5. **Reference-to-Target Comparison** — confirmed similarities and differences without proposing the future state.
6. **Gaps and Conflicts** — the issue, its impact, and required resolution.
7. **Assumptions** — only when present and clearly labeled.
8. **Recommendations** — only when present and clearly labeled.
9. **Open Questions** — questions required to resolve missing, ambiguous, or conflicting information.
10. **Readiness Decision** — READY, PARTIAL, or BLOCKED; supported drafting scope; unsupported drafting scope; and required additional sources.

Also include a **Source Lifecycle Assessment** covering Documented Baseline, Pending Changes, Implemented but unverified production changes, Released Changes, Current Production State, Unknown / Unverified Behavior, and Conflicting Information where applicable.

Use tables when they improve traceability. Do not claim that behavior does not exist unless an authoritative source explicitly establishes that fact.

For an illustrative application of this contract, see [examples/appointment-date-example.md](examples/appointment-date-example.md).

## Quality Checks

- Every confirmed current-state finding cites an identified source.
- Every discovery candidate used as evidence was independently validated; search titles and classifications alone were not used as proof.
- Baseline, pending, implemented-unverified, released, production, unknown, and conflicting states are distinguished when applicable.
- Production state is supported by sufficient lifecycle and release evidence rather than ticket recency or generic status alone.
- Reference and target behavior remain separate until comparison.
- Current State does not contain proposed future behavior.
- Applicable rules, validations, permissions, status dependencies, filter, sort, export, and data behavior are assessed when relevant.
- Assumptions and recommendations are not presented as facts.
- Missing information and conflicts are explicit.
- The readiness status matches the materiality of the remaining gaps.

## Failure Handling

- If no usable current-state source is available, return **BLOCKED** and do not reconstruct behavior from the request or generic knowledge.
- List sources reviewed or searched, missing sources, dimensions that could not be established, why the gaps prevent safe drafting, and the minimum evidence required to continue.
- If only part of the baseline is supported, return **PARTIAL**, identify the supported drafting scope, and prevent unsupported findings from becoming requirements.
- If sources conflict and precedence is unclear, preserve each conflicting statement and raise an Open Question.
- If a source is unreadable, identify what could not be assessed and request a usable copy.
