# [TMS] Freeze DO and DR% KPI at Finance Cut-off

## Description

### Applied GEO

LATAM only (confirmed by requester), consistent with the referenced BRD's stated scope ("[TMS][BRD] Agent performance tracking metric to KPI Performance," GEO: LATAM).

### Business Context / Purpose

Finance performs the monthly DR cut-off on the 20th, and the DR data is then provided to the team around the 25th for commission calculation and payment on the 30th. However, the DR displayed in TMS for Sales Agents continues to update after the Finance cut-off. As a result, the DR shown to agents may differ from the DR provided by Finance, since the two figures are based on different data filter times. *(Source: requester-provided business context.)*

### Current Behavior

Per the approved BRD "[TMS][BRD] Agent performance tracking metric to KPI Performance" (System: TMS, GEO: LATAM):

- The KPI Performance popup lets the Agent filter by MTD (default) or a custom From Date/To Date range; whenever the filter period is changed, the system immediately recalculates and refreshes all KPI cards. *(Source: BRD AC2, AC3.)*
- **DO** and **DR%** both use **SO Created Date** as their date source for the selected filter period. *(Source: BRD AC4 — KPI Filter Logic table.)*
- Formulas (per BRD AC5):
  - **DO** = Total DO linked with a validated SO (SO Status = Validated), Integer, Date Source = SO Created Date.
  - **DR%** = Total Delivered Orders ÷ Total Validated SO × 100, Percentage, Date Source = SO Created Date.
- There is no cut-off, snapshot, or freeze mechanism defined in the BRD — every KPI, including DO and DR%, is recalculated live against current data each time the filter period is applied. This live recalculation is why DO/DR% for a past (already-cut-off) period continues to change whenever underlying SO/delivery data for that period is updated afterward.
- The BRD does not define any other date source change, snapshot mechanism, or freeze logic for any KPI.

*Source: Confluence "[TMS][BRD] Agent performance tracking metric to KPI Performance" (`https://accelo-tech.atlassian.net/wiki/x/AYB-UQ`), Sections AC2–AC5.*

### Expected Behavior

1. At the moment Finance's own cut-off job runs for a period, the system shall capture a **snapshot** of that period's DO and DR% underlying values (per the existing formulas and date source — SO Created Date — unchanged) and store it as the frozen DO/DR% for that period. The date source itself is **not changed**; only a snapshot/lock is added on top of the existing calculation. *(Resolves Open Question Q2.)*
2. For any period whose cut-off snapshot has been captured, the Sales Agent TMS KPI Performance view shall display the **snapshot** value for DO and DR%, not a live recalculation — even if underlying SO/delivery data for that period is updated afterward.
3. This lock is **permanent**: once a period's cut-off snapshot is captured, the frozen DO/DR% value for that period is not recalculated or reopened again, including if Finance later issues a correction after the 25th data delivery. *(Resolves Open Question Q5.)*
4. For the current, in-progress period (cut-off job not yet run), DO and DR% continue to recalculate live against current data, unchanged from today's behavior.
5. For a custom date range (From Date/To Date) that spans both an already-frozen period and the current open period, the frozen portion of the range shall use the frozen snapshot values, while the open portion shall continue to use live-calculated values. *(Resolves Open Question Q4; the exact combination logic for producing one DO/DR% figure across a mixed frozen+live range is a Recommendation, not a confirmed requirement — see Open Questions / Assumptions.)*
6. No other KPI (Total Lead Calls, AR_QA, AOV, Revenue Validated, Revenue Delivered) is in scope for this change; their date sources and live-recalculation behavior remain exactly as defined in the BRD.
7. This behavior applies to LATAM only. *(Resolves Open Question Q3.)*
8. The cut-off moment itself is defined as "the moment Finance's own cut-off job runs" — not a fixed clock time such as end-of-day on the 20th. *(Resolves Open Question Q1.)*

## User Story

As a Sales Agent viewing my KPI Performance in TMS,
I want the DO and DR% figures for a period that Finance has already cut off to stay fixed,
So that the numbers I see match the DR figures Finance uses for commission calculation and payment, instead of appearing to change after the cut-off.

## Business Rules

