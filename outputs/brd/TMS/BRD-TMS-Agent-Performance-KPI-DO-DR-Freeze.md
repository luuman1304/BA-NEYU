| **System** | TMS |
| --- | --- |
| **Feature** | Agent performance tracking metric to KPI Performance |
| **GEO** | LATAM |
| **Agenda** |  |
| **References** | <https://www.figma.com/design/aMsjuaHiKyvm9rGiAzDno1/TMS?node-id=998-477&t=SwMIvSJSTPvGNkbq-4> |
| **Change Log** | 2026-09-18 — Split the KPI Performance popup into a Realtime tab and a Performance tab, and added DO/DR% freeze-at-Finance-cut-off behavior, per CR [TM-9010](https://accelo-tech.atlassian.net/browse/TM-9010). AC1–AC6 content unchanged; now scoped to the Realtime tab. |

# 1. Business Context

Currently, LATAM agents do not have a dedicated place in TMS to review their performance.

This enhancement provides a KPI Performance dashboard where agents can monitor key business and operational metrics, including:

- Total Lead Calls
- Approval Rate QA (AR_QA%)
- Average Order Value (AOV)
- Delivery Order, Delivery Rate (DR%)
- Revenue Validated
- Revenue Delivered

The dashboard will help agents track their performance and understand their contribution to business results.

Role Apply: Agent

**Addendum — Finance Cut-off Misalignment (source: CR TM-9010, requester-provided business context):**

Finance performs the monthly DR cut-off on the 20th, and the DR data is then provided to the team around the 25th for commission calculation and payment on the 30th. However, the DO and DR% displayed in TMS for Sales Agents continue to update after the Finance cut-off, because today's KPI Performance popup is a single, undivided view that always recalculates live (confirmed current state — see §3.1). As a result, the DO/DR% shown to agents may differ from the figures Finance uses for commission calculation and payment, since the two are based on different data filter times.

> The cut-off timeline (20th/25th/30th) is requester-provided context from CR TM-9010 and is not independently corroborated by a Finance-owned document in the sources reviewed. Per the requester's decision, no further corroborating source is being pursued for this item (see **Deferred Items**).

**Confirmed structural change:** Prior to this change, the KPI Performance popup has no tabs — it is a single view showing real-time (live-recalculated) data, matching §3.1 (AC1–AC6) below. This change splits the popup into two tabs, each with its own, independent date picker:

- **Realtime tab** — continues today's live-recalculation behavior (AC1–AC6), with an added restriction on selectable dates (AC12).
- **Performance tab** (new) — introduces the DO/DR% freeze-at-cut-off behavior (AC7–AC11), with its own date filter (AC13).

# 2. User Story

As an Agent,

When I want to review my performance,

I want to access KPI metrics directly from TMS,

So that I can monitor my productivity and business performance.

**Addendum User Story (source: CR TM-9010):**

As a Sales Agent viewing my KPI Performance in TMS,

I want the DO and DR% figures for a period that Finance has already cut off to stay fixed,

So that the numbers I see match the DR figures Finance uses for commission calculation and payment, instead of appearing to change after the cut-off.

# 3. Acceptance Criteria

## 3.1 Realtime Tab

*Confirmed current behavior (unchanged content). Prior to this change this was the entire KPI Performance popup; it is now scoped to the Realtime tab, with AC12 added as the only new behavior in this tab.*

### AC1. KPI Performance Popup & Filter

Given the user clicks the KPI Performance button on the header

When the KPI Performance popup is displayed

Then the system shall display the following filters:

| Field | Type | **Field (ES)** |
| --- | --- | --- |
| MTD When user hovers, the button shows: "Month to Date" | Quick Filter Button | MTDWhen user hover show, the button shows "Mes a la fecha" |
| From Date | Date Picker | Desde |
| To Date | Date Picker | Hasta |

And:

- MTD shall be selected by default.
- From Date shall default to the first day of the current month.
- To Date shall default to the current date.
- The system shall automatically calculate and display all KPI metrics using the default filter.

Example:

If Current Date = 19/06/2026

Then:

- From Date = 01/06/2026
- To Date = 19/06/2026

Header

### AC2. MTD Filter

Given the KPI Performance popup is opened

When the user clicks the MTD button

Then:

- From Date = First day of the current month.
- To Date = Current Date.
- The system shall recalculate and refresh all KPI metrics.

Example:

If Current Date = 19/06/2026

Then:

- From Date = 01/06/2026
- To Date = 19/06/2026

### AC3. Custom Date Filter

Given the KPI Performance popup is opened

When the user manually changes From Date and/or To Date

Then:

- The MTD button shall be unselected.
- The system shall immediately recalculate and refresh all KPI metrics.

Validation:

- From Date cannot be greater than To Date.
- From Date > Current Date
- To Date > Current Date

If From Date > To Date:

- The system shall display the validation message:
    - EN: From Date cannot be later than To Date.
    - ES: La fecha inicial seleccionada tiene que ser antes de la fecha final
- KPI values shall not be refreshed.

If To Date/From Date > Current Date

- The system shall display the validation message:
    - EN: Future dates are not allowed
    - ES: Elija una fecha antes de hoy

### AC4. KPI Filter Logic

The system shall calculate KPI metrics for the logged-in user only.

Each KPI shall use the selected date range and the corresponding date source below:

|  |  |
| --- | --- |
| **KPI** | **Date Source** |
| Total Lead Calls / Day | Lead Modified Date |
| AR_QA | Lead Created Date |
| AOV | SO Created Date |
| DO / DR% | SO Created Date |
| Revenue Validated | SO Created Date |
| Revenue Delivered | SO Created Date |

When the user changes the filter period, the system shall refresh all KPI cards simultaneously using their respective date source.

The system shall not use a single date source for all KPI metrics.

### AC5. KPI Calculation

The system shall calculate and display the following KPI metrics:

| **KPI** | **Formula** | **Display Format** | **Date Source** | **KPI (ES)** |
| --- | --- | --- | --- | --- |
| Total Lead Calls | Total lead session (update lead) | Integer | Lead Modified Date | Total de Llamadas |
| AR_QA | (Total AR QA Leads ÷ Total Leads) × 100 | Percentage (%) | Lead Created Date | Tasa de Aprobación |
| AOV | Total Validated SO Amount ÷ Total Validated SO | Currency (S/) | SO Created Date | Cheque Promedio |
| DO | Total DO which link with SO validated (SO status = validated) | Integer | SO Created Date | Ordenes Validadas |
| DR% | Total Delivered Orders ÷ Total Validated SO × 100 | Percentage (%) | SO Created Date | Tasa de Entrega |
| Revenue Validated | Validated lead * AOV validated | Currency (Peru: S/, Colom: $) | SO Created Date | Rendimiento de Validadas |
| Revenue Delivered | Number of Delivered oders * AOV delivered | Currency (Peru: S/, Colom: $) | SO Created Date | Rendimiento de Entregadas |

### AC6. Zero Value Handling

If any denominator in a KPI formula equals 0, the system shall display 0 for the corresponding KPI value.

Examples:

|  |  |
| --- | --- |
| Condition | Result |
| Total Leads = 0 | AR_QA = 0% |
| Total Validated SO = 0 | AOV = 0 ; DR% = 0% |
| AR_QA denominator = 0 | AR_QA = 0% |
| DR denominator = 0 | DR% = 0% |
| Revenue Validated formula returns invalid value | Revenue Validated = S/0 |
| Revenue Delivered formula returns invalid value | Revenue Delivered = S/0 |

### AC12. Realtime Tab — Date Selection Restricted to Open Period *(new)*

Given a Sales Agent (LATAM) is viewing the Realtime tab on the KPI Performance dashboard/popup,

When the agent interacts with the date picker (From Date / To Date),

Then the system shall only allow selecting dates within the current open/un-baselined period (i.e., dates after the latest Finance cut-off up to the current date),

And dates belonging to previously frozen/cut-off periods shall be disabled (grayed out) and unselectable in the date picker.

All other existing behaviors on the Realtime tab — including metric formulas (AC5), currency formatting, zero-value handling (AC6), and agent-only data scoping (AC4) — remain unchanged.

## 3.2 Performance Tab *(new)*

*Applies to LATAM only. Applies only to the DO and DR% KPIs defined in AC5. No other KPI (Total Lead Calls, AR_QA, AOV, Revenue Validated, Revenue Delivered) and no other GEO is affected by the freeze behavior — their date sources and live-recalculation behavior remain exactly as defined in AC4–AC5.*

### AC7. Snapshot Captured at Finance Cut-off

Given Finance's own cut-off job runs for a period,

When the job completes,

Then the system shall capture and store a snapshot of that period's DO and DR% values, calculated per the existing formulas and date source in AC5, as the frozen value for that period.

*The exact trigger/integration mechanism for "Finance's own cut-off job" is not defined in source. Per the requester's decision, this is not being pursued further at this time (see **Deferred Items**).*

### AC8. Frozen DO/DR% Displayed Permanently for a Cut-off Period

Given a period whose cut-off snapshot has been captured (per AC7),

When a Sales Agent (LATAM) views the KPI Performance dashboard for that period, at any time afterward — including after a later Finance correction to underlying SO/delivery data,

Then the system shall display the stored snapshot values for DO and DR%, and these values shall not be recalculated or reopened again.

### AC9. Live DO/DR% for the Current Open Period

Given the current, in-progress period for which Finance's cut-off job has not yet run,

When a Sales Agent (LATAM) views the KPI Performance dashboard,

Then DO and DR% shall continue to recalculate live against current data, consistent with AC4–AC5, unchanged from current behavior.

### AC10. Custom Date Range Spanning the Cut-off Boundary

Given a Sales Agent (LATAM) selects, via the Performance tab's own date filter (AC13), a range that spans both an already-frozen period and the current open period,

When the KPI Performance dashboard displays DO and DR% for that range,

Then the frozen portion of the range shall use the stored snapshot values (per AC7–AC8), and the open portion shall use live-calculated values (per AC9).

### AC11. Scope Boundary Confirmation

Given the DO/DR% freeze behavior (AC7–AC10) is implemented for LATAM,

When a Sales Agent views the KPI Performance dashboard,

Then Total Lead Calls, AR_QA, AOV, Revenue Validated, and Revenue Delivered shall continue to use their existing date sources and live-recalculation behavior exactly as defined in AC4–AC5, and no other GEO's DO/DR% behavior shall be affected.

### AC13. Performance Tab — Independent Date Filter

Given a Sales Agent (LATAM) is viewing the Performance tab,

When the agent selects a date/period to view,

Then the Performance tab shall use its own date filter, independent of and distinct from the Realtime tab's date picker (AC1–AC3, AC12) — a change to one tab's date selection shall not affect the other tab.

Unlike the Realtime tab, the Performance tab's date filter shall allow selection of a range that includes previously frozen/cut-off periods, so that the frozen-vs-open split in AC10 can occur.

*The exact UI control for this filter (e.g., a Month selector as referenced in CR TM-9010, versus a From Date/To Date range picker matching AC1) is not defined in source — see **Open Questions**, OQ-1.*

---

## Deferred Items

- The exact mechanism/timing of "Finance's own cut-off job" (AC7) — not corroborated by a Finance-owned source; requester elected to skip further verification of this item for now. Downstream teams should confirm the trigger/integration point before build.

## Open Questions

- **OQ-1:** What is the exact UI control for the Performance tab's date filter (AC13) — e.g., a Month selector (as referenced in CR TM-9010's AC-04 wording "selects a Month") versus a From Date/To Date range picker matching the Realtime tab's AC1 pattern?

## Sources and Traceability

| Requirement | Source |
| --- | --- |
| AC1–AC6 | Approved baseline, Confluence page 1367310337 (content unchanged; now scoped to §3.1 Realtime Tab) |
| Business Context addendum, confirmed structural change, User Story addendum | CR TM-9010; tab-structure confirmed by BA/requester on 2026-09-18 |
| AC7–AC11 | CR TM-9010, Expected Behavior items 1–7 and Acceptance Criteria AC-01 to AC-05 |
| AC12 | CR TM-9010, Acceptance Criteria AC-RT-01, AC-RT-02 |
| AC13 | CR TM-9010, Acceptance Criteria AC-04 wording; independence of the two tabs' date pickers confirmed by BA/requester on 2026-09-18 |
| Deferred Items, Open Questions | Current-State Analysis, `outputs/current-state/TMS/CS-TMS-DO-DR-Freeze-at-Finance-Cutoff.md`, as narrowed by requester decisions on 2026-09-18 |
Writ