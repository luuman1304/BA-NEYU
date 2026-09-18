---
name: ba-source-discovery
description: Find, classify, and rank relevant Jira, Confluence, and local existing-system sources before Current State Analysis. Use for requests that change or investigate an existing system feature, including direct Jira references; do not use search results as requirements without inspecting their content.
---

# BA Source Discovery

## Purpose

Find, classify, and rank relevant existing-system sources before Current State Analysis. This skill defines BA search intent and evidence selection; connector contracts define how external systems are queried.

This skill must not generate a BRD or CR ticket, define Target State, invent business logic, or treat a search result as confirmed requirement evidence automatically.

## Inputs

Extract when available:

- System identity as stated by the user
- Resolved System Key and System Name
- GEO
- Module and screen
- Feature and entity
- Related or reference feature, module, and screen
- Explicit Jira issue key or URL
- Explicit Confluence URL
- Important business keywords

Resolve the user-provided System Key, System Name, or Alias through [../../../knowledge/standards/system-registry.md](../../../knowledge/standards/system-registry.md), using case-insensitive matching. The registry is the single source of truth; do not maintain or infer aliases in this skill. Use the resolved canonical row for its Jira Summary Pattern and Knowledge Path. For an unmapped system, return `UNKNOWN_SYSTEM_KEY`, report the missing mapping, and do not perform guessed system-scoped discovery.

## Source Channels

Request retrieval from or search, when available:

1. Jira through the connector capability described in [../../../connectors/atlassian/jira-source-contract.md](../../../connectors/atlassian/jira-source-contract.md).
2. Confluence through the connector capability described in [../../../connectors/atlassian/confluence-source-contract.md](../../../connectors/atlassian/confluence-source-contract.md).
3. Local knowledge under `knowledge/systems/{SYSTEM_KEY}/BRD`, `CR`, `Decisions`, and `Specifications`.

Do not embed Jira or Confluence API implementation, credentials, URLs, or company-specific query syntax in this BA skill.

## Workflow

### 1. Identify the system and search context

Parse the request and resolve its System Key, System Name, or Alias against the registry. Carry the canonical System Key and System Name through discovery. Build primary and secondary terms from the feature, entity, module, screen, GEO, and related behavior.

### 2. Select discovery mode

**Discovery Mode:** Start Jira discovery from the resolved registry Jira Summary Pattern, then allowed issue types, then feature relevance. Do not start with a global feature search.

**Direct Reference Mode:** If an issue key or Jira URL is supplied, retrieve it first, determine its system and feature from accessible content, and search related or superseding system-scoped tickets when necessary. A direct reference does not disable related discovery.

Follow [references/jira-search-rules.md](references/jira-search-rules.md) for both modes.

### 3. Discover Confluence and local sources

Search Confluence using both the resolved System Key and System Name before feature, module, screen, and business terms. Search only the resolved registry Knowledge Path as fallback or additional evidence. Apply [references/source-discovery-rules.md](references/source-discovery-rules.md) to all channels.

### 4. Inspect and normalize candidates

Search result titles are candidate indicators only. Inspect accessible content and metadata before selection. Normalize available fields without inventing missing metadata:

- `source_id`, `source_type`, `source_system`, `system_key`
- `title`, `location`, `external_url`, `issue_key`
- `document_version`, `document_status`, `issue_type`, `jira_status`, `release_status`
- `created_date`, `updated_date`, `effective_date`
- `matched_keywords`, `relevance`, `accessible`
- `selected_for_analysis`, `selection_reason`

Use `Unknown` where applicable.

### 5. Classify candidates

Assign exactly one discovery classification:

- **SELECTED:** relevant enough to pass to Current State Analyzer.
- **RELATED:** supporting context but not primary evidence.
- **EXCLUDED:** not relevant to the requested system or feature.
- **UNVERIFIED:** potentially relevant but evidence is insufficient.
- **INACCESSIBLE:** a reference exists but its content cannot be retrieved.
- **CROSS_SYSTEM_SUPPORTING_SOURCE:** inspected content belongs to another registered system but explicitly documents an integration or dependency relevant to the target system; never merge its requirements into target-system evidence.

