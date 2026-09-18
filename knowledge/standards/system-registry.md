# System Registry

This registry is the single source of truth for identifying a system from a user request and resolving its Jira summary pattern and local knowledge path.

| System Key | System Name | Aliases | Jira Summary Pattern | Knowledge Path |
|---|---|---|---|---|
| LTX | Latam Express | LTX, Latam Express | `[LTX]` | `knowledge/systems/LTX` |
| TMS | Telesale Management System | TMS, Telesale, Telesale Management System | `[TMS]` | `knowledge/systems/TMS` |
| RMS | Rescue Management System | RMS, Rescue, Rescue Management System | `[RMS]` | `knowledge/systems/RMS` |
| WFO | Workforce Optimization | WFO, Workforce Optimization | `[WFO]` | `knowledge/systems/WFO` |
| WFM | Workforce Management System | WFM, Workforce Management System | `[WFM]` | `knowledge/systems/WFM` |
| AFS | Affscale | AFS, Affscale | `[AFS]` | `knowledge/systems/AFS` |
| AQM | Automated Quality Management | AQM, Automated Quality Management | `[AQM]` | `knowledge/systems/AQM` |

## System Resolution Rules

1. Match the request against the registered System Key, System Name, or Aliases. Matching is case-insensitive.
2. Resolve a match to the canonical System Key in this registry.
3. Use the canonical row to obtain the Jira Summary Pattern and Knowledge Path.
4. Do not infer or create a system, name, alias, Jira pattern, or path that is not registered here.
5. If no entry resolves, return `UNKNOWN_SYSTEM_KEY` and do not perform guessed system-scoped discovery.

## Discovery Rules

1. Jira discovery must start with the resolved row's Jira Summary Pattern, then allowed issue types, then feature relevance, candidate-content inspection, and evidence selection.
2. The default Jira issue types are Story, CR, and Task.
3. Primary evidence must match the resolved system. A different system may be used only when inspected content explicitly documents an integration or dependency; classify it as `CROSS_SYSTEM_SUPPORTING_SOURCE` and do not merge its requirements into the target system.
4. Confluence discovery must use both the resolved System Key and System Name before applying feature or module terms.
5. Local discovery must use only the resolved Knowledge Path.
6. A generic feature-keyword match does not establish system ownership.

## Extension

Add or change a row only after the System Key, System Name, Aliases, Jira Summary Pattern, and Knowledge Path are confirmed. Preserve existing mappings unless an authoritative source explicitly changes them. Do not duplicate the complete mapping in BA skills; skills must reference this registry.
