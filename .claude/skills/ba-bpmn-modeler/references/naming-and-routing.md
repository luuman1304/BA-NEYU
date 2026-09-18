# Naming and Routing Rules

## Output Location

Save BPMN files under:

```text
outputs/bpmn/<SYSTEM>/
```

Supported system folders currently include:

```text
AQM
LTX
RMS
TMS
WFM
WFO
```

This list mirrors the existing `outputs/bpmn/` structure and the System Registry (`knowledge/standards/system-registry.md`), which also includes `AFS`. When the registry adds a system, its `outputs/bpmn/<KEY>/` folder may not yet exist — create it only as part of saving that system's first BPMN output, not speculatively.

## Filenames

Use lowercase kebab-case:

```text
<feature-name>-as-is.bpmn
<feature-name>-to-be.bpmn
<feature-name>-subprocess.bpmn
```

Examples:

```text
outputs/bpmn/RMS/rescue-approval-to-be.bpmn
outputs/bpmn/TMS/callback-reminder-to-be.bpmn
outputs/bpmn/WFM/screen-recording-as-is.bpmn
```

## Sidecar Reports

Use these sidecar filenames alongside the `.bpmn` file, in the same system folder, where applicable:

```text
<feature-name>-process-analysis.md
<feature-name>-impact-analysis.md
<feature-name>-validation-report.md
<feature-name>-change-log.md
```

## Versioning

- Do not add version numbers to filenames by default.
- Use Git history and the change log ([../templates/bpmn-change-log-template.md](../templates/bpmn-change-log-template.md)) for version management.

## Ambiguity and User-Specified Paths

- If the system is unknown or ambiguous, ask before saving — do not guess a folder.
- Do not save BPMN files outside `outputs/bpmn/` unless the user explicitly provides another destination; an explicit user-specified path always takes precedence over this convention.
- Never save a generated BPMN or sidecar report under `knowledge/` — that tree is reference-only. Do not promote an output into `knowledge/` unless the user explicitly requests that exact action.

## Test Cases

- BA-deliverable test cases (functional test cases derived from a BRD/CR/BPMN) belong under `outputs/test-cases/`, not at the workspace root.
- The workspace-root `test-cases/` directory is a separate, pre-existing set of internal skill-verification fixtures for the BA skills themselves (e.g., `TC-SD-*`, `TC-CS-*`). Do not write BA deliverables there, and do not create a second test-cases directory anywhere else.
- This skill only reports test-case impact ([impact-analysis-rules.md](impact-analysis-rules.md)); it does not author files under `outputs/test-cases/` unless the user explicitly asks for that separately.
