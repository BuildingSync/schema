---
applyTo: "proposals/**/*.md"
description: "Format and process for BuildingSync feature proposals"
---

# Writing a proposal

Follow [proposals/README.md](../../proposals/README.md).

- Location: `proposals/<year of submission>/<Title Case Name>.md` (e.g. `proposals/2026/Add Field-assembled DX system to DXSystemType.md`).
- Required sections, in order: `## Overview` (brief summary), `## Justification` (evidence the change is needed and beneficial), `## Implementation` (exact XSD changes: element paths, types, enumerations, documentation text). Optional: `## References`.
- State whether the change is breaking or non-breaking per [docs/versioning.md](../../docs/versioning.md); breaking proposals must discuss severity of the breakage and the migration path.
- Reference the GitHub issue it addresses.
- The proposal and its implementation may be in the same PR or in separate PRs; separate PRs are not required. Either way, the proposal is discussed and accepted/rejected before merge; the project lead decides if no consensus.
- Markdown is formatted by prettier via `poetry run pre-commit run --all-files`.
