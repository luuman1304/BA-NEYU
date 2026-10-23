# Current-State Analysis: CPL Deal Postback Rules (ID & TH)

## 1. Request Context

**Requested change (Target State — not yet confirmed as current behavior):**
OPEX team requests implementation of new standardized CPL deal postback rules for all CPL deals in ID & TH, confirmed with AM (Alex Chu) and GMs (Agus Surya Kusuma – ID, Jeremy Duong – TH). Requested deadline: before 12:00 PM 29/09/2026 (GMT+7).

Proposed rule table (`inputs/references/1. request.png`):

| Rule # | Lead Status/Reason | Postback Decision |
|---|---|---|
| 0 | Customer_do_not_order | If ≤8%: Approve all. If >8%: Approve 8% only |
| 1 | Foreigner | Trash |
| 2 | Under 18 years old | Trash |
| 3 | Duplicate_order | Trash |
| 4 | Incorrect_phone_number | Trash |
| 5 | No_COD_area | Trash |
| 6 | Lockdown_area | Trash |
| 7 | Other status | Approve |

Follow-up clarification (`inputs/references/2. request.png`, email from Agus Surya Kusuma, GM, 2026-09-28, thread "Request IT Support - CPL Deals Postback Rules Implementation (ID & TH)"): "closed area" considered trash = **NON COD area + Low DR area**, with Low DR area to be treated as **all NON COD to the partner**.

**Target:** TMS lead-postback decision logic to AFS (AffScale/Scaleo tracker), for CPL deals in ID and TH.

**Named reference:** None — this is a new standardized rule set, not stated as copying another GEO's implementation. However, the request's mechanics (COD/Non-COD, Lockdown, quota-based approval) closely resemble existing mechanisms already built for other GEOs, so those are treated as comparison points, not as a formal "same logic as" reference.

**Analysis scope:** Current TMS postback-decision behavior for CPL deals in ID and TH — specifically: (a) which lead statuses/reasons currently trigger a Trash postback vs. no postback, (b) current area-based (COD/Non-COD/Low DR/Lockdown) postback logic and its deal-scoping, (c) current existence of an 8%-quota-style approval mechanism, and (d) current existence of Foreigner / Under-18 / Duplicate-order / Incorrect-phone-number as trash detection rules.

## 2. System Resolution

- User-confirmed Primary System: **TMS** (Telesale Management System), System Key `TMS`.
- User-confirmed Related/Impacted System: **AFS** (Affscale) — the affiliate/lead partner platform TMS posts back to (via a tracker integration, referred to in evidence as "AffScale"/"Scaleo").
- Resolution required explicit user confirmation because system confidence was not High — "postback"/"CPL deal" language is affiliate-marketing terminology not tied to a single registry system by keyword alone, and no local `knowledge/systems/AFS` or `knowledge/systems/TMS` documentation existed to disambiguate. Confirmed via user Q&A: Primary = TMS, Related = AFS.

## 3. Sources Reviewed

