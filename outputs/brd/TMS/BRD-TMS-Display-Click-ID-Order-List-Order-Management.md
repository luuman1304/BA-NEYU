# Business Requirement Document

## 1. Background

Today, AM ↔ Publisher (Pub) communication uses **Click ID**, while Geo ↔ AM communication uses **Lead ID**. TMS's Order List and Order Management screens currently only surface **Lead ID** (confirmed — see Current Behavior §5), so whenever an Account Manager (AM) needs to discuss an order with a Publisher, they have to manually look up the corresponding Click ID elsewhere (e.g., in the affiliate/tracking platform). This creates avoidable manual cross-referencing work for AMs during routine Pub communication.

*(Source: Jira TM-9094, "[TMS] Display Click ID on Order List and Order Management (All GEOs)," CR, status DEFINING REQUIREMENTS, created 2026-09-24.)*

## 2. Objective

Display **Click ID** as a visible field on the TMS **Order List** and **Order Management** screens, alongside the existing **Lead ID**, across all GEOs currently live in TMS, so an Account Manager can reference the same identifier a Publisher uses when discussing an order, without manually cross-referencing it in another system.

## 3. GEO Apply

All GEOs currently live in TMS. No GEO-specific exclusions. *(Source: Jira TM-9094, Acceptance Criteria 1.2 and 2.2.)*

## 4. Scope

### 4.1 In Scope

- Adding a **Click ID** column to the **Order List** screen, alongside the existing Lead ID column, for every order, across all GEOs.
- Adding a **Click ID** field to the **Order Management** (order detail) screen, alongside the existing Lead ID, across all GEOs.
- Displaying the Click ID value that matches what is used in AM ↔ Publisher communication — i.e., the click tracking ID from the order's originating source (e.g., Keitaro/AFS).

### 4.2 Out of Scope

- Any change to existing Order List or Order Management columns, filters, sorting, or export logic, other than the addition described above.
- Any change to how Click ID is generated, captured, or stored at its originating source (e.g., Keitaro/AFS).
- Any change to Lead ID's definition, generation, or display behavior.

## 5. Current Behavior

**TMS — Order List and Order Management (Primary System):**

### 5.1 Order List — Confirmed Current Fields

The most recent UI specification for the Order List screen (card-based layout) lists the following fields per order card, with no Click ID field present:

| Row | Field | Notes |
|---|---|---|
| Header | Lead ID | Bold, clickable, navigates to order detail |
| Header | Status Badge | Colored badge |
| Info | Customer Name | |
| Info | Phone | Masked (first/last 3 digits shown) |
| Info | Product Name | |
| Info | Affiliate ID | "N/A" if not set |
| Info | Lead Source | "N/A" if not set |
| Info | Delivery Address | "N/A" if not set |
| Footer | Created Date | |
| Footer | Updated Date | |

*(Source: Jira TM-8118, "[TMS][UXUI] Redesign Order List UI - List Page," Story, status In Progress, updated 2026-06-11.)*

### 5.2 Order Management — Confirmed Current Fields

The most recent UI specification for the Order Management table lists the following columns, with no Click ID column present. Lead ID is documented as a mandatory column that cannot be hidden:

| Column | Description |
|---|---|
| Checkbox | Select row |
| **Lead ID** | Unique ID (clickable); **mandatory, cannot be hidden** |
| SO ID | Sales Order ID |
| Name | Customer name |
| Phone | Phone number |
| Product Name | Product |
| Delivery Service | Shipping method |
| Product Cross Sell | Cross-sell info |
| Affiliate ID | Affiliate reference |
| Sub ID 1 | Sub tracking ID |
| Amount | Order amount |
| Agency | Agency source |
| Assigned | Assigned user |
| Group | Group classification |
| Campaign Name | Campaign |
| Lead Status | Lead status |
| SO Status | Order status |
| DO Status | Delivery status |
| Payment Method | Payment type |
| Payment Status | Paid/Unpaid/Pending payment |
| Notification Method | SMS/Email |
| Notification Status | Sent/Failed |
| Address | Customer address |
| Cust Area | Customer region |
| Carrier | Delivery carrier |
| Comment | Order note |
| Agent Note | Internal note |
| Create Date | Created datetime |
| Update Date | Updated datetime |
| Total Call | Total calls |
| Actual Call | Actual calls |

*(Source: Jira TM-7980, "[TMS][UXUI] Redesign Order Management UI," Story, status Pending, updated 2026-07-27.)*

