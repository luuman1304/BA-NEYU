# Current-State Analysis

## 1. Request Context

**Requested change (per CR TM-9010):** Freeze the DO and DR% KPI values shown on the Sales Agent KPI Performance dashboard (LATAM) at the moment Finance's monthly cut-off job runs, so the agent-facing figures stop changing after cut-off and match the DR figures Finance uses for commission. The current, in-progress period continues to recalculate live. No other KPI or GEO is in scope.

**Target:** TMS — Agent KPI Performance dashboard (Performance tab and, per CR, a Realtime tab), LATAM.

**Named reference:** None (no other system/module is cited as a model to copy).

**Analysis scope:** Current DO/DR% calculation and date-source logic, current date-filter/validation behavior, and whether any freeze/snapshot/lock mechanism already exists for any KPI tied to Finance's cut-off.

## 2. Sources Reviewed

| Source | Type | Approval/Version | Scope | Authority Notes |
|---|---|---|---|---|
| Confluence page 1367310337 "[TMS][BRD] Agent performance tracking metric to KPI Performance" | Approved BRD | Current, last modified 2026-06-23 | Defines KPI Performance popup, its filters (MTD/From Date/To Date), and 6 KPIs including DO and DR% | Highest-priority source per Source Priority order (Latest approved BRD). No visible draft/review markers in retrieved content; treated as the approved baseline per Source Discovery selection. |
| Jira TM-9010 (CR) | CR ticket | Status: To Do (not yet implemented/released) | States business context, requests the freeze behavior, and defines Expected Behavior/Acceptance Criteria for the future state | Authoritative for **requested change** and **requester-provided business context** only. Not usable to establish Current State (would require reversing Expected Behavior into Current Behavior, which is prohibited). |

No Confirmed meeting minutes, stakeholder email, or historical ticket documenting a prior freeze/snapshot mechanism was found in Source Discovery.

## 3. Confirmed Current State

All findings below are sourced to the approved BRD (Confluence 1367310337) unless noted.

| # | Finding | Source |
|---|---|---|
| CS-1 | DO is calculated as "Total DO which link with SO validated (SO status = validated)," an Integer, sourced from **SO Created Date**. | BRD §AC5 |
| CS-2 | DR% is calculated as "Total Delivered Orders ÷ Total Validated SO × 100," a Percentage, sourced from **SO Created Date**. | BRD §AC5 |
| CS-3 | The KPI Performance popup filters are: MTD (Quick Filter Button, selected by default), From Date, To Date (Date Pickers). MTD defaults From Date to the first day of the current month and To Date to the current date. | BRD §AC1, §AC2 |
| CS-4 | A user may override MTD with a custom From Date/To Date; doing so unselects MTD and immediately recalculates all KPIs. | BRD §AC3 |
| CS-5 | Existing date validation: From Date cannot be later than To Date; From Date and To Date cannot be later than the current date. Violation blocks the KPI refresh and shows a validation message (EN/ES text defined). | BRD §AC3 |
| CS-6 | KPI values recalculate live/on demand for whatever date range is selected — there is no described exception for any past period. | BRD §AC2, §AC3, §AC4 |
| CS-7 | If a KPI's denominator is 0, the KPI displays 0 / 0% (documented per-KPI in a zero-value table). | BRD §AC6 |
| CS-8 | The BRD documents six KPIs total: Total Lead Calls, AR_QA, AOV, DO, DR%, Revenue Validated, Revenue Delivered — each with its own date source (Lead Modified Date, Lead Created Date, SO Created Date for AOV/DO/DR%/Revenue Validated/Revenue Delivered). | BRD §AC4, §AC5 |
| CS-9 | The approved BRD text describes a single "KPI Performance popup" opened from a header button. It does **not** describe a "Realtime tab" / "Performance tab" split anywhere in its text. | BRD full text (all sections) |

**On the freeze/snapshot mechanism specifically:** the approved BRD contains no field, rule, or AC describing a freeze, snapshot, lock, or cut-off-linked behavior for DO, DR%, or any other KPI. Per the instruction not to reverse Expected Behavior into Current Behavior: **the absence of a freeze mechanism is stated here only because the approved BRD is silent on it, not because CR TM-9010 requests one.** Consistent with CLAUDE.md guidance, the correct current-state statement is:

> **"Current existence of a freeze/snapshot/lock mechanism for DO/DR% (or any KPI) tied to Finance's cut-off is not verified from available source. The approved BRD defines only live/on-demand recalculation (CS-6) and does not document any such mechanism, whether present or absent as a deliberate design decision."**

## 4. Existing Rules and Constraints

- Date-range validation (From ≤ To; neither > current date) applies today to the single documented KPI Performance popup (CS-5).
- All KPIs share the popup-level filters but each has its own date source; the system does not use one date source for all KPIs (BRD §AC4, explicit rule).
- KPI scope is the logged-in user (agent) only (BRD §AC4).
- Currency formatting (S/, $) and zero-value handling are defined per KPI (BRD §AC5, §AC6) and are unrelated to any cut-off logic.

## 5. Reference-to-Target Comparison

Not applicable — the CR does not name a separate reference system/module to align with; it defines new behavior for the same TMS KPI Performance feature.

## 6. Gaps and Conflicts

