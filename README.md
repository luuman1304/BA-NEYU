# Business Analyst AI Agent

This repository contains source-grounded skills, reusable knowledge, examples, and test cases for a Business Analyst AI Agent. Its current MVP focuses only on writing or updating Business Requirement Documents and writing Change Request tickets.

## Current MVP Skills

1. BA BRD Writer / Updater
2. BA CR Ticket Writer

No other BA skills are currently implemented.

## Source-Grounding Principle

Every final requirement must be supported by a provided source. The agent must distinguish confirmed requirements from assumptions, recommendations, and open questions. It must not invent formulas, rules, permissions, status transitions, scope, or implementation details. Existing approved document structures take precedence over repository defaults.

## Folder Structure

```text
.
├── AGENTS.md                  # Codex repository instructions
├── CLAUDE.md                  # BA Agent global operating rules
├── .claude/skills/            # Implemented BA skills, references, and examples
├── knowledge/                 # Shared standards, templates, system/domain knowledge, glossary
├── test-cases/                # Skill behavior test scenarios
└── outputs/                   # Generated BA deliverables
```

The `knowledge/standards`, `knowledge/systems`, `knowledge/domain`, and `knowledge/glossary` directories are intentionally empty until approved sources are provided.

## Using a Skill

- Use `ba-brd-writer-updater` to create a new BRD or minimally update an existing BRD.
- Use `ba-cr-ticket-writer` to draft a change request or system-change ticket.
- Supply source documents and identify approval status and recency when known.
- Review Open Questions before treating the output as complete.

## Testing a Skill

1. Select the matching scenario under `test-cases/brd` or `test-cases/cr-ticket`.
2. Run the relevant skill using only the scenario inputs and cited source artifacts.
3. Compare the output with the expected and forbidden behaviors in the test case.
4. Verify grounding, classification, traceability, terminology, and template precedence.
5. If the skill fails, make the smallest relevant change and rerun the same test.

## Adding a New Skill

Add a skill only when explicitly requested:

1. Define its purpose, triggers, inputs, workflow, rules, output contract, quality checks, and failure handling.
2. Create a lowercase, hyphenated folder under `.claude/skills/` with a `SKILL.md` containing YAML frontmatter.
3. Add only necessary references and examples.
4. Add a matching test case.
5. Update this README only after the skill is implemented and tested.

