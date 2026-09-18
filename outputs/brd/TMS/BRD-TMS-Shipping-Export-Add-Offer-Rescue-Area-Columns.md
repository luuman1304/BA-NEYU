# Business Requirement Document

## 1. Background

The Operations Excellence (OE) team needs to analyze **Delivery Rate (DR) by Offer and by Area**, in order to identify Rescue failure root causes and provide data-driven recommendations to Account Managers (AM) — e.g., increase/reduce PO, scale leads, or adjust lead allocation by area. This need was raised directly by the OE team to the IT team (stakeholder request addressed to Mia Tran and Hera Vo). *(Source: stakeholder request — "DR by Offer and by Area" requirements, `inputs/references/requirment_DR Offer.png`.)*

Users export the list of Delivery Orders (DO) from the TMS Shipping screen for downstream logistics and reporting use. This export currently does not include information about the sales Offer, the Rescue outcome recorded in RMS when a case was worked as a Rescue Job, or the delivery Location Status (Area) of the customer's address — information the OE team needs to complete this DR analysis. Adding this information to the export lets OE calculate validated order volume and DR by Offer, identify High DR / Low DR / Non-COD areas, and analyze Rescue failure reasons, without cross-referencing multiple systems manually.

**Note — additional fields raised in the same stakeholder request, not yet in this BRD's scope:** The same request also asks for the following fields to be added/ensured on TMS Shipping: **DO Validated, Order Status, COD, Province, District, Pincode** (purpose: calculate validated order volume and DR by Offer, and identify High DR/Low DR/Non-COD areas). These are outside the 4-column scope currently defined below (Section 4) and are **not** reflected in Scope, Business Rules, Functional Requirements, or Acceptance Criteria in this version. They are recorded here for traceability; confirm with the requester whether they should be added as a scope expansion in a follow-up revision.

*Related/Impacted Systems (supporting reference only, not confirmed Current State for TMS):*
- **RMS (Rescue Management System)** — source of the data requested for the "Rescue Reason" and "Rescue Sub Reason" columns.
- **System Management (SMG)** — source of the Location Status configuration requested for the fourth column.
- **AFS (Affscale)** — source of the "Offer" data, per requester confirmation (Offer is paired with Pub/Publisher).
- **TMS Order Management** — per the same stakeholder request, TMS Shipping already has PUB; the Offer field is additionally needed so Offer can be analyzed as a PUB + Offer pair (e.g., "DOMAdianabol").

## 2. Objective

Add four columns — **Offer**, **Rescue Reason**, **Rescue Sub Reason**, and **Location Status** — to the DO export template on the TMS Shipping screen, so the **Operations Excellence (OE) team** can analyze **Delivery Rate (DR) by Offer and by Area**, analyze Rescue failure root causes, and provide recommendations to Account Managers (e.g., increase/reduce PO, scale leads, adjust lead allocation by area).

## 3. GEO Apply

Not defined in source. The requester explicitly deferred this question ("Skip, no information now"). See Open Questions.

## 4. Scope

### 4.1 In Scope

- Adding four new columns to the Shipping screen's DO export template, positioned as the last columns (after all existing columns): **Offer, Rescue Reason, Rescue Sub Reason, Location Status**.
- Mapping "Rescue Reason" to RMS's "CS Sub Status" field and "Rescue Sub Reason" to RMS's "Return Reason" field, keyed by Lead ID, per the requester's explicit instruction.
- Mapping the fourth column to the existing "Location Status" field (the requester confirmed the column should use the "Location Status" label, not "Area") configured in System Management (SMG).
- Adding **High DR** and **Low DR** as new values to the existing Location Status configuration field in SMG, per requester confirmation.
- Populating "Offer" from AFS, where Offer is paired with Pub (Publisher), per requester confirmation.

### 4.2 Out of Scope

