# LangGraph Adapter Example

## Mapping

- graph state -> UAICP workflow state
- node outputs -> evidence candidates
- terminal node -> UAICP deliver gate

## Control Point

Insert a dedicated verification node that evaluates UAICP invariants and routes to:

- `deliver` when pass
- `fail_safe` when fail
