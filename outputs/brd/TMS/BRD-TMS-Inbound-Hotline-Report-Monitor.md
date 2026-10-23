# Business Requirement Document – Inbound Hotline Report & Monitor

| Item | Detail |
|---|---|
| **System** | TMS |
| **Platform** | UWS (Unified Workspace), built with Superset |
| **Feature** | Inbound Hotline Report & Monitor |
| **Mockup** | Figma – [UW – Inbound Hotline Report & Monitor (Mockup)](https://www.figma.com/design/RvE4KLHy7F5itVZaINTRGe), page **Superset template** |
| **Related** | [TM-9195](https://accelo-tech.atlassian.net/browse/TM-9195) Blending Mode · [TM-9005](https://accelo-tech.atlassian.net/browse/TM-9005) Inbound Hotline Call Capture |
| **Status** | Draft |
| **Date** | 2026-10-19 (v0.3) |

## 1. Background

The hotline inbound feature is live in TMS. A customer calls a hotline, TMS creates or updates a lead, and the call is routed to an agent. Agents in Blending mode handle both inbound calls and outbound leads, with inbound first.

Team Leaders and Operations Managers have no single view of how the hotline performs: call volume, answered and missed calls, customer wait time, peak hours, callback speed for missed calls, which agents receive calls, and the closing rate per agent and per hotline.

## 2. Objective

- Show hotline call volume, outcomes and customer wait time, including peak hours.
- Show how fast unanswered calls are called back.
- Show which agents receive inbound calls and which do not, over a period and in real time.
- Show the order closing rate per agent and per hotline.

## 3. GEO Apply

**IN** (first release).

## 4. Scope

### 4.1 In Scope

- One dashboard on UWS with four tabs: **Real-time Monitor**, **Operation**, **Agent**, **Performance**.
- A collapsible native filter bar on the left (not on the Real-time Monitor tab).
- Access for Manager and Team Leader (Supervisor) (§6.6).
- Inbound hotline calls and inbound hotline leads only.

### 4.2 Out of Scope

- Changes to inbound call routing, lead creation, lead status or agent status logic (covered by TM-9005 and TM-9195).
- Export (CSV / Excel).
- Conditional formatting (colour highlights on values).

## 5. Current Behavior

- TMS captures inbound hotline calls, creates or updates the lead, and routes the call to an agent (TM-9005, TM-9195).
- **Duplicate lead rule:** a call from the same phone number within 12 hours of its last call does not create a new lead. After more than 12 hours, a new lead is created (TM-9195, §8).
- **Unanswered call results** (TM-9195, §7):
  - **Missed call** (rings, agent does not answer): lead **Urgent**, goes to the Team Leader pool.
  - **Abandoned call** (customer hangs up): lead **Urgent** and assigned to the agent who last declined the call, if any agent declined. Otherwise lead **New**, no assignee, and the Team Leader assigns it.
- **Decline** routes the call to the next available agent (MoM 2026-10-13).
- **Approved Rate:** AR % = Approved leads / Total leads (Data Glossary CMDC).
- CDR playback exists for inbound hotline calls (TM-9131).
- An existing inbound hotline report or monitor was not found in the sources reviewed. Its absence is not verified.
- Which PBX call events and timestamps TMS stores for inbound calls (queue entry, ringing, accept, decline, ring timeout, hang-up) is **not verified from available sources**.

## 6. Expected Behavior

### 6.1 Dashboard Layout

The report is built on **UWS (Unified Workspace)** with **Superset**, following the Superset dashboard template shown in the mockup:

1. **Header:** dashboard title "Inbound Hotline – Report & Monitor" and four tabs in this order: **Real-time Monitor** (first tab), Operation, Agent, Performance.
2. **Native filter bar** on the left, on the Operation, Agent and Performance tabs. The Real-time Monitor tab has **no filter bar**:
   - **Expanded:** title "Filters", the filter fields, and **Apply filters** / **Clear all** buttons.
   - **Collapsed:** a narrow strip with an expand icon and a filter icon. The dashboard content uses the freed width.
   - The user can switch between Expanded and Collapsed at any time.
3. **Filter fields and default values:**

| Filter | Default |
|---|---|
| Time range | Today |
| Hotline | All |
| Team | All |
| Agent | All |

**Mockup – Filter bar Collapsed** (Expanded state: see 6.2 – 6.4): [Figma](https://www.figma.com/design/RvE4KLHy7F5itVZaINTRGe?node-id=9-462)

### 6.2 Tab "Operation"

| Section | Chart type | Content |
|---|---|---|
| Summary | Big Number × 8 | Total inbound calls · Answered calls · Missed calls · Abandoned calls · Unanswered rate · Avg. wait time · Max. wait time · Peak hour |
| Peak time | Bar Chart | Inbound calls by hour: Total inbound calls and Calls waited in queue |
| Peak time | Table | Peak time detail per hour: Total calls, Calls waited, Max waiting, Answered, Missed, Abandoned, Avg. wait |
| Missed call callback | Big Number × 4 | Unanswered calls · Called back (with callback rate) · Not called back yet · Avg. time to callback |
| Missed call callback | Table | Per unanswered call: Call time, Phone, Hotline, Outcome, Lead ID, Lead status, Assignee, First callback, Callback (min) |

**Mockup – Tab Operation:** [Figma](https://www.figma.com/design/RvE4KLHy7F5itVZaINTRGe?node-id=6-145)

### 6.3 Tab "Agent"

| Section | Chart type | Content |
|---|---|---|
| Summary | Big Number × 4 | Agents in Blending · Agents with inbound call · Agents with no inbound call · Avg. answered per agent |
| Agent report | Table | Per agent: Agent, Team, Inbound calls routed, Answered, Declined, Missed, Avg. talk time, Has inbound call (Yes / No) |

**Mockup – Tab Agent:** [Figma](https://www.figma.com/design/RvE4KLHy7F5itVZaINTRGe?node-id=6-576)

### 6.4 Tab "Performance"

| Section | Chart type | Content |
|---|---|---|
| Summary | Big Number × 3 | Inbound leads · Approved · AR % |
| Charts | Bar Chart × 2 | AR % by hotline · AR % by agent (sorted descending) |
| Closing rate by agent | Table | Agent, Team, Inbound leads, Approved, AR % |
| Closing rate by hotline | Table | Hotline number, Product / Offer, Total inbound calls, Inbound leads, Approved, AR % |

**Mockup – Tab Performance:** [Figma](https://www.figma.com/design/RvE4KLHy7F5itVZaINTRGe?node-id=6-871)

### 6.5 Tab "Real-time Monitor"

| Section | Chart type | Content |
|---|---|---|
| Today | Big Number × 6 | Total inbound calls today · Answered · Missed · Abandoned · Calls waiting now · Longest current wait |
| Real-time agent monitor | Table | Per agent logged in to TMS in Blending mode: Agent, Team, Current TMS status, Current activity, Time in activity, Answered today, Last inbound call |
| Agents by current activity | Pie Chart | Count of agents per Current activity |

- The tab updates in **real time**.
- No filter bar is shown on this tab.

**Mockup – Tab Real-time Monitor:** [Figma](https://www.figma.com/design/RvE4KLHy7F5itVZaINTRGe?node-id=6-1186)

### 6.6 Access

| Role | Data visible |
|---|---|
| Manager | All teams |
| Team Leader (Supervisor) | Own team only |

## 7. User Story

- As a **Team Leader / Operations Manager**,
  I want to see inbound call volume, answered and missed calls, customer wait time, peak hours and callback time for unanswered calls,
  so that I can plan staffing and make sure no hotline customer is left without a callback.
- As a **Team Leader / Operations Manager**,
  I want to see which agents receive inbound calls and which do not, over a period and in real time,
  so that I can balance the inbound workload.
- As a **Team Leader / Operations Manager**,
  I want to see the order closing rate per agent and per hotline,
  so that I can evaluate agent and hotline performance.

## 8. Business Rules

| Rule ID | Business Rule | Source |
|---|---|---|
| BR-01 | Each inbound call has exactly one final outcome: **Answered** (an agent accepted the call), **Missed** (the call rang, no agent accepted it, and it ended by ring timeout) or **Abandoned** (the customer hung up before any agent accepted). | TM-9195 §7; Mockup S1 |
| BR-02 | **Decline** is not a final outcome. A declined call continues to the next available agent. Each decline is counted for the agent who declined. | MoM 2026-10-13; TM-9195 §7; Mockup S2 |
| BR-03 | Calls and leads are counted separately. Under the 12-hour duplicate rule, one lead can have several calls. | TM-9195 §8 |
| BR-04 | **Unanswered calls** = Missed calls + Abandoned calls. | Mockup S1 |
| BR-05 | **Wait time** is measured from the time the call reaches the hotline to the time an agent accepts it, for Answered calls only. | Mockup S1; User decision 2026-10-19 |
| BR-06 | **Time to callback** is measured from the end of the unanswered call to the first outbound call attempt on the same lead. | Mockup S1 |
| BR-07 | **Closing rate** uses **AR % only**, with the same formula as the AR metric in the existing UWS reports: AR % = Approved leads / Total leads. Only inbound hotline leads are counted, by **lead created date**. | Data Glossary CMDC; UWS Supervisor Workspace Dashboard; User decisions 2026-10-15, 2026-10-19 |
| BR-08 | The Agent tab lists every agent who logged in to TMS in Blending mode during the period, including agents with 0 inbound calls. **Has inbound call** = Yes when Inbound calls routed > 0, otherwise No. | User request; Mockup S2 |
| BR-09 | The Real-time Monitor lists agents currently logged in to TMS in Blending mode. **Current activity** is one of: On inbound call, On outbound call, Outbound lead in Preview, Idle, Not available. | Mockup S4; TM-9195 §2 |
| BR-10 | Each hotline is mapped to one Product / Offer (1 Offer – 1 Sub – 1 Phone Number). | TM-9005 |
| BR-11 | A **Manager** sees data for all teams. A **Team Leader (Supervisor)** sees data for their own team only. | User decision 2026-10-15 |

## 9. Functional Requirements

### 9.1 Metrics

| FR ID | Metric | Definition | Formula | Data Scope | Data Period | Source |
|---|---|---|---|---|---|---|
| FR-01 | Total inbound calls | Inbound calls that reached the hotline(s) | Count of calls | Hotline calls | Selected time range | User request; Mockup S1 |
| FR-02 | Answered calls | Calls with outcome Answered | Count | Hotline calls | Selected time range | User request; BR-01 |
| FR-03 | Answer rate | Share of calls answered | Answered calls / Total inbound calls × 100 | Hotline calls | Selected time range | Mockup S1 |
| FR-04 | Missed calls | Calls with outcome Missed | Count | Hotline calls | Selected time range | User request; BR-01 |
| FR-05 | Abandoned calls | Calls with outcome Abandoned | Count | Hotline calls | Selected time range | BR-01; Mockup S1 |
| FR-06 | Unanswered rate | Share of calls not answered | (Missed + Abandoned) / Total inbound calls × 100 | Hotline calls | Selected time range | Mockup S1 |
| FR-07 | Avg. / Max. wait time | Average and longest wait time per BR-05 | Average / Maximum of (accept time − hotline arrival time) | Answered calls | Selected time range | User request; Mockup S1 |
| FR-08 | Peak hour | Hour with the highest Total inbound calls, shown with its call count and calls waited | Not defined in source (tie handling) | Hotline calls | Selected time range, by hour | User request; Mockup S1 |
| FR-09 | Calls waited in queue | Calls that found no agent available when they arrived and waited in the queue | Count, by hour | Hotline calls | Selected time range | User request; Mockup S1 |
| FR-10 | Max waiting | Highest number of calls waiting in the queue at the same time in the hour | Maximum concurrent count, by hour | Hotline calls | Selected time range | User request; Mockup S1 |
| FR-11 | Called back / Not called back yet | Unanswered calls whose lead has / has no outbound attempt after the call ended | Count | Unanswered calls | Selected time range | User request; Mockup S1 |
| FR-12 | Callback rate | Share of unanswered calls called back | Called back / Unanswered calls × 100 | Unanswered calls | Selected time range | Mockup S1 |
| FR-13 | Avg. time to callback | Average of time to callback per BR-06 | Average of (first outbound attempt time − unanswered call end time) | Called-back calls | Selected time range | User request; Mockup S1 |
| FR-14 | Inbound calls routed / Answered / Declined / Missed (per agent) | Calls that rang at the agent / were accepted / were declined / ended by ring timeout at the agent | Count per agent | Hotline calls | Selected time range | User request; Mockup S2 |
| FR-15 | Avg. talk time (per agent) | Average talk time of calls the agent answered | Average talk time | Answered calls | Selected time range | Mockup S2 |
| FR-16 | Agents in Blending / with inbound call / with no inbound call | Count of agents per BR-08 | Count | Agents in Blending mode | Selected time range | User request; Mockup S2 |
| FR-17 | Avg. answered per agent | Average answered calls per agent with calls | Not defined in source | Agents with inbound call | Selected time range | Mockup S2 |
| FR-18 | Inbound leads / Approved / AR % | Per BR-07, per agent and per hotline | AR % = Approved / Inbound leads × 100 (same as the UWS AR metric) | Inbound hotline leads | Leads created in the selected time range | User request; Data Glossary CMDC; Mockup S3; User decision 2026-10-19 |
| FR-19 | Calls waiting now / Longest current wait | Calls in the queue now, and the longest wait among them | Count / Maximum of (now − hotline arrival time) | Calls in queue | Real time | Mockup S4 |
| FR-20 | Time in activity / Answered today / Last inbound call (per agent) | Time since the current activity started / answered calls since 00:00 / time of the last answered inbound call | Not defined in source (beyond definition) | Logged-in Blending agents | Today, real time | Mockup S4 |

### 9.2 Dashboard Functions

| FR ID | Requirement | Business Rule Ref | Source |
|---|---|---|---|
| FR-21 | The dashboard shall show the four tabs, with Real-time Monitor first, and the charts listed in §6.2–§6.5. | BR-01 – BR-10 | Mockup S1–S4 |
| FR-22 | The filter bar shall support Expanded and Collapsed states. Collapsing shall widen the dashboard content. The filter bar shall not be shown on the Real-time Monitor tab. | – | Mockup (filter bar collapsed); User request 2026-10-15 |
| FR-23 | The unanswered calls table shall list each Missed or Abandoned call with the columns in §6.2. | BR-04, BR-06 | Mockup S1 |
| FR-24 | The Agent table shall support filtering by Has inbound call = No to list agents without inbound calls. | BR-08 | Mockup S2 |
| FR-25 | The Real-time Monitor tab shall update in real time. | BR-09 | Mockup S4; User decision 2026-10-15 |
| FR-26 | The dashboard shall limit data by role: Manager – all teams; Team Leader (Supervisor) – own team only. | BR-11 | User decision 2026-10-15 |

## 10. Data Mapping

| Source Data | Used For | Notes |
|---|---|---|
| PBX call events – hotline arrival, queue entry, ringing at agent, accept, decline, ring timeout, customer hang-up, call end | Call outcomes, wait time, calls waited, max waiting, routed/declined/missed per agent, real-time queue | Availability **not verified** from available sources |
| CDR – talk time, outbound call attempts on a lead | Avg. talk time, time to callback | Inbound CDR exists (TM-9131) |
| TMS lead – Lead ID, lead status, assignee, hotline, Product / Offer, phone number (masked) | AR %, callback table, closing rate by hotline | Phone masking follows the current TMS rule (TM-9005) |
| TMS agent – mode, current status, team | Agent tab, Real-time Monitor | Status sync per TM-9195 |

## 11. Acceptance Criteria

**AC1 – Call outcomes and counting**
Given inbound calls in the selected time range,
When the dashboard calculates call metrics,
Then each call shall be counted once with one outcome (Answered, Missed or Abandoned),
And declines shall be counted only for the agent who declined,
And call counts and lead counts shall be calculated separately.

**AC2 – Operation summary and peak time**
Given the Operation tab is open,
When a time range is applied (default: Today, all hotlines, all teams, all agents),
Then the Big Numbers shall show FR-01 to FR-08 per their formulas,
And the Bar Chart and the peak time table shall show calls per hour with Calls waited and Max waiting,
And wait time shall cover Answered calls only, from hotline arrival to agent accept.

**AC3 – Missed call callback**
Given Missed or Abandoned calls exist in the time range,
When the Operation tab is shown,
Then it shall show Unanswered calls, Called back with callback rate, Not called back yet and Avg. time to callback,
And the table shall list each unanswered call with its first callback time and time to callback, or "—" when not called back.

**AC4 – Agents with and without inbound calls**
Given agents logged in to TMS in Blending mode during the time range,
When the Agent tab is shown,
Then every such agent shall appear, including agents with 0 inbound calls,
And each row shall show Inbound calls routed, Answered, Declined, Missed, Avg. talk time and Has inbound call,
And filtering Has inbound call = No shall list only agents with no inbound call.

**AC5 – Closing rate**
Given inbound hotline leads created in the time range,
When the Performance tab is shown,
Then AR % shall equal Approved / Inbound leads × 100,
And it shall be shown per agent and per hotline, with each hotline's Product / Offer.

**AC6 – Real-time Monitor**
Given agents are logged in to TMS in Blending mode,
When the Real-time Monitor tab is open,
Then it shall show today's Big Numbers including Calls waiting now and Longest current wait,
And each agent's Current TMS status and Current activity (one of the five values in BR-09),
And the tab shall update in real time and show no filter bar.

**AC7 – Filter bar**
Given the Operation, Agent or Performance tab is open,
When the user collapses the filter bar,
Then it shall shrink to a narrow strip with an expand icon and a filter icon, and the dashboard content shall widen,
And expanding it shall restore the filter fields and the Apply filters / Clear all buttons.

**AC8 – Access by role**
Given a user opens the dashboard,
When the user is a Manager,
Then data for all teams shall be shown,
And when the user is a Team Leader (Supervisor), only data for their own team shall be shown.

## 12. Open Questions

| # | Question |
|---|---|
| 1 | **Closing rate attribution:** credit the lead to the agent who answered the call or to the current assignee? |
| 2 | **Time to callback:** count outbound attempts by agents only, or any outbound attempt (including auto dialer)? |
| 3 | **Peak hour tie:** which hour is shown when two hours have the same call count? **Avg. answered per agent:** confirm the formula. |
| 4 | **Real time:** what update delay is acceptable for the Real-time Monitor? Superset dashboards refresh on an interval. |

**Resolved (2026-10-15):** GEO = IN first · Platform = UWS with Superset · GEO filter removed, no filter on Real-time Monitor, Real-time Monitor is the first tab · Access: Manager all teams, Team Leader (Supervisor) own team · Leads counted by lead created date · Real-time Monitor updates in real time · Conditional formatting not in this BRD · Export not required.

**Resolved (2026-10-19):** Filter defaults = Today, all hotlines, all teams, all agents · AR % only, same formula as the UWS AR metric · Wait time starts when the call reaches the hotline · PBX data availability question removed.

## 13. Sources and Traceability

| Requirement | Business Rule | Functional Requirement | Acceptance Criteria | Source |
|---|---|---|---|---|
| Call outcomes and counting | BR-01, BR-02, BR-03, BR-04 | FR-02, FR-04, FR-05, FR-14 | AC1 | TM-9195; MoM 2026-10-13; Mockup S1–S2 |
| Call volume, answered, missed, wait time, peak time | BR-01, BR-05 | FR-01 – FR-10, FR-21 | AC2 | User request 2026-10-15; Mockup S1 |
| Missed call callback | BR-04, BR-06 | FR-11 – FR-13, FR-23 | AC3 | User request 2026-10-15; Mockup S1 |
| Agents with / without calls | BR-08 | FR-14 – FR-17, FR-24 | AC4 | User request 2026-10-15; Mockup S2 |
| Closing rate per agent / hotline | BR-07, BR-10 | FR-18 | AC5 | User request 2026-10-15; Data Glossary CMDC; TM-9005; Mockup S3 |
| Real-time monitor | BR-09 | FR-19, FR-20, FR-25 | AC6 | Mockup S4; TM-9195 |
| Collapsible filter bar | – | FR-22 | AC7 | Mockup; User request 2026-10-15 |
| Access by role | BR-11 | FR-26 | AC8 | User decision 2026-10-15 |

**Source list**

| Source | Type |
|---|---|
| User request 2026-10-15 – report items (Operation view, Performance view, agents with / without calls) | Stakeholder request |
| User decisions on Open Questions, 2026-10-15 and 2026-10-19 | Stakeholder decision |
| Figma mockup, page "Superset template" – S1 Operation, S2 Agent, S3 Performance, S4 Real-time Monitor, filter bar Expanded / Collapsed | Mockup reviewed by requester |
| Confluence page 1449099265 – [IN][Hotline] Blending Mode (TM-9195), version 6 | Requirement document |
| [TM-9005](https://accelo-tech.atlassian.net/browse/TM-9005) – Inbound Hotline Call Capture (Done) | Approved ticket |
| MoM – Training Inbound Hotline Call, 2026-10-13 | Meeting minutes |
| Confluence – Data Glossary CMDC (AR %, e-AR %) | System documentation |
| Confluence – User Guide: Supervisor Workspace Dashboard (AR metric in UWS reports) | System documentation |
| [TM-9131](https://accelo-tech.atlassian.net/browse/TM-9131) – CDR Playback for Inbound Hotline Calls | Historical ticket (title only) |

## 14. Version History

| Version | Date | Change | Author |
|---|---|---|---|
| 0.1 | 2026-10-15 | Initial draft | Man Luu Gia |
| 0.2 | 2026-10-15 | Applied Open Question decisions: GEO IN, UWS with Superset, Real-time Monitor first without filter bar, GEO filter removed, access by role, lead created date, real-time update, conditional formatting and export out of scope | Man Luu Gia |
| 0.3 | 2026-10-19 | Filter defaults; AR % only with the UWS AR formula; wait time start confirmed; Open Questions updated | Man Luu Gia |