| Gap/Conflict | Impact | Required Resolution |
|---|---|---|
| **G-1: Tab structure not documented in approved BRD.** CR TM-9010's Acceptance Criteria are organized under a "Realtime tab" and a "Performance tab," and its mockups show these as separate views. The approved BRD's text describes only one undivided "KPI Performance popup" (CS-9). | Cannot confirm from source whether the Realtime/Performance tab split is (a) existing production UI that was never back-filled into the BRD text, or (b) a new structural change being introduced by this CR itself. This affects how the BRD update should be framed (documenting existing UI vs. adding new UI). | Confirm with the requester/BA owner whether the two-tab layout already exists in production today. Carried into Open Questions; does not block drafting the DO/DR%-freeze logic itself. |
| **G-2: No corroborating source for the Finance cut-off business context.** The "20th cut-off / 25th data handoff / 30th payment" timeline and the mismatch problem statement are stated in the CR as "requester-provided business context," with no confirmed meeting minutes, stakeholder email, or Finance-owned document in evidence. | The cut-off trigger ("the moment Finance's own cut-off job runs") is the core mechanism the whole feature depends on, but its exact timing/ownership/interface is not independently confirmed. | Classify as Assumption (sourced to CR/requester) in the BRD update; flag as Open Question for independent confirmation (e.g., Finance-owned SLA doc or integration spec for the cut-off job trigger). |
| **G-3: No existing snapshot/storage mechanism documented.** No source (approved BRD, other TMS BRDs found in discovery, or local knowledge) describes any existing period-locking data structure in TMS that this feature could extend. | The BRD update cannot claim reuse of an existing snapshot mechanism; the freeze/storage behavior is wholly new. | State explicitly in the BRD as new behavior, not a modification of an existing mechanism. |

## 7. Assumptions

- A1: The "Realtime tab" and "Performance tab" referenced in CR TM-9010 correspond to the single "KPI Performance popup" documented in the approved BRD, i.e., this CR is adding a tabbed structure to (or documenting an already-tabbed) the same popup — not a separate, previously undocumented screen. *(Sourced to: CR mockup context; not confirmed by approved BRD text — see G-1.)*
- A2: The Finance cut-off business timeline (cut-off on the 20th, data to team ~25th, payment on the 30th) is accurate as stated by the requester. *(Sourced to: CR "Business Context / Purpose," attributed to requester-provided information.)*

## 8. Recommendations

- R1: When the BRD is updated, retain the existing AC1–AC6 numbering and content for the currently-documented popup behavior, and append new ACs (rather than renumbering) for the freeze logic and the Realtime-tab date-picker restriction, to preserve traceability to the approved baseline.
- R2: Record CR TM-9010 explicitly as the source reference inside the updated BRD (e.g., a Change Log or Reference row) so the freeze-related ACs are traceable to their originating ticket.

## 9. Open Questions

- OQ-1: Does the KPI Performance popup already have a "Realtime tab" and "Performance tab" in current production, or is this tab split being introduced by CR TM-9010? (See G-1.)
- OQ-2: Is there a Finance-owned or IT-integration document describing the exact mechanism/timing of "Finance's own cut-off job" that TMS would key its snapshot capture off of? (See G-2.)
- OQ-3: For AC-RT-01 (Realtime tab date-picker restriction to the open period only), does this restriction apply only to the Realtime tab, or should the same open-period restriction also apply to the Performance tab's date picker? The CR's AC-04 for the Performance tab describes selecting "a Month" without describing a picker restriction, which is not fully consistent with AC-RT-01's picker-disabling behavior — clarify whether Performance tab retains its current (BRD §AC3) unrestricted date picker with validation only, or gains its own restriction.

## 10. Readiness Decision

**PARTIAL**

**Supported drafting scope:**
- The DO/DR% freeze/snapshot behavior itself (CR AC-01, AC-02, AC-03, AC-05) can be drafted against the confirmed current formulas, date source, and live-recalculation baseline (CS-1, CS-2, CS-6).
- The statement that no other KPI's date source or live-recalculation behavior changes (CR AC-05 scope limit) is directly traceable to CS-8.
- The custom-range split behavior (CR AC-04, frozen portion vs. open portion) can be drafted as new behavior layered on the confirmed live-calculation baseline (CS-6), while noting it is new mechanism, not a modification of an existing split rule (none exists — G-3).

**Unsupported / carry-to-Open-Questions scope:**
- The Realtime-tab date-picker restriction (CR AC-RT-01) and the tab structure itself cannot be confirmed as pre-existing UI from the approved BRD; the BRD update will document it as requested by the CR while flagging OQ-1 rather than asserting it as previously-existing behavior.
- The exact cut-off trigger mechanism/timing (G-2/OQ-2) remains an Assumption sourced to the requester, not an independently confirmed fact.

**Required additional sources (if full confirmation is desired before finalizing):** a Finance-side document or integration spec for the cut-off job, and confirmation (from the requester or a UI/production screenshot review) of whether the Realtime/Performance tab split already exists in production.

## Source Lifecycle Assessment

- **Documented Baseline:** The approved BRD (2026-06-23) is the documented baseline for DO/DR% formulas, date sources, and filter/validation logic (CS-1 through CS-8).
- **Pending Changes:** CR TM-9010 is a pending, undeployed change request (Status: To Do); its Expected Behavior/AC are proposed future state only.
- **Implemented but unverified production changes:** None identified.
- **Released Changes:** None identified for this feature since the BRD's last modification.
- **Current Production State:** Best-supported current production state = the approved BRD's documented behavior (CS-1 through CS-8), with the caveat that the tab structure (G-1) may be under-documented relative to actual production UI.
- **Unknown / Unverified Behavior:** Existence of a Realtime/Performance tab split in production (G-1); exact Finance cut-off job mechanism/timing (G-2); any existing snapshot/lock infrastructure (G-3, confirmed absent from all reviewed sources).
- **Conflicting Information:** None between sources reviewed (BRD and CR do not contradict each other on formulas or date sources); the only inconsistency is the CR's tab-based AC structure vs. the BRD's non-tabbed text (G-1), which is a documentation gap, not a factual conflict.
