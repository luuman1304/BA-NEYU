# Clarification Rules

## Before Asking the User

1. Search approved local sources (existing BPMN, BRD, CR ticket, current-state analysis).
2. Check relevant system knowledge (`knowledge/systems/{SYSTEM_KEY}/`, `knowledge/domain/`, `knowledge/glossary/`).
3. Check whether the answer can be reliably derived from an already-confirmed source.
4. Identify the exact missing or conflicting information.
5. Explain its impact on the BPMN (which element, flow, or outcome it affects).
6. Ask one or more focused questions — not a generic "any other requirements?".
7. Provide clear options where appropriate (e.g., "Should the default branch be Approved or Rejected when the amount is missing?").

## Ask For Material Ambiguity

Ask when the missing or conflicting information would change:

- Process scope.
- Actor or system responsibility.
- Approval sequence.
- A gateway condition or default branch.
- A success/failure outcome.
- Exception, rejection, cancellation, timeout, or retry handling.
- Manual-vs-automated processing.
- Timer or SLA behavior.
- A data handoff between actors or systems.
- Whether a diagram is As-Is or To-Be.

## Do Not Block For

- Cosmetic naming (task/gateway label wording, as long as it stays verb-object / question-style).
- Exact x/y placement or minor layout choices.
- Nonmaterial layout decisions.
- Default left-to-right orientation.
- Safe technical corrections that do not alter business meaning (e.g., a lint-flagged missing `default` flow where the safer branch is unambiguous from context).

Record minor assumptions made under this rule in the process-analysis report's Assumptions section rather than asking about them.

## Never Invent

Never invent, even to keep the diagram moving:

- Business rules.
- Approval thresholds.
- Approval sequences.
- Permissions.
- Actors.
- Status transitions.
- Formulas.
- SLA values.
- Timer durations.
- Exception handling.
- Integration behavior.
- Notification recipients.
- Production behavior.

When one of these is applicable but undefined in any available source, state **"Not defined in source"** and raise it as an Open Question rather than filling it in.
