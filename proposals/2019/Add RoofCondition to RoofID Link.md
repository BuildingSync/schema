# Add RoofCondition to RoofID Link

## Overview

Add `<auc:RoofCondition>` element to `<auc:RoofID>` element.

## Justification

Currently, there is no way to store the overall condition of a roof system. The RoofCondition is on the link to the RoofSystem allowing for the same roof system to have multiple conditions based on the Section of the building.

## Implementation

Add `<auc:RoofCondition>` element (of type `<auc:EquipmentCondition>`) to the following XPaths:
* `BuildingSync/Facilities/Facility/Sites/Site/Section/Section/Roofs/Roof/RoofID/`

## References

n/a
