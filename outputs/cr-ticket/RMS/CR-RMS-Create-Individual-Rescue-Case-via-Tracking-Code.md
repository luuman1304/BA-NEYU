# [RMS][Peru] Create Individual Rescue Case Using Tracking Code

## Description

### Applied GEO

Peru (LATAM)

### Business Context / Purpose

The Peru Last-Mile (LM) partner in Lima operates using Tracking Code only. The current manual Rescue Job creation form does not accept Tracking Code as a search/creation input, which prevents Peru users from creating an individual rescue case using the identifier their LM partner provides.

### Current Behavior

On the "All Rescue" page, the user clicks "New Rescue Job," which opens a form with exactly two input fields:

- **DO ID** (text input)
- **DO Code** (text input)

The user may input one field or both:

- If only one field is filled, the system searches and returns records matching that value.
- If both fields are filled, the system applies an AND condition and returns records matching both DO ID and DO Code.
- If the entered value(s) do not match any existing record, an error message is displayed prompting the user to verify the information.

The "Search information" button is disabled when both fields are empty, and enabled when at least one field is filled. Only a Team Leader (TL) can create a Rescue Job through this form; CS cannot.

After a DO match is found, the user selects Last-mile status and Last-mile sub-status before the "Create" button becomes active.

Tracking Code already exists as a stored data attribute on the related Delivery Order and is displayed (read-only) in the Rescue Job detail's "Related DO" section, alongside DO code, DO ID, and SO ID — it is not currently exposed as a search/creation input on the New Rescue Job form.

*Sources: Jira TM-6347 "[RMS][Create] TL can create a new rescue job with new UI"; Confluence "User Guide RMS 2.0" §4.2.3 and §5.3.*

**Peru-specific context (not part of the creation-form baseline itself):** Peru runs a simplified RMS version — no rescue approval workflow, no create-new-SO, no discount/payment-method change, no Pre-delivery module (TM-8040) — and today auto-creates Rescue Jobs via Packed Time + SLA or DO Status = Delivery Failed (TM-8110), a separate automatic path from the manual form described above. Whether the manual "New Rescue Job" form is currently enabled/used in Peru's production deployment is **not confirmed by any reviewed source** (see Open Questions).

### Expected Behavior

Add an option to create an individual rescue case using **Tracking Code**, in addition to the existing DO ID / DO Code options, on the New Rescue Job form.

The exact field placement, and how Tracking Code combines with DO ID/DO Code in the search/match logic (e.g., OR-matched alongside the existing two fields, or an independent input), are **not yet defined** — see Open Questions. This CR does not assume or specify that logic.

## User Story

As a Team Leader (Peru RMS),
I want to create an individual rescue case using the Tracking Code provided by the LM partner,
So that I can create rescue cases without needing the DO ID or DO Code, which our Lima LM partner does not provide.

## Business Rules

- Not defined in source. The matching/validation rule for Tracking Code (e.g., exact match, combination with DO ID/DO Code) requires confirmation before implementation — see Open Questions.

## Acceptance Criteria

Not finalized. Acceptance criteria depend on resolving Open Questions Q2 and Q3 below (Tracking Code's authoritative source, and its search/match behavior relative to DO ID/DO Code). Drafting detailed Given/When/Then criteria now would assert unconfirmed behavior as a requirement.

## Other Information

- Reference: Jira [TM-6347](https://accelo-tech.atlassian.net/browse/TM-6347) — current manual rescue job creation UI and logic
- Reference: Jira [TM-8040](https://accelo-tech.atlassian.net/browse/TM-8040) — Peru RMS scope
- Reference: Jira [TM-8110](https://accelo-tech.atlassian.net/browse/TM-8110) — Peru auto-create Rescue Job logic
- Reference: Confluence "User Guide RMS 2.0" §4.2.3, §5.3

## Open Questions / Assumptions

**Open Questions:**

1. Is the manual "New Rescue Job" (TL-initiated) form currently live and used in Peru's production RMS deployment, or does Peru currently rely only on auto-creation?
2. What is the authoritative source/definition of "Tracking Code" for the Peru LM partner in Lima — is it the same Tracking Code field already stored on the DO (per Confluence §4.2.3), or a separate LM-specific identifier that needs to be newly captured/integrated?
3. Should Tracking Code participate in the same OR/AND multi-field search logic as DO ID/DO Code (per current behavior), or does it require its own resolution rule (e.g., mutually exclusive input, always OR'd with the others)?
4. Should the "Search information" activation rule (currently: enabled when at least one of DO ID/DO Code is filled) be extended to also activate on Tracking Code alone?

**Assumptions:** None — all open items above are recorded as questions, not assumed.

---

*Readiness at time of drafting: **PARTIAL** (per Current-State Analysis). Current Behavior above is source-grounded and confirmed. Expected Behavior is limited to the high-level request; detailed acceptance criteria are withheld pending answers to the Open Questions.*