- Any change to the Shipping Export's existing columns, data, filters, or overall export logic.
- Any change to RMS's CS Sub Status or Return Reason field definitions, values, or business logic.
- Any change to the SMG Location Status configuration mechanism itself, other than adding the High DR and Low DR values.
- Any change to AFS's Pub/Offer data model.

## 5. Current Behavior

**TMS — Shipping Export (Primary System):**

### 5.1 Current Export Columns — Confirmed

The requester provided the complete current field list of the Shipping DO export template directly (2026-09-15). This supersedes the partial, Jira-sourced column list previously documented here and is treated as **confirmed current state** (direct requester-provided source, per Source Priority — confirmed stakeholder input).

| # | Group | Column / Field | Notes |
|---|---|---|---|
| 1 | Order / Customer (Đơn/khách) | orgId | |
| 2 | Order / Customer (Đơn/khách) | saleOrder | |
| 3 | Order / Customer (Đơn/khách) | deliveryCode | Corroborated by Jira TM-1142 (Done) — "Delivery Code" column added to the Orders/Shipping menu. |
| 4 | Order / Customer (Đơn/khách) | customerName | |
| 5 | Order / Customer (Đơn/khách) | customerAge | |
| 6 | Order / Customer (Đơn/khách) | customerGender | |
| 7 | Order / Customer (Đơn/khách) | customerPhone | |
| 8 | Order / Customer (Đơn/khách) | customerJob | |
| 9 | Order / Customer (Đơn/khách) | source | |
| 10 | Order / Customer (Đơn/khách) | username | |
| 11 | Address (Địa chỉ) | address | |
| 12 | Address (Địa chỉ) | postalCode | |
| 13 | Address (Địa chỉ) | neighborhoodId | |
| 14 | Address (Địa chỉ) | neighborhood | |
| 15 | Address (Địa chỉ) | wardsId | |
| 16 | Address (Địa chỉ) | wards | |
| 17 | Address (Địa chỉ) | district | |
| 18 | Address (Địa chỉ) | province | |
| 19 | Shipping & Status (Vận chuyển & trạng thái) | carrier | |
| 20 | Shipping & Status (Vận chuyển & trạng thái) | comment | |
| 21 | Shipping & Status (Vận chuyển & trạng thái) | status | |
| 22 | Shipping & Status (Vận chuyển & trạng thái) | soStatus | |
| 23 | Shipping & Status (Vận chuyển & trạng thái) | statusTransport | |
| 24 | Shipping & Status (Vận chuyển & trạng thái) | firstAttempt | Corroborated by Jira TM-1256, TM-1266 (both Done) — "1st/2nd/3rd attempt" export columns. |
| 25 | Shipping & Status (Vận chuyển & trạng thái) | secondAttempt | Corroborated by Jira TM-1256 (Done). |
| 26 | Shipping & Status (Vận chuyển & trạng thái) | thirdAttempt | Corroborated by Jira TM-1256 (Done). |
| 27 | Shipping & Status (Vận chuyển & trạng thái) | reason1 | |
| 28 | Shipping & Status (Vận chuyển & trạng thái) | reason2 | |
| 29 | Shipping & Status (Vận chuyển & trạng thái) | reason3 | |
| 30 | Shipping & Status (Vận chuyển & trạng thái) | createdate | |
| 31 | Shipping & Status (Vận chuyển & trạng thái) | updatedate | |
| 32 | Shipping & Status (Vận chuyển & trạng thái) | totalCall | |
| 33 | Money (Tiền) | paymentMethod | |
| 34 | Money (Tiền) | Receivable Amount | Corroborated by Jira TM-8511 (Done) — Receivable Amount = Order Amount − Total Discount Amount. |
| 35 | Money (Tiền) | COD amount | |
| 36 | Money (Tiền) | depositAmount | |
| 37 | Money (Tiền) | discountPercentage | Corroborated by Jira TM-8511 (Done). |
| 38 | Money (Tiền) | discountAmount | Corroborated by Jira TM-8511 (Done). |
| 39 | Money (Tiền) | Order Amount | Corroborated by Jira TM-8511 (Done). |
| 40 | Money (Tiền) | totalAmount | |
| 41 | Money (Tiền) | originalShippingFee | |
| 42 | Money (Tiền) | shippingFeePlatformDiscount | |
| 43 | Money (Tiền) | shipping_fee | |
| 44 | Money (Tiền) | discount | |
| 45 | Money (Tiền) | ecomTotalAmount | |
| 46 | Money (Tiền) | ecomTotalAmountWithoutShippingFee | |
| 47 | Product (Sản phẩm) | product1 … product10, each with its own qty + price (30 columns total) | Products 11 and beyond are **not exported** (per requester confirmation). Exact per-column naming convention (e.g., `qty1`/`price1` vs. another pattern) is **Not defined in source** beyond the `product1`…`product10` base names given. |
| 48 | Fulfillment & Timestamps (Fulfillment & mốc thời gian) | leadId | |
| 49 | Fulfillment & Timestamps (Fulfillment & mốc thời gian) | ffmCode | |
| 50 | Fulfillment & Timestamps (Fulfillment & mốc thời gian) | trackingCode | |
| 51 | Fulfillment & Timestamps (Fulfillment & mốc thời gian) | reconciliationCode | |
| 52 | Fulfillment & Timestamps (Fulfillment & mốc thời gian) | ffmName | |
| 53 | Fulfillment & Timestamps (Fulfillment & mốc thời gian) | warehouse | |
| 54 | Fulfillment & Timestamps (Fulfillment & mốc thời gian) | agentNote | |
| 55 | Fulfillment & Timestamps (Fulfillment & mốc thời gian) | affiliateId | |
| 56 | Fulfillment & Timestamps (Fulfillment & mốc thời gian) | lastmileReturnCode | |
| 57 | Fulfillment & Timestamps (Fulfillment & mốc thời gian) | pickedUpDate | |
| 58 | Fulfillment & Timestamps (Fulfillment & mốc thời gian) | attemp | |
| 59 | Fulfillment & Timestamps (Fulfillment & mốc thời gian) | paymentStatus | |
| 60 | Fulfillment & Timestamps (Fulfillment & mốc thời gian) | paidCodDate | |
| 61 | Fulfillment & Timestamps (Fulfillment & mốc thời gian) | firstDeliveryTime, second/third | Exact field names for the second/third variants as given by requester — not separately spelled out. |
| 62 | Fulfillment & Timestamps (Fulfillment & mốc thời gian) | returnTime | |
| 63 | Fulfillment & Timestamps (Fulfillment & mốc thời gian) | closeTime | |
| 64 | Fulfillment & Timestamps (Fulfillment & mốc thời gian) | pickedTime | |
| 65 | Fulfillment & Timestamps (Fulfillment & mốc thời gian) | packedTime | |
| 66 | Fulfillment & Timestamps (Fulfillment & mốc thời gian) | handoveredTime | |
| 67 | Fulfillment & Timestamps (Fulfillment & mốc thời gian) | cpName | |
| 68 | Fulfillment & Timestamps (Fulfillment & mốc thời gian) | category | |
| 69 | Fulfillment & Timestamps (Fulfillment & mốc thời gian) | leadCreateDate | |
| 70 | Fulfillment & Timestamps (Fulfillment & mốc thời gian) | soCreateDate | |
| 71 | Fulfillment & Timestamps (Fulfillment & mốc thời gian) | firstDeliveredTime, second/third | Exact field names for the second/third variants as given by requester — not separately spelled out. |
| 72 | Package & E-commerce Platform (Gói & sàn TMĐT) | delivery_package_code | |
| 73 | Package & E-commerce Platform (Gói & sàn TMĐT) | delivery_package_name | |
| 74 | Package & E-commerce Platform (Gói & sàn TMĐT) | payment_transaction_id | |
| 75 | Package & E-commerce Platform (Gói & sàn TMĐT) | market_place | |
| 76 | Package & E-commerce Platform (Gói & sàn TMĐT) | mp_order_id | |
| 77 | Package & E-commerce Platform (Gói & sàn TMĐT) | shop_id | |
| 78 | Package & E-commerce Platform (Gói & sàn TMĐT) | managed_by | |