System-key match alone is insufficient for `SELECTED`.
Primary candidates must belong to the resolved system. Exclude other-system candidates unless their inspected content explicitly documents a cross-system integration or dependency.

### 6. Assess discovery confidence

Return **High**, **Medium**, or **Low** based on channel availability, source coverage, content accessibility, relevance, authority metadata, and unresolved conflicts. Reduce confidence when Jira or Confluence is unavailable or material content is inaccessible.

### 7. Handoff

Pass the resolved System Key and System Name, explicitly provided sources, and `SELECTED` Jira, Confluence, and Local sources to `ba-current-state-analyzer`. Pass `RELATED`, `UNVERIFIED`, `INACCESSIBLE`, `CROSS_SYSTEM_SUPPORTING_SOURCE`, exclusions, connection failures, and conflicts as discovery context - not as confirmed evidence.

The discovery flow is:

```text
User Request
      |
System Registry
      |
Canonical System Key
      |
+-----------+-------------+----------+
|           |             |          |
Jira     Confluence     Local         |
|           |             |          |
+-----------+-------------+----------+
      |
Source Selection
      |
Current State Analyzer
```

## Output Contract

Return exactly this structure:

# Source Discovery Result

## 1. Search Scope

System:
System Key:
GEO:
Module:
Screen:
Feature:

## 2. Search Terms

Primary:
Secondary:

## 3. Jira Search Scope

System Summary Pattern:
Allowed Issue Types:

## 4. Relevant Jira Sources

| Issue | Summary | Type | Status | Release | Relevance | Selection |
|---|---|---|---|---|---|---|

## 5. Relevant Confluence Sources

| Page | Type | Status | Version | Relevance | Selection |
|---|---|---|---|---|---|

## 6. Relevant Local Sources

| Source | Type | Relevance | Selection |
|---|---|---|---|

## 7. Excluded Sources

| Source | Reason |
|---|---|

## 8. Missing / Inaccessible Sources

## 9. Sources Selected for Current State Analysis

## 10. Discovery Confidence

High / Medium / Low

## Grounding Rules

- **SEARCH RESULT ≠ REQUIREMENT EVIDENCE.**
- A title or summary alone cannot establish detailed system behavior.
- Read accessible content before selecting evidence.
- A newer Jira ticket is not automatically Current Production State.
- `Done` does not automatically mean released to production.
- A recently edited Confluence page is not automatically the current production specification.
- Never invent missing source content or metadata.
- Examples illustrate behavior only and are never requirement evidence.

See [examples/ltx-appointment-date-example.md](examples/ltx-appointment-date-example.md) for a fictitious handoff example.

## Failure Handling

- If Jira is unavailable, state `Jira Connection: Unavailable`, do not guess its content, continue with Confluence and local sources, and reduce confidence.
- If Confluence is unavailable, state `Confluence Connection: Unavailable`, do not guess its content, continue with Jira and local sources, and reduce confidence.
- If a key or URL is found but unreadable, record `Source Found: Yes`, `Content Accessible: No`, and `Evidence Usable: No`; classify it `INACCESSIBLE`.
- If the System Key is unknown, return `UNKNOWN_SYSTEM_KEY` and do not perform a guessed system-scoped search.
- If all usable channels fail, return a Low-confidence discovery result identifying the exact missing retrieval capabilities.

## Quality Checks

- System mapping comes from the registry or is reported unknown.
- Jira discovery starts with System Key and allowed issue types, except direct retrieval starts with the explicit reference.
- Candidates are content-inspected where accessible before selection.
- Cross-system results are not selected as target-system evidence.
- Cross-system sources are classified `CROSS_SYSTEM_SUPPORTING_SOURCE` only when inspected content explicitly documents a dependency or integration.
- Release and production state are not inferred from recency or generic status names.
- Every candidate has a classification and selection reason where applicable.
- Only explicitly provided and `SELECTED` sources are handed off for evidence validation.
- No BA artifact or Target State is generated.
