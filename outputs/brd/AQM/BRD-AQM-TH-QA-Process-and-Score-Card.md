# Business Requirement Document

**System:** WFO (Workforce Optimization)
**Feature:** AQM (Automated Quality Management)
**GEO:** TH (Thailand)
**Document Status:** DRAFT — PARTIAL (Current-State Analysis readiness: PARTIAL — see Section 13, Open Questions)
**Prepared by:** Phoebe Luu
**Date:** 2026-08-31
**Jira Reference:** [WFM-531](https://accelo-tech.atlassian.net/browse/WFM-531) — "[WFO][AQM][TH] QA Process & Score Card" (Story, To Do)

## 1. Background

Thailand sales teams need a consistent, defined way to review a recorded sales call before the order is approved, so quality issues are caught and corrected before the order moves forward in TMS.

AQM already provides automated review of sales interactions for other GEOs, but no Thailand-specific evaluation criteria or review process exists today. *(Source: [\[FS\] AQM Management](https://accelo-tech.atlassian.net/wiki/pages/viewpage.action?pageId=551288903))*

Before an in-system tool existed, this kind of review was done manually. A checklist-based tool — the WFO QA Module — was later introduced to support QA/Validator review of orders and QC evaluation of agents. *(Source: [\[WFO\]\[BRD\] QA Module](https://accelo-tech.atlassian.net/wiki/pages/viewpage.action?pageId=377880770))*

This requirement is tracked in Jira as [WFM-531](https://accelo-tech.atlassian.net/browse/WFM-531), summary "[WFO][AQM][TH] QA Process & Score Card" (Story, status To Do). The ticket's own tagging confirms this BRD's System/Feature/GEO framing (WFO / AQM / TH). The ticket does not yet contain a description, so no additional requirement content was drawn from it beyond this confirmation — see OQ-5.

## 2. Objective

Define the TH QA Process flow and the TH Score Card's 13 evaluation criteria so that a Sales order's recorded conversation can be reviewed against a consistent, source-grounded checklist and the outcome recorded in TMS.

## 3. GEO Apply

TH (Thailand)

## 4. Scope

- The TH QA Process flow for reviewing a Sales order's voice recording (Section 7).
- The TH Score Card: 13 criteria (Thai and English labels), each rated **Yes (Included) or No (Not Included)**. Partial rating is out of scope.

## 5. Stakeholders and User Roles

| Role | Description | Source |
|---|---|---|
| Sales team | Provides the voice recording of the Sales order | Attachment |
| QA/QC reviewer | Listens to the recording, reviews it against the Score Card, updates the result in TMS | Attachment |
| Validator/QC | Validates orders and evaluates agents in the WFO QA Module; not confirmed to apply to the TH AQM workflow | [WFO][BRD] QA Module |

## 6. Current Behavior

**AQM:**
- Auto-scans interactions, producing sentiment and order-validation results "depending on the configuration." *(Source: [FS] AQM Management)*
- Order Validation cross-references TMS data (customer name, address, lead status, product, quantity, order value) as a read/comparison view; no write-back to TMS is documented. *(Source: [FS] AQM Management)*
- Scans an interaction's lead status only when the TMS status is Approved or Rejected. *(Source: [FS] AQM Management)*
- No TH-specific AQM criteria, Score Card, or QA Process exists in any reviewed source.

**WFO QA Module (manual, pre-automation):**
- Before this tool existed, QA/QC work was performed manually via Excel/Google Sheet. *(Source: [WFO][BRD] QA Module)*
- A QA/Validator opens an order sourced from TMS and completes a checklist, applicable only when the TMS SO status is New or Pending; validation status moves one-way (To Do → Completed) and does not itself change the SO status. *(Source: [WFO][BRD] QA Module)*
- TMS and WFO exchange order data directly: TMS posts order data to WFO, and WFO posts the validation result back. *(Source: [WFO][BRD] QA Module)*

## 7. Expected Behavior

*(As explicitly described in `inputs/attachments/[TH] QA Process and Score Card (2).xlsx`. Not confirmed to already exist — see Section 13.)*

The TH QA Process:

1. Receive the voice file of the Sales order from the Sales team.
2. Open the voice file and listen to the conversation.
3. Review the conversation against the TH Score Card (below).
4. Update the result in TMS.
5. Approve the Order.
   - **Branch A — needs correction:** change status to Pending, add a comment, and inform the Sales team to correct the missing information with the customer.
   - **Branch B — disqualified:** change status to Cancel and add a comment.

*(The system component performing steps 2–5 — a manual reviewer, or an AQM-automated action — is not confirmed; see OQ-1 and OQ-4.)*

**TH Score Card — 13 criteria:**

| # | Thai | English |
|---|---|---|
| 1 | เปิดตัวแจ้งชื่อสินค้า เรียกชื่อลูกค้า | Mention Product name and customer name correctly at the start |
| 2 | นำเสนอสินค้า สรรพคุณถูกต้อง | Explain Product information and the benefits to customer clearly |
| 3 | เสนอโปรโมชั่น ส่วนลด ของแถม | Provide the Promotion, Price, Discount and Free products correctly |
| 4 | ถามข้อมูลการจัดส่งครบถ้วน | Gather full the delivery address and repeat with customer correctly |
| 5 | สรุปการสั่งซื้อสินค้า+ราคาถูกต้องและช่องทางการชำระชัดเจน | Summarize the order, Product, Price and Payment Method Selection correctly |
| 6 | ลูกค้าตอบรับ | Customer Confirm to order and agree to purchase on the phone clearly |
| 7 | คีย์ออเดอร์สินค้า ราคา ลงข้อมูลลูกค้า ถูกต้อง | All Data entry in TMS matching with the conversation on the phone correctly |
| 8 | ไม่อวดอ้างสรรพคุณเกินจริง | Don't Overclaim, or Guarantee the symptom will be cured |
| 9 | มีมารยาทการขายใช้คำสุภาพ ไม่พูดประชดประชัน เหน็บแนม | Use the polite tone and not sarcastic word in conversation with customers |
| 10 | ไม่พูดเร็วรัวจนจับใจความไม่ได้ | Speak at normal speed and easy to understand |
| 11 | ไม่แจ้งเจาะจงวันที่ได้รับสินค้า (นอกจากลูกค้าระบุวันรับเอง) | Should not specify the arrival date except when the customer requests the date |
| 12 | ไม่ชี้ช่อง แนะนำว่าหากไม่เห็นผลหรือแพ้สามารถเคลมขอคืนเงินได้ | No wording about refund or claim if the customer doesn't see an effect from the product |
| 13 | มีการแจ้งให้ลูกค้าแอดไลน์ หรือแจ้งเบอร์โทรเพื่อสอบถามสินค้าและโปรโมชั่นต่างๆของบริษัท | Request the customer to add Line, or provide a backup phone number |

Each criterion is rated **Yes (Included)** or **No (Not Included)**.

## 8. User Story

**As a** QA/QC reviewer in Thailand,
**I want to** review a Sales order's voice recording against the TH Score Card and record the outcome in TMS,
**so that** the order's quality is validated before it is approved, returned for correction, or cancelled.

## 9. Business Rules

| Rule ID | Business Rule | Source |
|---|---|---|
| BR-01 | The TH Score Card has 13 criteria, each rated Yes (Included) or No (Not Included). | Per user direction (2026-08-31) — the source attachment, Sheet "Score Card," originally specified three values (Included/Partial/Not Included) with partial credit for criteria 8–13; Partial is excluded from scope. |
| BR-02 | One voice recording is reviewed per Sales order, and the result is recorded in TMS. | Attachment, Sheet "QA Process" |
| BR-03 | A comment is required when the order is not approved. | Attachment, Sheet "QA Process" |

The formula combining the 13 Yes/No ratings into a final score/result, and the TMS status values behind Approve/Pending/Cancel, are **Not defined in source** — see OQ-2 and OQ-3.

## 10. Functional Requirements

| FR ID | Requirement | Business Rule Ref | Source |
|---|---|---|---|
| FR-01 | The system shall present the 13 TH Score Card criteria (Thai and English labels) to the reviewer for rating. | BR-01 | Attachment |
| FR-02 | The system shall allow each criterion to be rated Yes (Included) or No (Not Included). | BR-01 | Per user direction (see BR-01 source note) |
| FR-03 | The system shall allow the reviewer to record the reviewed result against the Sales order in TMS. | BR-02 | Attachment |
| FR-04 | The system shall require a comment when the order is not approved. | BR-03 | Attachment |

## 11. Data Mapping

| Source Field | Target Field | Transformation | Notes |
|---|---|---|---|
| Score Card rating (Included/Not Included) per criterion | AQM/QA result record | Not defined in source | Final rollup formula not defined in source (OQ-2) |
| Review result | TMS order status | Not defined in source | Exact TMS status field/values not confirmed (OQ-3) |
| Comment (when not approved) | TMS order comment | None | Required only when not approved |

## 12. Acceptance Criteria

**AC-01 — Display the TH Score Card**
Given a QA/QC reviewer is reviewing a Sales order's voice recording,
When the reviewer opens the TH Score Card,
Then all 13 criteria are displayed with their Thai and English labels and a rating control offering Yes (Included) and No (Not Included).

**AC-02 — Comment required when not approved**
Given a reviewer sets the order result to Pending or Cancel,
When the reviewer attempts to save the result,
Then the system requires a comment before the result can be saved.

## 13. Open Questions

Resolving OQ-1–OQ-4 is required before BR/FR can be extended to cover final scoring and TMS status transitions. OQ-5 concerns ticket ownership only.

| # | Question | Why It Matters |
|---|---|---|
| OQ-1 | Does this workflow run in AQM's automated pipeline, the WFO QA Module's manual checklist tool, or a TH rollout of the manual process ahead of AQM automation? | Determines which system component implements these requirements. |
| OQ-2 | How do the 13 Yes/No (Included/Not Included) ratings combine into a final score and pass/fail result? | Not defined in the attachment. |
| OQ-3 | Do "Approve," "Pending," and "Cancel" map to existing TMS status values, or are they new/TH-specific? | Sources conflict: the WFO QA Module documents SO statuses New/Pending/Cancel/Delay (no "Approved"); AQM Management references TMS status Approved/Rejected for Lead status. |
| OQ-4 | Does AQM have, or need, a capability to write an order status and comment back to TMS? | Not confirmed in any reviewed source; only the WFO QA Module confirms a TMS write path today. |
| OQ-5 | [WFM-531](https://accelo-tech.atlassian.net/browse/WFM-531) has no description yet — should this BRD's confirmed content be used to populate it, or does the requirement content live elsewhere? | Affects whether this BRD or the Jira ticket is the authoritative source going forward. |

## 14. Sources and Traceability

| Requirement | Business Rule | Functional Requirement | Acceptance Criteria | Source |
|---|---|---|---|---|
| TH Score Card display and rating (Yes/No) | BR-01 | FR-01, FR-02 | AC-01 | Attachment, Sheet "Score Card" (rating simplified to Yes/No per user direction) |
| Record result in TMS | BR-02 | FR-03 | — | Attachment, Sheet "QA Process" |
| Comment required when not approved | BR-03 | FR-04 | AC-02 | Attachment, Sheet "QA Process" |
| AQM current behavior | — | — | — | [FS] AQM Management (Confluence) |
| WFO QA Module manual workflow | — | — | — | [WFO][BRD] QA Module (Confluence) |
| Ticket tracking (System/Feature/GEO confirmation only — no requirement content) | — | — | — | [WFM-531](https://accelo-tech.atlassian.net/browse/WFM-531) (Jira, Story, To Do) |

## 15. Version History

| Version | Date | Change | Author |
|---|---|---|---|
| 0.1 | 2026-08-31 | Initial draft — PARTIAL readiness. Current State from AQM Management (Confluence 551288903) and WFO QA Module (Confluence 377880770, cross-system supporting evidence); Expected State from `inputs/attachments/[TH] QA Process and Score Card (2).xlsx`. Five Open Questions raised; no Jira/Confluence write performed. | BA AI Agent |
| 0.2 | 2026-08-31 | Relocated from `knowledge/systems/AQM/BRD/` to `outputs/brd/AQM/` per updated Output Routing Rules (`knowledge/` is reference-only). Content unchanged. | BA AI Agent |
| 0.3 | 2026-08-31 | Revised to the updated BRD skill's section standard (Background/Objective/GEO Apply/Scope/Stakeholders/Current Behavior/Expected Behavior/User Story/Business Rules/Functional Requirements/Data Mapping/Acceptance Criteria/Open Questions/Sources and Traceability/Version History). Added the full 13-item TH Score Card table. Removed placeholder BR/FR rows for undefined items. Combined tier-behavior ACs. Labeled WFO citations as Related System, supporting reference only. | BA AI Agent |
| 0.4 | 2026-08-31 | Per explicit user instruction: header changed to System: WFO / Feature: AQM (Automated Quality Management), Prepared by: Phoebe Luu; removed the Primary System/Related System labeling throughout (this resolves former OQ-5 — the organization's own Confluence tagging already treats AQM as a WFO feature); Background rewritten as business-context only, with technical detail and the file path removed and Confluence links added; Scope simplified to a binary Yes/No (Included/Not Included) rating — Partial excluded, deviating from the attachment's original three-value design per this explicit direction; removed the Out of Scope section; removed all Agent Evaluation content from Current Behavior (GEO-dependent Criteria/Requirement/Score columns, and the WFO QC weighted-scoring mechanism); Business Rules, Functional Requirements, Acceptance Criteria, and Sources and Traceability updated to match the binary rating model. No Jira/Confluence access. | BA AI Agent |
| 0.5 | 2026-08-31 | Linked this BRD to Jira [WFM-531](https://accelo-tech.atlassian.net/browse/WFM-531) ("[WFO][AQM][TH] QA Process & Score Card," Story, To Do), retrieved read-only. The ticket's own summary tag confirms this BRD's System: WFO / Feature: AQM / GEO: TH framing. The ticket has no description, so no requirement content changed as a result — added a new OQ-5 on which document (this BRD or the ticket) should be authoritative going forward. Jira was not written to. | BA AI Agent |
