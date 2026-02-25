# UAICP Compliance Tests (Baseline)

## Test Categories

1. **State Machine Compliance**
   - all required states implemented
   - invalid transitions rejected

2. **Evidence Gating Compliance**
   - deliver blocked when required evidence missing
   - evidence object matches schema

3. **Verification Compliance**
   - verifier output matches schema
   - deliver blocked on verifier failure

4. **Policy Gate Compliance**
   - write actions categorized by risk tier
   - high-risk write blocked without approval token

5. **Audit Compliance**
   - transitions emit request_id, trace_id, timestamp, outcome

## Pass Criteria

Baseline conformance requires 100% pass rate in all categories.

## Reporting

Implementations should output:

- test run id
- protocol version
- pass/fail per category
- failing invariant ids (if any)
