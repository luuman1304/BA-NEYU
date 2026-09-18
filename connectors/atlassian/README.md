# Atlassian Connector Layer

This directory defines the retrieval contracts that BA skills expect for Jira and Confluence. It does not contain BA reasoning, credentials, tenant URLs, or API implementation.

## Current Connection Status

`ATLASSIAN_CONNECTION_REQUIRED`

The inspected development environment exposes no Atlassian-compatible Jira or Confluence tool, MCP server, connector, or repository configuration.

Missing capabilities:

- Jira issue search and issue-content retrieval
- Jira link and release metadata retrieval
- Confluence page search and page-content retrieval
- Confluence version, status, and update metadata retrieval

## Repository Usage

When a compatible external integration is connected, `ba-source-discovery` supplies system-scoped search inputs and consumes normalized outputs described by:

- [jira-source-contract.md](jira-source-contract.md)
- [confluence-source-contract.md](confluence-source-contract.md)

Credentials, API tokens, passwords, personal access tokens, tenant URLs, and other secrets must remain outside source control.
