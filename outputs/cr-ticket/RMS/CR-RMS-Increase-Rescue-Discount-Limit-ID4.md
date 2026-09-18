# [RMS][ID4] Increase Rescue Discount Limit from 10% to 15%

## Description

### Applied GEO

ID4 (Indonesia)

### Business Context / Purpose

The current Rescue Discount limit of 10% constrains how much Customer Service (CS) can discount an order during a Rescue Job. For GEO ID4, this limit needs to be raised to 15% for Rescue Jobs on orders paid via COD — whether requesting a Discount alone, or requesting a Discount combined with a Change to Bank Transfer.

### Current Behavior

In RMS Rescue Approval, CS can select one or both of the following options when submitting a Rescue Job for approval: **Discount** and **Change to Bank Transfer**. The Rescue Approval "Type" reflects this as Discount, Bank Transfer, or Both.

If the order's current Payment Method is already Bank Transfer, both Rescue Discount and Change to Bank Transfer are blocked entirely — the system does not allow these options on such orders.

The Rescue Discount limit is currently **10% of the original order value**, cumulative per Lead:

- If no prior Rescue Discount exists on the order, Discount Allowed = 10% of the original order amount.
- If a prior Rescue Discount exists, Discount Allowed = 10% of the original order amount minus the Rescue Discount already used.

Rescue Discount can be applied at most **twice per Lead**. After 2 approved Rescue Discounts, no third discount and no resubmission for discount is allowed.

On Save & Submit, the system validates: Discount ≤ 10%, no conflicting previous Rescue Discount, and the rescue attempt limit — before the Approval Rescue record is created. Once a Rescue Job's Bank Transfer request is approved, the system disables further discount-related fields on that job.

No source documents a GEO-specific variant or override of this 10% limit — as currently documented, it applies as a single global rule.

*Sources: Confluence "RMS v2.1: User Guide - Rescue Job & Rescue Approval" (§Key Business Rules, §3.1 Step 3 and Step 5, §3.2 Filters); Jira TM-7610 "[RMS v2.1] Update Change Bank Transfer and Discount Logic" (Done).*

Per stakeholder confirmation (2026-09-11): the Rescue Discount limit is in fact a **GEO-configurable parameter**, and the request is to update that configuration for ID4 specifically — not to build new GEO-scoping capability.

### Expected Behavior

1. For GEO ID4, update the configured Rescue Discount limit from **10% to 15%** of the original order value. This is a configuration update to an existing GEO-configurable parameter, not new capability. *(Resolves Open Question Q1.)*
2. The 15% limit applies to **both** the "Discount" request type and the "Both" (Discount + Change to Bank Transfer) request type for ID4. *(Resolves Open Question Q3.)*
3. All other current Rescue Discount rules remain unchanged for ID4, including:
   - The Discount Allowed formula (configured % of the original order amount, minus any Rescue Discount already used), now using 15% in place of 10% for ID4.
   - The 2-attempts-per-Lead cap and "no resubmission after 2 approved discounts" rule. *(Resolves Open Question Q4.)*
   - The block on Rescue Discount and Change to Bank Transfer when the order's current Payment Method is already Bank Transfer.
4. GEOs other than ID4 are not affected by this change; their existing configured discount limit values remain as-is.

Whether "COD" is the only non-Bank-Transfer payment method in scope was raised as Open Question Q2 and was explicitly **skipped** (not pursued) per stakeholder direction — see Open Questions.

## User Story

As a Customer Service (CS) agent processing a Rescue Job in ID4,
I want to offer a discount of up to 15% (instead of 10%) on COD orders,
So that I can better recover orders at risk while staying within an approved, GEO-appropriate discount ceiling.

## Business Rules

- BR-01: The Rescue Discount limit is a GEO-configurable parameter. For GEO ID4, the configured value shall be updated from 10% to 15%. *(Source: stakeholder confirmation)*
- BR-02: The 15% limit for ID4 applies to both the "Discount" and "Both" (Discount + Change to Bank Transfer) request types. *(Source: stakeholder confirmation)*
- BR-03: All other current Rescue Discount rules — the Discount Allowed formula, the 2-attempts-per-Lead cap, the no-resubmission-after-2-approved rule, and the Bank-Transfer-already-set block — remain unchanged. *(Source: current-state evidence + stakeholder confirmation)*
- BR-04: GEOs other than ID4 retain their existing configured discount limit values; this change does not alter them. *(Source: stakeholder confirmation)*

## Acceptance Criteria

**AC-01 — Updated limit applies for ID4, Discount type**
Given GEO = ID4,
When CS submits a Rescue Job with Type = Discount on an eligible order (Payment Method not already Bank Transfer),
Then the system validates the requested Discount ≤ 15% of the original order value (not 10%).

**AC-02 — Updated limit applies for ID4, Both type**
Given GEO = ID4,
When CS submits a Rescue Job with Type = Both (Discount + Change to Bank Transfer),
Then the system validates the Discount portion of the request ≤ 15% of the original order value.

**AC-03 — Discount Allowed formula uses the updated value**
Given GEO = ID4 and a Lead already has an approved Rescue Discount,
When CS submits a further Rescue Discount on the same Lead,
Then Discount Allowed = 15% of the original order amount minus the Rescue Discount already used.

**AC-04 — Other GEOs unaffected**
Given GEO is not ID4,
When CS submits a Rescue Discount,
Then the system continues to validate against that GEO's existing configured limit, unchanged by this CR.

**AC-05 — Attempt cap and resubmission rule unchanged**
Given a Lead in ID4 already has 2 approved Rescue Discounts,
When CS attempts a third Rescue Discount or a resubmission for discount,
Then the system blocks it, consistent with current (unchanged) behavior.

**AC-06 — Bank Transfer gating unchanged**
Given an order's current Payment Method is already Bank Transfer,
When CS attempts to submit a Rescue Discount or Change to Bank Transfer on that order,
Then the system blocks both, unchanged by this CR.

## Other Information

- Reference: Jira [TM-7610](https://accelo-tech.atlassian.net/browse/TM-7610) — current Discount Allowed formula and Bank Transfer/Discount field-disable logic
- Reference: Confluence "RMS v2.1: User Guide - Rescue Job & Rescue Approval" — Key Business Rules, Rescue Discount Limitations
- Target ticket: Jira [TM-8929](https://accelo-tech.atlassian.net/browse/TM-8929) — "[RMS][ID4] Increase Bank Transfer Discount Limit from 10% to 15%" (currently empty, status DEFINING REQUIREMENTS)

## Open Questions / Assumptions

**Resolved (stakeholder confirmation, 2026-09-11):**

1. ~~Is the 10% Rescue Discount limit currently GEO-configurable?~~ → **Yes** — it is a GEO-configurable parameter; this CR updates the ID4 configuration value to 15%.
2. ~~Is COD explicitly the only non-Bank-Transfer payment method in scope?~~ → **Skipped** — explicitly not pursued per stakeholder direction; not resolved, not assumed.
3. ~~Should the new 15% limit apply to both the "Discount" type and the "Both" type?~~ → **Both.**
4. ~~Does the 2-attempts-per-Lead cap / no-resubmission rule change?~~ → **No — remains exactly as-is.**

**Assumptions:** None — all items above are either confirmed by the stakeholder or explicitly left unresolved (Q2, skipped).

---

*Readiness: **READY** for the scope covered by Q1, Q3, and Q4 (per stakeholder confirmation on 2026-09-11). Q2 (exact qualifying payment method beyond "not already Bank Transfer") remains unresolved by stakeholder direction (skipped) and is out of scope for this CR's acceptance criteria.*
