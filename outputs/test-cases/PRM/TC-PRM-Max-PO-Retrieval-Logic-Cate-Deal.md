# Test Cases: [PRM-3421] [Max PO] Update logic to get Max PO in Cate/Deal

**Source ticket:** [PRM-3421](https://accelo-tech.atlassian.net/browse/PRM-3421) (Story, status: Ready To Test, parent epic PRM-3523)
**Related sources (context / regression baseline, not PRM-3421's own AC):**
- [PRM-3398](https://accelo-tech.atlassian.net/browse/PRM-3398): new Offer attributes (Language, Price, Form factor, Standard). PRM-3421 cites it as the source of the Parent Category mapping.
- [PRM-3073](https://accelo-tech.atlassian.net/browse/PRM-3073) / [PRM-3074](https://accelo-tech.atlassian.net/browse/PRM-3074): Category / Deal Max PO calculation jobs.
- Confluence [Deals (updated)](https://accelo-tech.atlassian.net/wiki/pages/viewpage.action?pageId=1397063717): In-house approval workflow (PRM-3069), Max PO Request approval and overlap rules (PRM-3105 / PRM-3114).

**Clarifications confirmed by BA (Man Luu, 2026-10-19):**
- C1: **Scope.** When AM creates a new deal, the Max PO field is **auto-filled** from the Pub/Offer pair or the Category. PRM-3421 changes the logic that decides which Max PO is filled. The daily Max PO calculation job (PRM-3073/3074) is out of scope.
- C2: **Lead in last 30d** uses the **lead created date** and is checked for the **same Pub + Offer pair**.
- C3: **Parent Category Max PO follows the ticket.** Use the Max PO of the Parent Category exactly as PRM-3421 AC2.2.2 states. The "average + $2" formula mentioned earlier is not in the ticket, so it is **not** tested.
- C4: **Decision path.** The PRM-3421 AC stays as written: for Non-standard offers, use Deal Max PO first, then the 30-day lead check (Cate vs Parent). "Non-standard → parent cate" refers to the no-lead branch.
- C5: **Parent Category mapping.** Test against the Parent Category already configured for each Category in the system (mapping source: PRM-3398).

Each test case cites the AC it verifies. Cases marked **(Open Question)** have no expected result defined in source. Do not use them as pass/fail gates until the ticket owner confirms the rule (see Section 8).

---

## 0. Baseline: current behavior (from Deals page, PRM-3069)

| Item | Current rule |
|---|---|
| Scope | In-house deals only (ADV ID = 2). ADV deals unchanged. |
| New Deal | Pub/Offer has **no lead volume in the last 30 days** AND **no Max PO configured at Pub/Offer level** |
| Max PO used | New Deal → latest **Category** Max PO. Existing Deal → latest **Active Deal** Max PO (Pub/Offer). |
| Auto-approve | New Deal: `Max PO − New PO ≥ $3`. Not New: `Max PO − New PO ≥ $2` AND `New PO − Current PO < $2` |
| Short (AMM only) | `(Max PO − New PO ≥ $2 AND New PO − Current PO ≥ $2)` OR `0 ≤ Max PO − New PO < $2` |
| Full flow | New Deal: `Max PO − New PO < $3`. Not New: `Max PO − New PO < 0`. Chain: AM → AMM → FBP → MO → MOM → FBP TL → HOF |
| Logging / badge | Max PO used is saved on the deal. Badge: green `AUTO-APPROVAL MET` / red `MANUAL-APPROVAL REQUIRED` |
| Max PO record keys | Category Max PO = `GEO + Category`. Deal Max PO = `GEO + Pub + Offer`. Only **Active** (approved, Applied From Date reached) records apply. |

## 1. Target rule (PRM-3421 AC)

```
AC1  Deal Max PO exists                               → Deal Max PO
AC2  No Deal Max PO
     AC2.1  Offer Standard = On                       → Cate Max PO
     AC2.2  Offer Standard = Off (Non-standard)
            AC2.2.1  same Pub + Offer has lead in 30d → Cate Max PO
            AC2.2.2  same Pub + Offer no lead in 30d  → Parent Category Max PO
AC3  No Max PO found                                  → Max PO = 0 → full-flow approval
AC4  All unrelated cases                              → existing behavior unchanged
```

"Lead in 30d" = at least one lead of the same Pub + Offer whose **lead created date** falls in the last 30 days (C2).

**Verification point for every case (C1):** On **Create Deal**, after selecting Pub + Offer, check the **auto-filled Max PO** value. Then submit the deal and check (a) the Max PO saved on the deal and (b) the approval route and badge.

## 2. Test data setup

All deals are **In-house (ADV ID = 2), GEO = TH** unless stated otherwise. The names below are placeholders; map them to real staging data before execution.

| Data | Value |
|---|---|
| Category **CA** | Parent Category = **PA** (mapping per PRM-3398 / Offer data) |
| Category **CB** | Parent Category = **PB** |
| Offer **OS** | Category CA, **Standard = On** |
| Offer **ON** | Category CA, **Standard = Off** |
| Offer **ON2** | Category CB, **Standard = Off** |
| Pub **P1** | Has leads on OS and ON within the last 30 days |
| Pub **P2** | No leads on any offer in the last 30 days |
| Active Cate Max PO | TH + CA = **30** |
| Active Parent Cate Max PO | TH + PA = **20** (C3) |
| Active Deal Max PO | TH + P1 + OS = **40**, TH + P2 + ON = **40** (set per case; remove when the case requires "no Deal Max PO") |

Values were chosen so that Deal (40), Cate (30), Parent (20) and 0 give **different approval outcomes** for the same New PO, so the outcome shows which source was picked.

---

## 3. AC1: Deal Max PO takes priority

### TC-01: Standard offer with Deal Max PO uses Deal Max PO
**Pre:** Deal Max PO TH+P1+OS = 40 (Active). Cate TH+CA = 30.
**Steps:** AM creates and submits a deal request P1 + OS, New PO = 36, Current PO = 35.
**Expected:** Max PO saved on deal = **40**. Not a New Deal → 40−36 = 4 ≥ 2 and 36−35 = 1 < 2 → **Auto-approved**, green badge.
**Ref:** AC1, PRM-3069. **Priority:** High

### TC-02: Non-standard offer with lead in 30d and Deal Max PO uses Deal Max PO
**Pre:** P1 has lead on ON in the last 30d. Deal Max PO TH+P1+ON = 40. Cate = 30, Parent = 20.
**Steps:** Submit a deal P1 + ON, New PO = 36, Current PO = 35.
**Expected:** Max PO = **40** (not 30). Auto-approved.
**Ref:** AC1. **Priority:** High

### TC-03: Non-standard offer without lead in 30d but with Deal Max PO uses Deal Max PO
**Pre:** P2 has no lead on ON in the last 30d. Deal Max PO TH+P2+ON = 40. Cate = 30, Parent = 20.
**Steps:** Submit a deal P2 + ON, New PO = 36, Current PO = 35.
**Expected:** Max PO = **40** (not Parent 20). Not a New Deal, because a Pub/Offer Max PO exists → Auto-approved.
**Ref:** AC1, PRM-3069 New Deal definition. **Priority:** High

### TC-04: Deal Max PO of another Pub on the same Offer is not used
**Pre:** Deal Max PO exists only for TH+**P1**+ON = 40. P2 has no lead on ON. Parent PA = 20.
**Steps:** Submit a deal **P2** + ON.
**Expected:** P1's Deal Max PO is ignored; flow goes to AC2. Expected Max PO = **20** (Parent, per AC2.2.2).
**Ref:** AC1 (key GEO+Pub+Offer). **Priority:** High

### TC-05: Deal Max PO in another GEO is not used
**Pre:** Deal Max PO exists only for **VN**+P1+OS = 40. Cate TH+CA = 30.
**Steps:** Submit a TH deal P1 + OS.
**Expected:** Max PO = **30** (Cate, AC2.1).
**Ref:** AC1, record key GEO+Pub+Offer (Deals page AC5). **Priority:** Medium

### TC-06: Non-Active Deal Max PO is treated as non-existent (regression)
**Pre:** No Active Deal Max PO for TH+P1+OS. Run three variants, one Deal Max PO = 40 record each:
a) in a Max PO Request not yet HOF-approved (Open / Pending / Rejected);
b) HOF-approved but Applied From Date is in the future;
c) Inactive, because a newer record superseded it.
For (c), the newer Active record has a different value (e.g. 35), which must be used.
**Steps:** Submit a deal P1 + OS.
**Expected:** a, b → Max PO = **30** (Cate). c → Max PO = **35**.
**Ref:** AC4 (keep existing), PRM-3105 "not used in a deal before approval", overlap rule AC5. **Priority:** High

---

## 4. AC2.1: Standard offer, no Deal Max PO → Cate Max PO

### TC-07: Standard offer with lead in 30d uses Cate Max PO
**Pre:** No Deal Max PO for P1+OS. P1 has lead on OS within 30d. Cate = 30, Parent = 20.
**Steps:** Submit P1 + OS, New PO = 27, Current PO = 26.
**Expected:** Max PO = **30**. Not a New Deal (has lead): 30−27 = 3 ≥ 2 and 27−26 = 1 < 2 → **Auto-approved**.
**Ref:** AC2.1. **Priority:** High

### TC-08: Standard offer without lead in 30d still uses Cate Max PO, not Parent
**Pre:** No Deal Max PO for P2+OS. P2 has no lead on OS. Cate = 30, Parent = 20.
**Steps:** Submit P2 + OS, New PO = 27.
**Expected:** Max PO = **30** (the lead check does not apply to Standard offers). New Deal: 30−27 = 3 ≥ 3 → **Auto-approved**.
*Discriminator:* if Parent (20) were wrongly used → 20−27 < 3 → full flow.
**Ref:** AC2.1. **Priority:** High

---

## 5. AC2.2: Non-standard offer, no Deal Max PO

### TC-09: Non-standard offer with lead in 30d for the same Pub + Offer uses Cate Max PO
**Pre:** No Deal Max PO for P1+ON. P1 has lead on ON within 30d. Cate = 30, Parent = 20.
**Steps:** Submit P1 + ON, New PO = 27, Current PO = 26.
**Expected:** Max PO = **30**. Auto-approved (not New Deal, same thresholds as TC-07).
**Ref:** AC2.2.1. **Priority:** High

### TC-10: Non-standard offer without lead in 30d uses Parent Category Max PO
**Pre:** No Deal Max PO for P2+ON. P2 has no lead on ON. Cate = 30, Parent = 20.
**Steps:** Submit P2 + ON, New PO = 17.
**Expected:** Max PO = **20**. New Deal: 20−17 = 3 ≥ 3 → **Auto-approved**.
**Ref:** AC2.2.2. **Priority:** High

### TC-11: Non-standard offer without lead goes to full flow when New PO exceeds the Parent value
**Pre:** Same as TC-10.
**Steps:** Submit P2 + ON, New PO = 25.
**Expected:** Max PO = **20** → 20−25 < 3 → **Full approval flow**, red badge `MANUAL-APPROVAL REQUIRED`.
*Discriminator:* if Cate (30) were wrongly used → 30−25 = 5 ≥ 3 → auto-approved.
**Ref:** AC2.2.2, PRM-3069. **Priority:** High

### TC-12: Lead on the same Offer from another Pub does not count
**Pre:** P1 has lead on ON within 30d. P2 has none. No Deal Max PO for P2+ON.
**Steps:** Submit P2 + ON.
**Expected:** Treated as "no lead" → Max PO = **20** (Parent).
**Ref:** AC2.2 ("same pub + offer"). **Priority:** High

### TC-13: Lead from the same Pub on another Offer does not count
**Pre:** P2 has lead on **OS** within 30d, none on ON. No Deal Max PO for P2+ON.
**Steps:** Submit P2 + ON.
**Expected:** Max PO = **20** (Parent).
**Ref:** AC2.2 ("same pub + offer"). **Priority:** Medium

### TC-14: Lead outside the 30-day window does not count
**Pre:** P2's latest lead on ON has **lead created date** 45 days ago. No Deal Max PO for P2+ON.
**Steps:** Create a deal P2 + ON.
**Expected:** Max PO = **20** (Parent).
**Ref:** AC2.2.2, C2. **Priority:** High

### TC-14a: The 30-day check uses lead created date, not another lead date
**Pre:** P2 has one lead on ON with **lead created date = 40 days ago**, but its other dates (e.g. validated / updated) fall within the last 30 days. No Deal Max PO for P2+ON.
**Steps:** Create a deal P2 + ON.
**Expected:** Counted as "no lead" → Max PO = **20** (Parent).
*Mirror variant:* lead created date = 10 days ago (other dates older or empty) → "has lead" → Max PO = **30** (Cate).
**Ref:** AC2.2, C2. **Priority:** High

### TC-15 (Open Question): Lead exactly at the 30-day boundary
**Steps:** Latest lead on P2+ON has lead created date = exactly 30 days ago (variants: 29 and 31 days).
**Expected:** 29 days → has lead (Cate). 31 days → no lead (Parent). **Exactly 30 days is not defined in source:** inclusive or exclusive? Calendar day or rolling 30 × 24h? Which timezone? See OQ-3.

### TC-16: Non-standard offer in another Category uses its own Parent
**Pre:** Active Parent PB Max PO = 15, Parent PA = 20. No Deal Max PO for P2+ON2. P2 has no lead on ON2.
**Steps:** Submit P2 + ON2.
**Expected:** Max PO = **15** (PB), not 20.
**Ref:** AC2.2.2 + Parent mapping. **Priority:** Medium

### TC-16a: Parent Category Max PO is used exactly as stored
**Pre:** Same as TC-10. Active Parent Cate Max PO TH + PA = 20.
**Steps:** Create a deal P2 + ON.
**Expected:** Auto-filled Max PO = **20**, exactly the stored Parent Cate Max PO value, with no adjustment.
**Ref:** AC2.2.2, C3. **Priority:** High

---

## 6. AC3: No Max PO found → Max PO = 0 → full flow

### TC-17: Standard offer with no Deal and no Cate Max PO
**Pre:** Standard offer OS3 in a Category with no Active Cate Max PO (its Parent also has none). No Deal Max PO.
**Steps:** Submit a deal with any New PO (e.g. 5).
**Expected:** Max PO saved on deal = **0**. **Full approval flow** AM → AMM → FBP → MO → MOM → FBP TL → HOF. Red badge. Deal becomes Approved only after HOF approves.
**Ref:** AC3. **Priority:** High

### TC-18: Non-standard offer without lead and with no Max PO at any level
**Pre:** Non-standard offer whose Category and Parent both have no Active Max PO. No Deal Max PO. No lead in 30d.
**Expected:** Max PO = **0** → Full flow.
**Ref:** AC3. **Priority:** High

### TC-19: Non-standard offer with lead and with no Max PO at any level
**Pre:** Same as TC-18, but the Pub + Offer has lead in 30d.
**Expected:** Max PO = **0** → Full flow.
**Ref:** AC3. **Priority:** High

### TC-20: Max PO = 0 never auto-approves or short-approves, even with a very low New PO
**Pre:** Same as TC-17. Run variant A (New Deal) and variant B (Not New Deal: has lead + Current PO exists).
**Steps:** Submit with the lowest allowed New PO (e.g. 1).
**Expected:** Both variants → **Full flow** (0−1 < 0 and < 3). No AMM-only route.
**Ref:** AC3. **Priority:** High

### TC-21 (Open Question): Fallback when the expected level is missing but another level exists
| Variant | Setup | Literal AC3 reading | Question |
|---|---|---|---|
| a | Standard, no Deal, **no Cate**, Parent exists | 0 → full flow | Should it fall back to Parent? |
| b | Non-standard + lead, no Deal, **no Cate**, Parent exists | 0 → full flow | Fall back to Parent? |
| c | Non-standard, no lead, no Deal, **no Parent**, Cate exists | 0 → full flow | Fall back to Cate? |
| d | Non-standard offer whose Category has **no Parent mapped** | ? | Use Cate? 0? |

**Status:** Not confirmed. See OQ-1, OQ-2.

---

## 7. AC4: Regression / unchanged behavior

### TC-22: Approval thresholds for New vs Not-New Deal are unchanged
Run the boundary set on a resolved Max PO of 30 (TC-07 setup for Not New; TC-08 setup for New):

| Type | New PO | Current PO | Expected route |
|---|---|---|---|
| New | 27 | – | Auto (diff = 3) |
| New | 27.5 or 28 | – | Full (diff < 3) |
| Not New | 28 | 27 | Auto (diff 2, ΔPO 1) |
| Not New | 28 | 26 | Short / AMM only (diff 2, ΔPO 2) |
| Not New | 29 | 28 | Short / AMM only (0 ≤ diff 1 < 2) |
| Not New | 30 | 29 | Short / AMM only (diff 0) |
| Not New | 31 | 29 | Full (diff < 0) |

**Ref:** AC4, PRM-3069. **Priority:** High

### TC-23: Auto-filled Max PO on Create Deal matches the value saved and used for approval
**Steps:** For TC-01, TC-07, TC-10 and TC-17: on Create Deal, select Pub + Offer and note the auto-filled Max PO. Submit, then open the deal detail.
**Expected:** Auto-filled value = saved value = value used for the approval check (40 / 30 / 20 / 0).
**Ref:** AC4, C1, PRM-3069 item 2. **Priority:** High

### TC-23a: Auto-fill refreshes when Pub or Offer is changed on the form
**Steps:** On Create Deal, select P1 + OS (auto-fill 40). Change Offer to ON with Pub P2 (expected 20). Change back.
**Expected:** The Max PO auto-fill updates each time, following AC1–AC3 for the current Pub + Offer.
**Ref:** C1. **Priority:** Medium. *Note:* whether the auto-filled field is editable by AM is not stated in source and is not asserted here.

### TC-24: Badge matches the approval route
**Expected:** Auto-approved deals → green `AUTO-APPROVAL MET`. Short or full flow → red `MANUAL-APPROVAL REQUIRED`. Includes Max PO = 0 cases.
**Ref:** AC4, PRM-3069 item 3 / PRM-3092. **Priority:** Medium

### TC-25: ADV deals are unaffected
**Pre:** ADV deal (ADV ID ≠ 2) on an offer that would hit AC2/AC3 if it were In-house.
**Expected:** The ADV approval workflow is the same as before release. No Max PO = 0 / full-flow routing is introduced.
**Ref:** AC4, PRM-3069 "ADV deals must remain unchanged". **Priority:** High

### TC-26: Rejection still terminates the flow
**Steps:** For a TC-17 deal (Max PO = 0, full flow), have any approver (e.g. MO) Reject.
**Expected:** The workflow stops and the deal status becomes **Rejected**.
**Ref:** AC4, PRM-3069. **Priority:** Medium

### TC-27 (Open Question): Offer Standard toggle changed after a deal was submitted
**Steps:** Submit a deal P2 + ON (Parent 20 used, pending approval). Then switch ON to Standard = On.
**Expected:** A **new** deal created after the change follows AC2.1 (Cate 30), per C1. **Not defined in source:** whether the pending deal's saved Max PO is re-evaluated. See OQ-5.

### TC-28 (Open Question): Offer with Standard empty (migrated data)
**Pre:** Offer created before PRM-3398 migration, with the Standard field null or unset. Standard is a non-required toggle.
**Expected:** **Not defined in source.** Treat as Non-standard (toggle Off)? See OQ-4.

---

## 8. Open Questions (to confirm with PO / ticket owner)

| # | Question | Impacted TC |
|---|---|---|
| OQ-1 | AC3 "No Max PO found": is there a cascading fallback (Cate ↔ Parent), or is it the literal reading (0)? | TC-21 a–c |
| OQ-2 | ~~Parent mapping source~~ **Resolved (C5):** use the Parent Category configured in the system. Still open: what happens when a Category has **no** Parent Category? | TC-21d |
| OQ-3 | ~~Which lead date / scope~~ **Resolved (C2):** lead created date, same Pub + Offer. Still open: is exactly 30 days inclusive? Calendar or rolling days? Which timezone? | TC-15 |
| OQ-4 | How should an Offer with Standard null/unset be treated? | TC-28 |
| OQ-5 | ~~When is Max PO resolved~~ **Partly resolved (C1):** auto-filled on Create Deal. Still open: is the Max PO of a pending deal re-evaluated when Offer attributes or Max PO records change? | TC-27 |
| OQ-6 | **New Deal classification** (PRM-3069) still drives the $3 vs $2 thresholds. Confirm it is unchanged. Example: a Non-standard offer with lead but no Deal Max PO is "Not New" and gets Cate Max PO, so the $2 + Current PO rules apply. TC-22 assumes it is unchanged. | TC-07–TC-11, TC-22 |
| OQ-7 | ~~Scope: calculation job vs deal lookup~~ **Resolved (C1):** only the Max PO auto-fill on Create Deal. | – |
| OQ-8 | Does Max PO = 0 also apply to ADV deals, or only to In-house deals (where approval uses Max PO today)? | TC-25 |

---

## Summary

| Group | Confirmed TC | Open Question TC |
|---|---|---|
| AC1 Deal Max PO priority | TC-01 – TC-06 | – |
| AC2.1 Standard → Cate | TC-07, TC-08 | – |
| AC2.2 Non-standard → Cate / Parent | TC-09 – TC-14a, TC-16, TC-16a | TC-15 |
| AC3 Max PO = 0 → full flow | TC-17 – TC-20 | TC-21 |
| AC4 Regression | TC-22 – TC-26, TC-23a | TC-27, TC-28 |

**Readiness:** 27 confirmed TCs can be executed against PRM-3421's AC, BA clarifications C1–C5 and the PRM-3069 baseline. TC-15, TC-21, TC-27 and TC-28 stay Open Question.
