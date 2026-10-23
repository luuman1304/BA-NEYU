# CS-TMS – Blending Mode: Agent Status ↔ Inbound Routing Condition Matrix

| Item | Detail |
|---|---|
| **Primary System** | TMS (Related: PBX) |
| **Request** | TM-9195 – [IN][Hotline] Blending Mode – Agent handles Inbound & Outbound with Inbound Priority |
| **Date** | 2026-10-14 |
| **Readiness** | **PARTIAL** – status model confirmed; user decisions D1–D4 applied; open items in §6 |

## 1. Sources

| # | Source | Type | Use |
|---|---|---|---|
| S1 | [TM-9195](https://accelo-tech.atlassian.net/browse/TM-9195) (In Progress) | Story / CR | Target behavior |
| S2 | [1. Agent Main Status and Rules](https://accelo-tech.atlassian.net/wiki/spaces/TMSF/pages/90439681) (last modified 2022-03-14) | Existing system documentation | Current agent status model |
| S3 | [TM-9005](https://accelo-tech.atlassian.net/browse/TM-9005) (Done, TH4) | Related story | Current inbound queue / lead scenarios |
| S4 | `outputs/mom/TMS/MoM-TMS-Training-Inbound-Hotline-Call-2026-10-13.md` | Meeting minutes (training) | Current inbound operation in IN |

> S2 is from 2022. It is the only status-model source found; whether it still reflects production is **not verified**.

## 2. Current State – TMS Agent Statuses (S2)

| Status | Type | Set by | Current rule |
|---|---|---|---|
| Unavailable | Main | Agent / on login | Default after login. Can go to Available or Log out. Cannot go to Break/Busy. |
| Available | Main | Agent | Ready for leads. Can go to Unavailable/Break/Busy. Cannot log out. |
| Assigned | Main | System | Set when a lead is auto-assigned (agent opens Order list). Back to Available after lead saved (if no pending request). |
| Requested to Break / Busy / Unavailable | Sub-status of Assigned | Agent | Applied only after the agent saves the lead. |
| Break (reason: Lunch, Quick Break, Dinner, Others) | Main | Agent | Can go to Available/Unavailable/Assigned. Cannot Log out/Busy. |
| Busy (reason: Meeting, Training, Others) | Main | Agent | Cannot Log out/Break. |
| On-call | System | PBX event Ringing | Agent makes a call on TMS/PBX app. |
| Wrap-up | System | PBX event Endcall while On-call | After call ends. |

Other current facts:
- TMS only listens to PBX events; queue pause/unpause is manual on PBX (S1 Current Behavior).
- IN inbound agents currently log in with **separate inbound accounts** and select **Power** mode; they can only receive calls (S4 §2.1, §2.3).
- Inbound popup: Accept / Decline / auto-accept after 2–3 s (S4 §2.3).

## 3. Target – Inbound Routing Condition Matrix (Blending mode)

### 3.1 Status-level summary – which status receives Inbound / Outbound

Applies to **Blending** mode only. Other modes: current logic (outbound only, no inbound, no PBX sync).

| # | TMS agent status | Receive Inbound? | Receive new Outbound lead? | PBX hotline queue | Source |
|---|---|---|---|---|---|
| 1 | Logged out | ❌ | ❌ | Paused | S1 AC2.3, S2 |
| 2 | Unavailable | ❌ | ❌ | Paused | S1 AC2.3, D1 |
| 3 | **Available** | ✅ **First priority** – immediately if a call is waiting, or any time during the T-second window | ✅ **Only if** no inbound call after T seconds **and** an outbound lead exists | Unpaused | S1 AC3, AC4 |
| 4a | Assigned – **outbound** lead in **Preview** (not dialed) | ✅ – on inbound arrival, the outbound lead is **released to the distribution pool** (lead status unchanged) and the inbound call is routed | ❌ | **Unpaused** | D10, D11 |
| 4b | Assigned – **outbound** lead **On-call / Wrap-up** (dialed, not saved) | ❌ – agent must finish and save the lead | ❌ | **Paused** – sent when the agent clicks Call (D12); first event wins vs. inbound (D13) | S1 AC5.4, D8, D11 |
| 5 | Assigned – **inbound** call / lead (incl. On-call / Wrap-up of that call) | ❌ | ❌ | **Paused** until lead saved | S1 AC3.3, D5; status name pending (G4) |
| 6a | Assigned (outbound) + **Requested to Break / Busy / Unavailable** – lead in **Preview** (not dialed) | ✅ – same as 4a: release lead to pool, route inbound | ❌ | **Unpaused** | D1, D6, D8, D10 |
| 6b | Assigned (outbound) + **Requested to Break / Busy / Unavailable** – lead **On-call / Wrap-up** (dialed, not saved) | ❌ – agent must finish the lead first | ❌ | **Paused** until the lead is saved (call + wrap-up done) | D8 |
| 6c | Assigned (outbound) + **Requested to Break / Busy / Unavailable** – lead **saved** | ✅ if an inbound call is waiting → handle it; requested status applies after the inbound lead is saved. No call waiting → apply requested status and Pause immediately | ❌ | Unpaused after save; Paused when requested status applies | D8, D9 |
| 7 | Break | ❌ | ❌ | **Paused** – sent on status change | D1, D7 |
| 8 | Busy | ❌ | ❌ | **Paused** – sent on status change | D1, D7 |

Transition after the lead is **saved successfully**:

| From | No pending Request | Pending Request to X | Urgent inbound lead assigned (abandoned call) |
|---|---|---|---|
| Assigned (outbound / inbound) | → Available, send Unpause | → X (Break/Busy/Unavailable), send **Pause** | → Load Urgent inbound lead next, bypass new outbound (AC7.3) |

Lead-check order while **Available**: (1) inbound call waiting → route → (2) wait T seconds, inbound arrives → route → (3) outbound lead exists → assign (Preview, still Unpaused) → inbound arrives before dial → release lead to pool, route inbound; agent dials → Pause → (4) nothing → stay Available, re-check.

### 3.2 Scenario matrix

Inbound call is routed to an agent **only when all of**: Mode = Blending **AND** TMS status = Available **AND** PBX hotline queue member = Unpaused **AND** agent has no outbound lead assigned.

| # | Working mode | TMS agent status | Context | PBX queue state (TMS → PBX) | Inbound routed? | Outbound lead assigned? | Source |
|---|---|---|---|---|---|---|---|
| 1 | Not Blending (any other mode) | Any | — | No sync from this story | **No** | Current logic | S1 AC1.3 |
| 2 | Blending | Logged out / Unavailable | — | Paused | **No** | No | S1 AC2.3 |
| 3 | Blending | Available | Inbound call waiting in queue | Unpaused – send *Available (in + out)* when agent sets Available | **Yes – immediately** | No | S1 AC2.1, AC3.1 |
| 4 | Blending | Available | No inbound waiting, inside T-second window | Unpaused | **Yes** if a call arrives within T | No (halted) | S1 AC4 |
| 5 | Blending | Available | No inbound after T, outbound lead exists | Stays Unpaused (AC5.1 changed by D11) | Yes, while lead in Preview | Yes → status Assigned | S1 AC5, D11 |
| 6 | Blending | Available | No inbound, no outbound lead | Unpaused; system keeps checking | Yes, when a call arrives | When a lead appears (after T) | S1 AC6 |
| 7 | Blending | Assigned (outbound lead) | Preview (not dialed) → inbound arrives | Unpaused; Pause when agent clicks Call (D12) | **Yes** – lead released to pool, status unchanged | Current lead released | D10, D11 |
| 8 | Blending | On-call (outbound) | Talking | Paused | **No** | — | S1 AC5.1 + S2 |
| 9 | Blending | Wrap-up / Assigned after outbound call | Lead not yet saved, or save failed | Stays Paused | **No** | — | S1 AC5.4 |
| 10 | Blending | Assigned → lead saved, no pending request | Status returns to Available | Send *Available (in + out)* (Unpause) | Yes (back to #3/#4) | — | S1 AC5.3 + S2 |
| 11a | Blending | Assigned + Requested to Break/Busy/Unavailable (lead not yet saved) | Agent makes the Request | Preview: Unpause when the Request is made (inbound → release lead). On-call / Wrap-up: stay Paused until lead saved | Preview: **Yes**; dialed: **No** | No | D1, D6, D8 (user) |
| 11b | Blending | Assigned + Requested to Break/Busy/Unavailable → lead saved | Status becomes Break/Busy/Unavailable | Stay Paused – do **not** send Available | **No** | No | D1 (user) + S2 |
| 12 | Blending | On-call (inbound) | Talking to hotline customer | Paused | **No** | No | D5 (user) |
| 13 | Blending | Wrap-up after inbound call | Updating lead | Paused until lead saved | **No** | No | S1 AC3.3, D5 (user) |
| 14 | Blending | Inbound lead saved | Status returns to Available | Send *Available (in + out)* | Yes | — | S1 AC3.3 |
| 15 | Blending | Break / Busy / Unavailable | Agent changes from Available | Send *Unavailable for inbound* (Pause) on the status change | **No** | **No** | S1 AC2.3 + D1 (user) |
| 16 | Blending | Assigned (outbound) + abandoned call assigned to this agent (latest agent) | Handling outbound | Paused | No | After save → Urgent inbound lead loads next, bypassing new outbound | S1 AC7.2, AC7.3 + D3 (user) |
| 17 | Blending | Available | Customer was waiting in queue (no agent free) | Unpaused | **Yes – immediately** | No | S1 AC7.1 |

## 4. User Decisions (2026-10-14, Man Luu)

| # | Topic | Decision |
|---|---|---|
| D1 | Break / Busy / Unavailable | Agent receives **no leads** – neither inbound nor outbound. While in **Requested to Break/Busy/Unavailable**, the agent **still receives inbound leads** if any. Resolves G1, G2. |
| D2 | Current IN inbound accounts (C1) | Move to **Blending** mode. AC1.3 stands: other modes have no inbound routing. |
| D3 | Abandoned-call assignee (C2) | Assign to the **latest agent** (AC7.2). Expected Behavior §5 "highest skill level" no longer applies. |
| D4 | Open Question 4 (C3) | Closed – no further action. AC5.1 applies. |
| D5 | Handling an inbound call / lead (G3) | PBX **Paused** until the lead is saved. |
| D6 | Requested to Break / Busy / Unavailable (Q-A) | PBX **Unpaused** – agent still receives inbound while the Request is pending. Applies to all three Requests. |
| D7 | Break / Busy | PBX **Paused**. |
| D9 | Lead saved with a Request pending (R3) | Inbound call waiting → handle it first; requested status applies after the inbound lead is saved. No call waiting → apply requested status and Pause. |
| D10 | Released Preview lead (R4) | Returned to the **distribution pool**; lead status unchanged. |
| D11 | Release on Preview scope (R5) | Applies to **every Assigned outbound lead** in Preview (with or without a Request) – inbound has priority. **Changes AC5.1**: agent is no longer Paused before outbound assignment. Re-opens TM-9195 Open Question 4 (D4) with answer "release the outbound lead". |
| D12 | Pause trigger for outbound (A1) | TMS sends *Unavailable for inbound* (Pause) **when the agent clicks Call** on the outbound lead. Replaces AC5.1 "before assigning". |
| D13 | Race: inbound routed vs. agent clicks Call (R6) | **First event wins.** Inbound event first → release outbound lead to pool, route inbound. Call click first → Pause, outbound call proceeds; inbound stays in queue for another agent. |
| D14 | "Latest agent" (abandoned call) | The agent who **last declined** the phone call. The decline sets the lead to **Urgent**. |
| D15 | Simultaneous event / inbound Pause trigger | An inbound call that loses the race stays in the queue for the next agent. TMS sends the Pause when an inbound call is routed to the agent. |
| D16 | Urgent inbound lead priority | Priority applies only to a **live inbound call**. A system-assigned Urgent callback lead is a normal outbound lead with no priority (changes TM-9195 AC7.3). |
| D17 | Abandoned call with no decline | Lead status **New**, no assignee; the Team Leader assigns it manually. |
| D18 | Missed call (no answer) | Lead goes to the **Team Leader pool**. |
| D19 | Abandoned-call banner | Removed (not needed). |
| D8 | Requested state vs. outbound lead phase (R1, R2) | Unpause only after the agent **finishes the lead, including call and wrap-up**. If the outbound lead is only in **Preview** (not dialed), it is **released** so the inbound call takes priority. If the lead is dialed (On-call / Wrap-up), the agent must finish and save it first. Refines D6. |

## 5. Gaps & Conflicts

| # | Type | Description |
|---|---|---|
| G1 | ~~Gap~~ Resolved by D1 | After lead save with a pending Request, status becomes Break/Busy/Unavailable and TMS must not send Available. |
| G2 | ~~Gap~~ Resolved by D1 | TMS must send *Unavailable for inbound* when the agent changes to Break / Busy / Unavailable. Logout: agent must be Unavailable first (S2), so already paused. |
| Q-A | ~~Conflict~~ Resolved by D6 | Unpause when the Request is made. **Impact:** this overrides AC5.1 (agent Paused while handling an outbound lead) for the Requested sub-statuses – TM-9195 AC5 must be updated. |
| G3 | ~~Gap~~ Resolved by D5 | — |
| R1 | ~~Risk~~ Resolved by D8 | Stay Paused during On-call / Wrap-up. |
| R2 | ~~Open~~ Resolved by D8 | Preview → release outbound lead; dialed → finish outbound lead first. |
| R3 | ~~Open~~ Resolved by D9 | — |
| R4 | ~~Open~~ Resolved by D10 | — |
| R5 | ~~Open~~ Resolved by D11 | — |
| A1 | ~~Assumption~~ Confirmed by D12 | — |
| R6 | ~~Risk~~ Resolved by D13 | — |
| G3 | Gap | No PBX sync defined during/after an **inbound** call (On-call → Wrap-up). AC3.3 implies agent is unavailable until lead saved, but no Pause is sent. A queue member typically becomes free on hang-up (not verified for this PBX). |
| G4 | Gap | TMS status while handling an inbound call is not defined (Assigned? On-call?). |
| G5 | Terminology | TM-9195 uses **Paused, Offline** (AC2.3) – not TMS statuses in S2. Proposed mapping: Paused → PBX state only; Offline → Logged out / Unavailable. |
| C1 | ~~Conflict~~ Resolved by D2 | Current IN inbound accounts move to Blending. |
| C2 | ~~Conflict~~ Resolved by D3 | Latest agent. TM-9005 rule (New → TL pool) stays for TH4 only – not verified for IN. |
| C3 | ~~Note~~ Closed by D4 | — |
| C4 | Gap | Decline / missed call in Blending mode: S4 says Decline will be removed with Blending; TM-9195 does not state it. |

## 6. Open Questions

1. Which TMS status is shown while handling an inbound call? (G4)
2. Is the Decline button kept in Blending mode? (C4)
3. Is S2 (2022) still the current agent status model?