| # | Source | Type | Approval / Status | Scope | Authority Notes |
|---|---|---|---|---|---|
| S1 | `inputs/references/1. request.png` | Stakeholder communication (chat/email image) | Provided by requester, not yet approved as BRD/CR | ID & TH | Defines the requested Target State (8 rules). Not current-state evidence. |
| S2 | `inputs/references/2. request.png` | Confirmed stakeholder email (GM, 2026-09-28) | Sent, acknowledged by IT (Sam Tran, 2026-09-28) | ID & TH | Clarifies target-state intent (Low DR = NON COD to partner). Not current-state evidence. |
| S3 | `inputs/requests/ID COVERAGE CATEGORY REVISE.xlsx` | Local data file (postal-code/subdistrict → CATEGORY AREA, COD/NON COD coverage) | No approval/version metadata present in file | ID | Candidate reference data. **Not confirmed** as the live production Non-COD/Low-DR configuration (no source ties it to SMG's actual config); could equally be a proposed revision. |
| S4 | Jira TM-8189 — "[PERU][CPO] Check the Non-COD or Lockdown area logic on TMS" | Historical ticket, Done | Done, updated 2026-06-02 | **Peru** (Spanish-language UI strings) | Cross-GEO. Establishes the underlying mechanism, not ID/TH-specific values. |
| S5 | Jira TM-8475 — "[ID2][ID3][TMS] Warning for Non-COD / Lockdown Areas" | Historical ticket, Done (Story) | Done, updated 2026-07-07 | **ID2, ID3** | Directly relevant — ID-scoped, extends TM-8189. |
| S6 | Jira TM-8702 — "[TMS] Non COD Deal RC" | Historical ticket, Done | Done, updated 2026-08-12 | Not GEO-tagged in summary; deal names are `-id` suffixed (Indonesia) | Later than TM-8475; conflicts with it (see §6). |
| S7 | Jira TM-8677 — "[TMS][IN] Update Reject and Trash Reasons on TMS" | Historical ticket, Done (Task) | Done, updated 2026-08-11 | **India** | Cross-GEO. Its "Current Logic" section describes a mechanism stated as general (CPA vs. CPL postback eligibility by lead-status type), not India-specific — treated as supporting evidence for the general mechanism only. |
| S8 | Jira TM-8293 — phone-number validation rule | Historical ticket, Done | Done, updated 2026-09-24 | **Peru, Colombia** | Cross-GEO. Country-specific phone-format validation; no ID/TH equivalent found in evidence reviewed. |
| S9 | Jira TM-8935 — "[TMS][TH4] Reason (adv_param1) postback sang Scaleo rỗng" | Historical ticket / bug, Done | Done, updated 2026-09-22 | **TH (org 20 / TH4)** | Directly relevant — TH-scoped, recent, describes current production postback behavior and bugs, including confirmation of an existing 8%-quota mechanism. |
| S10 | Jira TM-712 — "[TMS] - Pending postback Affscale cho nhóm Deal CPL-ID" | Historical ticket, Done | Done, 2023 | **ID** (named CPL-ID deals) | Old but establishes deal-scoped postback administration as a long-standing pattern. |
| S11 | Jira TM-1121 — "[TMS] - CPL ID deal: pending post back Uncalled/Callback lead for Non-COD Province" | Historical ticket, Done | Done, 2023 | **ID** (named CPL-ID deals) | Same pattern as TM-712; lists specific CPL-ID deal codes. |
| S12 | Jira TM-8372 — "[TMS] Refactor the lead postback logic for AFS" (+ subtasks TM-9114–TM-9118) | In-progress ticket | Parent: **In Progress**; 4 subtasks Done, 1 subtask To Do; all updated 2026-09-28 (day before this request) | Not GEO-tagged | **Content inaccessible** — ticket bodies contain no description/spec text retrievable in this pass. Classified `UNVERIFIED` / `INACCESSIBLE` for content, but its existence and timing are confirmed facts. |
| S13 | `outputs/brd/TMS/BRD-TMS-Shipping-Export-Add-Offer-Rescue-Area-Columns.md` | Local existing-system documentation (approved BRD) | Approved (local knowledge artifact) | TMS, GEO not restricted in the cited section | High-authority local source; corroborates S4/S5 by citing TM-8189/TM-8475 as its own sources. |
| — | Confluence | Not searched | N/A | N/A | Confluence discovery was **not performed** in this pass. This is a coverage gap, not a negative finding. |

## 4. Confirmed Current State

### 4.1 Area-based (COD / Non-COD / Lockdown / DR-tier) postback mechanism — Target-system evidence (ID-scoped)

| Finding | Status | Source |
|---|---|---|
| TMS has a read-only **Location Status** field, populated after address validation, sourced from SMG (System Management) configuration keyed by Province/District/Ward/Neighborhood. | Confirmed | S5, S13 |
| Confirmed Location Status values: **Normal, Non-COD, Lockdown, Uncover Area**, plus combined "Delay N days" variants, and newly added **High DR, Low DR** values. | Confirmed | S13 (citing S4/S5 as its own sources) |
| TMS validates the entered address against the Non-COD/Lockdown configuration and displays a warning popup to the agent (ID2 during sales processing, ID3 during order processing). | Confirmed | S5 |
| When rejecting a lead with reason Non-COD or Lockdown, TMS requires Province/District/Ward/Neighborhood to be completed before save. | Confirmed | S5 |
| TMS sends a reject postback to AFS for Non-COD and Lockdown leads by **reusing the same existing postback configuration/workflow** — Lockdown is not a separate postback path from Non-COD. | Confirmed | S4 |
| Postback condition for Non-COD/Lockdown reject: **Lead Type = A** AND Location Status = Lockdown/Non-COD AND the **Non-COD/Lockdown Postback feature flag** is enabled. | Confirmed | S4, S5 (AC4) |
| Reject reason value sent to AFS for this case: `"No_COD_area"` / `"Lockdown_area"` (per TM-8189 AC05) — **these exact reason strings already exist in current production postback payloads**, matching the naming used in the new request's Rule 5/6. | Confirmed | S4 |
| As of TM-8475 (Jul 2026), the Non-COD postback list is **not applied uniformly to all deals** — it is deal-scoped (Pub+Offer), with three distinct list scenarios in production: (1) a list applied to all deals, (2) a list applied only to "ME campaign" deals (at the time, only `HKD duramen-id`), (3) a list applied to 5 named "Low DR" deals (`STR megamove390-id`, `U_ALX paraclean390-id`, `SPT diaclose390-id`, `RMZ vismax390-id`, `RMZ megamove390-id`). | Confirmed | S5 (AC4) |
| As of TM-8475, "Low DR" area was treated as Non-COD **only for those 5 named deals**, not for all CPL deals. | Confirmed | S5 |
| As of TM-8702 (Aug 2026, later than TM-8475), the non-COD rule set was reworked: a new Non-COD list applies to ME/Non-ME deals, but for 4 named deals (`STR megamove390-id`, `CMO glucolab-id`, `SPT binonagamat-id`, `HKD duramen-id`) **all Non-COD rule-checking is removed entirely** (no restriction). | Confirmed | S6 |
| Deal-scoped (not blanket) postback administration for CPL-ID deals has existed since at least 2023 (named deals: `slimmax390cpl-id`, `cellarin390cpl-id`, `glucoherb390cpl-id`, `megaburn390cpl-id`, `megamove390cpl-id`, `prostinol390cpl-id`, `vismax390cpl-id`). | Confirmed | S10, S11 |

### 4.2 Postback eligibility by lead-status type / program type — general mechanism (cross-GEO evidence, not ID/TH-confirmed)

| Finding | Status | Source |
|---|---|---|
| "Lead CPA" programs currently only postback **Approved** and **Rejected** statuses — a lead updated to **Trash does not trigger an AFS postback** under CPA. | Confirmed (as a general/cross-GEO mechanism description; not confirmed specifically for ID/TH) | S7 |
| "Lead CPL" programs currently **do** postback Trash statuses, but **only for COD and non-COD leads** (i.e., not stated to cover other trash reasons such as Foreigner, Under-18, Duplicate order, Incorrect phone number). | Confirmed (as described in S7; ID/TH applicability not independently verified) | S7 |
| Reason-code values sent to AFS/tracker are maintained in a **per-environment/GEO JSON config file** (`config-reason.json`), key-mapped from free-text agent "note" values — this is **not** a fixed enum of 8 rules. | Confirmed for TH (org 20/TH4) production | S9 |

### 4.3 Quota-based approval mechanism ("8%")

| Finding | Status | Source |
|---|---|---|
| TH production already has an **existing 8%-quota approval-limiting mechanism** for trash leads, implemented via `PostbackDecisionService` / an `approvedTrashCount` query pattern that counts `lead_status = TRASH AND postback_status = 'approved'`. | Confirmed | S9 |
| A confirmed bug (RC5) currently causes this quota counter to be incorrectly consumed: `cl_fresh.postback_status` can be set to `'approved'` before the system confirms the postback was actually sent, so blocked/failed postbacks still consume an 8% quota slot. | Confirmed | S9 |
| This 8%-quota mechanism is the closest existing behavior to the new request's Rule 0 (Customer_do_not_order: ≤8% approve all / >8% approve 8% only), but **no evidence confirms its exact current formula matches Rule 0's specific ≤8%/>8% approval logic** — S9 documents the quota's *existence and a defect*, not its precise business formula. | Confirmed existence; formula **Not defined in source** | S9 |

### 4.4 Reason-mapping and postback-value bugs currently in production (TH)

| Finding | Status | Source |
|---|---|---|
| In TH (org 20/TH4), the `adv_param1` (reason) field sent to the AFS/Scaleo tracker is empty in **~89.8%** of postbacks-with-note in the sampled window (2026-09-01–2026-09-10), due to case-sensitive key lookups, missing config keys, and timestamp-embedded note text that doesn't match any static key. | Confirmed | S9 |
| A separate rule referred to as "TM-8773" can override a lead's postback `type` to "approve" under certain conditions even when the underlying lead status is Trash, decoupling `conv_status` from the `reason` value sent. | Confirmed (existence of this override rule); **rule TM-8773's own content was not independently retrieved in this pass** | S9 (references TM-8773 by name; not separately fetched) |

### 4.5 Detection rules for specific trash reasons proposed in the new request (Rules 1–4)

| Requested Rule | Current TMS behavior found in reviewed evidence |
|---|---|
| Foreigner → Trash | **Not defined in source.** No ID/TH-specific "Foreigner" detection/trash rule found in reviewed evidence. |
| Under 18 years old → Trash | **Not defined in source.** No age-validation rule found in reviewed evidence. |
| Duplicate_order → Trash | **Not defined in source.** No duplicate-order detection rule found in reviewed evidence (S7 lists "Duplicated" as an existing India reason label only, not confirmed for ID/TH, and not describing detection logic). |
| Incorrect_phone_number → Trash | A phone-format validation rule (auto-trash + postback reason "Invalid Phone Number") **exists for Peru and Colombia** (S8), keyed to country-specific digit-length/prefix patterns. **No equivalent rule confirmed for Indonesia or Thailand** in reviewed evidence. |

Per CLAUDE.md grounding rule: the current absence of a documented rule must not be read as proof the rule doesn't exist elsewhere in TMS — it is stated here only as "not found in the sources reviewed in this pass," which did not include Confluence or the current TMS validation-rule configuration/codebase directly.

## 5. Existing Rules and Constraints (applicable to this feature)

- Postback triggering for Non-COD/Lockdown reject requires **Lead Type = A** and a feature flag to be enabled (S4, S5) — any new blanket rule must reconcile with this flag/lead-type gating rather than assume postback is unconditional.
- Non-COD/Low-DR postback lists are **deal-scoped** (by Pub+Offer), not global, in the only confirmed area-based mechanism (S5, S6, S10, S11). A "blanket rule for all CPL deals in ID & TH" (as requested) would be a **change** to this existing deal-scoped administration pattern, not a continuation of it.
- Reason values sent to the partner are maintained in a per-GEO/environment config file, not a centralized fixed rule table (S9).
- Existing reject/trash reason lists differ by GEO and are separately maintained (India example in S7); no unified ID/TH reason taxonomy was found in the sources reviewed.

## 6. Reference-to-Target Comparison

No named reference implementation was specified by the requester (this is not a "same logic as X" request). The comparison below is between **prior/other-GEO mechanisms** (Peru, India, Colombia) used as illustrative precedent and the **ID/TH target state**:

| Dimension | Peru/Colombia/India precedent | ID/TH target evidence |
|---|---|---|
| Non-COD/Lockdown reject postback reuse | Confirmed mechanism (S4) | Confirmed present in ID2/ID3 (S5), TH-specific area logic not directly evidenced beyond the general TH postback pipeline (S9) |
| Deal-scoped Non-COD lists | Not evidenced outside ID | Confirmed for ID (S5, S6); **no TH deal-scoped list evidenced** in sources reviewed |
| Phone-format validation → auto-trash | Confirmed for Peru/Colombia (S8) | **Not evidenced for ID or TH** |
| Trash-reason taxonomy | Confirmed distinct list for India (S7) | **No unified ID/TH taxonomy found**; TH reason values are free-text-mapped via config file (S9) |

## 7. Gaps and Conflicts

| # | Issue | Impact | Required Resolution |
|---|---|---|---|
| C1 | **TM-8475 vs. TM-8702 conflict**: TM-8475 (Jul 2026) names "5 Low DR deals" under a specific Non-COD list; TM-8702 (Aug 2026, later) names "4 deals" with **all** Non-COD rule-checking removed. The deal lists only partially overlap (`megamove390-id`, `duramen-id` appear in both under different treatment). Both tickets are Done. | Cannot state a single confirmed current Non-COD deal-exception list for ID without reconciling these two Done tickets. | Confirm with TMS engineering/PO which deal-exception configuration is currently live in production (TM-8475's 3-tier structure, TM-8702's override, or a merged state). |
| C2 | **TM-8677's CPA/CPL postback-eligibility rule is not confirmed for ID/TH.** It is described in an India-scoped ticket as general behavior, but no ID/TH source independently confirms "CPL currently postbacks Trash only for COD/non-COD leads" holds true for ID/TH CPL deals. | Directly affects feasibility of Rules 1–4, 7 (Trash postback for Foreigner/Under18/Duplicate/Incorrect-phone/Other), since if CPL currently only postbacks Trash for COD/non-COD, extending it to other trash reasons is a **behavior change**, not a restatement of current behavior. | Confirm current TH/ID CPL Trash-postback eligibility directly (code/config review or PO confirmation), not inferred from an India ticket. |
| C3 | **TM-8372 and subtasks TM-9114–TM-9118 (active "Refactor the lead postback logic for AFS", updated the day before this request) have no accessible description/spec content.** Most BE subtasks are marked Done as of 2026-09-28, with the parent still In Progress and one subtask still To Do. | This refactor may already implement part of, or conflict with, the OPEX request. Drafting a BRD/CR without knowing its scope risks duplicate or contradictory work. | Obtain the actual scope/spec of TM-8372 from its assignee/PO before finalizing any new BRD/CR for this feature. |
| C4 | **`ID COVERAGE CATEGORY REVISE.xlsx` is not confirmed as the live production Non-COD/Low-DR configuration.** No source ties this file to SMG's actual configuration or to any of the Non-COD list names referenced in TM-8475/TM-8702 ("1. Non COD list", "2. ME COVERAGE list", "3. Extend NON COD List"). | If treated as current production data without confirmation, downstream BRD/CR area-eligibility claims would be unverified assumptions presented as fact. | Confirm with the data owner (OPEX/GM team) whether this file represents the current live coverage config, a proposed revision, or a separate ad hoc analysis. |
| C5 | **Rule 0's exact 8%-quota formula is not confirmed.** An 8%-quota mechanism exists in TH production (S9) but its precise approval formula, and whether/how it applies to ID, is **not defined in source**. | Cannot confirm whether Rule 0 as proposed is a continuation of existing logic or a new/changed formula. | Confirm the current 8%-quota formula and its GEO scope (TH only, or also ID) directly from PostbackDecisionService owners. |
| C6 | **No ID/TH-specific detection logic found for Foreigner, Under-18, Duplicate_order, or Incorrect_phone_number.** Phone validation exists only for Peru/Colombia (S8); reason labels exist for India (S7) but not confirmed for ID/TH. | Rules 1–4 may require **new** detection logic in TMS for ID/TH, not just a postback-mapping change — materially larger scope than a "postback rules" ticket alone. | Confirm with TMS engineering whether any of these four detection mechanisms already exist for ID/TH under different naming, before scoping as new-build. |
| C7 | **Confluence was not searched in this pass.** | Possible additional current-state documentation (e.g., a CPL postback specification page) was not checked. | Perform Confluence discovery (System Key `TMS` and name "Telesale Management System") before final BRD/CR drafting. |

## 8. Assumptions

*(None presented as confirmed fact; all uncertain points are captured as Open Questions or Gaps above rather than assumptions, per grounding rules — no current-state assumption was necessary to complete this analysis.)*

## 9. Recommendations

- **Recommendation:** Before drafting a BRD/CR, obtain a direct answer from TMS engineering/PO on TM-8372's actual scope (C3), since it is the most recent and most directly on-point active work item and may materially change what "current state" means for this feature as of today (2026-09-29).
- **Recommendation:** Treat the requested Rule 0–7 table as a **policy standardization** request rather than a pure "restate current behavior" request — evidence indicates today's ID/TH postback behavior is deal-scoped, GEO-fragmented, and partially bug-affected (S6, S9), not a single uniform 8-rule table. The BRD/CR should explicitly document this as a behavior change, not a continuation of existing logic, for Rules 1–4 and the "blanket for all CPL deals" aspect of Rules 5–6.

## 10. Open Questions

1. Which Non-COD deal-exception configuration is currently live in production for ID — TM-8475's 3-tier list structure, TM-8702's override, or a merged/superseding state? (C1)
2. Does TMS currently postback Trash status for CPL deals in ID and TH for reasons beyond COD/non-COD (e.g., would Rules 1–4 as proposed require new postback-trigger logic, not just a reason-mapping change)? (C2)
3. What is the actual scope and content of TM-8372 / TM-9114–TM-9118 ("Refactor the lead postback logic for AFS"), and does it already address any part of this request? (C3)
4. Is `ID COVERAGE CATEGORY REVISE.xlsx` the current live production Non-COD/Low-DR coverage configuration, or a proposed/candidate revision? (C4)
5. What is the current exact 8%-quota approval formula in `PostbackDecisionService`, and is it currently active for ID, TH, or TH only? (C5)
6. Do Foreigner, Under-18, Duplicate-order, and Incorrect-phone-number detection mechanisms already exist for ID/TH under different names/config, or must they be newly built? (C6)
7. Does Confluence hold a current CPL postback specification for TMS that was not covered in this pass? (C7)

## 11. Readiness Decision

**PARTIAL.**

**Supported drafting scope:**
- Documenting the existing Non-COD/Lockdown postback-reuse mechanism, its Lead-Type/feature-flag gating, and its existing reason strings (`No_COD_area`, `Lockdown_area`) as current-state baseline for Rules 5–6's *mechanism* (postback path already exists) — while flagging that *blanket, all-deal* application is a scope change from the confirmed deal-scoped precedent (S5, S6, S10, S11).
- Documenting the existing 8%-quota mechanism's *existence* (not its exact formula) as current-state context for Rule 0.
- Documenting the current reason-mapping bug in TH (S9) as relevant existing-defect context that any new postback rule work should account for.

**Unsupported drafting scope (must not be presented as current state without further evidence):**
- Rules 1–4 (Foreigner, Under-18, Duplicate_order, Incorrect_phone_number) — no confirmed ID/TH detection logic exists; these should be scoped as new requirements, pending resolution of Open Question 6.
- The exact Rule 0 8%-quota formula — existence is confirmed, formula is not.
- Whether the xlsx coverage file is production configuration — must be confirmed before being cited as current Non-COD/Low-DR data in any BRD/CR.
- The precise current Non-COD deal-exception list for ID — conflicting Done tickets (C1) must be reconciled first.

**Required additional sources before BLOCKED items can move to READY:**
- Direct confirmation from TMS engineering/PO on TM-8372 scope, the TM-8475/TM-8702 conflict, and the 8%-quota formula.
- Confluence discovery for TMS.
- Confirmation from OPEX/GM on the xlsx file's production status.

## Source Lifecycle Assessment

| Lifecycle Category | Applicable Findings |
|---|---|
| **Documented Baseline** | Location Status field values and SMG-sourced validation (S5, S13); Non-COD/Lockdown postback reuse mechanism (S4, S5). |
| **Pending Changes** | None confirmed as pending-only; the request itself (S1, S2) is the pending change under evaluation. |
| **Implemented but unverified production changes** | TM-8372 refactor and subtasks (S12) — implementation activity is evidenced (Done subtasks) but scope/content and production release are not verified from accessible ticket text. |
| **Released Changes** | Non-COD/Lockdown warning and postback (TM-8189, TM-8475) — Done with detailed ACs, treated as released given local BRD (S13) independently corroborates the resulting field values are live. |
| **Current Production State** | TH postback pipeline behavior and its reason-mapping defect (S9) — directly evidenced from production log data (`log_integrate_partner`, org 20) with dated volume statistics, the strongest production-state evidence in this set. |
| **Unknown / Unverified Behavior** | ID/TH Foreigner, Under-18, Duplicate-order, Incorrect-phone-number detection; exact 8%-quota formula; xlsx file's production status; TM-8372 scope. |
| **Conflicting Information** | TM-8475 vs. TM-8702 deal-exception lists (C1). |