*(Source: Requester-provided current export field list, 2026-09-15. Row counts treat each named field as one column, except Product (row 47), which represents 30 individual columns as noted.)*

**Confirmed absence — important for this BRD's scope:** This complete list does **not** include Offer, Rescue Reason, Rescue Sub Reason, Location Status, or AWB. Their absence is now confirmed directly from this requester-provided full current template (not inferred by reversing the requested Expected Behavior), corroborating that all four requested new columns (Section 6) are genuinely new to this export today.

### 5.2 Related Fields — Confirmed to Exist Elsewhere in TMS, Not Part of This Export

The following fields are confirmed to exist somewhere else in TMS (a screen, popup, or the underlying DO record), but — per the confirmed absence noted above — are **not** part of the current Shipping export template:

| Field | Confirmed as | Source |
|---|---|---|
| Location Status | A read-only field displayed on-screen under the Address section after address validation (see narrative below). | Jira TM-8189, TM-8475 (both Done) |
| AWB | A field added to the Shipping **popup** (screen), sourced from the DO record's `attribute5`. | Jira TM-4215 (Done) |

### 5.3 Supporting Narrative

The Shipping Export currently includes financial fields: `discountPercentage`, `discountAmount`, `Receivable Amount`, and Order Amount. *(Source: Jira TM-8511, Done.)*

