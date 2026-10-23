# [IN][Hotline] Blending Mode – Agent handles Inbound & Outbound with Inbound Priority (TMS ↔ PBX status sync)

> **Draft to replace the description of [TM-9195](https://accelo-tech.atlassian.net/browse/TM-9195)** – local file, not yet applied to Jira.
> Prepared: 2026-10-14 · Current-State Analysis: `outputs/current-state/TMS/CS-TMS-Blending-Mode-Agent-Status-Inbound-Routing.md`
>
> **Changes vs. current TM-9195** (remove this block before pasting into Jira):
> - Added the agent status → Inbound / Outbound routing matrix and the PBX sync event table.
> - **AC5.1 changed:** the agent is no longer paused before outbound assignment. Pause is sent when the agent clicks **Call**. An outbound lead in Preview is released when an inbound call arrives.
> - Added rules for Break / Busy / Unavailable and for Requested to Break / Busy / Unavailable.
> - Added the PBX pause rule while the agent handles an inbound call.
> - Abandoned call goes to the **latest agent**, i.e. the agent who last declined the call (the "highest skill level" rule is removed).
> - **AC8.2 changed:** abandoned call with no decline = **New**, no assignee, Team Leader assigns it. **AC8.3 added:** missed call = Urgent → Team Leader pool.
> - **AC8.4 changed:** the Urgent callback lead from an abandoned call no longer bypasses other outbound leads, and the "Urgent Inbound Lead Assigned" banner is removed. Inbound priority applies only to a live inbound call.
> - **AC5.4 added:** an inbound call that loses the simultaneous-event rule stays in the queue.
> - Current IN inbound accounts move to Blending mode.
> - Open Question 4 closed. Open Question 2 removed. New open questions added.

---

### Applied GEO

**IN (India)** – hotline on new dedicated numbers. To confirm: reuse for TH 4.

### Business Context / Purpose

Today an agent can handle **either** inbound **or** outbound calls, not both. Inbound-only agents receive few hotline calls and are idle most of the day. Outbound-only agents cannot pick up hotline calls when the queue is busy.

A new **Blending** mode lets one agent handle both inbound and outbound calls, with **inbound always handled first**. TMS must keep the agent's status in sync with the PBX, so the PBX only routes inbound calls to an agent who is free for inbound.

### Current Behavior

* Agents select a working mode in TMS, and each mode handles either inbound or outbound only.
* IN inbound agents log in with **separate inbound accounts** and select **Power** mode. They can only receive calls and cannot make outbound calls.
* TMS only **listens** to PBX events. The agent's status on the PBX queue (available / paused) is changed manually on the PBX side.
* No rule decides between an inbound call and an outbound lead for the same agent.
* Current TMS agent statuses:

| Status | Type | Current rule |
|---|---|---|
| Unavailable | Main | Default after login. Required before logout. |
| Available | Main | Ready to receive leads. |
| Assigned | Main (system) | Set when a lead is assigned. Returns to Available after the lead is saved, unless a Request is pending. |
| Requested to Break / Busy / Unavailable | Sub-status of Assigned | Applied only after the agent saves the lead. |
| Break | Main | Reason required: Lunch Break, Quick Break, Dinner, Others. |
| Busy | Main | Reason required: Meeting, Training, Others. |
| On-call | System | Set when the agent makes a call on TMS / PBX app (PBX event Ringing). |
| Wrap-up | System | Set when the PBX sends Endcall while the agent is On-call. |

### Expected Behavior

#### 1. Mode Selection

* Add a new mode **Blending** to the mode-selection screen.
* **Blending** mode: the agent can receive **both inbound calls and outbound leads**.
* **Other modes**: no change. The current logic applies (outbound only, no inbound routing, no PBX status sync).
* Current IN inbound accounts move to **Blending** mode.

#### 2. Agent Status → Inbound / Outbound Routing (Blending mode)

| # | TMS agent status / lead phase | Receive Inbound | Receive new Outbound lead | PBX hotline queue |
|---|---|---|---|---|
| 1 | Logged out | ❌ | ❌ | Paused |
| 2 | Unavailable | ❌ | ❌ | Paused |
| 3 | **Available** | ✅ **First priority** | ✅ Only if no inbound call after **T seconds** | Unpaused |
| 4 | Assigned – outbound lead in **Preview** (not dialed) | ✅ The outbound lead is released and the inbound call is routed | ❌ | Unpaused |
| 5 | Assigned – outbound lead **On-call / Wrap-up** (dialed, not saved) | ❌ The agent must finish and save the lead | ❌ | Paused |
| 6 | Handling an **inbound** call / lead (call + wrap-up, until the lead is saved) | ❌ | ❌ | Paused |
| 7 | Assigned + **Requested to Break / Busy / Unavailable** – lead in **Preview** | ✅ Same as #4 | ❌ | Unpaused |
| 8 | Assigned + **Requested to Break / Busy / Unavailable** – lead **On-call / Wrap-up** | ❌ The agent must finish and save the lead | ❌ | Paused |
| 9 | Assigned + **Requested to Break / Busy / Unavailable** – lead **saved** | ✅ If an inbound call is waiting | ❌ | Unpaused if an inbound call is waiting, otherwise Paused |
| 10 | Break | ❌ | ❌ | Paused |
| 11 | Busy | ❌ | ❌ | Paused |

#### 3. TMS → PBX Status Sync Events

| # | Trigger (Blending mode) | TMS sends to PBX | Agent status after |
|---|---|---|---|
| 1 | Agent sets **Available** | **Available (inbound + outbound)** – Unpause | Available |
| 2 | Agent changes to **Break / Busy / Unavailable** | **Unavailable for inbound** – Pause | Break / Busy / Unavailable |
| 3 | Agent clicks **Call** on an outbound lead | **Unavailable for inbound** – Pause | On-call |
| 4 | Inbound call is routed to the agent | **Unavailable for inbound** – Pause (until the inbound lead is saved) | Handling inbound |
| 5 | Lead saved – no pending Request | **Available (inbound + outbound)** – Unpause | Available |
| 6 | Lead saved – pending Request, inbound call waiting | Stays Unpaused, and the inbound call is routed | The requested status applies after the inbound lead is saved |
| 7 | Lead saved – pending Request, no inbound call waiting | **Unavailable for inbound** – Pause | Break / Busy / Unavailable |
| 8 | Lead save fails / not saved | No change (stays Paused) | Unchanged |

#### 4. Inbound Priority

* The system always checks inbound first.
* **Agent Available and an inbound call is waiting in the hotline queue** → route the inbound call to the agent. The agent handles it and updates the lead, staying Paused until the lead is saved. After the lead is saved, TMS sends **Agent Available (inbound + outbound)** to the PBX for the next call.
* **Agent Available but no inbound call waiting** → the system waits **T seconds** (configurable) before assigning an outbound lead.
    * If an inbound call arrives during the T seconds → route the inbound call to the agent.

#### 5. Outbound Lead Assignment & Release on Preview

* After T seconds with no inbound call, if an outbound lead is available:
    1. TMS assigns the outbound lead to the agent (status **Assigned**). The agent stays **Unpaused** on the PBX while the lead is in Preview.
    2. **Inbound call arrives while the lead is in Preview (not dialed):** TMS releases the outbound lead **back to the distribution pool** with the **lead status unchanged**, and routes the inbound call to the agent.
    3. **Agent clicks Call:** TMS sends **Agent Unavailable for inbound** to the PBX, and the PBX stops routing inbound calls to this agent.
    4. **Inbound routed and Call clicked at the same moment:** the event that arrives first wins.
        * Inbound event first → release the outbound lead (step 2).
        * Call click first → Pause, and the outbound call continues. The inbound call stays in the queue for the next available agent.
    5. The agent handles the lead (call + wrap-up) and updates the lead status.
    6. After the lead status is **saved successfully**, TMS sends **Agent Available (inbound + outbound)** to the PBX (or applies section 6 if a Request is pending).
* **No inbound call and no outbound lead** → the agent stays **Available for inbound and outbound**, and the system keeps checking (back to section 4).

#### 6. Break / Busy / Unavailable and Requests

* **Break / Busy / Unavailable:** the agent receives **no leads**, neither inbound nor outbound. TMS sends **Unavailable for inbound** to the PBX when the agent changes to one of these statuses.
* **Requested to Break / Busy / Unavailable** (the agent is Assigned): the agent **still receives inbound** calls.
    * The lead is in **Preview** → same as section 5 step 2: release the outbound lead and route the inbound call.
    * The lead is **On-call / Wrap-up** → the agent stays Paused until the lead (call + wrap-up) is saved.
    * The lead is **saved**:
        * Inbound call waiting → route it to the agent. The requested status applies after the inbound lead is saved.
        * No inbound call waiting → apply the requested status, and TMS sends **Unavailable for inbound**.
* No new outbound lead is assigned while a Request is pending.

#### 7. No Agent Available (Queue Busy / Abandoned Call)

* When an inbound call arrives and **no agent is available**, the customer hears the IVR message "all agents are busy" and waits in the queue.
* If the customer is still on the line when an agent becomes Available → **route the inbound call to that agent immediately**.
* If the customer **hangs up** (abandoned call):

| Case | Lead status | Assignee |
|---|---|---|
| At least one agent declined the call | **Urgent** (set by the decline) | **Latest agent** = the agent who **last declined** this phone call |
| No agent declined (no agent available, the customer hung up in the queue) | **New** | No assignee – the Team Leader assigns it manually |

* If the caller is already a lead, update the existing lead per the duplicate rule instead of creating a new one.
* **Missed call** (the call rings, but the agent doesn't answer): lead status **Urgent**, and the lead goes to the **Team Leader pool** for manual assignment (same as TM-9005).
* **Inbound priority applies only to a live inbound call** (the customer is calling in). An Urgent lead that the system assigns to an agent to call back is handled as a normal outbound lead and gets **no inbound priority**. It does not bypass other outbound leads and follows section 5 (released in Preview when an inbound call arrives, Pause on Call).

#### 8. Duplicate Lead Rule (12 hours)

* When an inbound call arrives, TMS checks whether the same phone number has called within the **last 12 hours**.
* **Same phone number within 12 hours** of the last call from that number → TMS **does not create a new lead** and uses the existing lead.
* **No call from the same phone number for more than 12 hours** → TMS **creates a new lead**.
* The rule applies to every inbound call outcome (answered, missed, abandoned).

| Example | Calls from the same phone number | Result |
|---|---|---|
| 1 | 09:00, then 13:00 the same day (4 h later) | 13:00 → **no new lead**, the existing lead is used |
| 2 | 13:00, then 10:00 the next day (21 h later) | 10:00 next day → **new lead** created |

## User Story

* **As a Telesales Agent in Blending mode**,
  _I want_ to receive both hotline inbound calls and outbound leads, with inbound calls coming first,
  _So that_ I don't sit idle when there are no inbound calls and customers calling the hotline are answered quickly.
* **As a Team Leader / Operations Manager**,
  _I want_ abandoned hotline calls to become Urgent leads assigned automatically to an agent,
  _So that_ we call back customers quickly without manual reassignment.

## Acceptance Criteria

#### **AC 1: Mode Selection**

1. **Mode-selection screen display:**
    * TMS must display a new working mode named **Blending** in the mode-selection screen.
2. **Blending mode capability:**
    * For agents in **Blending** mode, the system must allow the agent to receive both hotline inbound calls and outbound leads.
3. **Other modes compatibility:**
    * For agents in any mode other than Blending, the current logic remains unchanged (outbound only, no inbound routing, and no PBX status sync).

#### **AC 2: Agent Status & PBX Status Sync**

1. **Status synchronization on Available:**
    * When an agent in **Blending** mode sets their status to **Available**, TMS must immediately send **Available (inbound + outbound)** for this agent to the PBX.
2. **PBX queue unpause:**
    * The PBX must unpause the agent in the inbound hotline queue upon receiving this event.
3. **Break / Busy / Unavailable:**
    * When the agent changes to **Break**, **Busy** or **Unavailable**, TMS must send **Unavailable for inbound** to the PBX.
    * The agent must receive no inbound call and no outbound lead in these statuses.
4. **Logged out:**
    * A logged-out agent must not receive inbound calls or outbound leads.
5. **Routing matrix:**
    * Inbound and outbound routing per agent status must follow the table in Expected Behavior §2.

#### **AC 3: Inbound Call Priority & Call Notification**

1. **Inbound call waiting in queue:**
    * If the agent is Available and an inbound call is waiting in the hotline queue:
        * TMS must route the inbound call to the agent immediately.
        * No outbound lead assignment shall take place.
2. **Incoming call notification:**
    * When an inbound call is routed to an agent, TMS must immediately display an incoming call toast / screen pop notification:
        * **Content:** 📞 **Incoming Inbound Call:** `[Phone Number]` (`[Hotline Name]`) – _Connecting..._
3. **Paused while handling inbound:**
    * When the inbound call is routed to the agent, TMS must send **Unavailable for inbound** to the PBX.
    * While the agent handles the inbound call and its lead (call + wrap-up), the agent must stay **Paused** on the PBX and must not receive another inbound call or an outbound lead.
4. **Post-call status restoration:**
    * After the agent finishes the call and the lead is saved successfully:
        * TMS must send **Available (inbound + outbound)** to the PBX for the next call or lead, unless a Request is pending (AC 6).

#### **AC 4: Outbound Assignment Delay (Wait Window)**

1. **Inbound check buffer (T seconds):**
    * If the agent is Available and no inbound call is currently waiting in the queue:
        * The system must wait **T seconds** (configurable) before attempting to assign an outbound lead.
2. **Inbound arrival during wait window:**
    * If an inbound call arrives within the **T seconds** window:
        * The outbound assignment must be halted, and the inbound call must be routed to the agent instead.

#### **AC 5: Outbound Lead Handling & PBX Status Sync**

1. **Assignment without pause:**
    * After **T seconds** with no inbound call, if an outbound lead is available, TMS assigns the outbound lead to the agent.
    * The agent must stay **Unpaused** on the PBX while the lead is in Preview (not dialed).
2. **Release on Preview:**
    * If an inbound call arrives while the outbound lead is in Preview:
        * TMS must release the outbound lead back to the **distribution pool**, with the **lead status unchanged**.
        * TMS must route the inbound call to the agent.
3. **Pause on Call:**
    * When the agent clicks **Call** on the outbound lead, TMS must send **Unavailable for inbound** to the PBX.
    * The PBX must stop routing inbound calls to this agent until the lead is saved.
4. **Simultaneous events:**
    * If an inbound call is routed and the agent clicks Call at the same moment, the event that arrives first must win:
        * Inbound first → AC 5.2 applies.
        * Call first → AC 5.3 applies, and the inbound call stays in the queue for the next available agent.
5. **Successful update & status restoration:**
    * After the agent handles the lead (call + wrap-up) and the lead status is **saved successfully**:
        * TMS must send **Available (inbound + outbound)** to the PBX, unless a Request is pending (AC 6).
6. **Failed or unsaved updates:**
    * If the lead status update fails or has not been saved, the agent must remain **Unavailable for inbound** on the PBX until the update is successfully saved.

#### **AC 6: Requested to Break / Busy / Unavailable**

1. **Inbound still received:**
    * While the agent is in **Requested to Break**, **Requested to Busy** or **Requested to Unavailable**, the agent must still receive inbound calls. No new outbound lead is assigned.
2. **Lead in Preview:**
    * If an inbound call arrives while the outbound lead is in Preview, AC 5.2 applies.
3. **Lead On-call / Wrap-up:**
    * The agent must stay Paused and finish the current lead (call + wrap-up) before receiving an inbound call.
4. **Lead saved – inbound waiting:**
    * If an inbound call is waiting when the lead is saved, TMS must route it to the agent.
    * The requested status (Break / Busy / Unavailable) must apply only after the inbound lead is saved.
5. **Lead saved – no inbound waiting:**
    * TMS must apply the requested status and send **Unavailable for inbound** to the PBX.

#### **AC 7: Idle State Handling (No Inbound & No Outbound)**

1. **Continuous monitoring:**
    * If there is no inbound call waiting and no outbound lead available:
        * The agent must remain in status **Available (inbound + outbound)**.
        * The system continuously monitors for new inbound calls or available outbound leads (re-evaluating per AC 3 and AC 4).

#### **AC 8: Queue Busy & Abandoned Call Handling**

1. When an inbound call arrives and no agent is available:
    * The customer hears the IVR waiting message.
    * If an agent becomes Available while the customer is waiting, route the call immediately.
2. If the customer hangs up before being answered (Abandoned Call), TMS creates a new lead (or updates the existing lead per duplicate rules):
    * **At least one agent declined the call** → lead status **Urgent**, assigned to the **latest agent**, i.e. the agent who last declined this phone call.
    * **No agent declined the call** → lead status **New**, with no assignee. The lead appears in the Team Leader pool for manual assignment.
3. **Missed call:**
    * If the call rings but the agent doesn't answer, TMS sets the lead status to **Urgent** and puts the lead in the **Team Leader pool** for manual assignment.
4. **No inbound priority for the callback lead:**
    * An Urgent lead from an abandoned call is handled as an outbound lead for the assigned agent to call back.
    * It must not bypass other outbound leads and must not receive inbound priority. AC 5 applies to it.
    * Inbound priority (AC 3) applies only to a live inbound call.
5. **Duplicate lead rule (12 hours):**
    * If the same phone number calls within 12 hours of its last call, TMS must not create a new lead and must use the existing lead.
    * If the same phone number has not called for more than 12 hours, TMS must create a new lead.
    * Example: calls at 09:00 and 13:00 the same day → one lead only. A call at 10:00 the next day → new lead.
6. Other logic remains unchanged. For agents in any mode other than Blending, the current logic stays the same, with no inbound routing and no PBX status changes from this story.

## Other Information

### Configuration

1. **T seconds** (wait before assigning an outbound lead): configurable setting. Default value to be decided by testing (e.g. 3–5 s). Owner of the setting: to confirm.
2. **Mode list**: add **Blending** to the existing modes.
3. **PBX status mapping**:

| TMS → PBX event | PBX hotline queue |
|---|---|
| Available (inbound + outbound) | Agent unpaused |
| Unavailable for inbound | Agent paused |

### Dependencies

* TMS must be able to **send** status changes to the PBX (today it only listens to PBX events). Mechanism to confirm with IT/PBX: existing pause/unpause codes, AMI command or Web API. It must work without manual admin steps on the PBX.
* New hotline numbers for the inbound flow (not the numbers used for outbound calls in IN).
* Testing on new SIMs/numbers, separate from live numbers.
* Flow diagram attachment (`image-20261013-101635.png`) must be updated to show release on Preview and the Pause-on-Call rule.

### Related

* [TM-9005](https://accelo-tech.atlassian.net/browse/TM-9005) (TH 4): missed / declined call = **Urgent** → TL pool; abandoned call = **New** → TL pool. In this story (IN), an abandoned call that was declined = **Urgent** → latest agent who declined; with no decline = **New** → TL pool; missed call = **Urgent** → TL pool.

### Open Questions

1. **Latest agent unavailable**: if the agent who last declined the call is offline or on Break when the abandoned lead is created, is the lead still assigned to that agent?
2. **Agent after decline / missed call**: should the agent be set to not available?
3. **PBX does not confirm the status change** (timeout / error): do not assign the outbound lead and alert? Also: maximum time an agent can stay Unavailable for inbound.
4. **Agent profile**: agents who must do 100% outbound should use an outbound-only profile, not Blending.
5. **TMS status while handling an inbound call**: which agent status is displayed (Assigned / On-call / Wrap-up)?