- BR-01: At the moment Finance's own cut-off job runs for a period, the system captures a snapshot of DO and DR% for that period (using the existing formulas and date source, unchanged); this snapshot becomes the frozen value going forward. *(Source: requester confirmation)*
- BR-02: A frozen DO/DR% value is locked permanently — it is never recalculated or reopened, even if Finance issues a later correction. *(Source: requester confirmation)*
- BR-03: A period that has not yet reached its cut-off continues to recalculate DO and DR% live, exactly as today. *(Source: requester's business context — implied by "at the cut-off time... should be frozen")*
- BR-04: For a custom date range spanning a frozen period and the current open period, the frozen portion contributes its snapshot values and the open portion contributes live values. *(Source: requester confirmation; exact numeric combination method is a Recommendation — see Open Questions / Assumptions)*
- BR-05: This change applies only to the DO and DR% KPIs, and only for LATAM; all other KPIs, and all other GEOs, keep their current behavior unchanged. *(Source: requester's explicit scope — "these KPI DO and DR%," "Only LATAM")*

## Acceptance Criteria

**AC-01 — Snapshot captured when Finance's cut-off job runs**
Given Finance's cut-off job runs for a period,
When the job completes,
Then the system captures and stores a snapshot of that period's DO and DR% values (per the existing formulas/date source) as the frozen value for that period.

**AC-02 — Frozen DO/DR% displayed for a cut-off period, permanently**
Given a period whose cut-off snapshot has been captured,
When a Sales Agent (LATAM) views the KPI Performance dashboard for that period, at any time afterward — including after a later Finance correction,
Then the DO and DR% values displayed are the stored snapshot values, and do not change even if underlying SO/delivery data for that period is subsequently updated.

**AC-03 — Live DO/DR% for the current period**
Given the current, in-progress period (Finance's cut-off job has not yet run for that period),
When a Sales Agent (LATAM) views the KPI Performance dashboard,
Then DO and DR% continue to recalculate live against current data, consistent with existing behavior.

**AC-04 — Custom date range spanning the cut-off boundary**
Given a Sales Agent (LATAM) sets a custom From Date/To Date range that spans both an already-frozen period and the current open period,
When the KPI Performance dashboard displays DO and DR% for that range,
Then the frozen portion of the range uses the stored snapshot values and the open portion uses live-calculated values.
*(The exact numeric method for combining the frozen and live portions into one DO/DR% figure — e.g., summing underlying numerator/denominator components across both portions before computing the ratio — is a Recommendation, not confirmed by the requester; see Open Questions / Assumptions.)*

**AC-05 — Other KPIs and other GEOs unaffected**
Given the DO/DR% freeze behavior is implemented for LATAM,
When a Sales Agent views the KPI Performance dashboard,
Then Total Lead Calls, AR_QA, AOV, Revenue Validated, and Revenue Delivered continue to use their existing date sources and live-recalculation behavior everywhere, and no other GEO's DO/DR% behavior is affected.

## Other Information

- Reference: Confluence [TMS][BRD] Agent performance tracking metric to KPI Performance (`https://accelo-tech.atlassian.net/wiki/x/AYB-UQ`) — current DO/DR% definitions, date sources, and filter/refresh logic (AC2–AC5)

## Open Questions / Assumptions

**Resolved (requester confirmation, 2026-09-16):**

1. ~~What is the exact cut-off timestamp?~~ → **The moment Finance's own cut-off job runs** (event-triggered, not a fixed clock time).
2. ~~Is the mechanism a snapshot/lock, or a change to the date-source filter?~~ → **Snapshot.** The date source itself does not change; a snapshot/lock is captured on top of the existing SO Created Date-based calculation.
3. ~~Is this LATAM-wide, or one specific market?~~ → **LATAM only.**
4. ~~How should a custom range spanning the cut-off boundary behave?~~ → **The frozen portion uses frozen (snapshot) values; the open portion stays live.**
5. ~~Is the freeze permanent, or reversible on a later Finance correction?~~ → **Locked permanently once the cut-off snapshot is captured.**

**Recommendation (not a confirmed requirement):** For AC-04 (a custom range spanning the cut-off boundary), the exact numeric method to combine frozen and live values into a single DO/DR% figure is not specified by the requester. Recommended approach: sum the underlying numerator/denominator components (e.g., Total Delivered Orders, Total Validated SO) from the frozen snapshot(s) and from the live portion separately, then compute the final ratio (DR%) over the combined totals — rather than averaging two already-computed percentages. This should be confirmed with engineering/product before implementation.

**Assumptions:** None — all items are either confirmed by the requester or explicitly flagged as a Recommendation above.

---

*Readiness: **READY** for the scope covered by BR-01–BR-05 and AC-01–AC-05, per requester confirmation on 2026-09-16. The numeric combination method for a custom range spanning the cut-off boundary (AC-04) is carried as a Recommendation, not a confirmed requirement, and should be validated with engineering before implementation.*