A data pathway from RMS into the TMS Shipping Export **already exists** for at least one Rescue-originated data point: after a Rescue Job discount is approved in RMS, the Shipping Export reflects the updated discount and receivable amount. This is an existing, proven cross-system pattern — it is not being introduced from scratch. However, this pathway is triggered by the Rescue Job approval event specifically; its applicability to other RMS fields (CS Sub Status, Return Reason) is not confirmed by source. *(Source: Jira TM-8511, Done.)*

TMS currently has a read-only **"Location Status"** field, displayed under the Address section after address validation. Confirmed current values: **Normal, Non-COD, Lockdown, Uncover Area**, plus combined "Delay N days" variants (e.g., "Non-COD, Delay 8 days"). *(Source: Jira TM-8189, Done.)*

Location Status configuration is maintained in **SMG (System Management)**, keyed by the delivery address (Province/District/Ward/Neighborhood). *(Source: Jira TM-8189; TM-8475, both Done.)*

**"Low DR"** is confirmed as a **new, not-yet-released** Location Status value, introduced by a separate, currently in-progress ticket (status: To Do — a Pending Change, not Current Production State). *(Source: Jira TM-8776, status To Do.)*

**No source was found for "High DR"** anywhere prior to this requirement — neither as an existing configured value nor as a previously planned one. Per requester confirmation, High DR is a new value to be added to the existing Location Status configuration, following the same pattern as Low DR.

**No source confirms an "Offer" field's** current definition or storage location on the DO/Order record within TMS. Per requester confirmation, Offer originates from **AFS**, where it forms a Pub(Publisher)+Offer pair. This is consistent with a related TMS reference to "Deal (Pub-offers)" mapping in the Non-COD/Lockdown postback context *(Source: Jira TM-8475, Done)*, though that reference does not itself confirm Offer's exact field definition or its current availability on the DO/Order record for export purposes.

**RMS — CS Sub Status and Return Reason (Related System, supporting reference only):**

CS Sub-status values are context-dependent on the case's CS Status (e.g., "Notify customer," "Not notified" under certain CS Status scenarios). *(Source: Confluence "User Guide RMS 2.0" §5.1.)*

Return Reason has approximately 17 defined values (e.g., "Customers complaint about late delivery - 3PL"), shown only when CS Status = "Sales can't rescue." *(Source: Confluence "User Guide RMS 2.0" §5.1; Jira TM-6344.)*

