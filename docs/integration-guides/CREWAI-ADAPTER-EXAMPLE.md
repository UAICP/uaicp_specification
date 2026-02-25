# CrewAI Adapter Example

## Mapping

- Crew task execution metadata -> UAICP envelope identity/trace fields
- Tool outputs -> evidence objects
- crew completion status + external checks -> verification report

## Control Point

Wrap final task completion in UAICP `verify -> deliver` transition.

Crew task completion alone is insufficient for delivery when invariants require external evidence.
