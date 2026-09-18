# TC-SD-004 — Inaccessible Atlassian

## Skill Under Test

BA Source Discovery

## Input Condition

Jira and Confluence retrieval are unavailable.

## Expected Behavior

- Report `Jira Connection: Unavailable`.
- Report `Confluence Connection: Unavailable`.
- Do not guess Jira ticket content or Confluence document content.
- Continue discovery under the confirmed `knowledge/systems/{SYSTEM_KEY}/` folders when the System Key is known.
- Classify known but unreadable references as `INACCESSIBLE`.
- For a found but unreadable key or URL, report:
  - `Source Found: Yes`
  - `Content Accessible: No`
  - `Evidence Usable: No`
- Reduce Discovery Confidence to reflect missing enterprise-source coverage.
- Identify the missing Jira and Confluence retrieval capabilities.

## Forbidden Behavior

- Do not fabricate credentials, URLs, results, summaries, metadata, or content.
- Do not treat connection failure as proof that no enterprise sources exist.
- Do not stop local discovery solely because Atlassian is unavailable.

## Pass Criteria

The result reports both outages, performs any available local fallback, invents no content, and returns appropriately reduced confidence.