No source confirms an existing data pathway specifically carrying CS Sub Status or Return Reason from RMS into TMS today — only the discount/receivable-amount pathway described above is confirmed to exist. Per requester confirmation, the intended lookup is **by Lead ID**: when the Lead ID associated with a DO has a Rescue Job in RMS carrying CS Sub Status / Return Reason values, TMS should display those values.

**Naming note:** RMS's own field names are "CS Sub Status" and "Return Reason" — the export column labels "Rescue Reason" and "Rescue Sub Reason" are display labels for this export, not RMS's own field names. The fourth column uses the **"Location Status"** label directly (per requester confirmation), matching TMS's existing field name — no separate "Area" field is introduced. See the Data Mapping section below.

## 6. Expected Behavior

### 6.1 Expected Export Template

| # | Column | Status | Description / Source |
|---|---|---|---|
| 1–78 (≈101 columns incl. the 30 Product columns) | All current fields listed in Current Behavior §5.1 (Order/Customer, Address, Shipping & Status, Money, Product, Fulfillment & Timestamps, Package & E-commerce Platform groups) | **Unchanged (existing)** | Per Current Behavior §5.1 — requester-provided current export field list, 2026-09-15; corroborated in part by Jira TM-8511, TM-1256, TM-1266, TM-1142 |
| 79 | **Offer** | **New** | AFS Pub(Publisher)+Offer pair, via Lead — see BR-06, FR-01, Data Mapping §10 |
| 80 | **Rescue Reason** | **New** | RMS "CS Sub Status" field, via Lead ID lookup — see BR-01, FR-02, Data Mapping §10 |
| 81 | **Rescue Sub Reason** | **New** | RMS "Return Reason" field, via same Lead ID lookup — see BR-02, FR-03, Data Mapping §10 |
| 82 | **Location Status** | **New export column** — existing TMS field (§5.2), not currently part of this export, now added, including two new configured values (High DR, Low DR) | SMG-configured Location Status field — see BR-04, BR-05, FR-05, FR-06, Data Mapping §10 |

The four new columns are appended as the **last columns**, in the order shown, after all existing columns enumerated in Current Behavior §5.1. No existing column's name, order, or data is changed by this BRD.

### 6.2 Expected Behavior — Detail

1. The DO export template on the TMS Shipping screen shall include four additional columns, added as the **last columns** in the export, in this order: **Offer, Rescue Reason, Rescue Sub Reason, Location Status**.
2. **Rescue Reason** is populated from RMS's **CS Sub Status** field, looked up by the Lead ID associated with the DO. If the Lead ID has an associated Rescue Job in RMS with a CS Sub Status value, that value is displayed.
3. **Rescue Sub Reason** is populated from RMS's **Return Reason** field, looked up by the same Lead ID. If the Lead ID's Rescue Job has a Return Reason value, that value is displayed.
4. If the Lead ID has no associated Rescue Job in RMS, or the Rescue Job has no CS Sub Status / Return Reason recorded, the corresponding column(s) are **blank**.
5. **Location Status** is populated from the existing Location Status field (SMG-configured, address-based), now including two new values: **High DR** and **Low DR**, in addition to the existing values (Normal, Non-COD, Lockdown, Uncover Area).
6. **Offer** is populated from AFS, where Offer is part of a Pub(Publisher)+Offer pair associated with the Lead. Exact field-level retrieval logic is not further defined in source — see Open Questions.
7. All other existing Shipping Export behavior (existing columns, data, filters, export logic) remains unchanged.

## 7. User Story

As a user exporting the DO list from the TMS Shipping screen,
I want the exported file to include Offer, Rescue Reason, Rescue Sub Reason, and Location Status columns,
So that I can review offer, rescue-handling, and delivery-location information directly from the export without cross-referencing other systems.

## 8. Business Rules

