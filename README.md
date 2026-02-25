# UAICP Specification

UAICP stands for **Universal Agent Integrity & Control Protocol**.

UAICP is an open reliability contract for agentic workflow execution. It standardizes the control layer that makes systems **correct or explicitly uncertain** instead of silently wrong.

UAICP is an open-source contribution initiated by **Prismworks AI** ([prismworks.ai](https://prismworks.ai)) and developed with community contributions.

## What UAICP Solves

Enterprise agent workflows fail in predictable ways:

- claims delivered without verifiable evidence
- verification steps skipped under latency or orchestration pressure
- unauthorized or weakly controlled write actions
- weak audit trails that cannot support incident review or compliance

UAICP addresses this with mandatory runtime contracts for:

- deterministic state transitions
- evidence-gated delivery
- machine-readable verification reports
- risk-tiered policy controls for writes
- replayable audit events

## Why UAICP Is a Separate Layer

UAICP is intentionally decoupled from frameworks such as LangGraph, Microsoft Agent Framework, AutoGen, CrewAI, and similar orchestration stacks.

Those frameworks solve workflow composition and agent runtime concerns. UAICP solves reliability governance.

This separation keeps UAICP:

- framework-neutral and model-neutral
- portable across vendor stacks
- usable as a common conformance contract in mixed environments

## How UAICP Plays With Existing Frameworks

UAICP does not replace your current framework. It wraps execution with enforceable gates.

1. Map framework context to UAICP envelope contracts.
2. Normalize tool outputs into UAICP evidence objects.
3. Run mechanical verifiers and emit verification reports.
4. Enforce UAICP invariants before delivery or side effects.

See adapter details in [docs/integration-guides/ADAPTER-CONTRACT.md](docs/integration-guides/ADAPTER-CONTRACT.md).

## Scope

In scope:

- protocol/specification and normative invariants
- schema contracts
- conformance test definitions
- reference implementation primitives (separate repo)

Out of scope:

- building a monolithic agent framework
- replacing model APIs or orchestrator runtimes
- commercial managed services and enterprise delivery

## Project Status

- Protocol status: `v0.1-draft`
- Built so far:
  - baseline spec and invariants
  - core schema contracts
  - baseline compliance test definitions
  - initial reference implementation primitives
- Next to build:
  - machine-readable conformance harness
  - reliability maturity levels
  - additional adapter test fixtures and external conformance reports

Roadmap and implementation details:

- [PROJECT-ROADMAP.md](PROJECT-ROADMAP.md)
- [docs/specification/implementation-plan.md](docs/specification/implementation-plan.md)
- GitHub roadmap tracker: https://github.com/UAICP/uaicp_specification/issues/16

## Contributor Entry Points

- start from [CONTRIBUTING.md](CONTRIBUTING.md)
- pick a workstream issue in the GitHub issue tracker
- link all protocol behavior changes to spec + schema + tests updates

## Repository Layout

- `docs/specification/` - normative specification and rationale
- `docs/integration-guides/` - framework adapter and runtime integration patterns
- `docs/examples/` - production-style workflow examples
- `schema/` - JSON schemas for envelope, evidence, and verification contracts
- `tests/` - conformance test definitions
- `governance/` - project governance and contribution process

## Start Here

1. Read [docs/specification/why-now.md](docs/specification/why-now.md).
2. Read [docs/specification/specification.md](docs/specification/specification.md).
3. Implement adapters using [docs/integration-guides/ADAPTER-CONTRACT.md](docs/integration-guides/ADAPTER-CONTRACT.md).
4. Validate behavior with [tests/COMPLIANCE-TESTS.md](tests/COMPLIANCE-TESTS.md).

## License

- Code and repository artifacts: Apache-2.0
- Specification docs and schema content: CC BY 4.0
- Attribution details: see `NOTICE`
