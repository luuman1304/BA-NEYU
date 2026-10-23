# MoM – Training: Inbound Hotline Call in TMS

| Item | Detail |
|---|---|
| **Date** | 2026-10-13, 13:57 (VN time) |
| **Duration** | 23 min |
| **Presenter** | Man Luu Gia (IT/BA) |
| **Participants** | Pawan Ramnani, Pranay Mirgal, Uman Khan, Ziya |
| **System** | TMS – India Hotline |

## 1. Objective

Introduce the new **Inbound Hotline Call** feature in TMS and train agents and Team Leaders on how to handle inbound calls.

## 2. Key Points

### 2.1 Overview

- Until now, TMS agents could only make outbound calls to leads. With this release, agents can also **receive inbound calls** from the Hotline.
- Flow: Customer calls the Hotline → TMS creates a lead → TMS routes the call to an agent → Agent accepts or declines → Lead information opens in TMS.
- An agent assigned to the inbound queue can **only receive** calls. They cannot make outbound calls at the same time.
- **Separate accounts are used for inbound.** Existing outbound agent accounts are not used for Hotline inbound.

### 2.2 Duplicate lead rule (12 hours)

| Scenario | Result |
|---|---|
| Same phone number calls again **within 12 hours** | No new lead; TMS opens the existing lead |
| Same phone number calls again **after more than 12 hours** | TMS creates a new lead |

*Example: customer calls at 9:00 and again later the same morning → no new lead. Customer calls again at 10:00 the next day → new lead.*

### 2.3 Agent steps

1. Log in to TMS and select **Power** mode → Submit.
2. Check the phonebook status (Active) and wait for incoming calls.
3. When a call arrives, the call popup shows two buttons:
    - **Accept** – receive the call.
    - **Decline** – reject the call; TMS routes it to the next available agent (or back to the same agent if they are the only one available).
    - If the agent does nothing, TMS **auto-accepts after 2–3 seconds**.
4. After accepting, TMS opens the lead details. The agent fills in customer information (address, gender, product, etc.) and updates the lead status.
5. After saving, TMS returns to the order list, ready for the next call.

### 2.4 Call scenarios and lead status

| Scenario | System behavior | Next action |
|---|---|---|
| Agent answers | Lead assigned to the answering agent | Agent updates lead detail and status |
| Agent declines | Lead status = **Urgent**; call routed to next available agent (or back to the same agent if only one is available) | — |
| Ring timeout (no agent available / no answer) | Lead status = **Urgent** | TL assigns lead to an agent for immediate callback |
| Customer hangs up in queue | TMS creates a lead *(status to be confirmed)* | TL assigns lead to an agent to process |

### 2.5 Demo

Presenter demonstrated the full flow on the real system: login → Power mode → incoming call → Accept → lead detail update (example status: Uncall) → return to order list.

## 3. Q&A

| # | Question | Answer |
|---|---|---|
| 1 | **Pawan:** Why is there a Decline button? Can it be disabled in future? | In this phase, inbound and outbound use separate logins, so Decline lets busy agents pass the call to another available agent. Removing Decline is planned for the next phase together with **Blending mode** (one agent handles both inbound and outbound). |
| 2 | **Pawan / Ziya:** How can we call the customer back (e.g., after the call disconnects)? | Inbound accounts cannot make outbound calls. The **TL must assign the lead to an outbound agent**; the agent logs out of the inbound account, logs in with the outbound account, and calls the lead. |

## 4. Action Items

| # | Action | Owner | Due |
|---|---|---|---|
| 1 | Send production link and inbound agent accounts (username/password) to Aditya | Man Luu Gia | After the meeting (2026-10-13) |
| 2 | Use the separate inbound accounts for Hotline inbound calls | India team | From go-live |
