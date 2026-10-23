# [RMS][MY2][MY3] Configure 30-Second Ringing Duration before "End Call" Button Becomes Available

## Description

### Applied GEO

MY2, MY3

### Business Context / Purpose

MY business requested that RMS calls ring for 30 seconds before CS can end the call, with the same setting in MY2 and MY3.
*(Source: email from Syed Hafriz Al Hakim S. Hassan, 2026-10-09)*

### Current Behavior

- CS calls the customer via **Make call** on the Rescue Job detail (My Rescue).
- Current ringing duration and when "End Call" becomes available: **not verified from available source.**

### Expected Behavior

| Item | Change |
|---|---|
| "End Call" button | Not available for **30 seconds** from the moment CS clicks **Make call**; available after 30 seconds |
| GEO | Same setting in **MY2** and **MY3** |
| Other GEOs | No change |

## Acceptance Criteria

**AC-01** — Given CS clicks Make call in RMS MY2/MY3, When less than 30 seconds have passed, Then "End Call" is not available.

**AC-02** — Given CS clicks Make call in RMS MY2/MY3, When 30 seconds have passed, Then "End Call" becomes available.

**AC-03** — Given CS makes a call in any other GEO, Then End Call behavior is unchanged.

## Open Questions

1. ~~Does the 30 seconds start when CS clicks **Make call**?~~ → **Yes.**
2. ~~Behavior if answered before 30 seconds / unanswered at 30 seconds?~~ → **Skipped** — not in scope of this CR.
3. Which instance is **MY3**? Release tracking lists only MY2 and MYNHI.
4. Business reason for 30 seconds? *(asked by IT, pending)*
