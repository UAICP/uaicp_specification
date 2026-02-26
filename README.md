# UAICP Specification (v0.2)

## Archived Repository

This repository is archived and read-only.

The canonical source has moved to the UAICP monorepo:
- [UAICP/uaicp](https://github.com/UAICP/uaicp)
- [specification/](https://github.com/UAICP/uaicp/tree/main/specification)

UAICP stands for **Universal Agent Integrity & Control Protocol**.

UAICP is an open reliability contract for agentic workflow execution. It standardizes a control layer that forces systems to be **correct or explicitly uncertain**.

UAICP is an open-source contribution initiated by **Prismworks AI** ([prismworks.ai](https://prismworks.ai)) and developed with community contributions.

## v0.2 Release Scope

- baseline specification and invariant model
- schema contracts for envelope, evidence, and verification report
- executable baseline conformance harness (`npm test`)
- adapter contract and framework integration guidance
- reference implementation primitives and finance workflow comparison

## Practitioner Start Path

1. Read the [core specification](docs/specification/specification.md)
2. Implement the [adapter contract](docs/integration-guides/ADAPTER-CONTRACT.md)
3. Validate with [compliance tests](tests/COMPLIANCE-TESTS.md) and `npm test`
4. Compare behavior with the [finance workflow reference fixture](https://github.com/UAICP/uaicp/tree/main/reference-impl/src/examples/finance/workflow-comparison.ts)

## Why UAICP Is a Separate Layer

UAICP is intentionally decoupled from frameworks such as LangGraph, Microsoft Agent Framework style runtimes, AutoGen, CrewAI, and OpenAI Agents SDK.

Frameworks handle orchestration mechanics. UAICP handles deterministic reliability governance.

## How UAICP Integrates

1. map framework context into UAICP envelope
2. normalize runtime artifacts into evidence objects
3. run verifier checks
4. run policy gate checks before high-risk writes
5. deliver only when required gates pass

Start in:

- [docs/integration-guides/ADAPTER-CONTRACT.md](docs/integration-guides/ADAPTER-CONTRACT.md)
- [docs/integration-guides/LANGGRAPH-ADAPTER-EXAMPLE.md](docs/integration-guides/LANGGRAPH-ADAPTER-EXAMPLE.md)

## Contributor Tracking

Post-`v0.2` enhancements are tracked in:

- [Specification Issues](https://github.com/UAICP/uaicp/issues)
- [Roadmap](PROJECT-ROADMAP.md)
- [Implementation Workstream Map](docs/specification/implementation-plan.md)

## Repository Layout

- `docs/specification/` - protocol specification and rationale
- `docs/integration-guides/` - adapter contract and framework examples
- `docs/examples/` - workflow examples
- `schema/` - JSON schema contracts
- `tests/` - conformance test definitions

## License

- Code and repository artifacts: Apache-2.0
- Specification docs and schema content: CC BY 4.0
- Attribution details: see `NOTICE`
