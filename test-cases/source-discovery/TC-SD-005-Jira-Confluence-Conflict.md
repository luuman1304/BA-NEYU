# TC-SD-005 — Jira and Confluence Lifecycle Conflict

## Skills Under Test

- BA Source Discovery
- BA Current State Analyzer handoff

## Source Conditions

- An authoritative Confluence baseline documents behavior A.
- A later Jira CR proposes behavior B.
- The Jira CR has no confirmed production release evidence.

## Expected Source Discovery Behavior

- Select the accessible Confluence baseline for Current State validation.
- Select or relate the Jira CR as a potentially relevant change source based on inspected content.
- Preserve the lifecycle and release metadata gap.
- Do not decide Current Production State solely from recency.

## Expected Current State Behavior

- Classify behavior A as the Documented Baseline and, when its production authority is sufficiently supported, Current Production State.
- Classify behavior B as a Pending Change or Implemented but unverified production change according to available evidence.
- Set Jira `Release Status: Unknown` when release evidence is insufficient.
- Record the differing behaviors without silently replacing or merging them.

## Forbidden Behavior

- Do not apply "newest Jira ticket wins."
- Do not treat Jira `Done` as automatic production release.
- Do not treat the most recently edited Confluence page as automatically authoritative without assessing its metadata.
- Do not convert behavior B into Current Production State without sufficient release evidence.

## Pass Criteria

Behavior A remains the supported Current Production State, behavior B remains pending or production-unverified, and the conflict/lifecycle distinction is retained in the handoff and analysis.
