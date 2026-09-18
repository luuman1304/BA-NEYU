# Confluence Source Contract

## Purpose

Define external Confluence retrieval capabilities and normalized responses expected by BA source discovery. This contract retrieves sources; it does not classify their BA relevance or determine Current State.

## Required Capabilities

- Search pages
- Retrieve a page by link or ID
- Retrieve page metadata
- Retrieve or inspect relevant page sections
- Retrieve the canonical page link or ID
- Retrieve version and update information when supported

## Search Inputs

| Input | Description |
|---|---|
| `system` | Confirmed business/system name. |
| `system_key` | Confirmed registry key. |
| `feature` | Requested or reference feature. |
| `module` | Target or reference module. |
| `screen` | Target or reference screen. |
| `keywords` | Business terms and related behavior. |
| `page_url` | Optional explicit page reference. |

The connector may translate these inputs into provider-specific search syntax. It must not invent system aliases or document authority.

## Expected Normalized Output

Return available fields without inventing missing values:

```yaml
connection_status: Available | Unavailable
source_id:
source_type: Confluence
source_system:
system_key:
title:
location:
external_url:
page_id:
document_type:
document_version:
document_status:
approval_status:
superseded_status:
updated_date:
effective_date:
content:
relevant_sections:
accessible: true | false
retrieval_error:
```

Unsupported or unavailable metadata must be `Unknown` or omitted. Recency alone must not be translated into approval, effectiveness, or production authority.

## Safety and Secrets

Authentication and tenant configuration remain outside the repository. Never write credentials, tokens, passwords, or private connector configuration into these contracts or BA skill output.
