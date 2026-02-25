# UAICP Implementation Plan

## Objective

Deliver an OSS reliability core that drives adoption and can be embedded under existing orchestration stacks.

## Workstreams

1. **Specification Hardening**
   - finalize normative language
   - freeze v0.1 schema fields
   - document migration guarantees

2. **Reference Runtime Primitives**
   - identity + attestation validation (done)
   - policy evaluation service (next)
   - verification report assembly

3. **Conformance Harness**
   - machine-readable baseline checks
   - pass/fail report format
   - sample traces for replay

4. **Adapter Guidance**
   - framework adapter templates
   - example invariants per workflow class

## Milestones

- M1: spec and schemas stable
- M2: reference implementation passes internal baseline
- M3: first external adopter runbook and conformance report
