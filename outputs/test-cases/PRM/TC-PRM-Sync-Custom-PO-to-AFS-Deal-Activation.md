# Test Cases: [PRM-3504] Sync Custom PO to AFS after Deal Activation & Restrict AM/AMM to View-only on AFS Custom PO

**Source ticket:** [PRM-3504](https://accelo-tech.atlassian.net/browse/PRM-3504) (Story, status: To Do)
**Related sources used for edge-case context (not part of PRM-3504's own Acceptance Criteria — see Section 5, Open Questions):** [PRM-2871](https://accelo-tech.atlassian.net/browse/PRM-2871) (Active→Closed auto-transition), [PRM-2873](https://accelo-tech.atlassian.net/browse/PRM-2873) (Invalid Deal Handling), [PRM-2856](https://accelo-tech.atlassian.net/browse/PRM-2856) (overlap date-adjustment rules), [PRM-2918](https://accelo-tech.atlassian.net/browse/PRM-2918) (Case 8 — auto-extended Deal C)

Each test case traces to a specific AC in PRM-3504 where one exists. Test cases without a direct AC citation are marked **(Open Question / Not confirmed in source)** and must not be treated as pass/fail gates until the business rule is confirmed — per project grounding rules, a test case cannot assert an expected result that isn't defined in source.

---

## 1. Sync Custom PO to AFS after Deal Activation (AC1)

### TC-01 — New Custom PO created when none exists yet for the Offer/Pub/Sub
**Preconditions:** Deal D is in status Approved, for Offer O1 / Pub P1 / Sub S1. No Custom PO record currently exists on AFS for O1/P1/S1 (only Default PO applies).
**Steps:**
1. PIC activates Deal D (sets Deal Start/End, clicks Activate).
**Test data:** Deal D — New PO = $25, Deal Start = 2026-11-01, Deal End = 2026-11-30.
**Expected result:** A new Custom PO record is created on AFS for O1/P1/S1 with: Custom PO = $25, Custom PO start date = 2026-11-01, Custom PO end date = 2026-11-30.
**Reference:** PRM-3504 AC1.a. **Priority:** High.

### TC-02 — Existing Custom PO is deactivated and replaced when one already exists
**Preconditions:** Deal D activates for O1/P1/S1; an existing Custom PO record already exists on AFS for O1/P1/S1 (e.g., value = $20, from a previously activated deal).
**Steps:**
1. Activate Deal D (New PO = $25, Start = 2026-11-01, End = 2026-11-30).
**Expected result:** The old Custom PO record ($20) is **deactivated** (not deleted, not edited in place); a **new** Custom PO record is added with Custom PO = $25, start = 2026-11-01, end = 2026-11-30.
**Reference:** PRM-3504 AC1.b. **Priority:** High.

### TC-03 — Custom PO value exactly matches the Deal's New PO
**Steps:** Activate a Deal with New PO = $31.75 (decimal value).
**Expected result:** AFS Custom PO value = $31.75 exactly — no rounding/truncation.
**Reference:** PRM-3504 AC1. **Priority:** Medium.

### TC-04 — Custom PO start/end dates exactly match Deal start/end dates
**Steps:** Activate a Deal with Deal Start = 2026-12-01, Deal End = 2026-12-15.
**Expected result:** AFS Custom PO start date = 2026-12-01, end date = 2026-12-15 (same dates, no offset).
**Reference:** PRM-3504 AC1. **Priority:** Medium.

### TC-05 — Sync is scoped to the exact Offer/Pub/Sub combination on the Deal, not any other combination
**Preconditions:** A Custom PO already exists for O1/P1/**S2** (a different Sub than the Deal being activated).
**Steps:** Activate Deal D for O1/P1/**S1**.
**Expected result:** The existing Custom PO for O1/P1/S2 is **not** touched (not deactivated, not modified); only O1/P1/S1 gets a new Custom PO record.
**Reference:** PRM-3504 AC1 ("for the Offer/Pub/Sub selected on the deal"). **Priority:** High.

### TC-06 — Deal without a Sub value (Sub is optional per PRM-1381 field definition)
**Preconditions:** Deal D has Offer + Pub set, Sub left blank (Sub is not a required field per the Deal Request form).
**Steps:** Activate Deal D.
**Expected result:** **Not defined in source** — PRM-3504 only states the sync targets "the Offer/Pub/Sub selected on the deal," but does not define behavior when Sub is blank (sync at Offer+Pub level only? blocked? error?). **Status: Open Question — confirm with PRM-3504's owner before this case can be executed/pass-failed.**

---

## 2. AM/AMM view-only restriction on AFS (AC2)

### TC-07 — AM cannot see Add/Edit/Delete actions for Custom PO on AFS UI
**Preconditions:** User logged in to AFS with role = AM.
**Steps:** Navigate to the Custom PO section for any Offer on AFS.
**Expected result:** Add/Edit/Delete buttons/actions for Custom PO are hidden or disabled for this user.
**Reference:** PRM-3504 AC2. **Priority:** High.

### TC-08 — AMM cannot see Add/Edit/Delete actions for Custom PO on AFS UI
Same as TC-07, role = AMM. **Reference:** PRM-3504 AC2. **Priority:** High.

### TC-09 — AM/AMM can still view existing Custom PO records
**Steps:** Logged in as AM/AMM, open the Custom PO list/detail for an Offer.
**Expected result:** Custom PO records (value, start/end date, active/inactive status) are visible and readable.
**Reference:** PRM-3504 AC2 ("can only view"). **Priority:** High.

### TC-10 — Backend enforcement: AM/AMM cannot bypass UI restriction via direct API call
**Steps:** As AM/AMM, attempt to call the AFS Custom PO create/edit/delete API directly (e.g., via a saved request or dev tools), bypassing the UI.
**Expected result:** The backend rejects the action (authorization error), independent of whether the UI button is hidden.
**Reference:** PRM-3504 AC2 ("block these actions on the backend as well"). **Priority:** High (security-relevant).

### TC-11 — Roles other than AM/AMM are unaffected
**Expected result / status:** **Not defined in source** — PRM-3504 only restricts AM/AMM; it does not state whether any other AFS role currently has create/edit/delete rights on Custom PO, or whether this ticket changes anything for them. **Status: Open Question** — confirm which other roles (if any) retain write access before asserting "no regression" as a pass condition.

---

## 3. Error handling (AC3)

### TC-12 — Sync failure displays the exact required error message
**Preconditions:** Simulate a failure in the push-to-AFS call (e.g., AFS API unavailable, timeout, or rejected request) when activating Deal D with Deal_ID = D0876.
**Steps:** Activate Deal D0876 while the sync call is forced to fail.
**Expected result:** System displays:
- Title: `Failed to sync Custom PO to AFS`
- Message: `Failed to sync Custom PO to AFS for Deal D0876. Please contact IT Support for assistance.`
(Deal_ID placeholder must be substituted with the real Deal number, matching the PRM-1381 Deal-number format, e.g. `D876`.)
**Reference:** PRM-3504 AC3. **Priority:** High.

### TC-13 — Deal/system state after a failed sync
**Expected result / status:** **Not defined in source** — PRM-3504 specifies the error message shown to the user, but does not define: whether the Deal still transitions to Activated despite the sync failure, whether there is a retry mechanism (automatic or manual), or whether the Deal is rolled back to its prior status. **Status: Open Question** — must be confirmed before this scenario can be given a pass/fail expected result.

### TC-14 — Error shown only on genuine failure, not on success
**Steps:** Activate a Deal under normal conditions (AFS reachable, no conflicts).
**Expected result:** No error message is shown; sync completes per TC-01/TC-02.
**Reference:** Negative-path corollary of PRM-3504 AC3. **Priority:** Medium.

---

## 4. Logging (AC4)

### TC-15 — New Custom PO record creation is logged
**Steps:** Activate Deal D (new Custom PO path, TC-01 scenario).
**Expected result:** A log entry is created containing: Deal ID, Offer/Pub/Sub, Custom PO value, start date, end date, and timestamp.
**Reference:** PRM-3504 AC4. **Priority:** High.

### TC-16 — Deactivation of an old Custom PO record is logged
**Steps:** Activate Deal D where an existing Custom PO is deactivated (TC-02 scenario).
**Expected result:** A separate log entry records the deactivation event (old record details, timestamp), distinct from the "record added" log entry for the new one.
**Reference:** PRM-3504 AC4 ("record added, record deactivated"). **Priority:** High.

### TC-17 — Deal's History Log shows the sync event
**Steps:** After activating Deal D and a successful sync, open Deal D's detail page / History Log in PRM.
**Expected result:** The History Log shows an entry indicating the Custom PO was synced to AFS.
**Reference:** PRM-3504 AC4. **Priority:** Medium.

### TC-18 — Failed sync is also logged (or not) for audit purposes
**Expected result / status:** **Not defined in source** — AC4 only explicitly requires logging for "record added, record deactivated" (i.e., successful sync outcomes). Whether a **failed** sync attempt (TC-12/TC-13) is also logged for audit/traceability is not stated. **Status: Open Question.**

---

## 5. Edge cases from related Deal-lifecycle rules (context only — NOT confirmed AC of PRM-3504)

These scenarios come from other PRM tickets describing how a Deal's status can change around activation/overlap. PRM-3504 itself does not state how (or whether) its sync logic interacts with these scenarios. Each is listed as an **Open Question test case** — to be confirmed with the PRM-3504 owner (Tim Nguyen) before being treated as a pass/fail requirement.

### TC-19 (Open Question) — Activating a Deal that overlaps an existing Active deal for the same Pub/Offer
**Context:** Per PRM-2871 AC2, activating a new overlapping Deal for the same Pub/Offer auto-closes the old Active deal.
**Question to confirm:** When the old Deal is auto-closed by this overlap rule, does its corresponding Custom PO record on AFS get deactivated/end-dated to match, or does it remain active until its originally-synced end date?
**Status:** Not defined in source — cannot be executed as a pass/fail test until confirmed.

### TC-20 (Open Question) — Attempting to activate a Deal marked Invalid
**Context:** Per PRM-2873 AC2, Invalid deals "cannot be activated."
**Expected result (if this holds):** Activation action should be blocked/unavailable for an Invalid deal, and therefore no Custom PO sync should ever be triggered for it.
**Status:** Likely true per PRM-2873, but PRM-3504 does not itself restate this — include as a **regression guard** test case (deal must never reach PRM-3504's sync logic in an Invalid state), not as new confirmed behavior of this ticket.

### TC-21 (Open Question) — Auto-generated "Deal C" (Case 8 overlap extension, PRM-2918) reaching Activated status
**Context:** Deal C is system-generated, not user-created, with `Extended by = System`.
**Question to confirm:** Does system-generated Deal C go through the same Activation step (and therefore trigger PRM-3504's Custom PO sync) as a normal user-created Deal, or is it activated/synced differently (e.g., silently, or not synced at all since it's a continuation of the same underlying Offer/Pub/Sub arrangement)?
**Status:** Not defined in source.

### TC-22 (Open Question) — Deal end-date truncated by an overlap rule, after it was already Activated and synced
**Context:** Per PRM-2856 (e.g., Case 1/3/8), an Active deal's End Date can be automatically shortened when a newer overlapping deal is activated.
**Question to confirm:** Does this automatic date truncation re-trigger a sync of the already-created Custom PO's end date on AFS, or does the previously-synced Custom PO end date become stale/incorrect?
**Status:** Not defined in source — this is the most material gap, since it could leave AFS reflecting a PO that PRM itself no longer considers valid for that period.

---

## Summary

| Category | Confirmed test cases (traceable to an AC) | Open-Question test cases (not yet confirmed) |
|---|---|---|
| Sync on Activation | TC-01 – TC-05 | TC-06 |
| AM/AMM view-only | TC-07 – TC-10 | TC-11 |
| Error handling | TC-12, TC-14 | TC-13 |
| Logging | TC-15 – TC-17 | TC-18 |
| Related Deal-lifecycle edge cases | — | TC-19 – TC-22 |

**Readiness for execution:** The 13 confirmed test cases (TC-01–05, 07–10, 12, 14–17) can be executed directly against PRM-3504's stated Acceptance Criteria once built. The 9 Open-Question test cases (TC-06, 11, 13, 18–22) require explicit clarification from the ticket owner/PO before an expected result can be asserted — do not mark them pass/fail against an assumed behavior.
