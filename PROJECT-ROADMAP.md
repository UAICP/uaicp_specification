# UAICP Roadmap

## Goal

Deliver a practical, adoptable reliability contract for agentic workflows that can be implemented under existing frameworks.

## Phase 1: Contract Baseline (Current)

- finalize v0.1 state machine semantics
- finalize evidence + verification schemas
- publish conformance test set for read-only and low-risk writes
- stabilize reference implementation primitives in `uaicp-reference-impl`

Exit criteria:

- spec sections marked normative/informative
- schemas versioned and testable
- at least one end-to-end conformance run documented

## Phase 2: Adapter Adoption

- publish framework adapter examples (LangGraph, AutoGen, CrewAI, OpenAI Agents SDK)
- publish migration guide from prompt-only tool use to invariant-gated execution
- add policy profile examples for regulated workflows

Exit criteria:

- adapters execute conformance tests
- clear implementation path for existing orchestrators

## Phase 3: Reliability Maturity

- add replay and audit trace interoperability guidance
- define optional conformance levels for high-risk write actions
- publish reliability SLO guidance and reporting templates

Exit criteria:

- multiple independent implementations pass baseline conformance
- repeatable audit trace format demonstrated

## Non-Goals

- building a monolithic agent framework
- replacing model APIs
- embedding commercial-only operational features in protocol core