| Rule ID | Business Rule | Source |
|---|---|---|
| BR-01 | Rescue Reason is sourced from RMS's CS Sub Status field, looked up by the Lead ID associated with the DO. | Requester confirmation |
| BR-02 | Rescue Sub Reason is sourced from RMS's Return Reason field, looked up by the same Lead ID. | Requester confirmation |
| BR-03 | If the Lead ID has no associated Rescue Job in RMS, or the Rescue Job has no CS Sub Status / Return Reason recorded, Rescue Reason and/or Rescue Sub Reason are blank. | Requester confirmation |
| BR-04 | Location Status is sourced from the existing SMG-configured Location Status field for the delivery address. | Requester confirmation; corroborated by Jira TM-8189, TM-8475 |
| BR-05 | High DR and Low DR are new values added to the existing Location Status configuration field in SMG. | Requester confirmation; Jira TM-8776 (Low DR, To Do) corroborates Low DR specifically |
| BR-06 | Offer is sourced from AFS, where it is part of a Pub(Publisher)+Offer pair. | Requester confirmation |
| BR-07 | The four new columns are added as the last columns in the export, in the order: Offer, Rescue Reason, Rescue Sub Reason, Location Status. | Requester confirmation |
| — | All other existing Shipping Export columns, data, filters, and export logic remain unchanged. | Preserved per default BA principle; no source requests a change to existing logic |

## 9. Functional Requirements

| FR ID | Requirement | Business Rule Ref | Source |
|---|---|---|---|
| FR-01 | The system shall add an "Offer" column as the first of the four new columns, populated from AFS's Pub+Offer pair data. | BR-06, BR-07 | Requester confirmation |
| FR-02 | The system shall add a "Rescue Reason" column, populated from RMS's CS Sub Status field via Lead ID lookup. | BR-01 | Requester confirmation |
| FR-03 | The system shall add a "Rescue Sub Reason" column, populated from RMS's Return Reason field via the same Lead ID lookup. | BR-02 | Requester confirmation |
| FR-04 | The system shall display Rescue Reason and/or Rescue Sub Reason as blank when no corresponding RMS data exists for the Lead ID. | BR-03 | Requester confirmation |
| FR-05 | The system shall add a "Location Status" column, populated from the existing SMG-configured Location Status field. | BR-04 | Requester confirmation |
| FR-06 | The system shall support High DR and Low DR as valid Location Status values, displayable in the export. | BR-05 | Requester confirmation |
| FR-07 | The system shall position the four new columns as the last columns in the export, in the order: Offer, Rescue Reason, Rescue Sub Reason, Location Status. | BR-07 | Requester confirmation |

**Formula / Population Logic:** Not defined in source. The exact technical retrieval mechanism (e.g., real-time API lookup vs. batch sync, whether it extends the existing RMS→TMS pathway proven for discount data, and the exact AFS field(s) that constitute "Offer") is not specified in any reviewed source and must not be inferred — see Open Questions.

## 10. Data Mapping

| Source Field | Target Field (Export Column) | Transformation | Notes |
|---|---|---|---|
| RMS: CS Sub Status (via Lead ID) | Rescue Reason | Direct display of value; blank if not found | Label mapping only — RMS's own field name is "CS Sub Status." |
| RMS: Return Reason (via Lead ID) | Rescue Sub Reason | Direct display of value; blank if not found | Label mapping only — RMS's own field name is "Return Reason." Only populated in RMS when CS Status = "Sales can't rescue" (Confluence "User Guide RMS 2.0" §5.1); not defined in source whether this constraint is otherwise relevant to the export display. |
| SMG: Location Status (address-based) | Location Status | Direct display of value | Same field name reused directly — no relabeling. Existing values: Normal, Non-COD, Lockdown, Uncover Area. New values: High DR, Low DR. |
| AFS: Pub + Offer pair | Offer | Not defined in source | Exact AFS field(s) and retrieval mechanism not defined in source — see Open Questions. |

## 11. Acceptance Criteria

