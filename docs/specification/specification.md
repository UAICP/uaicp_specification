# UAICP Specification (v0.1 Draft)

## 1. Purpose

UAICP defines a reliability contract for agentic workflow execution.

The contract ensures that systems either:

- complete actions with required evidence and verification, or
- fail safe with explicit uncertainty

UAICP is framework-neutral. It standardizes control semantics that can be embedded under existing orchestration frameworks.

## 2. Roles

- **Orchestrator**: deterministic runtime that owns state and transitions.
- **Model**: untrusted planner/summarizer constrained by schemas.
- **Tool**: deterministic side-effecting or read-only function returning evidence objects.
- **Verifier**: mechanical validator that emits structured verification results.

## 3. Execution States

Required state machine phases:

1. `intake`
2. `plan`
3. `execute`
4. `verify`
5. `deliver`
6. `fail_safe`

### 3.1 Transition Rules

- `deliver` is forbidden unless all required invariants evaluate true.
- any invariant failure in `execute` or `verify` transitions to `fail_safe` unless retry policy allows bounded repair.
- retries must be bounded and logged.

## 4. Required Invariants

### 4.1 Evidence Gating

If task class requires evidence type `X`, no deliverable may be produced without valid evidence objects of `X`.

### 4.2 Verification Gating

Required verifiers for task class must complete and report `pass` before `deliver`.

### 4.3 Policy-Gated Writes

Write operations must be categorized by risk tier.

- `read_only`: auto-allowed
- `write_low_risk`: allowed with policy checks
- `write_high_risk`: requires approval token and rollback metadata

### 4.4 Auditability

Every state transition and tool invocation must include:

- `request_id`
- `trace_id`
- timestamp
- actor identity
- outcome

## 5. Contracts

Normative schema set:

- `schema/message-envelope.schema.json`
- `schema/evidence-object.schema.json`
- `schema/verification-report.schema.json`

Implementations may extend schemas with namespaced fields but must not break required fields.

## 6. Fail-Safe Behavior

When invariants are unmet, systems must:

- mark response as `uncertain`
- include missing-evidence reason codes
- avoid unverified side effects

## 7. Conformance

A system is UAICP-conformant at baseline if it:

- implements required state phases
- enforces required invariants before deliver
- emits valid contract objects
- passes baseline checks in `tests/COMPLIANCE-TESTS.md`

## 8. Versioning

- major: breaking contract changes
- minor: backward-compatible contract extensions
- patch: clarifications and errata

## 9. Relationship to Framework Runtimes

UAICP is a decoupled governance layer, not an orchestration framework.

- Framework runtimes own graph/task execution and tool routing.
- UAICP owns invariant enforcement, evidence contracts, verification contracts, and policy gates.
- Implementations may use any model vendor and orchestration stack as long as UAICP conformance is preserved.

This separation is required for portability across enterprise environments with mixed tooling.
