# [TMS] Standardize CPL Deal Postback Rules for Non-COD / Lockdown Areas (ID & TH)

## Description

### Applied GEO

ID & TH (confirmed by requester — OPEX team, with AM Alex Chu and GMs Agus Surya Kusuma (ID) and Jeremy Duong (TH)).

### Business Context / Purpose

As confirmed with AM and GMs, the business wants to implement new standardized CPL deal postback rules for all CPL deals in ID & TH. A GM follow-up (2026-09-28) reconfirmed that a "closed area" considered trash = **NON-COD area + Low DR area**, with Low DR area to be treated as **all NON-COD to the partner**. *(Source: `inputs/references/1. request.png`, `inputs/references/2. request.png` — email thread "Request IT Support - CPL Deals Postback Rules Implementation (ID & TH)", acknowledged by Sam Tran (IT) on 2026-09-28.)*

### Current Behavior

Per the Current-State Analysis (`outputs/current-state/TMS/CS-TMS-CPL-Deal-Postback-Rules-ID-TH.md`):

- TMS already has a reject-postback mechanism for Non-COD and Lockdown leads that reuses the same existing postback configuration/workflow (Lockdown is not a separate path from Non-COD). The reject reason values `"No_COD_area"` and `"Lockdown_area"` already exist in current production postback payloads. *(Source: Jira TM-8189, Done.)*
- This postback is triggered only when **Lead Type = A** and **Location Status = Non-COD/Lockdown** and the existing **Non-COD/Lockdown Postback feature flag** is enabled. Payload structure and trigger timing are otherwise unchanged. *(Source: Jira TM-8189, TM-8475, both Done.)*
- This mechanism is currently **deal-scoped**, not applied blanket across all CPL deals. As of TM-8475 (Jul 2026, ID2/ID3), three separate Non-COD list scenarios exist: (1) a list applied to all deals, (2) a list applied only to "ME campaign" deals, (3) a list applied to 5 named "Low DR" deals treated as Non-COD. *(Source: Jira TM-8475, Done, AC4.)*
- A later ticket, TM-8702 (Aug 2026, Done), reworked part of this deal-exception configuration, removing all Non-COD rule-checking entirely for 4 named deals. **TM-8475 and TM-8702's deal-exception lists are not fully consistent with each other** and have not been reconciled in available sources — see Open Questions.
- TH production already has an existing quota-style approval-limiting mechanism for trash leads (`PostbackDecisionService` / an `approvedTrashCount`-style query), which is the closest existing behavior to an "8% quota." Its existence is confirmed; its exact formula and whether it currently applies to ID are **not defined in source**. *(Source: Jira TM-8935, Done.)*
- TM-8935 also documents a live production defect in TH where the postback reason field (`adv_param1`) sent to the tracker is empty in ~89.8% of sampled cases due to reason-config mapping issues, and a separate race condition that can incorrectly consume quota slots on blocked postbacks. This is existing-defect context, not confirmed as in scope for this CR.
- No confirmed ID/TH detection logic exists in available sources for **Foreigner**, **Under 18 years old**, or **Duplicate_order**. A phone-number-format validation rule exists only for Peru and Colombia (Jira TM-8293, Done); no equivalent has been confirmed for ID or TH.
- An active, in-progress Jira ticket, TM-8372 "[TMS] Refactor the lead postback logic for AFS" (plus subtasks TM-9114–TM-9118, most marked Done as of 2026-09-28 — the day this request was raised — with one subtask still To Do), covers this same postback-logic area. Its content was not accessible for this analysis.
- `ID COVERAGE CATEGORY REVISE.xlsx` (local file) is **not confirmed** as the live production Non-COD/Low-DR coverage configuration; it is treated as a candidate reference only.

### Expected Behavior

This CR covers only the scope supported by confirmed current behavior. Rules 1–4 of the originally requested table, the exact quota formula, and the deal-exception-list conflict are **not** included as confirmed requirements here — see Open Questions.

