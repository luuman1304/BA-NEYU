# [Hotline] Inbound Call Report & Monitor on TMS – Operation and Performance views

> Local draft – not yet created in Jira. Prepared: 2026-10-15.
> Related: [TM-9195](https://accelo-tech.atlassian.net/browse/TM-9195) (Blending Mode), [TM-9005](https://accelo-tech.atlassian.net/browse/TM-9005) (Inbound Hotline Call Capture), Confluence: [TMS] Blending Mode page 1449099265.

---

### Applied GEO

**To confirm** – the hotline inbound feature exists for **IN** (TM-9195) and **TH 4** (TM-9005).

### Business Context / Purpose

The hotline inbound feature is live in TMS: customers call a hotline, TMS creates or updates a lead, and the call is routed to an agent. Team Leaders and Operations Managers need to track how the hotline performs:

* **Operation:** how many calls come in, how many are answered or missed, how long customers wait, when the peak hours are, and how fast missed calls are called back.
* **Agents:** which agents receive inbound calls and which do not.
* **Performance:** the order closing rate for each agent and each hotline.

### Current Behavior

* TMS captures inbound hotline calls, creates or updates the lead, and routes the call to an agent (TM-9005, TM-9195).
* Lead status values used in TMS reports include **Approved, Rejected, Callback, Uncalled, Trash, Urgent, New** (Data Glossary CMDC).
* CDR playback exists for inbound hotline calls (TM-9131).
* An existing inbound hotline report or monitor in TMS **was not found in the sources reviewed**. Its absence is not verified.
* Which call events and timestamps the PBX connector stores for inbound calls (queue entry, ringing, answer, decline, hang-up) is **not verified from available sources**.

### Expected Behavior

#### 1. Call Outcome Definitions

Each inbound call has exactly one final outcome. A **call** is counted separately from a **lead**: under the 12-hour duplicate rule, one lead can have several calls.

| Outcome | Definition | Lead result (TM-9195) |
|---|---|---|
| **Answered** | An agent accepted the call | Agent handles the lead |
| **Missed** | The call rang at an agent, no agent accepted it, and the call ended by ring timeout | Lead **Urgent** → Team Leader pool |
| **Abandoned** | The customer hung up before any agent accepted the call (while waiting in the queue or while ringing) | At least one decline → **Urgent**, assigned to the agent who last declined. No decline → **New**, no assignee |

* **Decline** is not a final outcome. A declined call is routed to the next available agent and ends as Answered, Missed or Abandoned. Declines are counted per agent.
* **Unanswered calls** = Missed + Abandoned.

#### 2. Operation View

##### 2.1 Summary

| Metric | Definition / Formula |
|---|---|
| Total inbound calls | Count of inbound calls to the hotline(s) in the selected period |
| Answered calls | Count of calls with outcome **Answered** |
| Answer rate % | Answered calls / Total inbound calls × 100 |
| Missed calls | Count of calls with outcome **Missed** |
| Abandoned calls | Count of calls with outcome **Abandoned** |
| Unanswered rate % | (Missed + Abandoned) / Total inbound calls × 100 |
| Avg. wait time (to answer) | Average of (time the agent accepted the call − time the call reached the hotline), Answered calls only |
| Max. wait time (to answer) | Longest of the same duration, Answered calls only |

##### 2.2 Peak Time (by hour)

One row per hour of the day (00:00–23:59, in the GEO's local time):

| Column | Definition |
|---|---|
| Hour | Hour bucket, e.g. 09:00–09:59 |
| Total inbound calls | Calls that reached the hotline in this hour |
| Calls waited in queue | Calls that found no agent available when they arrived and waited in the queue (heard the "all agents are busy" message) |
| Max. concurrent waiting calls | Highest number of calls waiting in the queue at the same time during this hour |
| Answered / Missed / Abandoned | Count of each outcome for calls that arrived in this hour |
| Avg. wait time | As in §2.1, for calls that arrived in this hour |

* The **peak hour** is the hour with the highest Total inbound calls. It must be highlighted.

##### 2.3 Missed Call Callback

For every unanswered call (Missed or Abandoned), measure how long it takes until the lead is called back.

| Metric | Definition / Formula |
|---|---|
| Unanswered calls | Missed + Abandoned calls in the period |
| Called back | Unanswered calls whose lead has at least one outbound call attempt after the unanswered call ended |
| Not called back yet | Unanswered calls − Called back |
| Callback rate % | Called back / Unanswered calls × 100 |
| Avg. time to callback | Average of (time of the first outbound call attempt on the lead − time the unanswered call ended) |
| Max. time to callback | Longest of the same duration |

* A drill-down list shows each unanswered call: Call time, Phone number (masked per current TMS rule), Hotline, Outcome, Lead ID, Lead status, Assignee, First callback time, Time to callback.

#### 3. Agent View – Which agents have calls

##### 3.1 Agent Report (selected period)

One row per agent who logged in to TMS in **Blending** mode during the period, **including agents with no inbound calls**.

| Column | Definition |
|---|---|
| Agent / Team | Agent name and team |
| Inbound calls routed | Calls routed (rang) to this agent |
| Answered | Calls this agent accepted |
| Declined | Calls this agent declined |
| Missed | Calls that rang at this agent and ended by ring timeout without being accepted |
| Avg. talk time | Average talk time of the calls this agent answered |
| Has inbound call | **Yes** if Inbound calls routed > 0, otherwise **No** |

* A quick filter **"Agents with no inbound call"** shows only rows where Has inbound call = No.

##### 3.2 Real-time Agent Monitor (today)

One row per agent currently logged in to TMS in Blending mode:

| Column | Definition |
|---|---|
| Agent / Team | Agent name and team |
| Current TMS status | Available / Assigned / Requested to Break, Busy or Unavailable / Break / Busy / Unavailable |
| Current activity | **On inbound call** / **On outbound call** / **Outbound lead in Preview** / **Idle** (Available, no lead) / **Not available** (Break, Busy, Unavailable) |
| Time in current activity | Duration since the current activity started |
| Inbound calls answered today | Count since 00:00 today |
| Last inbound call | Time of the last inbound call the agent answered today |

* Today's summary cards are shown above the table: Total inbound calls, Answered, Missed, Abandoned, **Calls waiting now**, **Longest current wait**.
* The monitor refreshes automatically.

#### 4. Performance View – Order Closing Rate

"Closing rate" uses the existing **AR %** definition: AR % = Approved leads / Total leads (Data Glossary CMDC). Only **inbound hotline leads** are counted.

##### 4.1 By Agent

| Column | Definition |
|---|---|
| Agent / Team | Agent name and team |
| Inbound leads | Inbound hotline leads handled by the agent in the period |
| Approved | Inbound leads with status **Approved** |
| AR % | Approved / Inbound leads × 100 |

##### 4.2 By Hotline

| Column | Definition |
|---|---|
| Hotline number | The hotline number the customer called |
| Product / Offer | Product or offer mapped to the hotline (1 Offer – 1 Sub – 1 Phone Number, TM-9005) |
| Total inbound calls | Calls to this hotline |
| Inbound leads | Leads created or updated from calls to this hotline |
| Approved | Leads with status **Approved** |
| AR % | Approved / Inbound leads × 100 |

## User Story

* **As a Team Leader / Operations Manager**, _I want_ to see inbound call volume, answer and missed rates, wait times, peak hours and callback time for missed calls, _So that_ I can plan staffing and make sure no hotline customer is left without a callback.
* **As a Team Leader / Operations Manager**, _I want_ to see which agents receive inbound calls and which do not, in real time and over a period, _So that_ I can balance inbound workload across agents.
* **As a Team Leader / Operations Manager**, _I want_ to see the order closing rate per agent and per hotline, _So that_ I can evaluate agent and hotline performance.

## Acceptance Criteria

#### **AC 1: Call Outcomes**

1. Each inbound call must be counted once, with exactly one outcome: **Answered**, **Missed** or **Abandoned**, as defined in Expected Behavior §1.
2. A declined call must not be counted as a final outcome. The decline must be counted for the agent who declined.
3. Call counts and lead counts must be calculated separately (one lead can have several calls under the 12-hour duplicate rule).

#### **AC 2: Operation Summary**

1. The report must show Total inbound calls, Answered calls, Answer rate %, Missed calls, Abandoned calls and Unanswered rate %, using the formulas in §2.1.
2. Avg. and Max. wait time must be calculated from the time the call reached the hotline to the time the agent accepted it, for Answered calls only.

#### **AC 3: Peak Time**

1. The report must show one row per hour with Total inbound calls, Calls waited in queue, Max. concurrent waiting calls, outcome counts and Avg. wait time (§2.2).
2. The hour with the highest Total inbound calls must be highlighted as the peak hour.

#### **AC 4: Missed Call Callback**

1. For each Missed or Abandoned call, the report must calculate the time from the end of the call to the first outbound call attempt on the same lead.
2. The report must show Unanswered calls, Called back, Not called back yet, Callback rate %, Avg. and Max. time to callback (§2.3).
3. Users must be able to drill down to the list of unanswered calls with the columns in §2.3.

#### **AC 5: Agent Report**

1. The report must list every agent who logged in to TMS in Blending mode during the period, including agents with 0 inbound calls.
2. Each row must show Inbound calls routed, Answered, Declined, Missed, Avg. talk time and Has inbound call (§3.1).
3. The quick filter "Agents with no inbound call" must show only agents with Inbound calls routed = 0.

#### **AC 6: Real-time Agent Monitor**

1. The monitor must list every agent currently logged in to TMS in Blending mode, with Current TMS status, Current activity, Time in current activity, Inbound calls answered today and Last inbound call (§3.2).
2. Current activity must be one of: On inbound call, On outbound call, Outbound lead in Preview, Idle, Not available.
3. Summary cards for today must show Total inbound calls, Answered, Missed, Abandoned, Calls waiting now and Longest current wait.
4. The monitor must refresh automatically.

#### **AC 7: Closing Rate**

1. Closing rate must be calculated as **AR % = Approved leads / Total leads × 100**, counting inbound hotline leads only.
2. The report must show AR % per agent (§4.1) and per hotline with its mapped Product / Offer (§4.2).

## Other Information

### Data Sources

| Data | Source |
|---|---|
| Call arrival, queue wait, ringing, accept, decline, ring timeout, hang-up times | PBX events received by TMS (PBX connector, TM-9006) – **availability to confirm** |
| Lead ID, lead status, assignee, hotline, product / offer | TMS lead |
| Outbound call attempts on a lead (for callback time) | TMS / PBX CDR |
| Agent mode, TMS agent status, team | TMS agent status |

### Dependencies

* The PBX must send, and TMS must store, a timestamp for each call event listed above. Without the queue entry and hang-up times, wait time, Calls waited in queue and Abandoned calls cannot be calculated.
* Real-time agent activity depends on the Blending mode status sync (TM-9195).

### Recommendations (not requirements – confirm before adding)

* **Filters:** Date range (default Today), Hotline, Team, Agent – similar to the existing Sale Operation Report filters.
* **Refresh interval** for the monitor: selectable 5 / 10 / 15 / 60 seconds, as in the existing CMDC real-time monitoring.
* **Abandoned wait time:** how long customers waited before hanging up, to help set the IVR message and staffing.

### Open Questions

1. **Applied GEO:** IN only, TH 4 only, or both?
2. **Location and access:** which TMS menu hosts the report and monitor? Which roles can see it (TL, SPV, Operations Manager, AM)?
3. **Filters and default period:** which filters are required, and what is the default date range?
4. **Closing rate:** is AR % (Approved / Total leads) the right definition, or should e-AR % (Approved / Approved + Rejected + Callback) also be shown?
5. **Closing rate attribution:** count a lead in the period of its creation date or its Approved date? Which agent gets the lead – the agent who answered the call, or the current assignee?
6. **Wait time start:** from the moment the call reaches the hotline, or after the IVR welcome message ends?
7. **Callback time:** count only outbound attempts by agents, or any outbound attempt (including auto dialer)? Is there a callback target time (SLA) to flag late callbacks?
8. **Monitor refresh interval:** fixed value, or selectable?
9. **Export:** is export to Excel/CSV required?
10. **Data availability:** does the PBX connector already store queue entry, ringing, decline, ring timeout and hang-up times for inbound calls?
