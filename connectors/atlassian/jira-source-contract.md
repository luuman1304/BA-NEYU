# Jira Source Contract

## Purpose

Define external Jira retrieval capabilities and normalized responses expected by BA source discovery. This contract does not decide relevance, authority, or Current State.

## Required Capabilities

- Search issues
- Retrieve an issue by key
- Retrieve an issue by URL when supported
- Retrieve issue description and accessible structured sections
- Retrieve issue metadata
- Retrieve linked issues where supported
- Retrieve fix-version and release metadata where supported

## Search Inputs

| Input | Description |
|---|---|
| `system_key` | Confirmed system key from the registry. |
| `summary_pattern` | Confirmed system summary marker, such as `[LTX]`. |
| `issue_types` | Allowed candidate types; normally Story, CR, and Task. |
| `keywords` | Feature, module, screen, entity, and business terms for relevance ranking. |
| `issue_key` | Optional direct issue reference to retrieve first. |
| `issue_url` | Optional direct URL when supported. |

The connector may translate these inputs into provider-specific query syntax. It must not invent mappings or expand issue types without the supplied request.

## Expected Normalized Output

Return available fields without inventing missing values:

```yaml
connection_status: Available | Unavailable
source_id:
source_type: Jira
source_system:
system_key:
title:
location:
external_url:
issue_key:
issue_type:
jira_status:
resolution:
release_status:
fix_versions:
created_date:
updated_date:
description:
current_behavior:
expected_behavior:
business_rules:
acceptance_criteria:
linked_issues:
accessible: true | false
retrieval_error:
```

Unsupported or unavailable metadata must be `Unknown` or omitted. A generic Jira status must not be translated to production release state without an explicitly configured mapping or release evidence.

## Safety and Secrets

Authentication and tenant configuration remain outside the repository. Never write credentials, tokens, passwords, or private connector configuration into these contracts or BA skill output.
