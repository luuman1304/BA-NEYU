# [TMS][IN] Display Customer Consent and Terms & Conditions Status on Order Detail

## Description

### Applied GEO

India

### Business Context / Purpose

Enable TMS users to verify whether a customer provided consent and accepted the Terms & Conditions for a lead submitted from a landing page.

### Current Behavior

- India landing pages contain two checkboxes:
  - Customer Consent
  - Terms & Conditions
- Customer selections are captured on the landing page.
- Leads are submitted from Landing Page Hosting to TMS.
- Consent information is not displayed in TMS.
- TMS users cannot verify this information for a Lead ID.

### Expected Behavior

#### 1. Landing Page Information

Landing Page Hosting sends the following information with the existing lead submission:

| Information | Description |
|---|---|
| Customer Consent | Indicates whether the Customer Consent checkbox was selected. |
| Terms & Conditions Acceptance | Indicates whether the Terms & Conditions checkbox was selected. |

#### 2. TMS Display

On Lead Detail / Order Detail, add two read-only fields below Address:

- Customer Consent Status
- Terms & Conditions Status

| Source Information | Source Value | TMS Display Value |
|---|---|---|
| Customer Consent | Selected | Consented |
| Customer Consent | Not selected | Not Consented |
| Customer Consent | Information not received | Unknown |
| Terms & Conditions Acceptance | Selected | Accepted |
| Terms & Conditions Acceptance | Not selected | Not Accepted |
| Terms & Conditions Acceptance | Information not received | Unknown |

#### 3. Existing Data

Display **Unknown** for existing leads that do not contain the consent information.

#### 4. Edit Behavior

TMS users cannot manually edit either status. The existing workflow remains unchanged.

## User Story

As a TMS user,  
I want to view the Customer Consent and Terms & Conditions status of each lead,  
So that I can verify whether the customer provided consent.

## Business Rules

- **BR-01:** Map Customer Consent to Consented, Not Consented, or Unknown according to the received value.
- **BR-02:** Map Terms & Conditions Acceptance to Accepted, Not Accepted, or Unknown according to the received value.
- **BR-03:** Display both statuses as read-only.
- **BR-04:** Display Unknown for existing leads without consent information.

## Acceptance Criteria

### AC1 — Receive and display information

Given Landing Page Hosting submits Customer Consent and Terms & Conditions Acceptance with a lead,  
When a TMS user opens the Lead Detail / Order Detail,  
Then TMS displays Customer Consent Status and Terms & Conditions Status below Address.

### AC2 — Map statuses

Given consent information is received,  
When TMS displays the statuses,  
Then it maps Customer Consent to Consented or Not Consented and Terms & Conditions Acceptance to Accepted or Not Accepted according to the source selections.

### AC3 — Handle missing information

Given consent information was not received, including for an existing lead,  
When a TMS user views the lead,  
Then the applicable status displays Unknown.

### AC4 — Prevent manual editing and preserve existing workflow

Given the statuses are displayed on Lead Detail / Order Detail,  
When a TMS user views or continues processing the lead,  
Then the statuses are read-only and the existing workflow remains unchanged.

> This sample demonstrates ticket structure only. Its business behavior is not a global rule for other tickets.

