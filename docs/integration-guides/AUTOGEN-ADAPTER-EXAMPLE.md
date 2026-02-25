# AutoGen Adapter Example

## Mapping

- AutoGen task context -> UAICP `MessageEnvelope`
- Tool call result -> UAICP `EvidenceObject`
- Group chat completion -> UAICP `VerificationReport`

## Critical Hook

Before final agent reply, run UAICP invariant check:

- required evidence present
- required verifiers passed
- write policy satisfied

If not satisfied, emit `fail_safe` output with uncertainty.
