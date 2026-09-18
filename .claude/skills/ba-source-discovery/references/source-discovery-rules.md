# Source Discovery Rules

## Separation of Responsibilities

The BA skill determines what to search, relevance, classification, selection, and handoff. External connectors perform retrieval and return normalized content and metadata. Do not place credentials, API calls, or vendor-specific authentication in BA instructions.

## Confluence Discovery

Prefer Confluence for BRDs, functional specifications, business specifications, approved requirement documentation, and decision documents.

Build searches using combinations of:

- Resolved System Key and System Name from `knowledge/standards/system-registry.md`
- Feature and entity
- Module and screen
- Business terms and related behavior

For a relevant page, capture where accessible:

- Page title, URL or ID, and document type
- System, module, and feature
- Version, status, and last-updated date
- Effective date, approval status, and superseded status

Use both the canonical System Key and System Name before feature or module terms. A generic feature match does not establish system ownership. The most recently edited page is not automatically the current production specification. Missing metadata remains `Unknown`.

## Local Knowledge Discovery

Search only the confirmed system path from the registry:

- `knowledge/systems/{SYSTEM_KEY}/BRD`
- `knowledge/systems/{SYSTEM_KEY}/CR`
- `knowledge/systems/{SYSTEM_KEY}/Decisions`
- `knowledge/systems/{SYSTEM_KEY}/Specifications`

Local knowledge is a fallback, cache, or additional evidence source. Do not automatically rank it above newer confirmed enterprise sources. Do not require enterprise documents to be copied locally.

## Relevance and Selection

Assess candidates using:

- Correct system and scope
- Feature, entity, module, and screen match
- Content-level evidence, not title alone
- Source authority, approval, version, and effective date where known
- Relationship to reference and target behavior
- Superseding, dependency, release, and conflict information

Classify each candidate as `SELECTED`, `RELATED`, `EXCLUDED`, `UNVERIFIED`, `INACCESSIBLE`, or `CROSS_SYSTEM_SUPPORTING_SOURCE`. Use `CROSS_SYSTEM_SUPPORTING_SOURCE` only when inspected content explicitly documents an integration or dependency with the resolved target system. Keep the systems' requirements separate. Record why a candidate was selected or excluded.

## Evidence Boundary

Discovery selects sources; it does not confirm Current State. Search snippets, filenames, summaries, and example documents are not sufficient evidence of detailed behavior. Current State Analyzer must independently validate selected content.

## Connection Failures

Continue across remaining channels when one channel is unavailable. Never simulate or reconstruct inaccessible Jira tickets or Confluence pages. Reduce Discovery Confidence in proportion to the missing coverage and report the missing capability.
