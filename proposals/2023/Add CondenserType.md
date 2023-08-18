# Add CondenderType

## Overview

This proposal is to add the element `auc:CondenserType` element under `auc:CoolingPlant`.

## Justification

Currently in BuildingSync, a `CondenserPlant` is required to be declared when a `CoolingPlant/Chiller` is defined and should be linked to the `Chiller` through `Chiller/CondenserPlantIDs/CondenserPlantID`. The `CondenserPlant` shares the same level as the `CoolingPlant`, as a component of `Plants`. However, the Audit Template Tool requires this element declared under a `CoolingPlant` for mappinig. 

## Implementation
The `auc:CondenserType` element will be added as a direct child of `auc:CoolingPlant` with enumerations of "Air Cooled", "Water Cooled", "Other" and "Unknown".
