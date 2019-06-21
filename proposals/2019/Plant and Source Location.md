# Add Location Element to Plants and Heating/Cooling Sources

## Overview

HVACSystem Plant and Sources do not have a location specifier. For example if a cooling source (e.g. PTZ, RTU), then there needs to be a way to specify where the system is located such as the Roof.

## Justification

The location of the plant and heating/cooling sources needs to be defined.

## Implementation

Add the `Location` to the following paths:

* BuildingSync/Facilities/Facility/Systems/HVACSystems/HVACSystem/HeatingAndCoolingSystems/CoolingSources/CoolingSource
* BuildingSync/Facilities/Facility/Systems/HVACSystems/HVACSystem/HeatingAndCoolingSystems/HeatingSources/HeatingSource
* BuildingSync/Facilities/Facility/Systems/HVACSystems/HVACSystem/Plants/HeatingPlants/HeatingPlant
* BuildingSync/Facilities/Facility/Systems/HVACSystems/HVACSystem/Plants/CoolingPlants/CoolingPlant
* BuildingSync/Facilities/Facility/Systems/HVACSystems/HVACSystem/Plants/CondenserPlants/CondenserPlant

## References

N/A
