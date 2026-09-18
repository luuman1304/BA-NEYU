# [RMS] Add Comment Column to All Rescue Case List Export

## Description

### Applied GEO

Peru first (confirmed — this is the "LATAM first" phase referred to in the request), then all other GEOs in a later phase. Rollout mechanism/timeline for the remaining GEOs not defined in source (see Open Questions).

### Business Context / Purpose

Users exporting the Case List from the All Rescue screen currently cannot see the Comment recorded on each Rescue Job in the exported file. Adding a Comment column lets users review this information directly from the export without opening each Rescue Job individually.

### Current Behavior

The rescue-job list pages (Pre-delivery, All Rescue, and My Rescue) share a common export/layout mechanism. On the All Rescue page specifically, the exported file mirrors the same columns as the on-screen "List of Rescue job" table/grid — the source explicitly notes both "Export" and "Choose column" behave "like current system" against this same column set.

**Confirmed current columns of the All Rescue list/export table** (per TM-6344, with subsequent renames/repositioning from TM-7209 applied):

| # | Column | Note |
|---|---|---|
| — | Checkbox | Selection control for assign/release; TL's All Rescue view only — not an exported data column |
| 1 | Rescue Job ID | string, hyperlink on screen |
| 2 | Job Create Date | renamed from "Create Date" (TM-7209) |
| 3 | Update Date | |
| 4 | Priority | |
| 5 | Assignee | CS Agent Name |
| 6 | Call Attempts | Number of call attempts by this CS; resets on reassignment |
| 7 | Job Status | |
| 8 | CS Status | |
| 9 | Returned Reason | Only shown when CS Status = "Sales can't rescue" |
| 10 | Activity Note | current name: "user note" |
| 11 | CS Sub Status | repositioned to immediately after Activity Note (TM-7209); originally appeared before Activity Note (TM-6344) |
| 12 | Redelivery Date | |
| 13 | Pre-delivery Action | |
| 14 | Campaign Name | |
| 15 | Product | |
| 16 | Price | |
| 17 | Delivery Service | |
| 18 | Carrier | current name: "Courier Name" |
| 19 | Lastmile Reason | |
| 20 | Lastmile Sub Reason | |
| 21 | Lastmile Return Code | |
| 22 | Actual Redelivery Date | |
| 23 | Lead ID | |
| 24 | Lead Name | current name: "Client Name" |
| 25 | Lead Phone | current name: "Client Phone" |
| 26 | TMS DO Create Date | renamed from "Lead Create Date" (TM-7209); value from TMS "createdate" field |
| 27 | Lead Time | |
| 28 | Source Name | |
| 29 | Total Call | |
| 30 | Actual Call | |
| 31 | Province | |
| 32 | Tracking Code | |
| 33 | DO ID | |
| 34 | DO Code | |
| 35 | DO Status | |
| 36 | DNC | |

*"Sub Return Reason" was removed from this table in the same TM-6344 redesign and is not part of the current column set.*

**Important history — Comment was already in this table once, and was removed:** TM-6344's original column spec included a "Comment" column, struck through with the note **"remove, duplicate with activity note."** No later source confirms it was re-added. This CR should confirm with the requester/product owner whether that "duplicate with Activity Note" rationale still applies before re-adding Comment as a separate column (see Open Questions/Recommendations).

