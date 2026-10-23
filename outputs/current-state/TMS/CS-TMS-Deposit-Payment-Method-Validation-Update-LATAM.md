# Current-State Analysis: Deposit Payment Method Validation Function Update (LATAM)

## 1. Request Context

**Requested change (Target State — not yet confirmed as current behavior):**
Email from Ana Pham to IT Team (`inputs/references/latam request.png`), "Request for the Deposit Payment Method Validation Function Update." Requests moving Evidence upload and Transaction ID entry from the **Agent** step to the **QA/Validation** step, and adding a Transaction ID uniqueness check that blocks validation and shows a specific error message if the Transaction ID was already used.

Requester-stated **current process** for Deposit:
1. Agent selects delivery service (Shalom/Olva)
2. Agent selects payment method = Deposit
3. Agent enters deposit amount
4. Agent uploads payment evidence
5. Agent enters Transaction ID
6. Agent approves the case
7. QA validates the case in the Validation section

Requester-stated **proposed process**:
- Agent: selects delivery service + payment method, enters deposit amount, approves the case.
- QA (Validation): reviews the case, uploads payment evidence, enters Transaction ID, validates the case.
- New rule: reject validation if the Transaction ID already exists in the system, with a specific error message (`code: 300`, example message "The transaction number is already recorded ...").

**Target/System:** TMS (Telesale Management System), Order Management / Validation module, Deposit payment method, GEO = LATAM.

**Analysis scope:** Whether the requester's stated "current process" matches confirmed TMS Deposit-flow behavior, and what current validation/uniqueness logic exists around Transaction ID today.

## 2. System Resolution

No system was explicitly named in the email. Resolved to **TMS** (registry key `TMS`) based on strong converging local and Jira evidence: TMS Order Management already has a "Payment Method" field with COD/Deposit/Bank Transfer values (local BRD `outputs/brd/TMS/BRD-TMS-Display-Click-ID-Order-List-Order-Management.md`), and multiple Jira TMS tickets directly document a "Deposit (Prepaid)" payment method, a "Validation" module/section, and Transaction ID handling (see below) — an exact terminology match to the email. GEO = LATAM is stated directly in the file name and matches Jira ticket TM-8669 ("[LATAM][TMS] Hide Unused Payment Methods... COD and Deposit"). Confidence: **High** — proceeding without a separate confirmation question, but flagging the resolution basis for the record.

## 3. Sources Reviewed

| # | Source | Type | Status | Scope | Notes |
|---|---|---|---|---|---|
| S1 | `inputs/references/latam request.png` | Stakeholder email (Ana Pham) | Provided, not yet approved as BRD/CR | LATAM | Defines Target State + requester's own "current process" claim. |
| S2 | Jira TM-8188 — "[PERU][TMS] Support Deposit (Prepaid) Payment Method for TMS" | Historical ticket, Done (Story) | Done, updated 2026-07-22 | Peru (LATAM) | **Primary source for the actual Deposit-flow spec** — directly on point. |
| S3 | Jira TM-8675 — "[TMS] Transaction Verification" | Historical ticket, Done (Task) | Done, updated 2026-08-10 | Not GEO-restricted in ticket body | Documents Transaction ID / Paid-Unpaid logic — but scoped to **Bank Transfer**, not Deposit. |
| S4 | Jira TM-8669 — "[LATAM][TMS] Hide Unused Payment Methods on TMS for LATAM Market... COD and Deposit" | Historical ticket, Done | Done, updated 2026-08-04 | LATAM | Confirms only COD and Deposit are currently active payment methods shown in LATAM (Bank Transfer hidden). Description empty — title only. |
| S5 | Jira TM-8440 — "[TMS][UXUI] Redesign Order Validation UI" | Ticket, **To Do** (not released) | To Do, updated 2026-06-29 | Not GEO-restricted | Confirms current Validation module structure/columns (incl. Payment Method, Payment Status) but is itself an unreleased redesign — treated as context only, not current production UI. |
| S6 | `outputs/brd/TMS/BRD-TMS-Display-Click-ID-Order-List-Order-Management.md` | Local approved BRD | Approved | TMS | Corroborates existing "Payment Method" / "Payment Status" fields in Order Management. |
| — | Jira TM-882 "Many fresh lead ID have same Click_id (Transaction_id) in cl_fresh table" | Historical bug | Done | — | **Different field**: this "Transaction_id" refers to affiliate Click ID in the lead table, not the customer bank-transfer Transaction ID discussed here. Excluded as a different concept sharing a similar name — flagged to avoid confusion, not merged as evidence. |
| — | Confluence | Not searched | N/A | N/A | Not performed in this pass — coverage gap. |

