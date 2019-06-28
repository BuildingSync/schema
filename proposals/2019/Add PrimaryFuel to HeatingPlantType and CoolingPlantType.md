# Add PrimaryFuel Element to Heating and Cooling Plants

## Overview

This proposal is to add the `<auc:PrimaryFuel>` element to the definitions of the `<auc:HeatingPlantType>` and `<auc:CoolingPlantType>` elements.

## Justification

Some users need to specify the main fuel used by heating and cooling plants.

## Implementation

Add the `<auc:PrimaryFuel>` element to the following XPaths:

* `BuildingSync/Facilities/Facility/Systems/HVACSystems/HVACSystem/Plants/HeatingPlants/HeatingPlant`
* `BuildingSync/Facilities/Facility/Systems/HVACSystems/HVACSystem/Plants/CoolingPlants/CoolingPlant`

## References

n/a
