# Current-State Analysis — [RMS][MY2/MY3] Ringing Duration before End Call

## 1. Scope

- System: RMS (Rescue Management System)
- GEO: MY2, MY3 (per request)
- Behavior analysed: ringing duration and availability of the "End Call" button during an outbound call from RMS

## 2. Confirmed Current Behavior

| # | Finding | Source |
|---|---|---|
| CS-01 | In My Rescue, the Rescue Job detail includes a **Make call** action for CS (both Manual and Auto Distribution). | Confluence: RMS v2.0 - User Guide, §4.3 Step 4 / Step 3 |
| CS-02 | RMS has a **Call Popup** showing call statuses including Active, Connected, Unknown. Evidence is from a LATAM ticket; applicability to MY2/MY3 is not confirmed. | Jira TM-8439 (Done) |
| CS-03 | RMS 2.1 (1) and RMS 2.1 (2) are Released for **MY2**; RMS 2.1 (2) is Released for **MYNHI**. **MY3 is not listed.** | Confluence: RMS v2 – GEO Release Tracking Page |

## 3. Not Verified from Available Source

- Current ringing duration / ring timeout for RMS calls in MY2 and MY3.
- When the "End Call" button currently becomes available (e.g., immediately on call start).
- Whether ringing duration is an existing configurable parameter (per GEO or global).
- Whether "MY3" is the same instance as "MYNHI" or a separate instance.
- Which RMS screens initiate calls beyond My Rescue (e.g., All Rescue, Pre-delivery).

## 4. Target State (from request only)

- Set ringing duration to **30 seconds before the "End Call" button becomes available**, for Rescue System MY2 and MY3, with consistent settings across both. *(Source: email from Syed Hafriz Al Hakim S. Hassan, 2026-10-09 2:36 PM)*

## 5. Delta

| Area | Current | Target |
|---|---|---|
| End Call availability | Not verified from available source | Available only after 30 seconds of ringing |
| GEO consistency | Not verified from available source | Same setting in MY2 and MY3 |

## 6. Pending Clarification Already Raised

IT replied on 2026-10-09 3:52 PM asking (a) the business reason for 30 seconds and (b) whether the 30 seconds starts from the moment CS begins the call. No answer is present in the source.

## 7. Readiness

**PARTIAL** — Target State is stated by a stakeholder email, but current behavior, the start point of the 30 seconds, and the MY3 instance are unverified. Draft the supported scope only; carry gaps into Open Questions.