## 4. Confirmed Current State

### 4.1 Deposit payment method flow (per TM-8188 — the documented Deposit spec)

| Step | Confirmed behavior | Source |
|---|---|---|
| 1 | Agent selects Payment Method = Deposit (Prepaid). | S2 |
| 2 | System requires a Deposit Amount field: must be > 0 and < Total Amount. | S2 |
| 3 | System requires Evidence upload (1+ images/files) — the customer sends proof via WhatsApp, and the **Agent** uploads it into TMS. | S2 |
| 4 | Evidence is required **before Approve**; evidence is **not** required to save the lead as Uncalled, Rejected, Trash, or Callback. Validation message: "Evidence is required for Deposit payment before approving the lead." | S2 |
| 5 | If the customer hasn't sent evidence yet, the Agent may save the lead as Callback (with a Callback Date), and the system auto-closes Peru Deposit callback leads after **8 days** (vs. the standard 3-day callback auto-close). | S2 |
| 6 | Deposit information (Payment method, Deposit amount, Evidence) is shown on Order Detail (**including Validation**) and DO Detail (Total/Discount/Deposit/COD Amount). | S2 |

**No Transaction ID field is documented anywhere in TM-8188's Deposit-flow spec.** The Agent-side Deposit flow as specified consists of: delivery service → payment method → deposit amount → evidence upload → approve. This **does not match** the requester's stated current-process step 5 ("Agent enters the Transaction ID") for Deposit.

### 4.2 Transaction ID / Transaction Verification flow (per TM-8675 — documented for Bank Transfer, not Deposit)

| Step | Confirmed behavior | Source |
|---|---|---|
| 1 | Agent selects Payment Method = **Bank Transfer** (a separate method from Deposit). | S3 |
| 2 | System displays company bank details (Company Name, Account Number, Bank and Branch). | S3 |
| 3 | Agent manually enters the customer's Transaction ID — **mandatory before the lead can be approved**. | S3 |
| 4 | On Agent approval: Lead Status = Approved, Transaction Status = Unpaid. | S3 |
| 5 | Accountant manually checks the Transaction ID; if valid, confirms it — Transaction Status changes Unpaid → Paid, with a recorded confirmation timestamp. | S3 |
| 6 | In the Validation menu: **Paid** → QA can validate the order; **Unpaid** → QA cannot validate. | S3 |
| 7 | After QA validates a Paid order, Order Status → Validated. | S3 |

This is a **separate documented flow, tied to Bank Transfer**, not Deposit. There is no confirmed source stating this Transaction ID/Accountant-confirmation logic also runs for the Deposit payment method.

### 4.3 Active LATAM payment methods

Per TM-8669 (Done, LATAM), only **COD** and **Deposit** are currently shown/active payment methods in the LATAM market UI — Bank Transfer and other methods are hidden. Ticket body has no further description beyond the title. *(Source: S4.)*

### 4.4 No confirmed current Transaction ID uniqueness check

No source reviewed documents an existing validation rule that checks whether a Transaction ID has already been used/recorded, for either the Deposit or Bank Transfer flow. TM-8675's Accountant-confirmation step (S3) checks validity manually, not duplicate-ness programmatically. **Not defined in source.**

## 5. Gaps and Conflicts