**AC-01 — New columns added as the last columns, in order**
Given a user exports the DO list from the Shipping screen,
When the export file is generated,
Then it includes all existing columns unchanged, followed by four new columns as the last columns, in this order: Offer, Rescue Reason, Rescue Sub Reason, Location Status.

**AC-02 — Rescue Reason and Rescue Sub Reason populated via Lead ID lookup**
Given a DO's associated Lead ID has a Rescue Job in RMS with CS Sub Status and/or Return Reason values,
When the DO is included in the export,
Then Rescue Reason displays the RMS CS Sub Status value and Rescue Sub Reason displays the RMS Return Reason value for that Lead ID.

**AC-03 — Blank when no Rescue data exists**
Given a DO's Lead ID has no associated Rescue Job in RMS, or the Rescue Job has no CS Sub Status / Return Reason recorded,
When the DO is included in the export,
Then the corresponding Rescue Reason and/or Rescue Sub Reason column is blank.

**AC-04 — Location Status populated, including new values**
Given a DO's delivery address is configured with a Location Status value in SMG (Normal, Non-COD, Lockdown, Uncover Area, High DR, or Low DR),
When the DO is included in the export,
Then the Location Status column displays that value.

**AC-05 — Offer populated from AFS**
Given a DO's associated Lead has a Pub+Offer pair recorded in AFS,
When the DO is included in the export,
Then the Offer column displays the Offer value from that pair.

## 12. Open Questions

**Resolved (requester confirmation, 2026-09-15):**

1. ~~Does "High DR" already exist, or is it new?~~ → **New value**, added to the existing Location Status configuration field (same treatment as Low DR).
2. ~~Is "Area" a new label for "Location Status," or a separate field?~~ → **It means Location Status** — the column uses the "Location Status" label directly; no separate "Area" field.
3. ~~What does "Offer" refer to, and where is it stored?~~ → **Offer comes from AFS**, where Pub (Publisher) and Offer form a pair.
4. ~~Should Rescue Reason/Sub Reason use a new integration or extend the existing pathway?~~ → **Lookup by Lead ID**: if the Lead ID has Rescue Reason/Rescue Sub Reason values in RMS, TMS displays them. (Underlying technical mechanism — real-time vs. batch, new vs. extended integration — remains open; see below.)
5. ~~What is the exact column position?~~ → **The last columns** in the export.
6. ~~What GEO(s) does this apply to?~~ → **Skipped** — explicitly no information available yet; not resolved, not assumed.
7. ~~What displays when there's no Rescue data?~~ → **Blank.**

**Still open:**

- The exact technical mechanism for the Lead-ID-based RMS lookup (real-time query vs. batch sync; whether it extends the existing discount-approval pathway from TM-8511 or is a new integration) — needs confirmation from engineering.
- The exact AFS field(s) that constitute the "Offer" value within the Pub+Offer pair, and how it is currently associated with a DO/Lead in TMS for export purposes.
- GEO scope for this change (explicitly skipped by requester; needs revisiting once information is available).

**Assumptions:** None — all items above are either confirmed by the requester or explicitly left unresolved.

---

*Readiness: **READY** for the scope covered by BR-01–BR-07 and AC-01–AC-05 (per requester confirmation on 2026-09-15). The underlying technical integration mechanism, exact AFS Offer field, and GEO scope remain open and are out of scope for this BRD's acceptance criteria — recommended as follow-up confirmations with engineering/AFS owner before implementation.*

## 13. Sources and Traceability

