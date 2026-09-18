# Source Discovery Result

## 1. Search Scope

System: Telesale Management System
System Key: TMS
GEO: LATAM
Module: KPI Performance dashboard (Agent-facing)
Screen: KPI Performance popup / Realtime tab / Performance tab
Feature: Freeze DO / DR% KPI values at Finance cut-off

## 2. Search Terms

Primary: TMS, DO, DR%, KPI Performance, Finance cut-off, freeze, snapshot
Secondary: Agent performance, LATAM, Realtime tab, Performance tab, DR Report

## 3. Jira Search Scope

System Summary Pattern: `[TMS]`
Allowed Issue Types: Story, CR, Task (Direct Reference Mode also included the supplied CR directly; Bug/Support/Subtask/Epic rows returned by the broad keyword query were inspected for relevance but are outside the default allowed set)

## 4. Relevant Jira Sources

| Issue | Summary | Type | Status | Release | Relevance | Selection |
|---|---|---|---|---|---|---|
| TM-9010 | [TMS][LATAM] Freeze DO & DO% KPI at Finance Cut off at Agent KPI Performance | CR | To Do | None | Direct reference — this is the change request being analyzed | SELECTED |
| TM-9032 | Request to Add Sales Agent DR Report to TMS – PBI | Support | To Do | None | Title mentions Sales Agent + DR, but description only links to an external, inaccessible ITSM ticket; no inspectable content on KPI Performance or freeze logic | UNVERIFIED |
| TM-6428, TM-6704, TM-6758, TM-6809, TM-6812, TM-6878, TM-6880, TM-7149, TM-7150, TM-7151, TM-8094, TM-8326, TM-8327, TM-8330, TM-8339, TM-8471, TM-8491, TM-8561, TM-8562, TM-8563, TM-8567, TM-8568, TM-8637 | Various "[TMS][DO Reconcile]" / "[LTX] DO status" / DO-related tickets | Story/Task/CR/Bug/Subtask/Epic | Done (mostly) | Various | Keyword match on "DO" only; these concern Delivery Order **reconciliation with 3PL/Finance bank statements** and **DO status sync between TMS/LM/FFM**, not the Agent KPI Performance dashboard or its DR%/cut-off display logic | EXCLUDED |

## 5. Relevant Confluence Sources

| Page | Type | Status | Version | Relevance | Selection |
|---|---|---|---|---|---|
| [TMS][BRD] Agent performance tracking metric to KPI Performance (id 1367310337) | BRD | Current | Last modified 2026-06-23 | This is the approved baseline BRD that defines the existing KPI Performance dashboard, including the current DO/DR% formula, date source (SO Created Date), and live-recalculation behavior (AC4, AC5) — the exact document the CR requests changes to | SELECTED |
| [TMS][BRD] Agent Dashboard (id 1426259969) | BRD | Current | Last modified 2026-09-15 | Different feature (general Agent Dashboard) with no inspected freeze/cut-off content; title suggests possible overlap with "agent" scope only | RELATED |
| [TMS][BRD] Shipping Export Add Offer Rescue Area Columns (id 1432911873) | BRD | Current | Last modified 2026-09-15 | Concerns DR analysis by Offer/Area for OE team exports, not the Agent KPI Performance dashboard or cut-off freeze | EXCLUDED |
| BRD - TMS Dashboard (id 1136295939) | BRD | Current | Last modified 2026-01-09 | Defines a different dashboard (access/config logic), no inspected DR%/cut-off content | EXCLUDED |
| [BRD] SMG & RMS v2.1 Working Calendar and Auto Rescue Job by SLA (id 1340801026) | BRD | Current | Last modified 2026-06-16 | Belongs to RMS (Rescue Management System), a different registered system; concerns DR improvement via rescue jobs, not TMS KPI Performance freeze | CROSS_SYSTEM_SUPPORTING_SOURCE |
| Other keyword hits (Sale Weekly Report, TMS_Functions.xlsx, Technical design for payment term, TMS system overview, Auto Resell Lead, Data Insight Report, etc.) | Various | Current | Various | No inspected content ties these to the Agent KPI Performance DO/DR% freeze logic | EXCLUDED |

## 6. Relevant Local Sources

| Source | Type | Relevance | Selection |
|---|---|---|---|
| `knowledge/systems/TMS/` | Local knowledge path | Path does not exist / contains no files | MISSING |

## 7. Excluded Sources

| Source | Reason |
|---|---|
| DO Reconcile ticket family (TM-6428 epic and its children/tasks) | Different feature: DO/3PL/Finance bank-statement reconciliation workflow, not the Agent KPI Performance dashboard's DO/DR% cut-off freeze |
| [TMS][BRD] Shipping Export Add Offer Rescue Area Columns | Different feature: export columns for OE analysis, not agent-facing KPI freeze |
| BRD - TMS Dashboard | Different dashboard/module (access & configuration), no freeze/cut-off content |
| Non-TMS-feature Confluence hits (Sale Weekly Report, Auto Resell Lead, TMS system overview, etc.) | No inspected relevance to KPI Performance or cut-off/freeze logic |

## 8. Missing / Inaccessible Sources

- `knowledge/systems/TMS/` local knowledge path: no files present (BRD, CR, Decisions, Specifications subfolders not found).
- TM-9032: description references an external ITSM ticket (`itsm.accelo.tech/...`) that is outside the Jira/Confluence connectors and was not retrieved; content accessibility could not be confirmed.
- No Jira or Confluence source was found that documents a prior/existing "freeze," "snapshot," or "cut-off lock" mechanism for any KPI in TMS. Absence of such a source is itself a discovery finding, not evidence that the mechanism does or does not exist.

## 9. Sources Selected for Current State Analysis

- TM-9010 (CR ticket, direct reference — defines Expected Behavior and Acceptance Criteria for the requested change)
- Confluence page 1367310337 — "[TMS][BRD] Agent performance tracking metric to KPI Performance" (approved baseline BRD — defines current DO/DR% formula, date source, filters, and live-recalculation behavior; this is also the document targeted for update)

## 10. Discovery Confidence

**Medium** — Jira and Confluence were both reachable and a directly-matching baseline BRD was found and is content-inspected. Confidence is not High because: (a) no local `knowledge/systems/TMS` sources exist, (b) no independent source (meeting minutes, stakeholder email, or prior ticket) beyond the requester-authored CR itself corroborates the stated Finance cut-off business context, and (c) one loosely-related ticket (TM-9032) could not be content-verified.
