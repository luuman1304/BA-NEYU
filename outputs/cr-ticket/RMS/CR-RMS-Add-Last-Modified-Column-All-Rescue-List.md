# [RMS] Add Last Modified Column to All Rescue List

## Description

### Applied GEO

All GEOs — phased rollout, applied first for Peru. Whether "Peru first" means Peru only or a broader LATAM set is not defined in source (see Open Questions).

### Business Context / Purpose

Leaders/managers assigning Rescue cases to agents on the All Rescue screen currently cannot see, at a glance, who last updated each case. A "Last Modified" column showing the last user to update the case would help leaders/managers make more informed assignment decisions without opening each case individually.

*Deferred, out of scope for this CR:* The requester also raised a related but more complex idea — letting users choose "Create/Import and Assign" or "Only Create/Import" when creating a case manually. The requester explicitly deferred this as too complex for now, choosing to add the Last Modified column first. This CR does not define requirements for that idea; it is noted here only as background context for a possible future CR.

### Current Behavior

The All Rescue List's current column set (36 columns, per TM-6344) includes an "**Update Date**" timestamp column, but **no user/"Updated By" column** exists in this list today.

The system already has an **assignment audit/history mechanism** that records, for every manual case assignment: Previous assignee, New assignee, **Updated by**, Updated datetime. This "Updated by" data point already exists — it is just not currently surfaced as a column on the All Rescue List itself.

A History tab also exists on the Rescue Job detail, recording all changes made to the job (created, assigned, status updates) until closed.

Manager/Leader role currently accesses the All Rescue screen and manually assigns Rescue cases to agents; a prior change extended manual-assignment capability to authorized Rescue agents as well, scoped to LATAM — establishing a precedent for GEO-phased rollout on this same screen.

*Sources: Jira TM-6344 "[RMS][View][All rescue] TL and CS can view the list and details of related RJs to them in 'All rescue' page" (Done) — full column spec; Jira TM-8526 "[RMS][LATAM] Allow Rescue Agents to View All Rescue Cases and Assign Cases" (Done) — existing "Updated by" audit mechanism (FR3/AC3) and GEO-phased precedent; Confluence "User Guide RMS 2.0" §4.2.2 — History tab.*

### Expected Behavior

1. Add a **Last Modified** column to the All Rescue List, displaying the last user who updated the case. Per requester confirmation, this reflects the last user for **any** update to the case (not limited to assignment changes) — consistent with the existing "Update Date" timestamp column, which is not assignment-specific either. *(Resolves Open Question Q1.)*
2. The column is positioned **immediately next to the Assignee column** in the list. *(Resolves Open Question Q2.)*
3. The column supports **sort and filter**, consistent with other columns in the list. *(Resolves Open Question Q4.)*
4. This column is rolled out first for Peru, then for all other GEOs in a later phase. Whether "Peru first" means Peru only or a broader LATAM set is **not yet defined** — see Open Questions (skipped per requester direction).
5. All other All Rescue List behavior (existing columns, filters, sorting, export) remains unchanged except for the addition of this one column.

## User Story

As a Manager/Leader viewing the All Rescue List,
I want to see who last updated each case,
So that I can make more informed decisions when assigning cases to agents.

## Business Rules

- BR-01: "Last Modified" displays the last user to make any update to the case (not limited to assignment changes). *(Source: requester confirmation)*
- BR-02: The Last Modified column is positioned immediately next to the Assignee column. *(Source: requester confirmation)*
- BR-03: The Last Modified column supports sort and filter, consistent with other list columns. *(Source: requester confirmation)*
- BR-04: This change applies first to Peru; rollout to remaining GEOs is a later, not-yet-defined phase. *(Source: requester confirmation of "Peru first"; exact GEO boundary of "Peru" vs. broader LATAM not resolved — see Open Questions)*
- Not defined in source what underlying data/mechanism populates "any update" (e.g., whether every field-level change reliably captures an "Updated by" user today, beyond the assignment-change audit trail confirmed in TM-8526) — see Open Questions.

## Acceptance Criteria

**AC-01 — Last Modified column displayed for Peru**
Given a Peru user views the All Rescue List,
When the list is displayed,
Then a "Last Modified" column appears immediately next to the Assignee column, showing the name of the last user to update the case.

**AC-02 — Sort and filter supported**
Given a Peru user views the All Rescue List,
When they interact with the Last Modified column,
Then they can sort and filter the list by this column, consistent with other columns.

**AC-03 — Other GEOs unaffected (current phase)**
Given a user in a GEO other than Peru views the All Rescue List,
When the list is displayed,
Then the list is unchanged from current behavior — no Last Modified column is shown, consistent with Peru being the first rollout phase.

**AC-04 — Existing columns and logic unchanged**
Given the Last Modified column is added,
When the All Rescue List is displayed,
Then all other existing columns, their order, and other list logic (other columns' filters, sorting, export) remain unchanged except for the addition of this new column.

## Other Information

- Reference: Jira [TM-6344](https://accelo-tech.atlassian.net/browse/TM-6344) — full current column spec for the All Rescue List
- Reference: Jira [TM-8526](https://accelo-tech.atlassian.net/browse/TM-8526) — existing "Updated by" assignment audit mechanism; GEO-phased (LATAM) rollout precedent on this same screen
- Reference: Confluence "User Guide RMS 2.0" — §4.2.2 (History tab)

## Open Questions / Assumptions

**Resolved (requester confirmation, 2026-09-14):**

1. ~~Should "Last Modified" reflect the last user for any update, or specifically the last assignment change?~~ → **Any update** — consistent with the existing "Update Date" timestamp column's scope.
2. ~~What is the exact position of the new column?~~ → **Immediately next to the Assignee column.**
3. ~~Does "Peru first" mean Peru only, or a broader LATAM set?~~ → **Skipped** — explicitly not pursued per requester direction; not resolved, not assumed.
4. ~~Should the Last Modified column support sort/filter?~~ → **Yes.**

**Still open:**

- The exact GEO boundary of "Peru" (Peru only vs. broader LATAM) — relates to skipped Q3 above.
- Whether the underlying system reliably captures an "Updated by" user for every kind of case field change today, or only for assignment changes as directly confirmed by TM-8526 — implementation should verify data availability for the "any update" scope confirmed in BR-01.

**Assumptions:** None — all items above are either confirmed by the requester or explicitly left unresolved (Q3, skipped).

**Deferred (explicitly out of scope, per requester):**

- Letting users choose "Create/Import and Assign" vs. "Only Create/Import" when creating a case manually. Noted as a possible future CR, not analyzed here.

---

*Readiness: **READY** for the Peru-scoped rollout covered by BR-01–BR-03 and AC-01–AC-04 (per requester confirmation on 2026-09-14). The exact GEO boundary of "Peru" (skipped Q3) and underlying data-availability for "any update" remain open and are out of scope for this CR's acceptance criteria.*
