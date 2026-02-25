# UAICP Roadmap

## Goal

Deliver a framework-neutral reliability protocol that enterprise teams can apply to agent systems without replacing existing orchestrators.

## Current Stage

Protocol maturity is `v0.1-draft`.

## Progress Snapshot

### Built

- baseline execution state model and invariant set
- schema contracts for envelope, evidence, and verification reports
- baseline compliance test specification
- initial reference implementation primitives for identity and policy evaluation

### In Progress

- normative wording hardening for `v0.1`
- conformance harness definition for machine-readable pass/fail output

### Not Yet Built

- public conformance runner reference package
- conformance maturity levels (`L1/L2/L3`) and profiles
- external adopter conformance reports and reproducible fixtures

## Phases

## Phase 1: Contract Baseline

Deliverables:

- finalize normative `v0.1` state transition semantics
- freeze required fields in core schemas
- publish baseline conformance criteria for read-only and low-risk writes
- stabilize reference primitives in `uaicp-reference-impl`

Exit criteria:

- spec marks normative vs informative sections consistently
- schema compatibility policy documented
- one end-to-end conformance run artifact published

## Phase 2: Adapter Adoption

Deliverables:

- adapter blueprints for LangGraph, AutoGen, CrewAI, and OpenAI Agents SDK
- migration playbook from prompt-driven tool use to invariant-gated delivery
- policy profiles for regulated workflows

Exit criteria:

- adapter implementations can pass baseline conformance checks
- integration docs include operational tradeoffs and failure handling

## Phase 3: Reliability Maturity

Deliverables:

- replay/audit trace interoperability guidance
- optional conformance levels for higher-risk write actions
- reliability SLO and reporting templates

Exit criteria:

- multiple independent implementations pass baseline conformance
- at least one published audit replay example

## Issue-Driven Execution

Roadmap execution is tracked in GitHub Issues under `UAICP/uaicp_specification`.

Recommended issue labels:

- `roadmap`
- `workstream/spec`
- `workstream/schema`
- `workstream/conformance`
- `workstream/adapters`
- `workstream/docs`
- `good first issue`

All roadmap work should be tracked as issues and linked from related PRs.

Current roadmap tracker:

- https://github.com/UAICP/uaicp_specification/issues/16

## Non-Goals

- building a monolithic agent framework
- replacing model APIs or orchestration runtimes
- embedding commercial managed-service features in protocol core
