# Add RoofCondition to RoofSystemType

## Overview

Add `<auc:RoofCondition>` element to `<auc:RoofSystemType>` element.

## Justification

Currently, there is no way to store the overall condition of a roof system.

## Implementation

Add `<auc:RoofCondition>` element (of type `<auc:EquipmentCondition>`) to the following XPaths:
* `BuildingSync/Facilities/Facility/Systems/RoofSystems/RoofSystem`

## References

n/a