**Confirmed absence — not inferred by reversing the requested Expected Behavior:** Both UI specifications above are independent, directly-sourced current/target field lists (each predating CR TM-9094, created 2026-09-24) that explicitly enumerate the fields shown on each screen. Neither lists a Click ID field. This is treated as confirmed current absence of Click ID from both screens' UI, not an assumption drawn from the request to add it.

### 5.3 Click ID — Confirmed to Already Exist as Backend/API Data

TMS's backend order-list API (`/api/v1/SO/list`, which serves Order Management data) already returns a `clickId` field in its response payload, alongside `leadId`, `affiliateId`, and `subId1`:

```json
{
  "leadId": 71418,
  "affiliateId": "",
  "clickId": "",
  "subId1": "",
  ...
}
```

*(Source: Jira TM-6585, "[FE] Add field TeamName on TMS Validation on UI, CustArea on TMS Order Management UI," Subtask, status Done, updated 2025-08-18 — production API response sample.)*

Separately, "Click ID" (also referred to as "Click_id"/"Transaction_id") is an established TMS data concept tied to fresh leads, historically expected to be unique per lead. *(Source: Jira TM-882, "TMS - Many fresh lead ID have same Click_id (Transaction_id) in cl_fresh table," Bug, status Done, 2023.)*

**Together, these two sources confirm:** Click ID data already exists in TMS's backend/data layer (both the `SO/list` API response and the underlying lead data), but per §5.1–§5.2, it is not currently rendered on either the Order List or Order Management UI. This is a UI display gap, not a data-availability gap — although the exact current population rate/completeness of `clickId` per lead is **not defined in source** (see Open Questions).

### 5.4 GEO Scope — No Exclusions Found

No Jira or Confluence source was found documenting a GEO-specific exclusion, variant, or restriction for either the Order List or Order Management screen with respect to Lead ID or Click ID display. This is consistent with, and does not contradict, CR TM-9094's own statement that the change applies to all GEOs with no exclusions.

## 6. Expected Behavior

1. The Order List screen shall display a **Click ID** field for every order, alongside the existing Lead ID field, for all GEOs currently live in TMS.
2. The Order Management (order detail) screen shall display a **Click ID** field alongside the existing Lead ID field, for all GEOs currently live in TMS.
3. The Click ID value displayed shall match the value used in AM ↔ Publisher communication — i.e., the click tracking ID from the order's originating source (e.g., Keitaro/AFS). Per Current Behavior §5.3, this corresponds to the existing `clickId` field already present in TMS's order data.
4. All other existing logic on both screens — columns, filters, sorting, and exports — remains unchanged.

## 7. User Story

As an Account Manager (AM),
I want the Click ID to be displayed on the Order List and Order Management screens in TMS,
So that I can reference the same identifier Publishers use when discussing orders, without having to cross-reference it manually.

## 8. Business Rules

| Rule ID | Business Rule | Source |
|---|---|---|
| BR-01 | The Order List screen displays a Click ID field for every order, alongside Lead ID, for all GEOs. | Jira TM-9094 |
| BR-02 | The Order Management screen displays a Click ID field, alongside Lead ID, for all GEOs. | Jira TM-9094 |
| BR-03 | The displayed Click ID value is the click tracking ID from the order's originating source (e.g., Keitaro/AFS) — the same identifier used in AM ↔ Publisher communication. | Jira TM-9094 |
| BR-04 | No GEO-specific exclusions apply to Click ID display on either screen. | Jira TM-9094 |
| — | All other existing Order List and Order Management logic (columns, filters, sorting, exports) remains unchanged. | Jira TM-9094; preserved per default BA principle |

## 9. Functional Requirements