1. For all CPL deals in ID and TH (not limited to the currently deal-scoped exception lists), when a lead's address resolves to a **Non-COD** or **Lockdown** Location Status, and the lead meets the existing postback-trigger condition (Lead Type = A, feature flag enabled), the system shall send a Trash postback to AFS using the existing reason values `No_COD_area` / `Lockdown_area`, extending the existing mechanism's applicability from the current deal-scoped lists to all CPL deals in ID & TH. *(Extends Jira TM-8189/TM-8475's existing mechanism; this blanket-application scope is new relative to confirmed current behavior — see Business Rules.)*
2. For all CPL deals in ID and TH, a lead's address that resolves to a **Low DR** Location Status shall be treated as **NON-COD to the partner** for postback purposes — i.e., it shall trigger the same Trash postback and reason mapping as a Non-COD area (using reason value `No_COD_area`, consistent with existing reason naming). *(Source: `inputs/references/2. request.png`, GM clarification.)*
3. For a lead status not covered by Rules 1–2 above (i.e., not Non-COD, Low DR, or Lockdown, and not one of the unresolved reasons in Open Questions), the system's postback decision for that reason is **not defined in this CR** — carried as Open Question OQ-4.
4. This CR does not define new detection logic for Foreigner, Under 18 years old, Duplicate_order, or Incorrect_phone_number, and does not define an exact approval-quota formula for "Customer_do_not_order" — see Open Questions OQ-1 through OQ-3.

## User Story

As an OPEX/GM stakeholder for ID and TH CPL deals,
I want the existing Non-COD/Lockdown postback mechanism (including Low DR treated as Non-COD) applied to all CPL deals rather than only a limited deal-exception list,
So that closed-area leads are consistently trashed and reported to the partner across all CPL deals in ID and TH.

## Business Rules

- BR-01: A lead whose Location Status is Non-COD or Lockdown, meeting the existing Lead Type = A + feature-flag postback-trigger condition, is posted back to AFS as Trash with reason `No_COD_area` / `Lockdown_area` respectively — for **all** CPL deals in ID & TH, not only the currently configured deal-exception lists. *(Source: `inputs/references/1. request.png` Rules 5–6, extending Jira TM-8189/TM-8475's existing mechanism.)*
- BR-02: A lead whose Location Status is Low DR is treated as Non-COD to the partner and posted back using the same reason mapping as Non-COD (`No_COD_area`). *(Source: `inputs/references/2. request.png`.)*
- BR-03: This change applies to CPL deals in ID and TH only; it does not change postback behavior for other deal types (e.g., CPA) or other GEOs. *(Source: `inputs/references/1. request.png`, `inputs/references/2. request.png` — explicit ID & TH scope.)*
- BR-04: The existing Non-COD/Lockdown postback payload structure, reason-value naming, and trigger timing remain unchanged; only the deal-scope of applicability is extended. *(Source: Jira TM-8189 AC07/AC08 — preserved unless explicitly changed.)*

## Acceptance Criteria

**AC-01 — Non-COD/Lockdown Trash postback applied to all CPL deals (ID & TH)**
Given a CPL deal lead in ID or TH whose Location Status is Non-COD or Lockdown, and the lead meets the existing Lead Type = A + feature-flag postback-trigger condition,
When the postback decision is evaluated,
Then the system sends a Trash postback to AFS with reason `No_COD_area` (Non-COD) or `Lockdown_area` (Lockdown), regardless of whether the deal is on the currently configured deal-exception list.

**AC-02 — Low DR treated as Non-COD for postback**
Given a CPL deal lead in ID or TH whose Location Status is Low DR,
When the postback decision is evaluated,
Then the system sends the same Trash postback to AFS as for a Non-COD area, using reason `No_COD_area`.

**AC-03 — Scope limited to ID & TH CPL deals**
Given a lead that is not a CPL deal in ID or TH,
When the postback decision is evaluated,
Then this change does not alter its existing postback behavior.

**AC-04 — Payload and trigger conditions unchanged**
Given the Non-COD/Lockdown/Low DR Trash postback is sent under this CR,
When the postback is generated,
Then it uses the existing payload structure, reason-value naming, and trigger timing (Lead Type = A, feature flag enabled), unchanged from current behavior.

## Other Information

- Reference: Current-State Analysis `outputs/current-state/TMS/CS-TMS-CPL-Deal-Postback-Rules-ID-TH.md` — confirmed current behavior, conflicts, and gaps underlying this CR.
- Reference: Jira TM-8189 (Done), TM-8475 (Done), TM-8702 (Done), TM-8935 (Done), TM-8293 (Done), TM-8372 + TM-9114–TM-9118 (In Progress / mixed).
- Reference: `inputs/references/1. request.png`, `inputs/references/2. request.png` — requester source images.

## Open Questions / Assumptions

**Open Questions (must be resolved before the following can move from Open Question to confirmed requirement):**

1. **OQ-1 (Rules 1–4 — Foreigner, Under 18, Duplicate_order, Incorrect_phone_number):** Do these lead statuses already exist and get set by agents/other means in ID/TH (making this only a postback-mapping change), or do they require new detection/validation logic to be built? No confirmed ID/TH mechanism was found in available sources. Out of scope for this CR pending clarification.
2. **OQ-2 (Rule 0 — Customer_do_not_order quota):** What is the exact current 8%-quota formula in `PostbackDecisionService`, and does it currently apply to ID as well as TH? Existence of a quota mechanism is confirmed (Jira TM-8935); the exact formula and its ID applicability are not. Out of scope for this CR pending confirmation from engineering.
3. **OQ-3 (Deal-exception conflict):** Jira TM-8475 and TM-8702 (both Done) define different, only partially overlapping deal-exception lists for Non-COD treatment. Which configuration is currently live in production? This CR proceeds on the basis that the blanket rule (BR-01/BR-02) supersedes deal-specific exceptions going forward, but the current-state conflict itself remains unresolved and should be confirmed with engineering before implementation.
4. **OQ-4 (Rule 7 — "Other status"):** The requested table's default/fallback rule ("Other status → Approve") is not included as a confirmed requirement in this CR, since its interaction with the existing CPA/CPL postback-eligibility mechanism (Jira TM-8677) — under which CPL currently postbacks Trash only for COD/non-COD reasons — is not confirmed for ID/TH. Needs confirmation of current Trash-postback eligibility for other reason categories before drafting.
5. **OQ-5 (TM-8372 overlap):** Jira TM-8372 "[TMS] Refactor the lead postback logic for AFS" is an active, in-progress refactor of this same postback-logic area, updated the day this request was raised. Its scope/spec was not accessible. Must be reviewed with its assignee/PO before or during implementation to avoid conflicting changes.
6. **OQ-6 (Coverage data source):** Is `ID COVERAGE CATEGORY REVISE.xlsx` the current live production Non-COD/Low-DR coverage configuration, or a proposed/candidate revision? This CR does not cite it as confirmed current-state data; the actual coverage list to be used for BR-01/BR-02 must be confirmed with the data owner (OPEX/GM team) before implementation.

**Assumptions:** None — all uncertain items above are carried as Open Questions rather than assumed.

---

*Readiness: **PARTIAL**. BR-01, BR-02, BR-03, BR-04 and AC-01–AC-04 are drafted from confirmed current behavior (existing Non-COD/Lockdown postback mechanism, extended in deal-scope per requester confirmation) and are ready for review. Rules 1–4, the exact quota formula (Rule 0), the "Other status" fallback (Rule 7), the TM-8475/TM-8702 deal-exception conflict, the TM-8372 overlap, and the coverage-data source are carried as Open Questions (OQ-1–OQ-6) and are **not** included as confirmed requirements pending the stated clarifications.*
