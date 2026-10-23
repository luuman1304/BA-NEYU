# Business Requirement Document

## 1. Purpose

Raise the Rescue Discount limit for GEO MY (Malaysia) from 10% to 20% of the original order value, so Customer Service (CS) can offer a larger discount when recovering at-risk orders through a Rescue Job.

## 2. Business Background

The Rescue Discount limit is a GEO-configurable parameter used to cap how much CS can discount an order during a Rescue Job. It is currently documented as a single global/default value of 10%, with one known GEO-specific override (GEO ID4, raised to 15% by a separate, prior CR). No source documents a GEO MY-specific override, so GEO MY currently operates on the 10% default value. This request raises the configured limit specifically for GEO MY to 20%.

**GEO Apply:** MY (Malaysia)

## 3. Scope

### 3.1 In Scope

- Updating the configured Rescue Discount limit for GEO MY from 10% to 20% of the original order value.
- Applying the updated 20% limit to Rescue Approval request Type = "Discount" and Type = "Both" (Discount + Change to Bank Transfer) for GEO MY.

### 3.2 Out of Scope

- Any GEO other than MY. GEO ID4's existing configured value (15%) and all other GEOs' existing configured values (10% default, unless separately overridden) are unaffected.
- Any change to the Discount Allowed formula structure, the 2-attempts-per-Lead cap, the no-resubmission-after-2-approved-discounts rule, or the Bank-Transfer block — these remain unchanged for GEO MY.
- Building new GEO-scoping capability. The Rescue Discount limit is already GEO-configurable; this request is a configuration value update for GEO MY.

## 4. Current State

*(Established via `ba-source-discovery` and `ba-current-state-analyzer`. Source coverage note: Jira and Confluence could not be queried directly in this session — the Atlassian connector requires authorization not available non-interactively. The findings below are drawn from two independent local secondary analyses that each cite the same original Jira/Confluence evidence, which corroborates rather than weakens confidence, but the original sources were not re-verified first-hand in this session.)*

- The Rescue Discount limit is a GEO-configurable parameter. The documented global/default value is **10%** of the original order value, cumulative per Lead. *(Source: Confluence "RMS v2.1: User Guide - Rescue Job & Rescue Approval", page 1201635331, §3 Key Business Rules — as cited in `outputs/bpmn/RMS/rescue-job-lifecycle-as-is-process-analysis.md` and `outputs/bpmn/RMS/rescue-approval-process-analysis.md`)*
- No source documents a GEO MY-specific override. The only documented GEO override is GEO ID4, raised to 15% by a separate prior CR. *(Source: `outputs/cr-ticket/RMS/CR-RMS-Increase-Rescue-Discount-Limit-ID4.md`)* GEO MY is therefore, as currently documented, on the 10% default value.
- Discount Allowed formula:
  - If no prior Rescue Discount exists on the order, Discount Allowed = configured % of the original order amount.
  - If a prior Rescue Discount exists, Discount Allowed = configured % of the original order amount minus the Rescue Discount already used.
  *(Source: `outputs/cr-ticket/RMS/CR-RMS-Increase-Rescue-Discount-Limit-ID4.md`, corroborated by Confluence 1201635331 §3 as cited in `outputs/bpmn/RMS/rescue-approval-process-analysis.md` BR-04)*
- Rescue Discount can be applied at most **twice per Lead**; no 3rd discount and no resubmission for discount is allowed after 2 approved discounts. *(Source: Confluence 1201635331 §3 Key Business Rules, as cited in `outputs/bpmn/RMS/rescue-job-lifecycle-as-is-process-analysis.md`, BR-DiscountCap)*
- On Save & Submit, the system validates: Discount ≤ configured limit, no conflicting previous Rescue Discount, and the rescue attempt limit — before the Approval Rescue record is created. *(Source: `outputs/cr-ticket/RMS/CR-RMS-Increase-Rescue-Discount-Limit-ID4.md`)*
- If the order's current Payment Method is already Bank Transfer, both Rescue Discount and Change to Bank Transfer are blocked entirely. *(Source: Confluence 1201635331 §3, as cited in `outputs/bpmn/RMS/rescue-approval-process-analysis.md` BR-03)*
- CS can select "Discount" and/or "Change to Bank Transfer" when submitting a Rescue Job for approval; the Rescue Approval "Type" reflects this as Discount, Bank Transfer, or Both. *(Source: `outputs/cr-ticket/RMS/CR-RMS-Increase-Rescue-Discount-Limit-ID4.md`)*

## 5. Expected State

1. For GEO MY, update the configured Rescue Discount limit from **10% to 20%** of the original order value.
2. The 20% limit applies to both the "Discount" request type and the "Both" (Discount + Change to Bank Transfer) request type for GEO MY. *(See Open Question OQ-1 — this scope is assumed by analogy to the prior ID4 change, not explicitly confirmed by the user for MY.)*
3. All other current Rescue Discount rules remain unchanged for GEO MY, including:
   - The Discount Allowed formula (configured % of the original order amount, minus any Rescue Discount already used), now using 20% in place of 10% for MY.
   - The 2-attempts-per-Lead cap and the no-resubmission-after-2-approved-discounts rule.
   - The block on Rescue Discount and Change to Bank Transfer when the order's current Payment Method is already Bank Transfer.