A **Comment** field exists today on the **Rescue Job Detail** screen (not the list/export) as its own distinct input field — separate from both "activity note" and "sale note" (per TM-6344's Rescue Job Detail "Column to display" spec: `activity note | input text`, `sale note | string`, `comment | input text` are three separate fields). This is also consistent with the Confluence User Guide, which shows Comment captured at Rescue Job creation and displayed on the Summary tab alongside Sale Note.

GEO-scoped changes to the export's display have a precedent that preserves underlying logic: the Peru/Spanish translation change explicitly stated the exported data, file format, filters, and export logic remained unchanged — only labels/values were localized.

*Sources: Jira TM-6344 "[RMS][View][All rescue] TL and CS can view the list and details of related RJs to them in 'All rescue' page" (Done) — Table Header column spec and Rescue Job Detail column spec; Jira TM-7209 "[RMS] Change meaning, field name and position in export file and layout" (Done); Jira TM-8249 "[RMS][PERU] Support Spanish Translation for Rescue Export" (Done); Confluence "User Guide RMS 2.0" §4.1, §4.2.1, §5.3.*

### Expected Behavior

1. Add a **Comment** column to the file produced when a user exports the Case List from the All Rescue screen, populated from the **Comment field on the Rescue Job Detail** screen (confirmed by requester — the distinct "comment" input-text field, not Activity Note or Sale Note).
2. The Comment column is added as the **last column** in the export (confirmed by requester), after all existing columns listed above.
3. All other export logic — data, file format, filters, all existing columns and their order — remains unchanged, consistent with the precedent set by the Peru/Spanish translation change (TM-8249).
4. This column is rolled out first for **Peru** (confirmed by requester as the "LATAM first" phase), then for all other GEOs in a later phase. The rollout mechanism/timing for the remaining GEOs is **not yet defined** — see Open Questions. This CR does not assume or specify that logic.

## User Story

As a user exporting the Case List from the All Rescue screen,
I want the exported file to include a Comment column,
So that I can review the Comment recorded on each Rescue Job directly from the export without opening each job individually.

## Business Rules

- BR-01: The Comment column is sourced from the Rescue Job Detail's distinct "comment" field — not Activity Note, not Sale Note. *(Source: requester confirmation, consistent with TM-6344's field spec)*
- BR-02: The Comment column is appended as the last column in the export; all existing columns and their order (see Current Behavior table) remain unchanged. *(Source: requester confirmation)*
- BR-03: This change applies first to Peru only; rollout to remaining GEOs is a later, not-yet-defined phase. *(Source: requester confirmation)*
- BR-04: A Comment column previously existed in this same table and was removed as duplicate with Activity Note (TM-6344). This CR reintroduces it as a separate column; the original "duplicate" rationale should be confirmed as no longer applicable before implementation. *(Source: TM-6344 — historical context, not a current rule)*
- Not defined in source whether a GEO-scoped configuration mechanism already exists for export columns specifically (as opposed to the language-display mechanism used for the Peru/Spanish precedent) — see Open Questions.

## Acceptance Criteria

**AC-01 — Comment column added for Peru**
Given a Peru user exports the Case List from the All Rescue screen,
When the export file is generated,
Then the file includes all existing columns unchanged, in their existing order, plus a new "Comment" column as the last column, populated from the Rescue Job Detail's Comment field.

**AC-02 — Other GEOs unaffected (current phase)**
Given a user in a GEO other than Peru exports the Case List from the All Rescue screen,
When the export file is generated,
Then the file is unchanged from current behavior — no Comment column is added, consistent with Peru being the first rollout phase.

**AC-03 — Existing columns and logic unchanged**
Given the Comment column is added for Peru,
When the export file is generated,
Then all existing columns, their names, their order, and the export's data/filters/format remain exactly as they are today, except for the appended Comment column.

## Other Information

- Reference: Jira [TM-6344](https://accelo-tech.atlassian.net/browse/TM-6344) — full current column spec for the All Rescue list/export table, and the Rescue Job Detail's field spec (Activity Note / Sale Note / Comment as three distinct fields); also documents the historical removal of "Comment" from this table
- Reference: Jira [TM-7209](https://accelo-tech.atlassian.net/browse/TM-7209) — current export column renames/positions and the shared export mechanism across All Rescue/My Rescue/Pre-delivery
- Reference: Jira [TM-8249](https://accelo-tech.atlassian.net/browse/TM-8249) — precedent for a GEO-scoped export display change that leaves data/format/filters/logic unchanged
- Reference: Confluence "User Guide RMS 2.0" — §4.1 (export capability), §4.2.1 (Comment field on Summary tab), §5.3 (Comment captured at Rescue Job creation)

## Open Questions / Assumptions

**Resolved (requester confirmation, 2026-09-14):**

1. ~~Is "Comment" the same field as "Sale note," or a separate field?~~ → **Separate field** — the Comment field on the Rescue Job Detail screen.
2. ~~What is the complete current column list, and where does the new column go?~~ → **All existing All Rescue columns (listed in Current Behavior) stay as-is; Comment is appended as the last column.**
3. ~~Which GEO(s) does "LATAM first" cover?~~ → **Peru.**
4. ~~Does a GEO-scoped configuration mechanism already exist for export columns?~~ → **Skipped** — explicitly not pursued per requester direction; not resolved, not assumed.

**Still open:**

- Whether the original "duplicate with Activity Note" rationale for removing Comment (TM-6344) still applies, and if so, how this CR's re-addition of Comment as a separate column should address that concern.
- Rollout mechanism/timeline for extending the Comment column to GEOs beyond Peru (relates to skipped Q4 above).

**Assumptions:** None — all items above are either confirmed by the requester or explicitly left unresolved (Q4, skipped).

---

*Readiness: **READY** for the Peru-scoped rollout covered by BR-01–BR-03 and AC-01–AC-03 (per requester confirmation on 2026-09-14). The all-GEO rollout mechanism (skipped Q4) and the historical "duplicate with Activity Note" concern remain open and are out of scope for this CR's acceptance criteria.*
