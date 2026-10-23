# Test Cases: [TM-9149] [PERU][TMS] Update Deposit (Prepaid) Payment Validation Process

**Source ticket (CR under test):** [TM-9149](https://accelo-tech.atlassian.net/browse/TM-9149) — CR, status: TESTING
**Related / impacted tickets (regression scope):**

| Ticket | Title | Status | Relationship to TM-9149 |
|---|---|---|---|
| [TM-8188](https://accelo-tech.atlassian.net/browse/TM-8188) | [PERU][TMS] Support Deposit (Prepaid) Payment Method for TMS | Done | Original Deposit spec. **Directly changed** by TM-9149 (Evidence moves Agent → QA; Approve no longer requires Evidence). |
| [TM-8514](https://accelo-tech.atlassian.net/browse/TM-8514) | [TMS][Order Shipping] Display Discount and Deposit Amount for All GEOs | Done | DO Detail payment breakdown. Must stay correct after the Deposit flow change. |
| [TM-8283](https://accelo-tech.atlassian.net/browse/TM-8283) | [TMS][PERU] CR: Deposit Callback Follow-up using Callback Reason "Waiting for Deposit" | Done | CR of TM-8188 (linked "blocks"). Referenced by TM-9149 Pending Clarification #2. |
| [TM-9203](https://accelo-tech.atlassian.net/browse/TM-9203) | [FE] subtask of TM-9149 | Done | Adds: hide `EVIDENCE` and `TRANSACTION_ID` in Order List for Agent role. |
| [TM-8675](https://accelo-tech.atlassian.net/browse/TM-8675) | [TMS] Transaction Verification | Done | Transaction ID / Paid-Unpaid flow for **Bank Transfer** — context only (Bank Transfer is hidden in LATAM per TM-8669). |

**Scope:** GEO = Peru, System = TMS, Payment Method = Deposit (Prepaid). COD must remain unchanged.

**Execution:** UAT run on 12/10/2026 — **23 Pass / 19 Fail / 16 Blocked / 17 Not Run**. Results and defects: see **Section 11**.

**Grounding rule:** Each test case cites its source. Cases marked **(OQ)** have no confirmed expected result in source — they must not be pass/failed until the business rule is confirmed (see Section 10).

---

## 0. Confirmed rule baseline (after TM-9149)

| # | Rule | Source |
|---|---|---|
| R1 | Agent flow for Deposit: select Delivery Service (Shalom/Olva) → Payment Method = Deposit → enter Deposit Amount → Approve. | TM-9149 §3.1 |
| R2 | Agent can Approve a Deposit case **without** Evidence and **without** Transaction ID. Both fields are **hidden** on the Agent order form. | TM-9149 §3.1, AC01; OQ-1 answer (confirmed by BA, 12/10/2026) |
| R3 | QA in Validation section: review → upload Evidence → enter Transaction ID → Validate. | TM-9149 §3.2, AC02 |
| R4 | On Validate, system checks Transaction ID for duplicates **only against Peru Deposit SOs whose current SO status = Validated** (COD / other payment methods and other GEOs are ignored). Delivery outcomes (Delivered, Delivery Fail, …) are tracked on the **DO status**, so they do not change the SO status — an SO stays Validated after its DO progresses. | TM-9149 §3.3, Pending Clarification #1 (confirmed 01/10/2026, Ana Pham); OQ-3 / OQ-4 answers (confirmed by BA, 12/10/2026) |
| R4a | Evidence **and** Transaction ID are **mandatory** for QA to Validate a Deposit case. Missing-field errors **reuse the error messages previously shown at the Agent step**: Evidence → `Evidence is required for Deposit payment before approving the lead` (TM-8188 §2). No exception for Deposit SOs approved before deploy. | OQ-2 / OQ-2b / OQ-10 answers (confirmed by BA, 12/10/2026) |
| R5 | Duplicate → Validate blocked, error: `The transaction number is already recorded for Lead ID:[Lead ID]`. Unique → Validate proceeds. ES text not specified — pass if the system's message conveys the same meaning. | TM-9149 §3.3, AC03, AC04; OQ-8 answer (confirmed by BA, 12/10/2026) |
| R6 | Transaction ID has **no required format** (no format / length rule). Duplicate comparison is **case-sensitive** and does **not trim** spaces (exact string match). | TM-9149 Pending Clarification #3 (confirmed 01/10/2026); OQ-5 answer (confirmed by BA, 12/10/2026) |
| R7 | COD process unchanged. | TM-9149 AC05 |
| R8 | Deposit Amount: required, > 0 and < Total Amount **after discount**. Errors: `Deposit amount must be greater than 0`, `Deposit amount must be less than total amount`. | TM-8188 §1 + API comment (Dino Nguyen); OQ-6 answer (confirmed by BA, 12/10/2026) |
| R9 | Evidence: 1 image/file only (updated by comment 11/06/2026 overriding "multiple"). A new upload **replaces** the existing file. Accepted types: .png, .jpg, .jpeg, .pdf. | TM-8188 comment 34594 + API 1; OQ-7 answer (confirmed by BA, 12/10/2026) |
| R10 | Order List: `EVIDENCE` and `TRANSACTION_ID` hidden for Agent role; visible as before for other roles. | TM-9203 |
| R11 | Deposit info (Payment method, Deposit amount, Evidence) displayed on Order Detail incl. Validation. | TM-8188 §7 |
| R12 | DO Detail shows Total Amount, Discount Amount (incl. Rescue Discount), Deposit Amount, COD Amount = Total − Discount − Deposit. | TM-8514 FR2 (see conflict C1) |
| R13 | ~~Callback reason "Waiting for Deposit" (ES: "Pendiente de depósito") for Callback Type = Potential; auto-close after 8 days.~~ **Superseded:** the "Waiting for Deposit" callback reason is **hidden on the UI** under the new flow (UI check only, no backend rejection required). Existing leads already holding this reason are out of test scope. All other callback reasons/rules unchanged. | TM-8283 (original); OQ-9 / OQ-11 / OQ-12 answers (confirmed by BA, 12/10/2026) |
| R14 | Callback Date column + filter only on Order Management; hidden on Validation, Shipping, Shipping Pending. | TM-8283 AC05 (see conflict C3) |

---

## 1. Agent Approval — Deposit (TM-9149 §3.1, AC01)

| ID | Title | Preconditions | Steps | Expected Result | Ref | Priority |
|---|---|---|---|---|---|---|
| TC-01 | Agent approves Deposit without Evidence and without Transaction ID | Agent (Peru) logged in; lead assigned with products; Total Amount = 300 | 1. Open lead → Delivery Service = Shalom<br>2. Payment Method = Deposit<br>3. Deposit Amount = 100<br>4. Leave Evidence / Transaction ID empty<br>5. Approve | Lead saved as Approved; SO created; no validation error. Case appears in Validation list. | AC01, R1, R2 | High |
| TC-02 | Same as TC-01 with Delivery Service = Olva | As TC-01 | Repeat TC-01 with Olva | Approved successfully. | R1 | High |
| TC-03 | **Regression of TM-8188 rule removal**: old evidence message no longer shown **at Agent Approve** | As TC-01 | Approve Deposit case without Evidence | Message `Evidence is required for Deposit payment before approving the lead` is **NOT** displayed at the Agent step (FE and API). Note: the same message is now expected at QA Validate (TC-24). | R2 vs TM-8188 §2 | High |
| TC-04 | Backend accepts Approve without evidence (API) | Valid token (Agent) | Call `PUT /api/v1/lead/v2` with `leadStatus=2`, `paymentMethod=3`, `amountDeposit` valid, `evidence` omitted / `[]` / `[""]` | 200 success for all 3 variants; no 400 evidence error. | R2, TM-8188 API 2 | High |
| TC-05 | Evidence & Transaction ID hidden on Agent order form | As TC-01 | Open Deposit order form as Agent (new lead and Callback lead) | Evidence upload and Transaction ID fields are **not displayed** when Payment Method = Deposit. Delivery Service, Payment Method, Deposit Amount still shown. | R2 (OQ-1) | High |
| TC-06 | Deposit Amount still required | As TC-01 | Deposit selected, Deposit Amount empty → Approve | Approve blocked; Deposit Amount required error. | R8 | High |
| TC-07 | Deposit Amount = 0 | As TC-01 | Deposit Amount = 0 → Approve | Blocked: `Deposit amount must be greater than 0`. | R8 | High |
| TC-08 | Deposit Amount negative | As TC-01 | Deposit Amount = -10 → Approve | Blocked (input rejected or > 0 error). | R8 | Medium |
| TC-09 | Deposit Amount = Total Amount (boundary) | Total = 300 | Deposit Amount = 300 → Approve | Blocked: `Deposit amount must be less than total amount`. | R8 | High |
| TC-10 | Deposit Amount > Total Amount | Total = 300 | Deposit Amount = 301 → Approve | Blocked: same message as TC-09. | R8 | High |
| TC-11 | Deposit Amount boundary valid values | Total = 300 | Deposit Amount = 0.01 and 299.99 (if decimals allowed) / 1 and 299 | Approve succeeds for each. | R8 | Medium |
| TC-12 | Deposit Amount compared to Total **after discount** — boundary | Total = 300, Discount = 30 → after discount = 270 | Deposit = 270 → Approve; then Deposit = 280 → Approve | Both blocked: `Deposit amount must be less than total amount`. | R8 (OQ-6) | High |
| TC-12a | Deposit just below after-discount Total | As TC-12 | Deposit = 269 → Approve | Approved. DO later shows COD = 300 − 30 − 269 = 1. | R8, R12 | High |
| TC-12b | Total changes after Deposit entered | Deposit = 250, Total = 300 → add discount so after-discount Total = 240 | Approve | Blocked (validation uses current after-discount Total). | R8 | Medium |
| TC-13 | Agent saves Deposit lead as Callback / Uncalled / Rejected / Trash | As TC-01 | Select Deposit, then save each non-Approve status | Saved without requiring Evidence / Transaction ID (unchanged behavior). | TM-8188 §2 | Medium |
| TC-14 | Payment-method switch Deposit → COD clears Deposit fields | As TC-01 | Select Deposit, enter Deposit Amount = 100 → switch to COD → Approve | Approved as COD; no Deposit Amount saved on SO; COD flow unchanged. | AC05, R7 | Medium |

## 2. QA Validation — Upload Evidence & Enter Transaction ID (TM-9149 §3.2, AC02)

| ID | Title | Preconditions | Steps | Expected Result | Ref | Priority |
|---|---|---|---|---|---|---|
| TC-15 | Deposit case approved by Agent appears in Validation | TC-01 done | QA opens Validation list | Case listed with Payment Method = Deposit; Deposit Amount visible on detail. | AC02, R11 | High |
| TC-16 | QA can upload Evidence in Validation section | QA logged in; Deposit case in Validation | Open case → upload 1 image (.jpg) | Upload succeeds; preview/link displayed in Evidence field. | AC02, R3 | High |
| TC-17 | QA can enter Transaction ID in Validation section | As TC-16 | Enter Transaction ID = `TXN-PE-0001` | Field editable; value retained. | AC02, R3 | High |
| TC-18 | QA validates with unique Transaction ID + Evidence (happy path) | As TC-16; `TXN-PE-0001` not used on any Validated SO | Upload evidence → enter Transaction ID → Validate | Validation succeeds; SO status = Validated; Evidence + Transaction ID persisted on SO. | AC02, AC03, R5 | High |
| TC-19 | Accepted Evidence file types | As TC-16 | Upload .png, .jpg, .jpeg, .pdf (separately) | Each upload succeeds. | R9, TM-8188 API 1 | Medium |
| TC-20 | Evidence limited to 1 file | As TC-16 | Try to upload a 2nd file | 2nd file **replaces** the 1st; only the latest file is shown and saved on the SO after Validate. | R9 (OQ-7) | Medium |
| TC-21 | Upload failure handling | Simulate invalid filename / IO error | Upload file | 400 → "upload failed, check file / rename"; 500 → "system error, try later" message; Validation not blocked silently. | TM-8188 API 1 | Low |
| TC-22 | QA replaces / removes evidence before Validate | As TC-16 | Upload A → remove → upload B → Validate | SO stores evidence B only. | R3 | Low |
| TC-23 | Validate without Transaction ID → blocked | As TC-16 | Upload evidence, leave Transaction ID empty → Validate | Validation blocked; SO status unchanged; shows the **same Transaction ID required message the Agent step used before this CR**. The exact text is not in the reviewed Jira sources. QC copies it from the pre-CR Agent screen (or asks dev) before running. | R4a (OQ-2b) | High |
| TC-24 | Validate without Evidence → blocked | As TC-16 | Enter unique Transaction ID, no evidence → Validate | Validation blocked; SO status unchanged; message `Evidence is required for Deposit payment before approving the lead` (reused from Agent step). | R4a (OQ-2b), TM-8188 §2 | High |
| TC-24a | Validate with both Evidence and Transaction ID empty → blocked | As TC-16 | Leave both empty → Validate | Validation blocked; both fields flagged as required. | R4a | High |
| TC-24b | Transaction ID whitespace only | As TC-16 | Upload evidence, Transaction ID = `"   "` → Validate | Spaces count as characters → `"   "` is accepted as a Transaction ID (mandatory rule satisfied). Validation succeeds if no Validated Peru Deposit SO has the exact same value; value saved as entered (spaces kept). See C9 (risk). | R4a, R6 (OQ-13) | Low |
| TC-24c | Mandatory check enforced server-side | QA token | Call validate API without Transaction ID and/or without evidence | Backend rejects; SO not validated. | R4a | High |
| TC-24d | Order of checks: missing field vs duplicate | As TC-16 | Transaction ID = duplicate value, Evidence empty → Validate | Validation blocked. Pass criterion = case not validated; which error shows first is **not** a pass criterion (not defined in source). | R4a, R5 | Low |
| TC-24e | Mandatory rule applies to Deposit only | COD case in Validation | Validate COD case with no Evidence / Transaction ID | Validated successfully (COD unchanged). | AC05, R4a | High |
| TC-25 | Evidence + Transaction ID shown on Order Detail after Validate | TC-18 done | Open Order Detail as Manager/QA | Payment method = Deposit, Deposit Amount, Evidence (QA-uploaded) and Transaction ID displayed. | R11 | Medium |
| TC-26 | Evidence uploaded by QA translated label (ES) | UI language = ES | Open Validation detail | Evidence label translated (per TM-8188 comment: "Evidence có translate"). | TM-8188 comment 34590 | Low |
| TC-27 | Agent cannot perform QA validation / edit QA fields | Agent logged in | Try to open Validation section / edit Transaction ID via UI or API | Agent has no access to Validate action (existing permission). | R3 | Medium |

## 3. Duplicate Transaction ID Validation (TM-9149 §3.3, AC03, AC04)

Test data setup: SO-A (Lead ID 1001) already **Validated** with Transaction ID `TXN-DUP-01`.

| ID | Title | Preconditions | Steps | Expected Result | Ref | Priority |
|---|---|---|---|---|---|---|
| TC-28 | Duplicate against a Validated SO → blocked | SO-A Validated with `TXN-DUP-01`; SO-B (Lead 1002) Deposit in Validation | QA on SO-B enters `TXN-DUP-01` → Validate | Validation blocked; SO-B status unchanged; error: `The transaction number is already recorded for Lead ID:1001`. | AC04, R4, R5 | High |
| TC-29 | Error message shows the Lead ID of the **existing** SO (not current) | As TC-28 | Check message content | `[Lead ID]` = 1001 (lead owning the Validated SO), not 1002. | §3.3 | High |
| TC-30 | Correct after duplicate error | After TC-28 | Change Transaction ID to unique `TXN-NEW-02` → Validate | Validation succeeds. | AC03 | High |
| TC-31 | Same Transaction ID used on SO **not** Validated → allowed | SO-C has `TXN-PEND-03` saved but status ≠ Validated (e.g., still in Validation / Approved) | QA on SO-D enters `TXN-PEND-03` → Validate | Validation allowed (check only against Validated SOs). | R4 (confirmed) | High |
| TC-32 | Both SOs with same pending Transaction ID — second validation blocked | Continue TC-31: SO-D now Validated with `TXN-PEND-03` | QA validates SO-C with `TXN-PEND-03` | Blocked with Lead ID of SO-D. | R4, R5 | High |
| TC-33 | Duplicate against Validated SO of **COD / other payment method** | A Validated non-Deposit SO stores Transaction ID `TXN-X` (if such data exists, e.g., legacy Bank Transfer per TM-8675) | Validate Deposit SO with `TXN-X` | Validation **allowed** — only Peru Deposit SOs are checked. | R4 (OQ-3) | Medium |
| TC-34 | Validated SO whose **DO** has progressed (Shipping / Delivered / Delivery Fail / Return) → still blocks | SO-A Validated with `TXN-DUP-01`; its DO updated to Delivered (repeat with Delivery Fail, Return) | Check SO-A status → Validate SO-B with `TXN-DUP-01` | SO-A status remains **Validated** (only DO status changed). SO-B validation blocked with `The transaction number is already recorded for Lead ID:1001`. | R4 (OQ-4 answer) | High |
| TC-34a | DO status change does not alter SO status | SO-A Validated; DO goes through each DO status | After each DO status update, open SO-A | SO status = Validated at every step. | R4 | High |
| TC-34b | SO whose current status is not Validated is ignored | SO-G had `TXN-G7` and its SO status is now not Validated (e.g., Rejected / Cancelled at SO level, if the system allows that transition) | Validate SO-H with `TXN-G7` | Validation allowed (only current SO status = Validated is checked). | R4 | Medium |
| TC-35 | Duplicate across GEOs | Validated SO in another GEO has `TXN-G1` | Validate Peru Deposit SO with `TXN-G1` | Validation **allowed** — other GEOs are not checked. | R4 (OQ-3) | Low |
| TC-36 | Case sensitivity | SO-A Validated with `abc123` | Validate SO-B with `ABC123`; then another SO with `abc123` | `ABC123` → **allowed** (case-sensitive). `abc123` → **blocked** (exact match). | R6 (OQ-5) | Medium |
| TC-37 | Leading/trailing spaces | SO-A Validated with `TXN-DUP-01` | Validate SO-B with ` TXN-DUP-01 ` | Validation **allowed** (no trim: value with spaces ≠ value without). Transaction ID saved exactly as entered, spaces included. | R6 (OQ-5) | Medium |
| TC-38 | No format restriction — special characters & alphanumeric | Deposit SO in Validation | Enter `TXN/2026-10#01_ñ`, numeric only `000123456`, letters only `ABCDEF` | Accepted (no format rule). Validation succeeds if unique. | R6 | Medium |
| TC-39 | Very long Transaction ID | Deposit SO in Validation | Enter 255+ characters | No business max length (R6). Verify no crash/truncation silently; DB limit behavior → note result for dev. | R6 | Low |
| TC-40 | Leading zeros are significant | SO-A Validated with `00123` | Validate SO-B with `123` | Not treated as duplicate (exact string compare) → Validation allowed. | R6 (OQ-5) | Low |
| TC-41 | Concurrent validation with same Transaction ID | SO-E and SO-F both in Validation; 2 QA users | Both enter `TXN-RACE` and click Validate at the same time | First-come-first-served: the QA whose Validate is processed **first** succeeds (SO becomes Validated). The other is blocked with `The transaction number is already recorded for Lead ID:[Lead ID of the first SO]`; that SO's status stays unchanged. Never both Validated. | R4, R5 (confirmed by BA, 12/10/2026) | Medium |
| TC-42 | Re-validate / re-save the same SO does not flag itself | SO-A Validated with `TXN-DUP-01` | If system allows re-opening/editing SO-A, save/validate again with same ID | Not blocked by its own record. | R4 | Medium |
| TC-43 | Duplicate check via API bypass | QA token | Call validate API directly with duplicate Transaction ID | Backend returns error with same message; SO not validated (check is server-side, not FE only). | AC04 | High |
| TC-44 | Error message language (ES UI) | UI = ES | Trigger TC-28 | Spanish duplicate error displayed. Pass if it means the same as the EN message (Transaction ID already recorded + the existing Lead ID). Record the actual ES text in the result. | R5 (OQ-8) | Low |

## 4. Order List field visibility by role (TM-9203)

| ID | Title | Preconditions | Steps | Expected Result | Ref | Priority |
|---|---|---|---|---|---|---|
| TC-45 | Agent: EVIDENCE & TRANSACTION_ID hidden in Order List | Agent (Peru) logged in | Open Order List | `EVIDENCE` and `TRANSACTION_ID` columns/fields not displayed. | TM-9203 AC1 | High |
| TC-46 | Manager: fields displayed | Manager logged in | Open Order List | Both fields displayed as before. | TM-9203 AC2 | High |
| TC-47 | QA / other roles: fields displayed | QA logged in | Open Order List | Both fields displayed. | TM-9203 AC2 | Medium |
| TC-48 | Agent cannot reveal hidden fields via column config / export | Agent | Try column chooser / export Order List | `EVIDENCE` and `TRANSACTION_ID` cannot be shown via column config and are not included in export for Agent. | TM-9203 (confirmed by BA, 12/10/2026) | Low |

Test accounts: see TM-9203 (not reproduced here).

## 5. Display & Amount Calculation — regression TM-8188 §7 / TM-8514

Test data: Total Amount = 300, Discount = 30 (incl. Rescue Discount 10), Deposit = 100.

| ID | Title | Steps | Expected Result | Ref | Priority |
|---|---|---|---|---|---|
| TC-49 | Order Detail (incl. Validation) shows Deposit info | Open Order Detail / Validation detail of Deposit SO | Payment Method = Deposit (Prepaid), Deposit Amount = 100, Evidence (after QA upload). Before QA upload: Evidence empty, no error. | R11 | High |
| TC-50 | DO Detail payment breakdown (Peru Deposit) | After Validate → DO created → open DO Detail | Total = 300, Discount = 30, Deposit = 100, COD = 300 − 30 − 100 = **170**. | TM-8514 FR2 (conflict C1) | High |
| TC-51 | DO Detail — Deposit order without discount | Total 300, Discount 0, Deposit 100 | COD = 200. | TM-8514 | Medium |
| TC-52 | DO Detail — COD order (no deposit) | COD order, Total 300, Discount 30 | Deposit = 0 (or blank), COD = 270. | TM-8514, AC05 | Medium |
| TC-53 | DO Detail — non-Peru GEO | Any other GEO DO with discount | Same 4 fields & formula displayed (TM-8514 applies to all GEOs). | TM-8514 AC1 | Medium |
| TC-54 | DO amounts not affected by moving Evidence/Transaction ID to QA | Compare DO of Deposit SO created post-CR vs expectations | Deposit Amount on DO = Agent-entered amount; QA actions do not change amounts. | TM-9149 §3.1 + TM-8514 | Medium |

## 6. Callback flow — regression TM-8188 §3–5 / TM-8283

| ID | Title | Steps | Expected Result | Ref | Priority |
|---|---|---|---|---|---|
| TC-55 | "Waiting for Deposit" reason is hidden (EN) | Agent: Status = Callback, Type = Potential → open Callback Reason | "Waiting for Deposit" **not** listed. | R13 (OQ-9 answer) | High |
| TC-55a | "Pendiente de depósito" reason is hidden (ES) | Same as TC-55 with UI = ES | "Pendiente de depósito" **not** listed. | R13 | Medium |
| TC-55b | Other Potential callback reasons still listed | Same as TC-55 | All other existing Potential reasons displayed as before. | R13, TM-8283 AC04 | High |
| TC-57 | Other callback reasons keep existing auto-close | Callback with other reason | Existing (3-day) rule applies. | TM-8283 AC03 | Medium |
| TC-58 | Callback → Approve without evidence | Lead in Callback (any available reason) → customer agrees → Agent sets Deposit + amount → Approve | Approved without evidence (R2); case goes to Validation. | R2 | High |
| TC-60 | Callback Date column visibility | Open Order Management, Validation, Shipping, Shipping Pending | Shown + filterable on Order Management only; hidden on the other 3. | TM-8283 AC05 (conflict C3) | Medium |
| TC-61 | Callback Date filter works | Order Management → filter Callback Date range | Only leads within range returned (`yyyyMMddHHmmss|yyyyMMddHHmmss`). | TM-8188 API 3 | Low |

## 7. COD & other payment methods — no impact (AC05)

| ID | Title | Steps | Expected Result | Ref | Priority |
|---|---|---|---|---|---|
| TC-62 | COD Agent approval unchanged | Agent approves COD order | Same behavior as before; no Deposit/Evidence/Transaction ID fields required. | AC05 | High |
| TC-63 | COD QA validation unchanged | QA validates COD order | No Evidence upload / Transaction ID requirement; **no duplicate check triggered**. | AC05 | High |
| TC-64 | Only COD and Deposit shown in Peru/LATAM | Open Payment Method dropdown | COD and Deposit only (Bank Transfer hidden). | TM-8669 (title only) | Low |

## 8. Data migration / in-flight orders

| ID | Title | Expected Result | Ref | Priority |
|---|---|---|---|---|
| TC-65 | Deposit SO approved **before** deploy (Agent already uploaded evidence) and pending Validation | QA sees existing evidence (counts as Evidence). No exception: Validate without Transaction ID → blocked (TC-23 message); with unique Transaction ID → Validated. | R4a (OQ-10) | Medium |
| TC-66 | Legacy Validated Deposit SOs with Transaction ID | Their Transaction IDs are included in duplicate check (R4). Verify with a legacy ID. | R4 | Medium |

## 9. Source conflicts identified (must be acknowledged by BA/PO)

| # | Conflict | Sources | Test handling |
|---|---|---|---|
| C1 | **COD Amount formula**: TM-8188 = `Final Order Amount − Deposit Amount`; TM-8514 = `Total Amount − Discount Amount − Deposit Amount` (applies to all GEOs). Also TM-8514 AC2 says "Order Amount − Discount − Deposit". | TM-8188 §7, TM-8514 FR2/AC2 | Tested with TM-8514 (latest, Done). Equivalent only if "Final Order Amount" = Total − Discount. |
| C2 | **Evidence quantity**: TM-8188 AC says "multiple images/files"; description strikes "multiple" and comment 11/06/2026 says only 1 image. | TM-8188 desc/AC/comment 34594 | Tested as 1 file (latest decision). |
| C3 | **Callback Date column**: TM-8188 says 4 screens; TM-8283 (later CR) says Order Management only. | TM-8188 §6, TM-8283 AC05 | Tested per TM-8283. |
| C4 | TM-8188 AC "System must require at least 1 Evidence before Approve" is **reversed** by TM-9149. | TM-8188 §2, TM-9149 §3.1 | TC-03/TC-04 verify the old rule is removed. TM-8188 should be marked superseded on this point. |
| C5 | TM-8283 AC01 ("Waiting for Deposit" displayed) is **reversed**: the reason is now hidden. This decision (12/10/2026) is not yet written into TM-9149 — Pending Clarification #2 still shows as open on the ticket. | TM-8283 AC01, OQ-9 answer | TC-55–55b test the hidden state. Recommend updating TM-9149 §6 #2 + AC so dev/QC share the same source. |
| C6 | Confirmed in chat, **not yet on TM-9149**: Agent form hides Evidence/Transaction ID (OQ-1); mandatory Evidence + Transaction ID at Validate with reused Agent error messages, no legacy exception (OQ-2/2b/10); duplicate scope = Peru Deposit SOs with current status Validated, case-sensitive, no trim (OQ-3/4/5); Deposit < Total after discount (OQ-6); evidence re-upload replaces (OQ-7). | OQ answers 12/10/2026 | Recommend adding to TM-9149 §3.1–3.3 / AC. |
| C9 | **Risk (recommendation, not a requirement):** because spaces count as characters (OQ-13), QA can pass the mandatory Transaction ID rule by typing only spaces, and ` TXN-01` / `TXN-01` are treated as different IDs. This weakens the duplicate check against accidental spaces. | OQ-5, OQ-13 answers | Tested as confirmed (TC-24b, TC-37). Raise with PO whether trim / spaces-only blocking is wanted later. |
| C8 | TM-9149 §3.3 says "already exists **in the system**", but the confirmed scope is narrower: only Peru Deposit SOs with status Validated. | TM-9149 §3.3, OQ-3/OQ-4 | Tested per the narrower confirmed scope (TC-31, 33, 35). |
| C7 | The reused Evidence message says "…before **approving the lead**", but it now appears when QA **validates**. The wording no longer matches the action. | TM-8188 §2, OQ-2b answer | Tested as-is (TC-24). Raise with PO if the wording should be adjusted. |

## 10. Open Questions

| # | Question | Blocks |
|---|---|---|
| ~~OQ-1~~ | **Resolved 12/10/2026:** hidden on the Agent order form. | — |
| ~~OQ-2~~ | **Resolved 12/10/2026:** Evidence and Transaction ID are mandatory at QA Validate. | — |
| ~~OQ-2b~~ | **Resolved 12/10/2026:** reuse the Agent-step error messages from before this CR. Note: the exact pre-CR Transaction ID message is not in the reviewed Jira sources. QC gets it from the pre-CR Agent screen or from dev (TC-23). Error display order is not a pass criterion. | — |
| ~~OQ-3~~ | **Resolved 12/10/2026:** only Peru Deposit SOs. | — |
| ~~OQ-4~~ | **Resolved 12/10/2026:** current SO status = Validated. Delivery outcomes live on DO status, so the SO stays Validated. | — |
| ~~OQ-5~~ | **Resolved 12/10/2026:** case-sensitive, no trimming (exact string match). | — |
| ~~OQ-6~~ | **Resolved 12/10/2026:** Total after discount. | — |
| ~~OQ-7~~ | **Resolved 12/10/2026:** new upload replaces the existing file. | — |
| ~~OQ-8~~ | **Resolved 12/10/2026:** use the system's current ES message; pass if the meaning is correct. | — |
| ~~OQ-9~~ | **Resolved 12/10/2026:** hide the "Waiting for Deposit" callback reason. | — |
| ~~OQ-10~~ | **Resolved 12/10/2026:** no exception. | — |
| ~~OQ-11~~ | **Resolved 12/10/2026:** UI check only. TC-55c removed. | — |
| ~~OQ-12~~ | **Resolved 12/10/2026:** out of scope (skip). TC-56 removed. | — |
| ~~OQ-13~~ | **Resolved 12/10/2026:** spaces are counted as characters, so a Transaction ID of spaces only is accepted. | — |
| ~~—~~ | **Resolved 12/10/2026:** Agent cannot see hidden fields via column config / export (TC-48). | — |
| ~~—~~ | **Resolved 12/10/2026:** concurrent validation with the same Transaction ID → whoever validates first wins (TC-41). | — |

## Summary

| Area | Confirmed TCs | OQ-dependent TCs |
|---|---|---|
| Agent approval (AC01) | TC-01–14, 12a, 12b | — |
| QA validation (AC02 + mandatory rule) | TC-15–24, 24a–24e, 25–27 | — |
| Duplicate Transaction ID (AC03/AC04) | TC-28–44, 34a, 34b | — |
| Order List role visibility (TM-9203) | TC-45–48 | — |
| Display & amounts (TM-8188/TM-8514) | TC-49–54 | — |
| Callback (TM-8283, reason hidden) | TC-55, 55a, 55b, 57, 58, 60, 61 | — |
| COD / no impact (AC05) | TC-62–64 | — |
| Migration | TC-65, TC-66 | — |

**Total: 75 test cases — all executable against confirmed rules; no open questions remain.** Removed: TC-59 (OQ-9), TC-55c (OQ-11), TC-56 (OQ-12).

**Decisions confirmed 12/10/2026 (OQ-1 – OQ-13, TC-41, TC-48) are not yet on TM-9149** — see C5/C6/C8; risk note in C9.

---

## 11. Test Execution Results — UAT, 12/10/2026

**Environment:** https://lt-tmsapp.uat.salespikes.global, GEO = Peru, UI language = ES. Accounts: Manager 01, Agent 01, Validator 01 (credentials not recorded here).
**Method:** browser automation (Chrome) for UI steps. API calls used the logged-in session; payloads were captured from the real UI.
**Evidence:** screenshots in [evidence-TM-9149/](evidence-TM-9149/).

### 11.1 Test data created

| Lead | SO | DO | Purpose | Final state |
|---|---|---|---|---|
| 60801 "TC9149 Test 01" | 362 | 333 | Deposit 20, approved **without evidence** (API) | SO **validated** with no evidence and no Transaction ID |
| 60802 "TC9149 Test 02" | 363 | — | Deposit boundary tests | SO new, **Deposit 75 / COD 55**: inconsistent data left by the API test in TC-09. **Needs cleanup.** |
| 60803 "TC9149 Test 03 COD" | 364 | 338 | COD regression | SO validated, COD 75 |
| 60804 "TC9149 Dup A" | 365 | 334 | Transaction ID `TC9149Dup113739` | SO validated |
| 60805 "TC9149 Dup B" | 366 | 335 | Same Transaction ID as A | SO **validated** (duplicate not blocked) |
| 60806 "TC9149 Dup C case" | 367 | 336 | `tc9149dup113739` | SO validated |
| 60807 "TC9149 Dup D space" | 368 | 337 | ` TC9149Dup113739` (leading space) | SO validated, value stored with the space |

### 11.2 Execution constraints (read before the results)

| # | Constraint | Impact |
|---|---|---|
| E1 | Leads created by Agent are **unassigned** (`assigned = 0`), so Agent gets "Denegar acceso" on them. Mass distribution shows no campaigns. | Agent could not process the new leads. Approvals were done by **Manager** (UI + API). Agent-role checks used lead 60775, already assigned to Agent 01. |
| E2 | Agent's lead page shows no status buttons (Aprobado, etc.) until a PBX call is connected. No call was placed. | Agent Approve via UI was **not executed**. AC01 was verified with the Manager role and the API. |
| E3 | No delivery packages are configured for the tested locations (`No delivery packages found for carrier ID: 252`). | Shalom / Olva could not be selected (TC-02 blocked). |
| E4 | Validation screen: Evidence and Transaction ID are read-only for Validator **and** Manager. | All "QA enters Transaction ID" cases were blocked. Transaction IDs for the duplicate tests were set at the approve step instead (API payload). |

### 11.3 Results

| TC | Status | Actual result / evidence |
|---|---|---|
| TC-01 | **Fail** | Approve Deposit without evidence is blocked by FE: toast `Se requiere evidencia para el pago de depósito antes de aprobar el lead` (Manager, leads 60801/60802). Agent form also marks `Evidencia *` required (60775). Screenshot 02. Bug: TM-9215. |
| TC-02 | Blocked | E3: no delivery service options. |
| TC-03 | **Fail** | The TM-8188 evidence message (ES) is still shown at Approve. Screenshot 02. |
| TC-04 | Pass | `PUT /api/v1/lead/v2` with `evidence = ""` → 200; lead 60801 approved, SO 362 created. Tested with the Manager token, not Agent (E1). |
| TC-05 | **Fail** | Agent form (lead 60775, Deposit): `Evidencia *` upload is **displayed and required**. `ID de transacción` is hidden (correct). Screenshot 01. Bug: TM-9215. |
| TC-06 | Not Run | — |
| TC-07 | Pass (API) | API rejects Deposit 0 with `Deposit amount must be greater than 0`, but returns **HTTP 500** (body code 400), see D7. FE shows no inline error for 0; it falls through to the evidence toast. |
| TC-08 | Not Run | — |
| TC-09 | **Fail** | FE: Deposit 75 (= total after discount 75) → inline `Deposit amount must be less than total amount.` (correct, screenshot 03). **Backend accepted Deposit 75** (200) → SO 363 saved with Deposit 75 / COD 55. See D6. |
| TC-10 | Pass (FE) | Deposit 80 and 100 → inline error (screenshot 04). Backend not tested for these values. |
| TC-11 | Not Run | — |
| TC-12 | **Fail** | Same as TC-09: FE compares with the total after discount (correct), backend does not. |
| TC-12a | Pass (FE) | Deposit 74 passes the deposit rule; save was then blocked only by the evidence rule (TC-01). COD = 1 not verified. |
| TC-12b | Not Run | — |
| TC-13 | Not Run | — |
| TC-14 | Not Run | — |
| TC-15 | Pass | SO 362/363 appear in Validación with Método de pago = Deposit. |
| TC-16 | **Fail** | Validation detail: Evidencia box has **no upload control** (no file input), for both Validator and Manager. Screenshot 05. Bug: TM-9216. |
| TC-17 | **Fail** | `ID de transacción` input is **disabled** in Validation, before and after clicking VALIDADO. Screenshot 05. Bug: TM-9216. |
| TC-18 | **Fail** | QA cannot upload evidence or enter a Transaction ID (TC-16/17). The validate request `PUT /api/v1/SO/Validate` carries no evidence or Transaction ID fields. Bug: TM-9216. |
| TC-19 | Blocked | No upload in Validation (D1). PNG upload works at the approve step. |
| TC-20 | Blocked | D1. |
| TC-21 | Not Run | — |
| TC-22 | Blocked | D1. |
| TC-23 | **Fail** | SO 362 validated with no Transaction ID: `PUT /api/v1/SO/Validate` → 200 `Sucesss`. SO API: `paymentTransactionId = null`, `status = validated`. |
| TC-24 | **Fail** | Same SO 362: validated with `evidence = null`. Screenshot 06. |
| TC-24a | **Fail** | Same SO 362 (both fields empty) → validated, no error. |
| TC-24b | Blocked | Transaction ID cannot be entered in Validation (D1). |
| TC-24c | **Fail** | Backend `PUT /api/v1/SO/Validate` accepted SO 362 without evidence or Transaction ID. |
| TC-24d | Blocked | D1. |
| TC-24e | Pass | COD SO 364 validated without evidence or Transaction ID. Screenshot 11. |
| TC-25 | Pass | Validation/Order detail shows Deposit, deposit amount, evidence and Transaction ID (SO 361, 365, 366). |
| TC-26 | Pass | Label shown as "Evidencia" (ES). |
| TC-27 | Not Run | Note: Agent's sidebar shows a "Validación" menu item; access not tested. |
| TC-28 | **Fail** | SO 365 (lead 60804) validated with `TC9149Dup113739`. Then SO 366 (lead 60805), same Transaction ID → **validated, no error**. Confirmed via `GET /api/v1/SO/366`: `statusName = validated`, `paymentTransactionId = TC9149Dup113739`. Screenshot 08. |
| TC-29 | **Fail** | No duplicate message displayed at all. |
| TC-30 | Blocked | Transaction ID not editable in Validation. |
| TC-31 | Pass* | SO 365 validated while SO 366 with the same Transaction ID was pending. *Passes only because no duplicate check exists (TC-28).* |
| TC-32 | **Fail** | Same as TC-28. |
| TC-33 | Not Run | — |
| TC-34 | Blocked | Depends on a working duplicate check (TC-28). |
| TC-34a | Blocked | Same. |
| TC-34b | Blocked | Same. |
| TC-35 | Not Run | — |
| TC-36 | Pass* | SO 367 (`tc9149dup113739`) validated. *Not meaningful while TC-28 fails.* |
| TC-37 | Pass* | SO 368 validated; the leading space is stored as entered. *The duplicate part is not meaningful while TC-28 fails.* |
| TC-38 | Blocked | D1. |
| TC-39 | Blocked | D1. |
| TC-40 | Blocked | D1. |
| TC-41 | Blocked | D3 (no duplicate check). |
| TC-42 | Not Run | — |
| TC-43 | **Fail** | Backend validate API accepted the duplicate (SO 366). |
| TC-44 | Blocked | No duplicate message exists. |
| TC-45 | **Fail** | Agent order detail shows `Evidencia` (TXN correctly hidden). Note: Gestión de pedidos list has **no** Evidence or Transaction ID column for **any** role, and "Lista de pedidos" is a report page without these columns. |
| TC-46 | Pass | Manager sees `Evidencia` and `ID de transacción` on order detail. |
| TC-47 | Pass | Validator sees both on the Validation detail. |
| TC-48 | Pass | Agent's View Columns chooser has no Evidence or Transaction ID. Export not tested. |
| TC-49 | Pass | Validation detail shows Método de pago = Deposit, Importe del depósito, Evidencia. |
| TC-50 | Pass (API) | SO 366: total 100, discount 25, deposit 20, `codAmount` 55 = 100 − 25 − 20. DO detail screen not opened (Envío list returned 0 rows). |
| TC-51 | Not Run | — |
| TC-52 | Pass (API) | COD SO 364: deposit null, `codAmount` 75 = 100 − 25. |
| TC-53 | Not Run | — |
| TC-54 | Pass (API) | SO deposit = amount entered at approve (20). |
| TC-55 | **Fail** | `GET /api/v1/synonym/object?typeId=43` still returns "Waiting for Deposit". EN UI not opened. Bug: TM-9217. |
| TC-55a | **Fail** | Callback → Potencial → Motivo lists **"Pendiente de depósito"** (screenshot 10). Not saved. Note: hide decision was made 12/10/2026, so it is likely not implemented yet. Bug: TM-9217. |
| TC-55b | Pass | Other reasons still listed: Pendiente por entrega lejana, Esperando entrega de paquete, Esperando cotización, Esperando decidir cuántas unidades comprar, Esperando transferencia. |
| TC-57 | Not Run | Needs elapsed time. |
| TC-58 | Blocked | E2 and the TC-01 FE block. |
| TC-60 | Pass | "Fecha de devolución de llamada" column on Gestión de pedidos only. Absent on Validación, Envío, Envío pendiente. |
| TC-61 | Not Run | — |
| TC-62 | Pass | COD lead 60803 approved without deposit or evidence ("Succeed!"). Manager role (E1). |
| TC-63 | Pass | COD SO 364 validated, no duplicate check involved. |
| TC-64 | Pass | Método de pago options: Deposit, COD. |
| TC-65 | Not Run | — |
| TC-66 | Not Run | — |

**Totals:** 23 Pass (3 marked * are not meaningful until TC-28 is fixed) / 19 Fail / 16 Blocked / 17 Not Run = 75.

### 11.4 Defects found

| # | Severity | Defect | TCs | Jira Bug |
|---|---|---|---|---|
| D1 | High | Validation screen: Evidence has no upload control and Transaction ID is disabled. QA cannot do the core TM-9149 steps (AC02). | TC-16, 17, 18 | TM-9216 |
| D2 | High | Deposit SO can be validated with **no Evidence and no Transaction ID** (FE and backend `PUT /api/v1/SO/Validate`). SO 362. | TC-23, 24, 24a, 24c | — |
| D3 | High | **Duplicate Transaction ID not blocked**: SO 366 validated with the same ID as Validated SO 365. No error message. | TC-28, 29, 32, 43 | — |
| D4 | High | Approve Deposit **still requires Evidence** on FE (TM-8188 rule not removed): toast `Se requiere evidencia…`. Backend already allows it. | TC-01, 03 | TM-9215 |
| D5 | Medium | Agent order form still shows `Evidencia *` (required). It should be hidden (OQ-1). Transaction ID is correctly hidden. | TC-05, 45 | TM-9215 (tracks TC-05; TC-45 not yet assigned) |
| D6 | Medium | Backend accepts Deposit = total after discount (75/75) → SO 363 saved with Deposit 75 and COD 55 (inconsistent). FE validates correctly. | TC-09, 12 | — |
| D7 | Low | Deposit 0 rejected with the correct message but **HTTP 500** instead of 400. | TC-07 | — |
| D8 | Medium | Callback reason "Waiting for Deposit / Pendiente de depósito" still selectable (decision 12/10/2026 — needs a ticket/implementation). | TC-55, 55a | TM-9217 |

**Jira bug tracking:** [TM-9215](https://accelo-tech.atlassian.net/browse/TM-9215) covers **TC-01 and TC-05** (D4 + D5) in one ticket. [TM-9216](https://accelo-tech.atlassian.net/browse/TM-9216) covers **TC-16, TC-17, TC-18** (D1). [TM-9217](https://accelo-tech.atlassian.net/browse/TM-9217) covers **TC-55, TC-55a** (D8).

### 11.5 Follow-ups

1. Raise D1–D8 to dev (no Jira change was made by this run).
2. Clean up SO 363 (Deposit 75 / COD 55) and, if needed, the other test SOs 362, 364–368 / DOs 333–338.
3. Re-run Blocked and Not Run cases after D1–D4 are fixed. For the Agent role, the following are needed:
   - Leads assigned to Agent 01 (E1).
   - A way to set status without a PBX call (E2).
   - A delivery package configured for at least one Peru location (E3).