| FR ID | Requirement | Business Rule Ref | Source |
|---|---|---|---|
| FR-01 | The system shall add a Click ID field to the Order List screen, displayed alongside the existing Lead ID field, for every order. | BR-01 | Jira TM-9094 |
| FR-02 | The system shall add a Click ID field to the Order Management (order detail) screen, displayed alongside the existing Lead ID field. | BR-02 | Jira TM-9094 |
| FR-03 | The system shall populate the displayed Click ID from the same click-tracking-ID value used in AM ↔ Publisher communication (the order's originating source, e.g., Keitaro/AFS). | BR-03 | Jira TM-9094 |
| FR-04 | The system shall apply Click ID display on both screens uniformly across all GEOs currently live in TMS, with no GEO-specific exclusion. | BR-04 | Jira TM-9094 |
| FR-05 | The system shall preserve all existing Order List and Order Management columns, filters, sorting, and export behavior unchanged. | — | Jira TM-9094 |

## 10. Data Mapping

| Source Field | Target Field (UI) | Transformation | Notes |
|---|---|---|---|
| TMS backend: `clickId` (per `/api/v1/SO/list` response; per Current Behavior §5.3) | Click ID (Order List, Order Management) | Direct display of value | Field already exists in the backend API response; this BRD's change is UI display only. Exact end-to-end originating source per GEO (Keitaro vs. AFS vs. other) and blank-value handling are **not defined in source** — see Open Questions. |
| TMS backend: `leadId` | Lead ID (unchanged) | Direct display of value (existing, unchanged) | Confirmed existing field on both screens — Jira TM-7980, TM-8118. |

## 11. Acceptance Criteria

**AC-01 — Click ID displayed on Order List**
Given a user opens the Order List screen,
When orders are displayed,
Then each order shows a Click ID value alongside its Lead ID, for all GEOs.

**AC-02 — Click ID displayed on Order Management**
Given a user opens the Order Management (order detail) screen for an order,
When the order detail is displayed,
Then the screen shows the Click ID value alongside the Lead ID, for all GEOs.

**AC-03 — Click ID value matches AM ↔ Publisher communication**
Given an order has a click tracking ID recorded from its originating source (e.g., Keitaro/AFS),
When the Click ID is displayed on either screen,
Then the displayed value matches the identifier used in AM ↔ Publisher communication for that order.

**AC-04 — No GEO exclusions**
Given an order from any GEO currently live in TMS,
When the Order List or Order Management screen is viewed,
Then the Click ID field is displayed with no GEO-specific exclusion.

**AC-05 — Existing logic unchanged**
Given the Click ID field has been added to both screens,
When a user uses existing columns, filters, sorting, or exports,
Then all of that existing behavior functions exactly as before this change.

## 12. Open Questions

1. What is the current data-completeness/population rate of the `clickId` field across leads and GEOs (i.e., how often is it blank), and what should the UI display when Click ID is not available for an order? **Not defined in source.**
2. Is the click-tracking-ID source (Keitaro vs. AFS vs. other) consistent per GEO, or does it vary, and does that affect how `clickId` should be retrieved/displayed? **Not defined in source** — CR TM-9094 states "e.g., Keitaro/AFS" without confirming a single canonical source per GEO.
3. What is the exact intended position/label of the Click ID field relative to Lead ID on each screen (e.g., immediately adjacent column vs. anywhere in the field list)? **Not defined in source** — CR TM-9094 says "alongside" without specifying exact placement.
4. Should Click ID also be added to the two screens' existing export templates? CR TM-9094 explicitly states exports remain unchanged (§4.2/BR—); confirm this is intentional and not a scope gap.

**Assumptions:** None — Current State findings above (§5) are all sourced directly, not inferred from the requested Expected Behavior.

**Recommendations:** Confirm `clickId` field population coverage with engineering before implementation, since a low fill rate would materially affect the value AMs get from this display (Open Question 1).

---

*Readiness: **READY** for the scope defined in BR-01–BR-04 and AC-01–AC-05, based on confirmed current UI field lists (Jira TM-8118, TM-7980) and confirmed existing backend data availability (Jira TM-6585, TM-882). Open Questions 1–4 do not block drafting this BRD's core requirements but should be resolved with the requester/engineering before implementation.*

## 13. Sources and Traceability

| Requirement | Business Rule | Functional Requirement | Acceptance Criteria | Source |
|---|---|---|---|---|
| Click ID displayed on Order List | BR-01 | FR-01 | AC-01 | Jira TM-9094 |
| Click ID displayed on Order Management | BR-02 | FR-02 | AC-02 | Jira TM-9094 |
| Click ID value matches AM↔Pub communication | BR-03 | FR-03 | AC-03 | Jira TM-9094 |
| No GEO exclusions | BR-04 | FR-04 | AC-04 | Jira TM-9094 |
| Existing logic unchanged | — | FR-05 | AC-05 | Jira TM-9094 |
| Confirmed current absence of Click ID on Order List UI | — | — | — | Jira TM-8118 |
| Confirmed current absence of Click ID on Order Management UI | — | — | — | Jira TM-7980 |
| Confirmed existing `clickId` backend field | — | — | — | Jira TM-6585 |
| Click ID/Transaction_id established as existing TMS lead-data concept | — | — | — | Jira TM-882 |

## 14. Version History

| Version | Date | Change | Author |
|---|---|---|---|
| 0.1 | 2026-09-24 | Initial draft — sourced from CR Jira TM-9094 and current-state evidence (Jira TM-8118, TM-7980, TM-6585, TM-882). Readiness: READY for defined scope; 4 Open Questions carried forward for pre-implementation confirmation. | BA Agent |
