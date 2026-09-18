# [RMS][Peru] Enable Agent Create/Import Rescue Case via Permission

## Description

### Applied GEO

Peru (as stated by requester). Whether this is intended as a Peru-only change or the start of a broader rollout is **not defined in source** — see Open Questions.

### Business Context / Purpose

The requester asked that a Customer Support (CS) Agent be able to create and/or import Rescue cases once a permission is enabled for that Agent. No further business driver (e.g., reducing dependency on Team Leader/Manager for case creation, operational urgency in Peru) was stated beyond the requirement itself — see Open Questions.

### Current Behavior

Per the current RMS role/permission baseline:

- **Create a rescue job**: Manager = Yes, Team Leader = Yes, Customer Support = **not granted** (blank in the permission matrix).
- **Import Rescue Job**: a separate, already-implemented feature (accessible from the same "Add Rescue Job" entry point as manual creation, via a distinct "Import Rescue Job" tab) that is independently gated by its own **"Import Rescue Job permission"** — when a user does not hold this permission, the Import Rescue button is not displayed and the feature is inaccessible. The current baseline does not confirm whether this permission can already be granted to the Customer Support/Agent role, or only to Manager/Team Leader.
- **Precedent for permission-gated Agent capability**: a configurable **"Rescue Assignment permission"** already exists and, when granted to a Rescue Agent (LATAM), extends View-All-Rescue and manual-assignment capability to that Agent beyond the base role matrix — confirming the system already supports elevating an Agent's capabilities via a specific, grantable permission rather than only through role reassignment.
- The manual "New Rescue Job" creation form (DO ID / DO Code / Tracking Code, per the Peru-specific search fields) and the "Add Rescue Job" entry point with its two tabs (Create Manual, Import Rescue Job) are already implemented.

*Sources: Jira TM-6449 "[RMS] User can view user management - roles and permissions" (Done) — base permission matrix, "Create a rescue job" row; Jira TM-8516 "[RMS][LATAM] Import Rescue Jobs from Excel" (Done) — Import Rescue Job permission, AC1/AC7, two-tab Add Rescue Job entry point; Jira TM-8526 "[RMS][LATAM] Allow Rescue Agents to View All Rescue Cases and Assign Cases" (Done) — precedent for a configurable permission extending Agent capability beyond the base role matrix; Jira TM-8905 "[RMS][Peru] Create Individual Rescue Case Using Tracking Code" (Done) — Peru manual-creation form fields.*

### Expected Behavior

1. When the configured **Create a rescue job** permission is enabled for a Customer Support/Agent user (Peru), that Agent can manually create a Rescue case using the existing "New Rescue Job" / "Add Rescue Job → Create Manual" flow, unchanged from the current Manager/Team Leader creation logic.
2. When the configured **Import Rescue Job** permission is enabled for a Customer Support/Agent user (Peru), that Agent can access and use the existing "Add Rescue Job → Import Rescue Job" flow, unchanged from the current import logic (template download, row-level validation, success/failure summary, error file).
3. An Agent who does **not** have the respective permission enabled continues to see no Create and/or Import entry point, consistent with the existing permission-gating behavior (per TM-8516 AC7 for Import; equivalent behavior assumed, not separately confirmed, for Create — see Open Questions).
4. All other current Create and Import logic (validation, DO/Tracking Code matching, template columns, status handling, history logging) remains unchanged.
5. Whether enabling Create and/or Import for an Agent also requires or implies enabling the existing "Rescue Assignment permission" (View All Rescue / Assign) is **not defined in source** — see Open Questions.

## User Story

As a Customer Support Agent in Peru with the Create/Import permission enabled,
I want to create or import Rescue cases myself,
So that I do not need to wait for a Team Leader or Manager to create or import cases on my behalf.

## Business Rules

