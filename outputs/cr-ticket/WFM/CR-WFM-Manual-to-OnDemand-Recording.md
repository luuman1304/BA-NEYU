# [WFM][TH] On-Demand Recording: Rename, 30-Minute Limit, Schedule Preemption, and Storage Compression/Resolution

## Description

### Applied GEO

TH (Thailand)

### Business Context / Purpose

The Manual Recording feature currently has no maximum duration, no defined behavior when a Scheduled recording's start time collides with an active Manual recording, and no storage optimization (compression or resolution control). This CR also renames the "Manual" recording type to "On Demand" for clearer terminology in the Recording History filter.

### Current Behavior

*(Source: Confluence [\[BRD\] WFM Live Monitoring and Screen Recording](https://accelo-tech.atlassian.net/wiki/spaces/BPO/pages/1398341636), version 11, GEO: TH)*

- Recording History distinguishes two recording types: **Scheduled** and **Manual**. The BRD also conditionally references a third type, "On-Demand (if yes)," in US-04 ("Recording History includes Scheduled, On-Demand (if yes), and Manual recordings"), but this type is not confirmed as fully specified elsewhere in the source.
- **Manual Recording** (Section III.D, US-10): a Supervisor/Manager manually starts/stops an Agent's screen recording from Live Monitoring. It is enabled only when the Agent is Online, capture-available, and has no other active recording session; start/stop each require a confirmation popup; recording continues independently of the initiating user's session; only one active recording is allowed per Agent; the finalized session is saved to Recording History with Recording Type "Manual." **No maximum duration is defined** — the recording "continues until an authorized user selects Stop, or until it is interrupted by the Agent/Application becoming unavailable or another applicable system condition."
- **Scheduled Recording** (Section III.C, US-09): automatically starts based on configured time slots and scope; automatically stops when the time slot ends, the configuration is disabled, the Agent is removed from scope, or the Agent/Application becomes unavailable. **No rule is defined for what happens if a Scheduled recording's start time arrives while a Manual recording is already active for the same Agent.**
- **Storage**: "Store the recording file and its related metadata in centralized storage." **No compression behavior and no resolution/quality specification are defined.**
- Related Jira: WFM-398 through WFM-407 (one Story per User Story of this BRD, including WFM-407 = US-10 "Start and Stop a Manual Recording") are all in status **QA TESTING** — implemented but not yet released to production.

### Expected Behavior

#### 1. Rename "Manual" to "On Demand"

- Rename the "Manual" recording-type label to **"On Demand"** wherever it is shown to users (for example, the Recording Type column in Recording History).
- Update the Recording Type filter in Recording History so it shows exactly three options: **All, Scheduled, On Demand** (the separate "Manual" filter option is removed/superseded by "On Demand").

#### 2. Maximum duration for On Demand (Manual) recording

- An On Demand (Manual) recording may run for a **maximum of 30 minutes**.
- If the recording reaches 30 minutes, the system automatically stops the recording.

#### 3. Scheduled recording preempts an active On Demand recording

Example provided by the requester: an On Demand recording starts at 14:30 for an Agent; a Scheduled recording is configured to start at 14:50 for the same Agent; the On Demand recording has not been stopped by 14:50.

- When a Scheduled recording's configured start time arrives and an On Demand (Manual) recording is still active for the same Agent, the system stops and finalizes the On Demand recording at that moment, then starts the Scheduled recording.
- Recording History then contains **two separate records** for the Agent: the On Demand recording (14:30–14:50) and the Scheduled recording (starting 14:50).

#### 4. Storage compression

- Recordings are compressed before being written to storage.
- When a user plays back a recording, the system decompresses it to display to the user.
- Compression algorithm, ratio, or target file size: **Not defined in source** — see Open Questions.

#### 5. Storage resolution reduction

- Recorded video resolution is reduced for storage to **480 or "HHD"** (requester's exact wording).
- Exact target resolution(s) and whether resolution is fixed or configurable: **Not defined in source** — see Open Questions.

## User Story

As a Manager reviewing storage usage and recording behavior,
I want On Demand recordings to be capped at 30 minutes, yield to Scheduled recordings, and be stored compressed at a reduced resolution,
So that recording behavior is predictable, Scheduled recordings are never blocked, and storage costs are reduced.

## Business Rules

- **BR-01:** The recording type previously labeled "Manual" is displayed as "On Demand."
- **BR-02:** The Recording History Recording Type filter offers exactly: All, Scheduled, On Demand.
- **BR-03:** An On Demand (Manual) recording has a maximum duration of 30 minutes; the system auto-stops it when this limit is reached.
- **BR-04:** A Scheduled recording's configured start time takes precedence over an active On Demand recording for the same Agent — the system stops the On Demand recording and starts the Scheduled recording, producing two separate Recording History records.
- **BR-05:** Recordings are stored compressed and decompressed at playback time.
- **BR-06:** Recorded video is stored at a reduced resolution (480 or "HHD" per requester wording — see Open Questions).

## Acceptance Criteria

### AC1 — Label and filter rename

Given the Recording Type previously labeled "Manual,"
When a user views Recording History or the Recording Type filter,
Then the label reads "On Demand," and the filter offers only All, Scheduled, and On Demand.

### AC2 — 30-minute cap

Given an On Demand recording is active,
When its duration reaches 30 minutes,
Then the system automatically stops the recording and finalizes it in Recording History.

### AC3 — Scheduled recording preemption

Given an On Demand recording is active for an Agent,
When a Scheduled recording's configured start time arrives for that same Agent,
Then the system stops and finalizes the On Demand recording at that time, starts the Scheduled recording, and Recording History shows both as separate records with the On Demand recording ending at the Scheduled recording's start time.

### AC4 — Compressed storage and playback

Given a recording is finalized,
When it is written to storage,
Then it is stored compressed;
When a user plays it back,
Then the system decompresses it for display.

### AC5 — Reduced storage resolution

Given a recording is finalized,
When it is written to storage,
Then its video resolution is reduced per the confirmed target resolution (see Open Questions).

## Other Information

- Reference BRD: [\[BRD\] WFM Live Monitoring and Screen Recording](https://accelo-tech.atlassian.net/wiki/spaces/BPO/pages/1398341636)
- Related Jira issue: [WFM-407](https://accelo-tech.atlassian.net/browse/WFM-407) — "[WFM][Manual Recording] US-10: Start and Stop a Manual Recording" (status: QA TESTING)

## Open Questions / Assumptions

| # | Question | Why It Matters |
|---|---|---|
| OQ-1 | Is the "Manual" → "On Demand" rename a display-label-only change, or does it also rename the underlying feature/permission name used elsewhere in the BRD (for example, "Manual Recording permission," the "Manual Screen Recording" feature section)? | Affects whether permission names, API/field names, and other BRD sections also need updating. |
| OQ-2 | The requester's exact wording for item 5 is "480 hoặc HHD" (480 or "HHD"). "HHD" is not a standard video resolution term. What is the intended second resolution option — HD (720p), FHD (1080p), or another value? | The target resolution(s) cannot be implemented as specified. |
| OQ-3 | Is the storage resolution a single fixed value, or configurable/selectable (for example, per GEO or per configuration)? | Not defined in source. |
| OQ-4 | What compression algorithm, ratio, or target file size is required? | Not defined in source. |