| # | Issue | Impact | Required Resolution |
|---|---|---|---|
| G1 | **The requester's stated "current process" includes a Transaction ID entry step for Deposit (step 5), but the only documented Deposit spec (TM-8188) does not mention a Transaction ID field at all** — Transaction ID is only documented for the separate Bank Transfer flow (TM-8675). Either (a) the Deposit flow was extended with a Transaction ID step by a change not found in the sources reviewed, (b) TMS's actual production Deposit UI has since converged with the Bank Transfer flow (plausible, since only COD/Deposit remain visible per TM-8669 — Bank Transfer's Transaction ID field may have been folded into Deposit when Bank Transfer was hidden), or (c) the requester is describing behavior loosely/imprecisely. | Cannot confirm the exact current field set and step order for the Deposit flow as it exists in production today without resolving this discrepancy. Any CR built only on TM-8188 would omit the Transaction ID step the requester describes as already existing; any CR built only on the requester's description would risk stating unconfirmed current behavior as fact. | Confirm directly (screenshot of production TMS Deposit flow, or with engineering) whether Transaction ID entry is currently part of the Deposit payment method flow, and if so, since when / under which ticket. |
| G2 | **No current Transaction ID uniqueness/duplicate check exists in any reviewed source.** This is confirmed as new logic, not a change to an existing rule. | The requested duplicate-check rule and its exact error payload (code 300, message format, whether it blocks only QA validation or also Agent entry) need full specification, not just extension of an existing rule. | Confirm scope: should the uniqueness check run only at QA "Validate" time (as requested), or also earlier when Transaction ID is first entered? Confirm the exact error response contract expected by the frontend (the example JSON in the email is illustrative — is this the actual required schema/wording, or just an example format?). |
| G3 | **TM-8440 (Redesign Order Validation UI) is not yet released (To Do).** Its column list confirms "Payment Method" and "Payment Status" exist as Validation-table concepts, but the actual current production Validation UI (pre-redesign) was not independently retrieved — only this future-state ticket and the local BRD were available for column-level confirmation. | Any statement about "the Validation section" UI in this request should be understood against the current (not the TM-8440-redesigned) UI. | Confirm which Validation UI (current vs. TM-8440's redesign) this request's "QA reviews the case in the Validation section" step is meant to target. |
| G4 | **GEO scope not fully confirmed.** TM-8188 is Peru-specific; TM-8669 says LATAM broadly. The requester's email doesn't name a specific country. | Whether this change applies to Peru only or all LATAM markets using Deposit affects rollout scope. | Confirm with requester whether this applies to all LATAM markets currently using Deposit, or Peru specifically. |
| G5 | Confluence was not searched in this pass. | Possible additional current-state documentation not checked. | Perform Confluence discovery for TMS before final BRD/CR drafting. |

## 6. Readiness Decision

**PARTIAL.** The requested *reordering* of responsibilities (Agent no longer uploads evidence/enters Transaction ID; QA does both at validation time) can be drafted once G1 is resolved, since the target behavior is clear regardless of exactly how the current Transaction ID field got into the Deposit flow. The **new Transaction ID uniqueness check** is confirmed as genuinely new logic (no existing rule found) and can be drafted as a new requirement, pending the error-contract and trigger-point clarification in G2.

## Open Questions (to send back to the requester / IT stakeholders)

1. **Transaction ID in the current Deposit flow (G1):** Today's confirmed Deposit spec (TM-8188) does not include a Transaction ID field — only Deposit Amount and Evidence upload. Can you confirm whether Transaction ID entry is actually part of today's production Deposit flow, and if so, is it the same Transaction ID/Bank-detail mechanism used for Bank Transfer (TM-8675), or a separate field added specifically for Deposit?
2. **Uniqueness check trigger point (G2):** Should the duplicate-Transaction-ID check run only when QA clicks "Validate" (as your proposed process implies), or also earlier — e.g., when the Transaction ID is first entered (whether by Agent today or QA in the new flow)?
3. **Uniqueness check scope (G2):** Should a Transaction ID be checked for uniqueness across *all* orders/leads system-wide, or only within a specific scope (e.g., per GEO, per payment method, per delivery service/Last Mile partner)?
4. **Error response format (G2):** Is the JSON example in your email (`code: 300, type: 1, message: "The transaction number is already recorded <ID>"`) the exact contract IT should implement, or just an illustrative example? Should this render as a UI alert/toast, an inline field error, or both?
5. **GEO scope (G4):** Does this change apply to all LATAM markets currently using the Deposit payment method, or to a specific country (e.g., Peru only)?
6. **Evidence/Transaction ID optionality under the new flow:** Under the current flow, Evidence is not required to save a lead as Callback/Rejected/Trash/Uncalled (only required before Approve). Under the proposed flow, since Evidence and Transaction ID move to QA, does the Agent's "Approve" step still require anything Deposit-specific before approving, or does Approve become unconditional for Deposit leads now that Evidence/Transaction ID are QA's responsibility?
7. **Existing accountant/Paid-Unpaid step (TM-8675):** Does the Deposit flow currently use (or should the new flow introduce) an Accountant confirmation / Paid-Unpaid status step analogous to Bank Transfer's, or does QA's "validates the case" step fully replace that role for Deposit?
8. **Rejection/re-entry path:** If QA finds the Transaction ID already used (duplicate), what should happen to the case — stay pending for QA to correct/re-enter, get sent back to the Agent, or something else?
