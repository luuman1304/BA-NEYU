# [PRM] Link Deal & Task into Partner Profile (URD-032)

## Description

### Applied GEO

Not GEO-restricted in source — Partner Management/PRM applies across all GEOs; URD-032 does not state a GEO limitation.

### Business Context / Purpose

As part of the broader PRM Partner-Profile enhancement initiative (following URD-031, Done — removing reliance on Excel/PBI for assignee data by sourcing directly from PRM), the business wants the Partner Profile to centralize Deal and Task visibility per Partner, instead of requiring users to look up Deals/Tasks separately. *(Source: [Google Sheet "Logic Requirement" tab](https://docs.google.com/spreadsheets/d/1BAcmD-oCTd1c4EF3EJalzQUxGdwvLc8QSSH41ebZzws/edit?usp=sharing), URD-032, row group 25–27, Status Requirement = "Ready for BA review".)*

### Current Behavior

Per the already-reviewed sources ([PRM-3050](https://accelo-tech.atlassian.net/browse/PRM-3050), [PRM-3058](https://accelo-tech.atlassian.net/browse/PRM-3058), and the Confluence Release Note [Release Note & User Guide — Deal & Partner Profile Enhancement](https://accelo-tech.atlassian.net/wiki/spaces/PRM/pages/1413120009/Release+Note+User+Guide+Deal+Partner+Profile+Enhancement#7.-Partner-Profile), §7):

- Partner Profile (as specified in [PRM-3050](https://accelo-tech.atlassian.net/browse/PRM-3050), status Waiting To Release) currently contains only business-profile fields (Type, Pub Name, Code, Team Size, Traffic, Language, Country, Working Location, Timezone, Continent, Our GEO, Strong Category, Test Category, KDM, Geo Open, Interesting news about our GEO, Competitor info, Priority, Trust Rate, Working Style) plus a create/edit/confirm permission workflow (Assigned AM, Team Lead, AM Head). **No Deal List and no "Partner change history" table are described in PRM-3050's Acceptance Criteria or in the Release Note's Partner Profile section.**
- Deal already has a **Pub** field linking each Deal to a Partner (confirmed in Jira [PRM-1381](https://accelo-tech.atlassian.net/browse/PRM-1381), "PO Request" field definitions) — the underlying Deal↔Partner data relationship exists. **Confirmed (requester, 2026):** the Deal List to be shown on Partner Profile is a **resurface** of this existing Deal data — i.e., reusing the existing Deal List/data, not a new data source or new underlying Deal List feature, with a confirmed UI column set and tooltip mechanism (see Expected Behavior).
- **Task Management** exists as its own separate top-level module in PRM, with an existing **Task creation screen** (confirmed via `inputs/references/Task-PRM.png` — local screenshot, no web URL available). Current confirmed fields/behavior on that screen:
  - Task Type (e.g. "CS"), with a status flow: **Open → In Progress → In Review → Closed**, plus **Wrong Format** and **Reopen** as additional transitions.
  - Task name, Priority (e.g. Medium).
  - Geo, Offer, **Pub**, Sub (all plain dropdown/lookup fields — no pre-fill mechanism from any other screen is visible in the current form).
  - Assigned Team, Assigned Sub-Team, Type, Sub-Type (lookup fields).
  - Description, Note, Feedback/Action Plan (rich text), Sub-Tasks (grid, with Task name/Feedback/Status/Type/Sub-Type/Assigned Team/Assigned Sub-Team/Assignees columns).
  - Right panel: Assignees, a toggle **"Task must be approved by Owner or Assistant,"** Owner, Watcher, Start Date, Deadline, Created Date, **#** (task number), **Parent task**, **Source**.
  - **Confirmed (requester, 2026): creating a Task from Partner Profile/List, with Partner information pre-filled, is not yet described anywhere** — i.e., this is new behavior to be layered on top of the existing Task creation screen, not something already supported.
- **Confirmed (requester, 2026):** the "Partner change history" shown on Partner Profile already exists as a platform-level change-tracking mechanism — it is not a new audit table to be built; URD-032 only requires surfacing it on the Partner Profile page.

### Expected Behavior

Scoped to URD-032's text (Google Sheet "Logic Requirement," rows 25–27) plus the requester's confirmations resolving the original Gap Analysis (G1–G6, all confirmed).

1. **Deal List in Partner Profile — resurfaced, not new.** Any user who can view a Partner Profile can view a read-only list of Deals associated with that Partner (via the Deal's Pub field), reusing existing Deal data. The list displays the columns shown in the approved mockup (the wireframe's Deal-field set: Deal #, Type, Pub, Sub, Traffic, Geo, Cate, Offer, PO.A, PO.N, AR.EV, AR.ET, AR.C, PO.C, CAP, Lead.FC, Lead.P, Period, Start Lead Date, LDP URL, Note, Request date, Start date, End date, Extended by, User Extended, Status, Sub Status, Reject Reason, AR_QA MRP, AR_QC MRP, DR_MRP, AOV_MRP). Metric/calculated columns display a tooltip describing their formula — four formulas are now confirmed (see **Metric Formulas** table below); the remaining metric columns' formulas are still pending (see Open Questions).

### Metric Formulas (confirmed by requester)

| Metric | Formula | Note |
|---|---|---|
| **AR QC** / AR validated | Approved lead / Total validated lead in TMS | Only counts **Lead type A** and **Fresh lead**. |
| **Avg leads/day** | Total leads / Number of days | — |
| **AOV** (Average order value, USD) | Total order value (USD) / Total orders | Requester phrasing: "có thể hiểu" (i.e., this is the requester's understanding of the formula — treat as confirmed working definition, but flag for final sign-off if AOV is calculated differently elsewhere in the system). |
| **PO Gap** | PO − Max PO | — |

*(Column-name mapping note: these 4 metrics were given by name only — e.g. "AR QC," "Avg leads/day" — and have not been individually matched one-to-one against the exact column labels seen in the wireframe, such as `AR_QC MRP` or `Avg lead`. Also, `PO Gap` and `AOV` appear in the wireframe's separate **"Performance by GEO & cate"** grid, not confirmed to be literally the same columns as the embedded Deal List's `AOV_MRP`/`AR_QA MRP`/`DR_MRP`. Treat the formulas above as confirmed business logic; confirm the exact target column/field during detailed design — see Open Questions.)*
2. **Click-through to Deal Profile.** Clicking a Deal # entry in that list navigates to the corresponding Deal's Deal Profile page.
3. **Task creation by AMM, from the Partner List, using the existing Task creation screen.** The AMM role has a [+] action at the end of each Partner row **on the Partner List**. Clicking it opens the existing Task creation screen (as in `Task-PRM.png`), with the **Pub** field pre-filled to that Partner. The resulting Task is for the AM (per URD-032's wording "tạo task cho AM") and is automatically recorded in Task Management — no separate manual registration step. *(The complete set of fields to pre-fill beyond Pub — e.g. Assignees = the Partner's assigned AM, Assigned Team, Geo — is not yet fully described; see Open Question OQ-1.)*
4. **Partner change history — existing mechanism, new placement.** All users can view a read-only "Partner change history" section on the Partner Profile, surfacing the existing platform change-tracking data, logging: AM actions (request a change / perform a task) and AMM actions (approve / reject / perform a task / edit).

## User Story

As an AM/AMM working a Partner relationship in PRM,
I want to see a Partner's related Deals and manage Tasks for that Partner without leaving the Partner screen,
So that I don't have to cross-reference separate Deal and Task modules manually.

## Business Rules

- BR-01: The Deal List shown on a Partner Profile includes every Deal whose Pub field references that Partner; it is read-only and reuses existing Deal data (resurfaced view, not a new data source). *(Source: URD-032, row 25; requester confirmation on G2.)*
- BR-02: Selecting a Deal # in that list opens the Deal's own Deal Profile page. *(Source: URD-032, row 25.)*
- BR-03: The Deal List columns match the approved mockup's Deal-field set; any metric/calculated column shows a tooltip describing its formula, per the **Metric Formulas** table in Expected Behavior (AR QC, Avg leads/day, AOV, PO Gap confirmed; remaining metrics pending). *(Source: requester confirmation on G5 and formula follow-up.)*
- BR-04: Only the AMM role can trigger Task creation via the [+] action on the Partner List. *(Source: URD-032, row 26; requester confirmation on G1 — action is on the Partner List, not the Partner Profile detail page.)*
- BR-05: Clicking [+] opens the existing Task creation screen (same screen as `Task-PRM.png`), with the Pub field pre-filled to the selected Partner; the task is for the AM. *(Source: URD-032, row 26; requester confirmation on G3 — reuses the existing screen, adds a new Partner-Profile entry point with pre-fill.)*
- BR-06: A Task created this way is automatically recorded as an entry in Task Management — no separate manual step is required to register it there. *(Source: URD-032, row 26.)*
- BR-07: The Partner change history section on Partner Profile surfaces the existing platform-level change-tracking mechanism (not a new audit table); it is view-only for all users and logs both AM-side actions (request / perform task) and AMM-side actions (approve / reject / perform task / edit). *(Source: URD-032, row 27; requester confirmation on G4.)*

## Acceptance Criteria

**AC-01 — Deal List visible on Partner Profile, with mockup columns**
Given a user opens a Partner Profile,
When the profile loads,
Then a read-only list of all Deals linked to that Partner (via Pub) is displayed, using the approved mockup's column set, reusing existing Deal data.

**AC-02 — Metric columns show formula tooltips**
Given the Deal List (or related performance grid) on a Partner Profile,
When the user hovers the AR QC, Avg leads/day, AOV, or PO Gap column,
Then a tooltip shows the confirmed formula (AR QC = Approved lead / Total validated lead in TMS, counting only Lead type A and Fresh lead; Avg leads/day = Total leads / Number of days; AOV = Total order value USD / Total orders; PO Gap = PO − Max PO).
*(For any other metric column not yet listed in the Metric Formulas table, the tooltip formula is not yet defined — see Open Questions.)*

**AC-03 — Click-through from Deal List to Deal Profile**
Given the Deal List on a Partner Profile,
When the user clicks a Deal # entry,
Then the system navigates to that Deal's Deal Profile page.

**AC-04 — AMM creates a Task from the Partner List via the existing Task screen**
Given an AMM is viewing the Partner List,
When the AMM clicks the [+] action at the end of a Partner row,
Then the existing Task creation screen opens with the Pub field pre-filled to that Partner, and upon save the new Task automatically appears in Task Management.

**AC-05 — Non-AMM cannot create a Task this way**
Given a user who is not AMM is viewing the Partner List,
When they look at a Partner row,
Then no [+] task-creation action is available to them (consistent with the related URD-033 permission rule for this same area — see Other Information).

**AC-06 — Partner change history visible**
Given a user opens a Partner Profile,
When they view the change history section,
Then they see the existing platform change-tracking data, read-only, logging AM actions (request / perform task) and AMM actions (approve / reject / perform task / edit).

## Other Information

- Reference: [Google Sheet "Logic Requirement" tab](https://docs.google.com/spreadsheets/d/1BAcmD-oCTd1c4EF3EJalzQUxGdwvLc8QSSH41ebZzws/edit?usp=sharing), URD-032 and its adjoining rows (25–27).
- Reference: Jira [PRM-3050](https://accelo-tech.atlassian.net/browse/PRM-3050), [PRM-3058](https://accelo-tech.atlassian.net/browse/PRM-3058) — current Partner/Contact Profile field scope (does not include this feature).
- Reference: Confluence [Release Note & User Guide — Deal & Partner Profile Enhancement](https://accelo-tech.atlassian.net/wiki/spaces/PRM/pages/1413120009/Release+Note+User+Guide+Deal+Partner+Profile+Enhancement#7.-Partner-Profile), §7 (Partner Profile).
- Reference: Jira [PRM-1381](https://accelo-tech.atlassian.net/browse/PRM-1381) — confirms Deal's Pub field.
- Reference: `inputs/references/Task-PRM.png` — current production Task creation screen (Task Type, status flow, Geo/Offer/Pub/Sub, Assigned Team/Sub-Team, Type/Sub-Type, Description/Note/Feedback-Action Plan, Sub-Tasks, Assignees, approval toggle, Owner/Watcher, Start Date/Deadline, #, Parent task, Source) — baseline this CR's Task-creation entry point builds on. *(Local screenshot — no web URL available to link.)*
- Reference (approved mockup for Deal List columns, per requester confirmation on G5): wireframe artifact [`2_Pub_profile.html` / `1_Deals.html`](https://claude.ai/artifact/WCLtDduLZiW3FX6SxGAQnW).
- Related, not in this CR's scope: URD-033 (auto Strong Category) and URD-034 (field/lifecycle rules) — same [Logic Requirement sheet](https://docs.google.com/spreadsheets/d/1BAcmD-oCTd1c4EF3EJalzQUxGdwvLc8QSSH41ebZzws/edit?usp=sharing) — share the same Partner List permission pattern (non-AM/AMM = view only) but are separate requirements to be reviewed on their own.

## Open Questions / Assumptions

**Resolved (requester confirmation):**

1. ~~G1 — Task-creation location~~ → **Confirmed: on the Partner List screen** (not the Partner Profile detail page).
2. ~~G2 — Deal List: new build or reuse~~ → **Confirmed: resurface/reuse of existing Deal data.**
3. ~~G4 — Partner change history: new or existing~~ → **Confirmed: existing mechanism, only needs surfacing on Partner Profile.**
4. ~~G5 — Deal List columns~~ → **Confirmed: use the approved mockup's column set; metric columns get formula tooltips.**
5. ~~G6 — Scope boundary~~ → **Confirmed: task-creation and change-history rows are in scope of URD-032.**

**Still open:**

1. **OQ-1 (from G3):** The existing Task creation screen (`Task-PRM.png`) has many fields beyond Pub (Geo, Offer, Sub, Assigned Team/Sub-Team, Type/Sub-Type, Assignees, Owner, Deadline, etc.). The requester confirmed Pub should be pre-filled, but there is still **no description of which other fields (if any) should also be pre-filled** — most notably, should **Assignees** be pre-filled with the Partner's assigned AM, matching URD-032's wording "tạo task cho AM"? Needs confirmation before final build.
2. **OQ-2 (partially resolved):** Formulas for **AR QC, Avg leads/day, AOV, and PO Gap** are now confirmed (see Metric Formulas table). **Still pending:** formulas for the other metric columns in the Deal List / performance grid (e.g. `AR_QA MRP`, `DR_MRP`, `AR.V`, `Lead.V`, `DR Act`) are not yet provided — these should come from the "Metric type" / "Chỉ số x Box" tabs in the Logic Requirement workbook, not yet reviewed in this CR. Also pending: confirming the exact column/field each given formula name (e.g. "AR QC," "Avg leads/day") maps to, since the wireframe's labels differ slightly (e.g. `AR_QC MRP`, `Avg lead`).

**Assumptions:** None — remaining uncertain points are carried as Open Questions rather than assumed.

---

*Readiness: **READY** for BR-01–BR-04, BR-06, BR-07 and AC-01, AC-03, AC-05, AC-06 (Deal List resurfacing + click-through, Task-creation entry point and permission, Partner change history), per requester confirmation resolving G1, G2, G4, G5, G6. BR-05/AC-04 (Task pre-fill) and AC-02 (tooltip formula content) carry minor open items (OQ-1, OQ-2) that should be confirmed during detailed design but do not block drafting this CR.*