4. GEOs other than MY are not affected by this change; their existing configured discount limit values (including GEO ID4's 15%) remain as-is.

## 6. User Story

As a Customer Service (CS) agent processing a Rescue Job in GEO MY,
I want to offer a discount of up to 20% (instead of 10%) on an eligible order,
so that I can better recover orders at risk while staying within an approved, GEO-appropriate discount ceiling.

## 7. Business Rules

| Rule ID | Business Rule | Source |
|---|---|---|
| BR-01 | The Rescue Discount limit is a GEO-configurable parameter. For GEO MY, the configured value shall be updated from 10% to 20%. | User confirmation (2026-09-23) |
| BR-02 | The 20% limit for GEO MY applies to both the "Discount" and "Both" (Discount + Change to Bank Transfer) request types. | Assumed by analogy to prior ID4 CR — **not explicitly confirmed for MY; see OQ-1** |
| BR-03 | The Discount Allowed formula, the 2-attempts-per-Lead cap, the no-resubmission-after-2-approved-discounts rule, and the Bank-Transfer block remain unchanged for GEO MY. | Current-state evidence (§4) |
| BR-04 | GEOs other than MY retain their existing configured discount limit values; this change does not alter them. | User confirmation (2026-09-23) |

## 8. Functional Requirements

| FR ID | Requirement | Business Rule Ref | Source |
|---|---|---|---|
| FR-01 | The system shall validate a submitted Rescue Discount for GEO MY against a 20% (not 10%) configured limit. | BR-01 | User confirmation (2026-09-23) |
| FR-02 | The system shall compute Discount Allowed for GEO MY as 20% of the original order amount, minus any Rescue Discount already used on that Lead. | BR-01, BR-03 | Current-state evidence (§4) |
| FR-03 | The system shall continue to enforce the 2-attempts-per-Lead cap and block a 3rd discount or resubmission for GEO MY, unchanged. | BR-03 | Current-state evidence (§4) |
| FR-04 | The system shall continue to block Rescue Discount and Change to Bank Transfer for GEO MY when the order's current Payment Method is already Bank Transfer, unchanged. | BR-03 | Current-state evidence (§4) |
| FR-05 | The system shall continue to validate all other GEOs against their existing configured limits (including GEO ID4 at 15%), unaffected by this change. | BR-04 | User confirmation (2026-09-23) |

## 9. Acceptance Criteria

**AC-01 — Updated limit applies for GEO MY, Discount type**
Given GEO = MY,
When CS submits a Rescue Job with Type = Discount on an eligible order (Payment Method not already Bank Transfer),
Then the system validates the requested Discount ≤ 20% of the original order value (not 10%).

**AC-02 — Updated limit applies for GEO MY, Both type**
Given GEO = MY,
When CS submits a Rescue Job with Type = Both (Discount + Change to Bank Transfer),
Then the system validates the Discount portion of the request ≤ 20% of the original order value.
*(Scope pending confirmation — see OQ-1.)*

**AC-03 — Discount Allowed formula uses the updated value**
Given GEO = MY and a Lead already has an approved Rescue Discount,
When CS submits a further Rescue Discount on the same Lead,
Then Discount Allowed = 20% of the original order amount minus the Rescue Discount already used.

**AC-04 — Other GEOs unaffected**
Given GEO is not MY,
When CS submits a Rescue Discount,
Then the system continues to validate against that GEO's existing configured limit (e.g., 15% for ID4, 10% default elsewhere), unchanged by this BRD.

**AC-05 — Attempt cap and resubmission rule unchanged**
Given a Lead in GEO MY already has 2 approved Rescue Discounts,
When CS attempts a third Rescue Discount or a resubmission for discount,
Then the system blocks it, consistent with current (unchanged) behavior.

**AC-06 — Bank Transfer gating unchanged**
Given an order's current Payment Method is already Bank Transfer,
When CS attempts to submit a Rescue Discount or Change to Bank Transfer on that order in GEO MY,
Then the system blocks both, unchanged by this BRD.

## 10. Assumptions and Dependencies

- **Assumption:** The 20% limit is assumed to apply to both the "Discount" and "Both" request types for GEO MY, by analogy to how the prior GEO ID4 change was scoped. This has not been explicitly confirmed by the user for GEO MY. *(See OQ-1.)*

## 11. Open Questions

- **OQ-1:** Should the 20% limit apply to both the "Discount" request type and the "Both" (Discount + Change to Bank Transfer) request type for GEO MY, or only to one of them? Assumed to cover both, by analogy to the prior ID4 change — requires explicit confirmation.
- **OQ-2:** This BRD's evidence relies on local secondary analyses that cite Jira TM-7610 (Done) and Confluence page 1201635331, which could not be directly queried in this session (Atlassian connector authorization unavailable non-interactively). Direct verification of these original sources is recommended before final approval.
- **OQ-3:** Is a specific Jira CR/ticket key already reserved or planned for this GEO MY change (as GEO ID4's change was tracked under Jira TM-8929)? Not stated in the request.

## 12. Traceability

| Requirement | BR | FR | AC |
|---|---|---|---|
| 20% limit for MY, Discount type | BR-01 | FR-01 | AC-01 |
| 20% limit for MY, Both type | BR-01, BR-02 | FR-01 | AC-02 |
| Discount Allowed formula | BR-03 | FR-02 | AC-03 |
| Other GEOs unaffected | BR-04 | FR-05 | AC-04 |
| Attempt cap / resubmission unchanged | BR-03 | FR-03 | AC-05 |
| Bank Transfer gating unchanged | BR-03 | FR-04 | AC-06 |

## 13. Version History

| Version | Date | Change | Author |
|---|---|---|---|
| 0.1 | 2026-09-23 | Initial draft — Rescue Discount limit increase (10%→20%) for GEO MY | man.luu@neyu.co (BA AI Agent) |
