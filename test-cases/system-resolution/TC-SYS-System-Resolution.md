# System Resolution Regression Tests

## Source Under Test

`knowledge/standards/system-registry.md`

Matching is case-insensitive. Expected values must come from the canonical registry row.

| Test Case | Input | Expected System Key | Expected System Name | Expected Jira Pattern |
|---|---|---|---|---|
| TC-SYS-001 | Latam Express | LTX | Latam Express | `[LTX]` |
| TC-SYS-002 | Telesale Management System | TMS | Telesale Management System | `[TMS]` |
| TC-SYS-003 | Rescue Management System | RMS | Rescue Management System | `[RMS]` |
| TC-SYS-004 | Workforce Optimization | WFO | Workforce Optimization | `[WFO]` |
| TC-SYS-005 | Workforce Management System | WFM | Workforce Management System | `[WFM]` |
| TC-SYS-006 | Affscale | AFS | Affscale | `[AFS]` |
| TC-SYS-007 | Automated Quality Management | AQM | Automated Quality Management | `[AQM]` |
| TC-SYS-008 | ABC | `UNKNOWN_SYSTEM_KEY` | N/A | N/A |
| TC-SYS-009 | TMS | TMS | Telesale Management System | `[TMS]` |
| TC-SYS-010 | WFO | WFO | Workforce Optimization | `[WFO]` |
| TC-SYS-011 | WFM | WFM | Workforce Management System | `[WFM]` |

## Pass Criteria

- Exactly seven canonical rows exist.
- System Keys, Jira Summary Patterns, and Knowledge Paths are unique.
- Every listed alias resolves case-insensitively to its canonical row.
- All eleven test cases return the expected result.
- `Workforce Optimization` resolves only to WFO.
- `Workforce Management System` resolves only to WFM.
- Unknown input returns `UNKNOWN_SYSTEM_KEY` and does not create a mapping.
