# Source Discovery Result

## 1. Search Scope

System: Latam Express
System Key: LTX
GEO: Not specified
Module: FFM and LM
Screen: Order List; LM exported files where explicitly referenced
Feature: Appointment Date

## 2. Search Terms

Primary: `[LTX]`, `Appointment Date`, `Appointment`
Secondary: `LM`, `FFM`, `Order List`, `date format`, `exported files`

## 3. Jira Search Scope

System Summary Pattern: `[LTX]`
Allowed Issue Types: Story, CR, Task

## 4. Relevant Jira Sources

| Issue | Summary | Type | Status | Release | Relevance | Selection |
|---|---|---|---|---|---|---|
| [TM-8797](https://accelo-tech.atlassian.net/browse/TM-8797) | [LTX][FFM & LM Order List] Add Appointment Date and Display All Status Options | CR | Done | Unknown | High - inspected content defines the FFM Appointment Date gap and requires the FFM value, source, format, and logic to match LM; blank when unavailable. | SELECTED - direct, detailed Appointment Date requirements and acceptance criteria. |
| [TM-8739](https://accelo-tech.atlassian.net/browse/TM-8739) | [LTX][Order List (LM)] Hide Time in Appointment Date Column | Task | Done | Unknown | High - inspected content defines the LM display and export format as `YYYY-MM-DD`, without changing the stored value or business logic. | SELECTED - direct, detailed Appointment Date behavior and acceptance criteria. |
| [TM-8570](https://accelo-tech.atlassian.net/browse/TM-8570) | [LTX] Improve UI/UX | Task | Done | Unknown | High - inspected content explicitly adds Appointment Date to the LM Order List and identifies its column position. | SELECTED - earlier content-level evidence for the LM Appointment Date column. |
| [TM-8335](https://accelo-tech.atlassian.net/browse/TM-8335) | [LTX] User can view orders list on LM | Story | Done | Unknown | Medium - inspected content establishes the LM Order List scope and links to the Phase 2 specification, but does not define Appointment Date. | RELATED - supporting LM Order List context only. |
| [TM-8331](https://accelo-tech.atlassian.net/browse/TM-8331) | [LTX] User can view orders list on FFM | Story | Done | Unknown | Medium - inspected content establishes the FFM Order List scope and links to the Phase 2 specification, but does not define Appointment Date. | RELATED - supporting FFM Order List context only. |

## 5. Relevant Confluence Sources

| Page | Type | Status | Version | Relevance | Selection |
|---|---|---|---|---|---|
| [BRD Latam Express](https://accelo-tech.atlassian.net/wiki/spaces/LE/pages/1351974923/BRD+Latam+Express) (Page ID 1351974923) | BRD | Current page status; approval status Unknown | 16 | Potentially high by document type, but the retrieved page body was empty and no Appointment Date content could be inspected. | UNVERIFIED - title and metadata alone are not requirement evidence. |
| [Phase 2: MVP](https://accelo-tech.atlassian.net/wiki/spaces/LE/pages/1355448351/Phase+2+MVP) (Page ID 1355448351) | Specification / requirements page | Current page status; approval status Unknown | 20 | Medium - inspected content defines FFM and LM Order List baselines, but no Appointment Date requirement was found. | RELATED - system and screen context only; not detailed Appointment Date evidence. |

## 6. Relevant Local Sources

| Source | Type | Relevance | Selection |
|---|---|---|---|
| `knowledge/systems/LTX/` | Local knowledge path | No files were present under the confirmed LTX path. | UNVERIFIED - no local evidence available. |

## 7. Excluded Sources

| Source | Reason |
|---|---|
| Jira TM-8487 - `[LATAM][Peru] Add the "Appointment Date" Column When Exporting LTX Data` | EXCLUDED from primary evidence because its summary does not contain the confirmed `[LTX]` pattern. Its inspected description contained only an image reference, so it also lacked accessible detailed text evidence. Its unreleased fix version must not be treated as Production. |
| Jira TM-8771, TM-8710, TM-8699, TM-8553, TM-8339, TM-8411, TM-8344, TM-8343, TM-8342, TM-8341, TM-8340, TM-8338, TM-8337, TM-8336, TM-8334, TM-8333, TM-8332, TM-8330, TM-8328, TM-8327, TM-8326, TM-8329 | EXCLUDED - matched the LTX primary scope but inspected candidate content did not provide Appointment Date behavior. |
| Confluence - `[CR] Add Mandatory Note for Delivery Failed Status Updates` (1412890629) | EXCLUDED - inspected content concerns status-update notes, not Appointment Date. |
| Confluence - `[CR] [Order List (FFM)] Add Summary and Detail Options for Order List Export` (1412431876) | EXCLUDED - inspected content concerns export structure and does not define Appointment Date. |
| Confluence - `Phase 1: Release Note` (1367080962) | EXCLUDED - inspected release-note content contains no Appointment Date behavior. |
| Confluence - `Phase 1: Manual` (1356038179) | EXCLUDED - inspected manual content contains no Appointment Date behavior. |
| Confluence - `LATAM EXPRESS` (1355546994) | EXCLUDED - inspected page is a space overview with no Appointment Date requirements. |

## 8. Missing / Inaccessible Sources

- The `BRD Latam Express` page exists and its metadata is accessible, but its retrieved body was empty. Detailed BRD evidence is therefore not usable.
- Confluence searches for `Appointment Date` and `Appointment` within the LATAM/LTX space returned no matching pages.
- No local files were available under `knowledge/systems/LTX/BRD`, `CR`, `Decisions`, or `Specifications`.
- Approval status, effective date, superseded status, and production applicability are not defined in the accessible sources.
- Jira release evidence is absent for TM-8797, TM-8739, and TM-8570. Their `Done` status does not establish release or Production deployment.
- Whether the newest Jira change represents current Production behavior: **Not defined in source.**

## 9. Sources Selected for Current State Analysis

1. Jira TM-8797 - detailed FFM/LM Appointment Date consistency and blank-value requirements.
2. Jira TM-8739 - detailed LM Appointment Date display/export formatting behavior.
3. Jira TM-8570 - earlier LM Order List Appointment Date column evidence.

Discovery context only: Jira TM-8335, Jira TM-8331, and Confluence `Phase 2: MVP` are RELATED; Confluence `BRD Latam Express` is UNVERIFIED. They must not be treated as confirmed detailed Appointment Date evidence without further validation.

## 10. Discovery Confidence

Medium

Jira search and direct content retrieval were available, and three content-inspected sources directly address Appointment Date. Confidence is not High because no usable Confluence BRD/specification content specifically confirms Appointment Date, local LTX knowledge is empty, and release/Production status is not established.
