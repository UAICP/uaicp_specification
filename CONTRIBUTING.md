# Contributing to UAICP

Thanks for contributing to UAICP.

## Contribution Priorities

- reliability invariants
- schema quality and compatibility
- conformance test coverage
- reference implementation correctness
- documentation clarity for adopters

## Workflow

1. Open an issue describing the change.
2. Link the change to one or more invariants.
3. Update spec + schema + tests together when behavior changes.
4. Submit a pull request with:
   - design intent
   - compatibility impact
   - verification steps performed

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