- BR-01: "Create a rescue job" becomes available to a Customer Support/Agent user only when that permission is explicitly enabled for that user; the base role matrix (Manager/Team Leader = Yes, Customer Support = No by default) is otherwise unchanged. *(Source: requester instruction + TM-6449 baseline)*
- BR-02: "Import Rescue Job" becomes available to a Customer Support/Agent user only when that permission is explicitly enabled for that user, using the existing Import Rescue Job permission mechanism. *(Source: requester instruction + TM-8516)*
- BR-03: All existing Create and Import validation, logic, and UI (form fields, template, status handling, error handling) remain unchanged for any user who gains access via this permission. *(Source: TM-8516, TM-8905 — preserved per default BA principle; no source requests a change to existing logic)*
- Not defined in source: whether this permission enablement is Peru-only by design, or a broader-GEO capability being enabled first for Peru — see Open Questions.

## Acceptance Criteria

**AC-01 — Create permission enabled**
Given a Customer Support/Agent user in Peru has the "Create a rescue job" permission enabled,
When the user opens "New Rescue Job" / "Add Rescue Job → Create Manual",
Then the user can create a Rescue case using the existing creation flow and logic, unchanged from current Manager/Team Leader behavior.

**AC-02 — Create permission not enabled**
Given a Customer Support/Agent user in Peru does not have the "Create a rescue job" permission enabled,
When the user attempts to create a Rescue case,
Then the create entry point/action is not available to that user, consistent with current baseline behavior.

**AC-03 — Import permission enabled**
Given a Customer Support/Agent user in Peru has the "Import Rescue Job" permission enabled,
When the user opens "Add Rescue Job → Import Rescue Job",
Then the user can import Rescue cases using the existing import flow and logic (template, validation, success/failure summary, error file), unchanged from current behavior.

**AC-04 — Import permission not enabled**
Given a Customer Support/Agent user in Peru does not have the "Import Rescue Job" permission enabled,
When the user accesses "Add Rescue Job",
Then the Import Rescue Job option/button is not displayed, consistent with TM-8516 AC7.

**AC-05 — Existing logic unchanged**
Given the Create and/or Import permission is enabled for a Customer Support/Agent user,
When that user creates or imports a Rescue case,
Then all other existing Create/Import validation, data handling, and history logging remain exactly as they are today.

## Other Information

- Reference: Jira [TM-6449](https://accelo-tech.atlassian.net/browse/TM-6449) — base role/permission matrix ("Create a rescue job" row)
- Reference: Jira [TM-8516](https://accelo-tech.atlassian.net/browse/TM-8516) — Import Rescue Job feature and its permission gating (AC1, AC7)
- Reference: Jira [TM-8526](https://accelo-tech.atlassian.net/browse/TM-8526) — precedent for a configurable permission extending Agent capability (Rescue Assignment permission)
- Reference: Jira [TM-8905](https://accelo-tech.atlassian.net/browse/TM-8905) — Peru manual rescue-case creation fields (DO ID / DO Code / Tracking Code)

## Open Questions / Assumptions

**Still open (not yet confirmed by requester):**

1. Is the "permission" referenced by the requester for Create the existing base-matrix "Create a rescue job" row (i.e., simply granting it to Customer Support/Agent), or a new, separately named permission analogous to the existing "Rescue Assignment permission"?
2. For Import: can the existing "Import Rescue Job permission" (TM-8516) already be assigned to a Customer Support/Agent user today, or does enabling it for this role require new configuration work?
3. Does enabling Create and/or Import for an Agent also require or imply granting the existing "Rescue Assignment permission" (View All Rescue / Assign), given Create/Import are both accessed from the All Rescue screen's "Add Rescue Job" entry point?
4. Is this change Peru-only, or the first phase of a broader LATAM/all-GEO rollout (consistent with the phased-rollout pattern seen in other recent RMS CRs)?
5. No business driver was stated beyond the requirement itself — confirm the operational purpose (e.g., reducing Team Leader/Manager dependency, coverage during peak hours) for traceability.

**Assumptions:** None — all items above are open, not assumed.

---

*Readiness: **PARTIAL**. The permission-gating mechanism and existing Create/Import UI and logic are confirmed from source (TM-6449, TM-8516, TM-8526, TM-8905), supporting the scope drafted in BR-01–BR-03 and AC-01–AC-05. The exact permission naming/mechanism for Create, Import-permission eligibility for the Agent role today, the Rescue-Assignment-permission dependency, and the Peru-only vs. phased-rollout scope (Open Questions 1–4) are not confirmed and are out of scope for this CR's acceptance criteria until answered.*
