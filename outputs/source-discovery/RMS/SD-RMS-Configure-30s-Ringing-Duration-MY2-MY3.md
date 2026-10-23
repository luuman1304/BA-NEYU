# Source Discovery Result

## 1. Search Scope

System: Rescue Management System
System Key: RMS
GEO: MY2, MY3 (as stated in request)
Module: Call function on Rescue Job (module/screen not stated in request)
Screen: Not defined in source
Feature: Ringing duration before "End Call" button becomes available

## 2. Search Terms

Primary: ringing, ringing duration, "end call", call button, call popup
Secondary: ring, call, dial, dialer, hang up, MY2, MY3, MYNHI

## 3. Jira Search Scope

System Summary Pattern: `[RMS]`
Allowed Issue Types: Story, CR, Task

## 4. Relevant Jira Sources

| Issue | Summary | Type | Status | Release | Relevance | Selection |
|---|---|---|---|---|---|---|
| TM-8439 | [RMS][LATAM] Update Spanish Translations on Call Popup | Task | Done | Unknown | Confirms an RMS Call Popup exists with statuses (Active, Connected, Unknown). No ringing-duration or End Call logic. LATAM-scoped. | RELATED |
| TM-8394 | [RMS][LATAM] Apply Dialer Profiles to Support WebPhone RTC | Task | Done | Unknown | Dialer profile for WebPhone RTC; no description; no ringing/End Call logic. LATAM-scoped. Comments contain sensitive data — not reproduced. | RELATED |
| TM-6960 | [TH4] [RMS] Check cannot call in RMS | Task | Done | Unknown | Image-only description; TH4 call issue; no ringing/End Call logic. | EXCLUDED |
| TM-6688 | [PH] [RMS] Mapping "Actual call" into the system | Task | Done | Unknown | Empty description; PH-scoped. | UNVERIFIED |

## 5. Relevant Confluence Sources

| Page | Type | Status | Version | Relevance | Selection |
|---|---|---|---|---|---|
| [RMS v2.0 - User Guide](https://accelo-tech.atlassian.net/wiki/spaces/TMSF/pages/1306394627/RMS+v2.0+-+User+Guide) | User guide | current | Unknown (last modified 2026-04-08) | Confirms "Make call" action in My Rescue job detail (§4.3, Manual and Auto Distribution). No ringing duration or End Call rule. | SELECTED |
| [RMS v2 – GEO Release Tracking Page](https://accelo-tech.atlassian.net/wiki/spaces/TMSF/pages/1338015745/RMS+v2+GEO+Release+Tracking+Page) | Release tracking | current | Unknown (last modified 2026-09-11) | Confirms MY2 and MYNHI release status. **MY3 is not listed.** | SELECTED |
| RMS 2.0 / RMS v2.1 / RMS v2.1 Reason Fail / Distribution Rule User Guide | Spec / user guide | current | Unknown | Matched search; summaries show no call-control content. Not fully inspected. | UNVERIFIED |

## 6. Relevant Local Sources

| Source | Type | Relevance | Selection |
|---|---|---|---|
| `inputs/references/RMS_request_My.png` | Stakeholder email (request + IT reply) | Primary request source | SELECTED (explicitly provided) |
| `knowledge/systems/RMS/*` | Local knowledge | Folders empty | N/A |

## 7. Excluded Sources

| Source | Reason |
|---|---|
| TM-9195, TM-9005, TM-8813, TM-7948, BPO-1810, TM-4674 and other "ringing" hits | Other systems (TMS / CEM / AutoDialer / WFM); no documented RMS dependency |
| [WFM] Technical Design Document, Insight Report Guidance, Action plan, MoM 17/12/2025 | Not RMS call-control content |

## 8. Missing / Inaccessible Sources

- No source documents the current ringing duration, ring timeout, or when the "End Call" button becomes available in RMS.
- No source documents whether ringing duration is an existing configurable parameter.
- No source identifies the "MY3" RMS instance.

## 9. Sources Selected for Current State Analysis

1. Stakeholder email — `inputs/references/RMS_request_My.png`
2. Confluence — RMS v2.0 - User Guide
3. Confluence — RMS v2 – GEO Release Tracking Page

Context only: TM-8439, TM-8394.

## 10. Discovery Confidence

Low — Jira and Confluence were reachable, but no inspected source documents the behavior being changed.
