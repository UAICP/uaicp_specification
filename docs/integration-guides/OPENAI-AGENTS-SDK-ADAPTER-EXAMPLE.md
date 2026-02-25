# OpenAI Agents SDK Adapter Example

## Mapping

- run context -> UAICP envelope
- function/tool results -> evidence objects
- run output checks -> verification report

## Control Point

The adapter must prevent final output emission if required evidence is missing.

Return structured uncertainty with missing evidence reason codes instead.
