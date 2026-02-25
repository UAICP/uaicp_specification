# UAICP Use Cases

## 1. Code Change Workflow

Goal: prevent unverified merges.

Flow:

1. Plan proposed code edits.
2. Execute file/tool operations.
3. Verify with tests + type checks.
4. Deliver only with evidence bundle:
   - changed files
   - test report
   - verifier summary

Fail-safe behavior:

- if tests fail, response is uncertain and no merge action is taken.

## 2. Research Workflow

Goal: prevent uncited factual claims.

Flow:

1. Gather sources via retrieval tools.
2. Normalize evidence objects with source URLs and timestamps.
3. Cross-check and verify required claims.
4. Deliver summary with evidence links.

Fail-safe behavior:

- unresolved claims are labeled uncertain.

## 3. High-Risk Operations Workflow

Goal: prevent unapproved production writes.

Flow:

1. classify action as `write_high_risk`.
2. collect approvals and rollback metadata.
3. execute action with idempotency key.
4. run post-action verifier checks.

Fail-safe behavior:

- without approval token, action is blocked.