| Requirement | Business Rule | Functional Requirement | Acceptance Criteria | Source |
|---|---|---|---|---|
| Rescue Reason sourced from RMS CS Sub Status via Lead ID | BR-01 | FR-02 | AC-02 | Requester confirmation; Confluence "User Guide RMS 2.0" §5.1 |
| Rescue Sub Reason sourced from RMS Return Reason via Lead ID | BR-02 | FR-03 | AC-02 | Requester confirmation; Confluence "User Guide RMS 2.0" §5.1; Jira TM-6344 |
| Blank when no Rescue data | BR-03 | FR-04 | AC-03 | Requester confirmation |
| Location Status sourced from existing SMG field | BR-04 | FR-05 | AC-04 | Requester confirmation; Jira TM-8189, TM-8475 |
| High DR / Low DR as new values | BR-05 | FR-06 | AC-04 | Requester confirmation; Jira TM-8776 (Low DR, To Do) |
| Offer sourced from AFS Pub+Offer pair | BR-06 | FR-01 | AC-05 | Requester confirmation; Jira TM-8475 (Deal/Pub-offers reference) |
| Columns positioned last, in order | BR-07 | FR-07 | AC-01 | Requester confirmation |
| Existing RMS→TMS Shipping Export pathway precedent | — | — | — | Jira TM-8511 (Done) |

## 14. Version History

| Version | Date | Change | Author |
|---|---|---|---|
| 0.1 | 2026-09-15 | Initial draft — new BRD, readiness PARTIAL pending Open Questions Q1–Q7 | BA Agent |
| 0.2 | 2026-09-15 | Resolved Open Questions Q1, Q2, Q3, Q4 (partially), Q5, Q7 per requester confirmation; Q6 skipped. Renamed "Area" column to "Location Status." Added AFS as related system. Drafted Business Rules BR-05–BR-07, Functional Requirements FR-01–FR-07, and Acceptance Criteria AC-01–AC-05. Readiness updated to READY for the confirmed scope. | BA Agent |
| 0.3 | 2026-09-15 | Updated Background and Objective per stakeholder request screenshot (`requirment_DR Offer.png`): reframed business driver as OE team's DR-by-Offer and DR-by-Area analysis feeding AM recommendations. Added TMS Order Management as a related system (PUB + Offer pair). Flagged additional fields from the same request (DO Validated, Order Status, COD, Province, District, Pincode) as out of this version's scope, pending confirmation. No changes made to Scope, Business Rules, Functional Requirements, Data Mapping, or Acceptance Criteria. | BA Agent |
| 0.4 | 2026-09-15 | Restructured Current Behavior (§5) with a confirmed-columns table (§5.1: 7 columns independently source-confirmed as existing export columns — Jira TM-8511, TM-1256, TM-1266) and a related-fields table (§5.2: Delivery Code, Location Status, AWB, and DO-record API fields — confirmed to exist on-screen/in the DO record, but NOT confirmed as export columns). Explicitly stated that no single source enumerates the full current export column set, per grounding rules (not inferred or reverse-engineered). Added an Expected Template table (§6.1) showing the confirmed existing columns unchanged plus the 4 new columns appended last; existing narrative Expected Behavior list retained as §6.2. No changes to Business Rules, Functional Requirements, Data Mapping, Acceptance Criteria, or Open Questions. | BA Agent |
| 0.5 | 2026-09-15 | Replaced §5.1's partial Jira-sourced column list with the requester-provided complete current export field list (2026-09-15): 78 named fields across 7 groups (Order/Customer, Address, Shipping & Status, Money, Product [30 columns, product1–product10 capped], Fulfillment & Timestamps, Package & E-commerce Platform). This confirmed list corroborates prior Jira findings (deliveryCode, discountPercentage, discountAmount, Order Amount, Receivable Amount, firstAttempt/secondAttempt/thirdAttempt) and confirms — directly, not by reversing Expected Behavior — that Offer, Rescue Reason, Rescue Sub Reason, Location Status, and AWB are NOT part of the current export. Updated §5.2 accordingly (removed Delivery Code, now confirmed in-export; kept Location Status and AWB as confirmed-elsewhere-but-not-in-export). Updated §6.1's Expected Template table to reference the full current field set rather than a partial list. No changes to Business Rules, Functional Requirements, Data Mapping, Acceptance Criteria, or Open Questions. | BA Agent |
