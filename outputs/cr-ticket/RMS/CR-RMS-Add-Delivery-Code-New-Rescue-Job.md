# [RMS] Add Delivery Code Field to the New Rescue Job Screen

## Description

### Applied GEO

Not specified in the request.

### Business Context / Purpose

Add a "Delivery Code" field to the New Rescue Job screen, positioned next to the existing "DO Code" field, in the same visual style as the existing DO ID and DO Code fields.

### Current Behavior

*(Source: Confluence ["RMS 2.0"](https://accelo-tech.atlassian.net/wiki/spaces/TMSF/pages/799735848/RMS+2.0), page 799735848)*

- On the All Rescue page, a Team Leader (TL) clicks the **"New Rescue Job"** button to open the Rescue Job creation form.
- The form lets the TL search for a Delivery Order (DO) using **DO ID only**, **DO Code only**, or **both** (AND condition).
- The **"Search information"** button is disabled when both DO ID and DO Code are empty, and enabled when either field has a value.
- If the entered values do not match any existing DO, an error message is displayed prompting the user to verify the information.
- Once a matching DO is found, the form displays DO-related data retrieved from TMS: DO Code, Tracking Code, DO ID, SO ID, SO Status, Shipping Status, Carrier, Warehouse, Product Name, Amount, Customer Name.
- No "Delivery Code" field currently exists on this screen, or anywhere else in the RMS/TMS sources reviewed for this CR.

### Expected Behavior

#### 1. Field Addition

- Add a new **Delivery Code** field to the New Rescue Job screen, positioned immediately next to the existing **DO Code** field.
- The Delivery Code field shall use the same visual style (label style and input/display style) as the existing DO ID and DO Code fields.

#### 2. Affected Screens

- Two screens, referenced by the requester via Figma, are in scope:
  - https://www.figma.com/design/ChhI5Om9goI7VOolg1269L/Customer-Engagement?node-id=13492-70126
  - https://www.figma.com/design/ChhI5Om9goI7VOolg1269L/Customer-Engagement?node-id=10962-78166
- Figma is not connected/authorized in this session, so these could not be opened to confirm which specific screen or state each link represents. See Open Questions.

## User Story

As a Team Leader using the New Rescue Job screen,
I want to see the Delivery Code next to the DO Code,
So that I can reference the delivery code alongside the DO information when creating or reviewing a Rescue Job.

## Acceptance Criteria

### AC1 — Display Delivery Code next to DO Code

Given a user is on the New Rescue Job screen,
When the DO Code field is displayed,
Then a Delivery Code field is displayed immediately next to it, styled consistently with the DO ID and DO Code fields.

## Other Information

- Reference BRD: Confluence ["RMS 2.0"](https://accelo-tech.atlassian.net/wiki/spaces/TMSF/pages/799735848/RMS+2.0)
- Figma references (not accessible this session — see Open Questions):
  - https://www.figma.com/design/ChhI5Om9goI7VOolg1269L/Customer-Engagement?node-id=13492-70126
  - https://www.figma.com/design/ChhI5Om9goI7VOolg1269L/Customer-Engagement?node-id=10962-78166

## Open Questions / Assumptions

| # | Question | Why It Matters |
|---|---|---|
| OQ-1 | Figma is not connected in this session, so the two referenced frames could not be viewed. Please confirm which screen/state each link shows (for example: New Rescue Job creation form vs. a detail/list view), or share a screenshot, so the field can be positioned and styled correctly. | The exact layout, screen identity, and styling cannot be confirmed without this. |
| OQ-2 | What is the data source and derivation of "Delivery Code"? Is it retrieved from TMS like the other DO-related fields (DO Code, Tracking Code, etc.), manually entered by the user, or the same value as an existing field such as Tracking Code under a new label? | Not defined in any reviewed source; determines the field's implementation. |
| OQ-3 | Should Delivery Code also function as a search input (like DO ID and DO Code), or is it a display-only field? | Not stated in the request; affects the "Search information" logic. |
| OQ-4 | Is the Delivery Code field read-only or editable? | Not defined in source. |
| OQ-5 | Does this change apply to a specific GEO, or all GEOs where RMS operates? | Not specified in the request. |
