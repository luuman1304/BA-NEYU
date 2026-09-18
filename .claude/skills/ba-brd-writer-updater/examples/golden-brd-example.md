# Business Requirement Document — Golden Example

> **Reference for writing quality, structure, detail level, and Acceptance Criteria style only.**
> Do NOT copy Auromedic, WhatsApp, India, Template C, any customer name, product name, Meta tier, or overnight-lead business content into another BRD unless the actual request explicitly contains that information. This example illustrates *how concise and testable* a BRD should read — not a source of reusable business content.

## Background

Fresh overnight leads may wait several hours before the calling lines open. During this time, customers do not receive confirmation that Auromedic has received their enquiry, which may reduce call connectivity.

Phase 1 will send an automatic WhatsApp acknowledgement to eligible overnight leads so that customers know when to expect the call.

## Objective

- Improve connectivity for overnight HOT leads.
- Ensure customers expect a call from Auromedic.
- Build a high-quality WhatsApp messaging record to support the Meta tier upgrade.
- Apply the initial rollout to a naturally volume-limited group that fits the 250-conversation tier.

## GEO Apply

India

## Scope

### In Scope

- Apply to fresh leads only.
- Apply to leads received between 9:01 PM and 7:59 AM IST.
- Use approved Template C.
- Apply under Meta's current 250 business-initiated conversations per day tier.

## Current Behavior

Fresh leads received overnight do not receive a WhatsApp acknowledgement. They are contacted through the existing calling process when the calling lines open.

## Expected Behavior

When a fresh lead is received between 9:01 PM and 7:59 AM IST:

1. The system identifies the lead as eligible for Phase 1.
2. The system automatically selects Template C.

Template C:

> Hi {{customer name}}, your enquiry with Auromedic for {{product name}} is confirmed. 🌙
>
> A health advisor has been assigned to you and your consultation on {{product name}} is being prepared.
>
> Our lines open at 8 AM and you'll be among the first we call. When we do, you'll see Auromedic on your caller ID — please keep your phone reachable in the morning.

3. The system populates the customer name and product name from the lead information.
4. The system sends Template C to the customer's WhatsApp number within seconds of receiving the lead.
5. Each eligible lead receives Template C only once.
6. The existing lead assignment and calling process remain unchanged.
7. When the customer is called, the caller ID displays "Auromedic."

## Data Mapping

| Source Field | Target Field | Notes |
|---|---|---|
| Lead Information (TMS) — customer name | `{{customer name}}` | Populated at send time |
| Lead Information (TMS) — product name | `{{product name}}` | Populated at send time |

## User Story

As an agent,
I want fresh overnight leads to receive an automatic WhatsApp acknowledgement,
so that customers know their enquiry has been received and expect a call from Auromedic when the calling lines open.

## Acceptance Criteria

**AC1 — Template C Trigger and Exclusion**
Given a fresh lead is received,
When its receipt time is between 9:01 PM and 7:59 AM IST,
Then the system shall send Template C within seconds using the customer's Name, Product, and Phone Number,
And shall not send it to non-fresh leads or leads received outside this time range.

**AC2 — Duplicate Prevention and Existing Flow**
Given an eligible lead has already received Template C or the message fails to send,
When the lead is updated or received again,
Then the system shall not send a duplicate message,
And the existing lead status, priority, assignment, and calling flow shall remain unchanged.

**AC3 — Meta Tier Compliance**
Given Phase 1 operates under Meta's 250 business-initiated conversations-per-day tier,
When the system processes eligible overnight leads,
Then it shall send Template C only within the available daily capacity,
And leads that do not receive the message shall continue through the existing calling flow.

---

### Why this is the standard

- Every Expected Behavior step and AC traces to a stated fact — nothing here reads as invented.
- Current Behavior is one short paragraph; it doesn't pad with irrelevant history.
- Acceptance Criteria combine multiple related conditions into three ACs instead of one AC per minor variation.
- Business language throughout — no implementation detail (no API names, no database fields, no code).
- Optional sections not needed here (Stakeholders, Permissions, Dashboard/Reporting, Dependencies, Business Rules, Functional Requirements, Open Questions) are simply omitted rather than left as empty headings.
