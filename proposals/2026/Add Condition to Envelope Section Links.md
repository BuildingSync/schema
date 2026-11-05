# Add Condition to Envelope Section Links

## Overview

This proposal adds an optional, occurrence-level condition rating to the remaining envelope section links (`WallID`, `DoorID`, `WindowID`, `SkylightID`, `CeilingID`, `ExteriorFloorID`, `FoundationID`), following the existing `RoofID/RoofCondition` pattern. It addresses part of [#370](https://github.com/BuildingSync/schema/issues/370) (asset condition).

## Justification

Since v2.7.0 ([#515](https://github.com/BuildingSync/schema/pull/515)), every envelope system type carries a system-level condition (`WallSystemCondition`, `CeilingSystemCondition`, `FenestrationSystemCondition`, `ExteriorFloorSystemCondition`, `FoundationSystemCondition`). These describe the referenced system record as a whole.

The roof, however, has its condition on the section link (`RoofID/RoofCondition`). This was a deliberate choice ([#109](https://github.com/BuildingSync/schema/pull/109), `proposals/2019/Add RoofCondition to RoofID Link.md`): the same roof system can be in different condition in different sections, and putting the rating on the link avoids duplicating an otherwise identical system description just to record a different condition.

The same need applies to the other envelope elements: one wall or window type is commonly shared by several sides or sections whose observed condition differs (e.g. a weather-exposed facade). Today the only option is to duplicate the system record. Adding the condition to each link makes the two assessment scopes available consistently across the envelope:

- **System scope**: `XXXSystemCondition` on the system record.
- **Occurrence scope**: `XXXCondition` on the section link (new, except the existing `RoofCondition`).

The two values are independent. The schema does not imply inheritance, synchronization, or averaging between them; any such rules belong to use-case definitions or consumers.

## Implementation

This is a **non-breaking** (MINOR) change: only new optional elements are added; no existing element is moved, renamed, or retyped.

Add the following optional elements, each of type `auc:EquipmentCondition`:

| New element              | Parent (path)                                                | Inserted after              |
| ------------------------ | ------------------------------------------------------------ | --------------------------- |
| `WallCondition`          | global `WallID` (used in `Section/Sides/Side` and `WallIDs`) | `WallArea`                  |
| `DoorCondition`          | global `DoorID`                                              | `FenestrationArea`          |
| `WindowCondition`        | global `WindowID`                                            | `PercentOfWindowAreaShaded` |
| `SkylightCondition`      | `Section/Roofs/Roof/RoofID/SkylightIDs/SkylightID`           | `PercentSkylightArea`       |
| `CeilingCondition`       | `Section/Ceilings/Ceiling/CeilingID`                         | `CeilingInsulatedArea`      |
| `ExteriorFloorCondition` | `Section/ExteriorFloors/ExteriorFloor/ExteriorFloorID`       | `ExteriorFloorArea`         |
| `FoundationCondition`    | `Section/Foundations/Foundation/FoundationID`                | `FoundationArea`            |

Documentation text (with the matching element/system names substituted):

> Assessed condition of this occurrence of the wall type on this side of the section. This value applies only to this occurrence and is independent of WallSystemCondition on the referenced system.

`ExteriorFloorCondition` is used rather than a generic `FloorCondition` because the link scope is exterior/exposed floors only.

A system-level `RoofSystemCondition` on `RoofSystemType` is out of scope and may be proposed separately.

No existing examples need to change. Downstream tools (use-cases, BOSS, buildingsync-measures-gem, BuildingSync-asset-extractor) are unaffected because no existing path changes; they may optionally read the new elements.

## References

- [#370 Feature request: add asset condition](https://github.com/BuildingSync/schema/issues/370)
- [#109 Add RoofCondition to RoofID](https://github.com/BuildingSync/schema/pull/109)
- [#515 Add Optional Elements to All Assets](https://github.com/BuildingSync/schema/pull/515)
- `proposals/2019/Add RoofCondition to RoofID Link.md`
