# UAICP Implementation Plan

## Objective

Deliver a small, enforceable protocol core that can be dropped under existing framework runtimes to provide deterministic reliability controls.

## Implementation Principles

- protocol first, framework adapters second
- deterministic checks over prompt-only expectations
- backward-compatible schema evolution where possible
- issue-driven work with explicit acceptance criteria

## Workstreams and Outputs

## 1. Specification Hardening (`workstream/spec`)

Outputs:

- normative/informative boundary cleanup in core spec
- invariant catalog with stable IDs
- compatibility and deprecation policy for `v0.1`

Done:

- baseline state machine and invariant sections

Remaining:

- finalize invariant ID convention
- finalize reason-code taxonomy

## 2. Schema Contracts (`workstream/schema`)

Outputs:

- stable `message-envelope`, `evidence-object`, `verification-report` schemas
- extension rules for namespaced fields
- schema test fixtures for conformance tooling

Done:

- initial JSON schemas published

Remaining:

- compatibility test fixtures
- example extension pack and validation guidance

## 3. Conformance Harness (`workstream/conformance`)

Outputs:

- machine-readable test definitions per invariant category
- structured conformance report format
- baseline reference test runner contract

Done:

- baseline compliance categories documented

Remaining:

- executable harness spec
- sample run output artifacts

## 4. Adapter Guidance (`workstream/adapters`)

Outputs:

- adapter contract and framework-specific examples
- mapping templates for runtime context/evidence/verifier hooks
- migration guide from prompt-only execution to invariant-gated execution

Done:

- initial adapter examples for major frameworks

Remaining:

- operational hardening examples
- adapter conformance walkthroughs with test artifacts

## 5. Project Operations (`workstream/docs`)

Outputs:

- public roadmap and status updates
- contribution map by workstream
- issue templates aligned to roadmap execution

## Milestones

- M1: `v0.1` spec + schema freeze candidate published
- M2: conformance harness contract and sample report published
- M3: first external adapter conformance report published
- M4: reliability maturity profile proposal (`L1/L2/L3`) published

## Success Criteria

- contributors can pick work directly from issues by workstream label
- protocol changes are traceable to spec + schema + test updates
- adopters can implement baseline conformance without framework lock-in

## Issue Tracker

Roadmap tracking issue:

- https://github.com/UAICP/uaicp_specification/issues/16
