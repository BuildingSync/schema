# Add YearInstalled to Plant Paths

## Overview

There is no YearInstalled field on the CoolingPlant and HeatingPlant paths.

## Justification

There exists a need for users to add YearInstalled on Cooling Plant and Heating Plant paths.  For consistency, also add the field to the CondenserPlant path.

## Implementation

This proposal is to:
1. Add the following path: BuildingSync/Facilities/Facility/Systems/HVACSystems/HVACSystem/Plants/CondenserPlants/CondenserPlant/YearInstalled

2. Add the following path: BuildingSync/Facilities/Facility/Systems/HVACSystems/HVACSystem/Plants/CoolingPlants/CoolingPlant/YearInstalled

3. Add the following elements under path BuildingSync/Facilities/Facility/Systems/HVACSystems/HVACSystem/Plants/HeatingPlants/HeatingPlant/YearInstalled

## References

N/A
