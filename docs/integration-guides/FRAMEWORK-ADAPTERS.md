# Framework Adapters

UAICP is designed to run under existing orchestrators.

## Why This Layer Is Separate

Frameworks optimize for workflow composition and runtime ergonomics.
UAICP optimizes for portable reliability controls and conformance.

This separation allows teams to keep their framework investment while applying one reliability contract across heterogeneous stacks.

## Integration Pattern

1. Keep framework planner and tool abstractions.
2. Add UAICP envelope + evidence contracts.
3. Route all writes through UAICP policy gate.
4. Block deliverable output until verifiers pass.

## Supported Adapter Targets (Initial)

- LangGraph
- AutoGen
- CrewAI
- OpenAI Agents SDK

## Expected Deliverables per Adapter

- request mapping table
- evidence mapping table
- verifier integration point
- policy gate hook
- minimal conformance test run

## Frameworks Covered

Initial guides cover:

- LangGraph
- Microsoft Agent Framework style runtimes (via generic adapter contract and OpenAI Agents SDK example)
- AutoGen
- CrewAI
