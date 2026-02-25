# Contributing to UAICP

Thanks for contributing to UAICP.

## Contribution Priorities

- reliability invariants
- schema quality and compatibility
- conformance test coverage
- reference implementation correctness
- documentation clarity for adopters

## Workstreams

Use these workstream labels when opening or selecting issues:

- `workstream/spec`: normative text, invariants, reason codes
- `workstream/schema`: schema contracts and compatibility fixtures
- `workstream/conformance`: conformance harness and report format
- `workstream/adapters`: framework adapter guidance and mappings
- `workstream/docs`: onboarding, roadmap, and contributor docs

Issue labels `roadmap` and `good first issue` are used for prioritization and onboarding.

## Workflow

1. Open an issue describing the change.
2. Link the change to one or more invariants.
3. Update spec + schema + tests together when behavior changes.
4. Submit a pull request with:
   - design intent
   - compatibility impact
   - verification steps performed

## Definition of Done

A contribution is complete when:

- issue scope is satisfied and linked in PR
- related docs/schemas/tests are updated
- CI checks pass
- backward compatibility impact is documented

## Local Private Notes

Use `.private/` for local drafts, customer notes, and internal planning artifacts that should never be published.

Only `.private/.gitkeep` is tracked. Everything else under `.private/` is ignored by git.

## Rules

- No unverifiable claims in normative docs.
- No vendor lock-in language in spec text.
- No behavior that weakens policy-gated writes or evidence gating.

## Required for Protocol Changes

- update `docs/specification/specification.md`
- update relevant `schema/*.json`
- update `tests/COMPLIANCE-TESTS.md`
- provide migration notes if breaking

## Security

If you find a security issue, open a private report with reproducible steps and impact details.
