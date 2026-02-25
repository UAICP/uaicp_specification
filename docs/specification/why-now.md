# Why UAICP Now

Agentic systems are moving from assistive chat to workflow execution with side effects.

That shift creates a gap:

- models are probabilistic
- production workflows require deterministic control

UAICP addresses this by specifying reliability controls that are enforceable by runtime code.

## Core Problem

Prompting an LLM to "use tools when needed" is not a safety guarantee.

Failure modes:

- skipped tool calls and stale assumptions
- hallucinated claims without evidence
- unverified writes to production systems
- no replayable audit of how a decision was made

## UAICP Response

UAICP standardizes the minimum contract required for trustworthy execution:

- deterministic state transitions
- evidence-gated delivery
- machine-verifiable verification reports
- policy gates for write actions
- fail-safe behavior when verification is missing

## Outcome Model

UAICP optimizes for:

- **correct** output when evidence and verification pass
- **explicitly uncertain** output when they do not

It does not optimize for autonomous behavior at any cost.
