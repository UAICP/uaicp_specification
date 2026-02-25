# UAICP Specification

UAICP stands for **Universal Agent Integrity & Control Protocol**.

UAICP is an open-source reliability contract for agentic workflows. It defines how orchestration systems enforce evidence, verification, policy gates, and auditability so outputs are **correct or explicitly uncertain**.

## Scope

UAICP does not replace model vendors or agent frameworks.

UAICP standardizes the control layer beneath them:

- state machine phases for execution
- required evidence objects
- verifier report contracts
- risk-tiered action policy
- conformance tests and replayable audit logs

## Boundary: Open Source vs Commercial

UAICP (this repo and related UAICP repos) is the open public adoption layer:

- protocol/specification
- schema contracts
- conformance test definitions
- reference implementation primitives

Commercial implementation services, managed runtime, and enterprise delivery are intentionally outside UAICP.

## Repository Layout

- `docs/specification/` - normative specification and rationale
- `docs/integration-guides/` - framework adapter and runtime integration patterns
- `docs/examples/` - production-style workflow examples
- `schema/` - JSON schemas for envelope, evidence, and verification contracts
- `tests/` - conformance test definitions
- `governance/` - project governance and contribution process

## Current Version

- Protocol status: `v0.1-draft`
- Focus: reliability invariants and conformance harness

## Start Here

1. Read [docs/specification/why-now.md](docs/specification/why-now.md)
2. Read [docs/specification/specification.md](docs/specification/specification.md)
3. Implement adapters using [docs/integration-guides/ADAPTER-CONTRACT.md](docs/integration-guides/ADAPTER-CONTRACT.md)
4. Validate behavior with [tests/COMPLIANCE-TESTS.md](tests/COMPLIANCE-TESTS.md)

## License

- Specification docs and schemas: CC BY 4.0
- Code artifacts: Apache 2.0
