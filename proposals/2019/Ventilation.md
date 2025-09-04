# VentilationType and VentilationControlMethod

## Overview

The MechanicalVentilation/VentilationType enumeration does not include None. There is also only a single type of ventilation control that is allowed.

## Justification

The user can either leave out MechanicalVentilation or set MechanicalVentilation/VentilationType to None.

The user should be able to select multiple ventilation control methods such as CO2 Sensors and Scheduled.

## Implementation

- Add None to BuildingSync/Facilities/Facility/Systems/HVACSystems/HVACSystem/OtherHVACSystems/OtherHVACSystem/OtherHVACType/MechanicalVentilation/VentilationType
- Convert the following to a container with multiples allowed. _(This is a breaking change.)_
  - BuildingSync/Facilities/Facility/Systems/HVACSystems/HVACSystem/OtherHVACSystems/OtherHVACSystem/OtherHVACType/MechanicalVentilation/VentilationControlMethods
  - BuildingSync/Facilities/Facility/Systems/HVACSystems/HVACSystem/OtherHVACSystems/OtherHVACSystem/OtherHVACType/SpotExhaust/VentilationControlMethods
  - BuildingSync/Facilities/Facility/Systems/HVACSystems/HVACSystem/OtherHVACSystems/OtherHVACSystem/OtherHVACType/NaturalVentilation/VentilationControlMethods

## References

N/A
