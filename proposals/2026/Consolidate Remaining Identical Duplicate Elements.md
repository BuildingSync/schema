## Overview

This proposal addresses part of [schema#356](https://github.com/BuildingSync/schema/issues/356) by consolidating remaining **identical duplicate element declarations** into shared global elements and local `ref` use sites, while preserving all existing XML names, paths, local context annotations, and cardinality at each use site.

Scope is intentionally limited to pure patch-safe deduplication:

- `Capacity` local duplicates (4) -> shared existing global `auc:Capacity`
- `ControlSystemTypes` local wrappers (3) -> new shared global `auc:ControlSystemTypes`
- General `Controls` local wrappers (19, excluding lighting) -> new shared global `auc:Controls`
- `Other` locals that are exactly `type="auc:OtherType"` (16) -> new shared global `auc:Other`
- `spec/validation_spec.rb` ignored duplicate list cleanup for `Capacity` and `ControlSystemTypes` only

This change is classified as **PATCH** (non-breaking patch-level restructuring). It changes declaration structure only and preserves validation of existing BuildingSync instance documents.

## Justification

The schema currently carries repeated local element declarations that are structurally identical, increasing maintenance burden and duplicate-name exceptions without adding expressive value. Reusing shared global elements:

- reduces duplicate name declarations while preserving instance compatibility,
- keeps context-specific wrapper documentation at ref sites,
- aligns with the long-running duplicate cleanup effort tracked in [#323](https://github.com/BuildingSync/schema/issues/323), [#324](https://github.com/BuildingSync/schema/issues/324), and [#325](https://github.com/BuildingSync/schema/issues/325).

No instance migration is required because element names/paths/cardinality remain unchanged in place.

## Implementation

### Classification

**PATCH**: refactor from local identical declarations to shared globals / refs only.
No element renames, no path moves, no type widening/narrowing, no sequence reordering, no new required content.

### Exact schema edits

Line references below identify the baseline `4f69954`, not the edited schema.

| Element              | Use sites                                                                                                                                    | Shared declaration and preserved constraints                                                                                                                                                                                                                           |
| -------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `Capacity`           | `HeatingSource`, `HeatingPlantType/Boiler`, `HeatingPlantType/DistrictHeating`, `HeatingPlantType/SolarThermal` (L5574, L6374, L6504, L6533) | Reuse the existing global at L12316 unchanged: decimal content with `auc:Source`. Keep each optional use in its choice with `OutputCapacity`, and retain its "Output capacity of equipment." annotation.                                                               |
| `ControlSystemTypes` | `HeatingPlantType`, `CoolingPlantType`, `CondenserPlantType` (L6566, L6749, L7039)                                                           | New global with inline complex type and sequence containing `<xs:element ref="auc:ControlSystemType" minOccurs="0" maxOccurs="unbounded"/>`. Preserve optional wrappers and plant-specific annotations on refs.                                                        |
| General `Controls`   | All 19 wrappers whose child is typed `auc:ControlGeneralType`; exclude the lighting wrapper at L7806                                         | New global with inline complex type and sequence containing local `<xs:element name="Control" type="auc:ControlGeneralType" maxOccurs="unbounded"/>`. The wrapper stays optional, but if present requires at least one control. Preserve use-site wrapper annotations. |
| Empty `Other`        | All 16 declarations typed exactly `auc:OtherType`, including the annotated use at L2883                                                      | New global `Other` typed `auc:OtherType`; refs remain optional. The type remains empty. Preserve the five distinct inline variants, including custom climate-zone and communication-protocol content.                                                                  |

New global documentation is "List of equipment control strategies." for `ControlSystemTypes`,
"List of general equipment or system controls." for `Controls`, and "Other type." for `Other`.
The shared local `Control` child is documented as "General equipment or system control.";
the enclosing ref retains the equipment-specific context.

Do not make `Control` global: that name collides with gbXML. Do not put occurrence attributes on global
declarations. Remove only `Capacity` and `ControlSystemTypes` from `ignored_dupes`.
`Controls` and `Control` each retain two declarations (general and lighting); `Other` retains six.

### Scope exclusions in this proposal

- **CBECS deduplication deferred** pending BuildingSync-website parser work tracked in [website#229](https://github.com/BuildingSync/BuildingSync-website/issues/229).
  The current source implementation (develop at `11f2f6e784463ff4c16092238bd24933366d1163`) still omits named complex types referenced through globals; [schema#474](https://github.com/BuildingSync/schema/issues/474) was closed as transferred and does not indicate deployment resolution.
- `WaterSideEconomizer` widening and semantic renames remain separate work.
- No unions, schema version changes, or changelog changes.

### Quantified impact

- Named declarations: **1585 -> 1528** (**-57**)
- Duplicate names tracked in this effort: **32 -> 30**
- Declarations across those originally duplicated names: **177 -> 120** (still-duplicated-only subtotal: **118**)
- Replaced use sites: **42 total** (`4 + 3 + 19 + 16`)

### Compatibility / downstream notes

- XML instance paths and names are unchanged; no XML migration script needed.
- Generated code bindings may need regeneration/review after declaration consolidation.
- XPath consumers retain the same instance paths. This proposal does not claim a runtime audit of downstream consumers.
- New complex wrappers use inline types; they do not introduce the named-complex-type ref pattern behind website #229. The new `Other` global has an empty type, so has no children to lose.
- Proposal acceptance is required before merge per proposal process.
- PR labels: `Non-breaking Change` and `Schema: General`. This is part of #356, not a resolution of its remaining duplicates.

### Required checks for implementation PR

- `bundle exec rake remove_tabs`
- `bundle exec rake`
- `bundle exec rake generate_data_dictionary`
- `poetry run pre-commit run --all-files`

## References

- https://github.com/BuildingSync/schema/issues/356
- https://github.com/BuildingSync/schema/issues/323
- https://github.com/BuildingSync/schema/issues/324
- https://github.com/BuildingSync/schema/issues/325
- https://github.com/BuildingSync/schema/pull/349
- https://github.com/BuildingSync/schema/issues/474
- https://github.com/BuildingSync/BuildingSync-website/issues/229
