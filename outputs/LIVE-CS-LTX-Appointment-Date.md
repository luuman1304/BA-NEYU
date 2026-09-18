# Current-State Analysis

## 1. Request Context

Requested investigation: Check the current behavior of Appointment Date for Latam Express (LTX), especially the LM Order List and FFM Order List.

System: Latam Express  
System Key: LTX  
GEO: Not specified  
Modules: LM and FFM  
Screens: LM Order List and FFM Order List  
Field: Appointment Date  
Analysis mode: Read-only; no Jira or Confluence content was modified.

The analysis distinguishes documented behavior from Production behavior. Jira status or resolution `Done` is not treated as release evidence.

## 2. Source Discovery Handoff

The live `ba-source-discovery` run resolved `Latam Express` to the confirmed registry key `LTX` and searched Jira using summary pattern `[LTX]`, limited to Story, CR, and Task. Candidates were ranked using `Appointment Date`, `Appointment`, `LM`, `FFM`, and `Order List`.

### Selected sources passed to Current-State Analyzer

1. Jira [TM-8570](https://accelo-tech.atlassian.net/browse/TM-8570) - `[LTX] Improve UI/UX`.
2. Jira [TM-8739](https://accelo-tech.atlassian.net/browse/TM-8739) - `[LTX][Order List (LM)] Hide Time in Appointment Date Column`.
3. Jira [TM-8797](https://accelo-tech.atlassian.net/browse/TM-8797) - `[LTX][FFM & LM Order List] Add Appointment Date and Display All Status Options`.

No Confluence page or local file qualified as `SELECTED` Appointment Date evidence. Confluence and local results were retained as discovery context only.

## 3. Sources Reviewed

| Source | Type | Status / Version | Relevant scope | Authority and lifecycle notes |
|---|---|---|---|---|
| [TM-8570](https://accelo-tech.atlassian.net/browse/TM-8570) | Jira Task | Done / resolution Done; created 2026-07-15; updated 2026-07-19; no fix version | LM Order List column | Independently retrieved. The content says to add Appointment Date to LM Order List, gives its column position, and marks the row `Done`. Approval, effective date, release, and deployment are Unknown. |
| [TM-8739](https://accelo-tech.atlassian.net/browse/TM-8739) | Jira Task | Done / resolution Done; created and updated 2026-08-17; no fix version | LM display and LM exported files | Independently retrieved. Contains explicit Current Behavior, Expected Behavior, and acceptance criteria. Approval, effective date, release, and deployment are Unknown. |
| [TM-8797](https://accelo-tech.atlassian.net/browse/TM-8797) | Jira CR | Done / resolution Done; created 2026-08-24; updated 2026-08-26; no fix version | FFM and LM Order Lists | Independently retrieved. Contains explicit Current Behavior, Expected Behavior, and acceptance criteria. Approval, effective date, release, and deployment are Unknown. |
| [Phase 2: MVP](https://accelo-tech.atlassian.net/wiki/spaces/LE/pages/1355448351/Phase+2+MVP) (1355448351) | Confluence requirements page | Page status current; version 20; updated 2026-07-14 | FFM and LM Order List baseline | RELATED discovery context only. Independently retrieved; no Appointment Date text was found. Approval and effective status are Unknown. Absence of the field from this page is not proof that the behavior does not exist. |
| [BRD Latam Express](https://accelo-tech.atlassian.net/wiki/spaces/LE/pages/1351974923/BRD+Latam+Express) (1351974923) | Confluence BRD | Page status current; version 16; updated 2026-06-29 | LTX baseline | UNVERIFIED discovery context only. Metadata was retrieved, but the returned page body was empty. Title and metadata are not requirement evidence. |
| `knowledge/systems/LTX/` | Local knowledge | Path exists; zero files | LTX | No local BRD, CR, Decision, or Specification evidence was available. |

## 4. Source Lifecycle Assessment

### Documented Baseline

| Conclusion | Classification | Supporting source |
|---|---|---|
| The LM Order List has an Appointment Date column. | Confirmed Requirement as a documented baseline, not confirmed Production state. | TM-8739 explicitly states in Current Behavior that the Appointment Date column displays date and time. TM-8570 also documents adding the column to LM Order List. |
| The documented LM baseline displayed Appointment Date as date and time in `YYYY-MM-DD HH: MM` format. | Confirmed Requirement as a documented baseline, not confirmed Production state. | TM-8739, Current Behavior. |
| The documented FFM baseline did not display Appointment Date on the FFM Order List. | Confirmed Requirement as a documented baseline, not confirmed Production state. | TM-8797, Business Context and Current Behavior. |
| The earlier documented LM column order placed Appointment Date after Updated Date and before Open Batch. | Confirmed Requirement as earlier documented behavior, not confirmed Production state. | TM-8570, item 5. |

### Pending Changes

No selected source is in an explicitly open or proposed workflow state. TM-8570, TM-8739, and TM-8797 are all marked `Done`; however, that does not prove release. Their change content is therefore classified below as implemented or completed workflow indications with unverified Production deployment, rather than as confirmed Released Changes.

### Implemented but Unverified Production Changes

| Documented change | Classification | Supporting source |
|---|---|---|
| LM Appointment Date should display only the date in `YYYY-MM-DD` format on the LM List and in exported files; time is hidden from the UI. | Confirmed Requirement; implementation/completion indicated, Production unverified. | TM-8739 Expected Behavior and Acceptance Criteria; Jira status and resolution are Done, with no release evidence. |
| Hiding LM time must not modify the stored Appointment Date value or existing business logic. | Confirmed Requirement; implementation/completion indicated, Production unverified. | TM-8739 Acceptance Criteria. |
| FFM Order List should add an Appointment Date column using the same data source, value, display format, and logic as LM. | Confirmed Requirement; implementation/completion indicated, Production unverified. | TM-8797 Expected Behavior and AC1; Jira status and resolution are Done, with no release evidence. |
| FFM and LM should display a consistent Appointment Date for the same DO. | Confirmed Requirement; implementation/completion indicated, Production unverified. | TM-8797 Expected Behavior and AC1. |
| FFM Appointment Date should be blank when the DO has no Appointment Date. | Confirmed Requirement; implementation/completion indicated, Production unverified. | TM-8797 Expected Behavior and AC1. |

### Released Changes

No Appointment Date change is confirmed as released.

TM-8570, TM-8739, and TM-8797 have no fix version, release date, deployment record, or linked release evidence in the retrieved fields. Their `Done` status and `Done` resolution are insufficient to classify them as Released.

### Current Production State

| Production question | Conclusion | Supporting source |
|---|---|---|
| Does LM currently show Appointment Date in Production? | Unknown. The documented baseline says the column exists, but Production deployment is not confirmed. | TM-8739 and TM-8570 document the column; neither provides release evidence. |
| Does LM Production display date and time or date only? | Unknown. TM-8739 documents date-and-time as Current Behavior and date-only as the change, but its Production release is not confirmed. | TM-8739. |
| Does the LM Production export show date only? | Unknown. Date-only export is documented as acceptance criteria, but release is not confirmed. | TM-8739. |
| Does FFM currently show Appointment Date in Production? | Unknown. TM-8797 documents absence as its baseline and addition as its change, but release is not confirmed. | TM-8797. |
| Are FFM and LM currently consistent for the same DO in Production? | Unknown. Consistency is a documented change requirement without confirmed release evidence. | TM-8797. |

No Current Production behavior can be confirmed from the accessible sources.

### Unknown / Unverified Behavior

| Behavior | Finding | Source / gap |
|---|---|---|
| Actual Appointment Date data source or system of record | **Not defined in source.** TM-8797 says FFM must reuse LM's source but does not identify it. | TM-8797. |
| Stored data type and timestamp semantics | **Not defined in source.** | TM-8739 only says the stored value is unchanged. |
| Timezone used for storage or display | **Not defined in source.** | No selected source defines timezone behavior. |
| LM null or blank display behavior | **Not defined in source.** | TM-8797 defines blank behavior for FFM only. |
| Appointment Date editability | **Not defined in source.** | No selected source defines editing behavior. |
| Appointment Date filters, sorting, or search | **Not defined in source.** | No selected source defines these list behaviors. |
| Roles and permissions controlling field visibility | **Not defined in source.** | Sources name FFM and LM users but do not define field-level permission rules. |
| Legacy or existing DO handling | **Not defined in source.** | No selected source specifies backfill or legacy-data treatment. |
| Production deployment and effective date | Unverified. | No fix version, deployment evidence, approved effective date, or release mapping was available for the selected Jira issues. |
| BRD authority for Appointment Date | Unverified. | BRD Latam Express body was empty in retrieval. |

### Source Conflicts

No direct semantic conflict was found among the selected Jira requirements:

- TM-8570 documents addition of the LM column.
- TM-8739 later documents that LM displays the column with date and time and defines a date-only change.
- TM-8797 later defines FFM alignment with LM.

There is a lifecycle ambiguity, not a resolved conflict: TM-8797 refers to the display format "currently applied" on LM, while TM-8739 changed that format shortly beforehand. Without release evidence, it is unknown whether the LM reference at Production time was date-and-time or date-only. The newest Jira issue cannot resolve this ambiguity by recency alone.

## 5. Confirmed Current State

Only documented baseline can be confirmed; Production state cannot.

### LM Order List

| Confirmed finding | Supporting source |
|---|---|
| Appointment Date is documented as an LM Order List column. | TM-8739 Current Behavior; TM-8570 item 5. |
| The documented pre-change display includes date and time in `YYYY-MM-DD HH: MM`. | TM-8739 Current Behavior. |
| An earlier source places the column after Updated Date and before Open Batch. | TM-8570 item 5. |

### FFM Order List

| Confirmed finding | Supporting source |
|---|---|
| Appointment Date is documented as absent from the FFM Order List before the TM-8797 change. | TM-8797 Business Context and Current Behavior. |

These are source-grounded documented baselines only. They are not claims about current Production behavior.

## 6. Existing Rules and Constraints

| Dimension | Confirmed rule or constraint | Lifecycle | Source |
|---|---|---|---|
| LM display format | Appointment Date is required by the change to display as `YYYY-MM-DD`; time is hidden from the UI. | Implemented/completed indication; Production unverified | TM-8739. |
| LM export format | Appointment Date is required by the change to display as `YYYY-MM-DD` in exported files. | Implemented/completed indication; Production unverified | TM-8739. |
| Stored value | The formatting change must not modify the stored Appointment Date value. | Implemented/completed indication; Production unverified | TM-8739. |
| Existing logic | The formatting change must not modify existing Appointment Date business logic. | Implemented/completed indication; Production unverified | TM-8739. |
| FFM mapping | FFM must use the same data source, value, display format, and logic as LM. | Implemented/completed indication; Production unverified | TM-8797. |
| Cross-screen consistency | FFM and LM must show a consistent Appointment Date for the same DO. | Implemented/completed indication; Production unverified | TM-8797. |
| FFM null behavior | FFM must display blank when no Appointment Date is available. | Implemented/completed indication; Production unverified | TM-8797. |

All other applicable calculation, timezone, permission, editability, filtering, sorting, search, validation, and legacy-data rules are **Not defined in source.**

## 7. Reference-to-Target Comparison

TM-8797 uses LM Appointment Date as the reference implementation and FFM Order List as the target.

| Dimension | LM reference | FFM target | Evidence status |
|---|---|---|---|
| Field availability | Documented as present on LM. | Documented as absent before TM-8797; addition required by TM-8797. | TM-8739, TM-8570, TM-8797. Production unverified. |
| Display format | Date-and-time is documented as the TM-8739 baseline; date-only is the TM-8739 change. | Must match the LM display format. | TM-8739 and TM-8797. Which LM format is in Production is Unknown. |
| Data source and value | Actual source is not identified. | Must use the same source and value as LM. | TM-8797; actual mapping is **Not defined in source.** |
| Missing value | LM null behavior is not defined. | Blank when unavailable. | TM-8797 defines FFM only. |
| Same-DO consistency | No separate LM rule is stated. | FFM and LM values must be consistent for the same DO. | TM-8797. Production unverified. |

## 8. Gaps and Conflicts

| Gap or ambiguity | Impact | Required resolution |
|---|---|---|
| No release or deployment evidence for selected Jira issues | Prevents any claim about Current Production behavior. | Obtain a released fix version, deployment record, release note linked to the issues, or authoritative Production verification. |
| BRD Latam Express body was empty on retrieval | Prevents validation against the highest-priority baseline document. | Obtain accessible BRD content or confirm that the page is only a container. |
| Phase 2: MVP has no Appointment Date text | It cannot confirm or refute the Jira Appointment Date behavior. | Obtain an approved Appointment Date specification or decision record if one exists. |
| LM format referenced by TM-8797 is lifecycle-dependent | FFM's intended matching format could refer to date-and-time or date-only. | Confirm the effective/released LM format at the time TM-8797 was implemented. |
| No local LTX source files | No local fallback can corroborate external sources. | No action is required unless local evidence is expected; enterprise sources need not be copied locally. |

## 9. Assumptions

None. No unverified behavior is used as a Current State fact.

## 10. Recommendations

- Verify deployment or release evidence for TM-8570, TM-8739, and TM-8797 before using their expected behavior as Current Production State.
- Obtain an accessible approved BRD/specification section for Appointment Date or a confirmed Production observation if Production behavior is needed.
- Keep LM and FFM Production conclusions separate until the effective LM display format and TM-8797 deployment are confirmed.

## 11. Open Questions

1. Were TM-8570, TM-8739, and TM-8797 deployed to Production? If yes, in which release and on what effective date?
2. What Appointment Date format is currently effective on the LM Order List in Production: date-and-time or date-only?
3. Does the FFM Order List currently display Appointment Date in Production?
4. What is the authoritative data source, timezone, and null behavior for LM Appointment Date?
5. Is there an approved Appointment Date BRD, specification, or decision page that was not returned by Confluence search?

## 12. Readiness Decision

**PARTIAL**

Supported analysis scope:

- Documented LM and FFM baselines.
- Documented Appointment Date formatting, consistency, and blank-value change requirements.
- Identification of implementation/completion indications in Jira.

Unsupported scope:

- Current Production State.
- Released Changes.
- Actual data-source mapping, timezone, permissions, filter/sort/search behavior, editability, and legacy-data handling.

Required additional evidence:

- Release or deployment evidence for the selected Jira issues.
- Accessible approved Appointment Date documentation or authoritative Production verification.

No BRD or CR was generated.
