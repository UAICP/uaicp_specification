# UAICP Adapter Contract

This contract defines the minimum interface for integrating a framework runtime with UAICP invariants.

## Adapter Interface

Required methods:

- `to_uaicp_request(input) -> MessageEnvelope`
- `invoke_tool(call) -> EvidenceObject`
- `run_verifiers(context) -> VerificationReport`
- `emit_audit(event) -> void`

## Behavioral Requirements

- Adapters must not bypass invariant checks.
- Adapters must propagate `request_id` and `trace_id`.
- Adapters must map framework-native errors to UAICP reason codes.

## Error Mapping

Minimum reason codes:

- `EVIDENCE_MISSING`
- `VERIFICATION_FAILED`
- `POLICY_BLOCKED`
- `APPROVAL_REQUIRED`
- `TOOL_TIMEOUT`

## Compatibility

Adapters may expose framework-specific extensions in namespaced fields.

Example:

- `framework.langgraph.node_id`
- `framework.autogen.agent_name`
