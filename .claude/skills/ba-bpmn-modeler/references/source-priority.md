# Source Priority

Apply this order unless the user identifies a different authoritative source:

1. File or source explicitly provided in the current request.
2. Latest approved BRD.
3. Latest approved CR ticket, Jira ticket, or user story.
4. Existing BPMN (for Update, Review, Explain, Correct, and As-Is baselines).
5. Approved current-state document (`ba-current-state-analyzer` output).
6. Current input request (unattributed description given directly by the user).
7. Authorized Jira or Confluence source (via `ba-source-discovery`).
8. Reference documents (`inputs/references/`, `inputs/attachments/`).
9. Knowledge files (`knowledge/domain/`, `knowledge/glossary/`, `knowledge/standards/`, `knowledge/systems/`, `knowledge/templates/`).
10. User description in the current conversation, treated as unconfirmed unless it matches an approved source.

AI inference is never a confirmed requirement. Classify it as an Assumption, Recommendation, or Open Question.

## Conflict Rules

- Approved sources take precedence over drafts.
- A newer approved source takes precedence over an older approved source.
- A feature-specific source takes precedence over a general system document.
- An explicitly identified source takes precedence for the current request.
- Existing production behavior must not silently override an approved To-Be requirement — surface the tension explicitly instead of picking one.
- Do not silently merge conflicting business rules.
- Report conflicts and request a decision when they materially affect the process (scope, actor responsibility, approval sequence, gateway outcome, exception handling).
- Record every source used in the process-analysis report, distinguishing fact, derived interpretation, and assumption.
- Do not treat AI-generated content — including content produced by this skill in an earlier turn — as approved.

## Atlassian Access

- Do not access Jira or Confluence unless the relevant connector is available and the request authorizes it.
- Route all Jira/Confluence retrieval through `ba-source-discovery`; do not implement independent search logic in this skill.
- Do not write to Jira or Confluence without explicit instruction, per the project's Atlassian Safety Rules.

## Knowledge Lookup

Search relevant knowledge under:

```text
knowledge/domain/
knowledge/glossary/
knowledge/systems/{SYSTEM_KEY}/
knowledge/templates/
```

using the System Key resolved from `knowledge/standards/system-registry.md`. Use system knowledge only when it is relevant to the requested process — do not pad the analysis with unrelated background.
