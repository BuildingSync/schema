# Explicit Zone Equipment Representation #

## Overview ##
The schema presently does not allow for the representation of the presence of delivery-type zone equipment without specifying the type of zone equipment. Workarounds are possible, but it is better to undertake the breaking change now so as to minimize the impact of the breaking change. The proposed change splits the fan-based delivery equipment into two parts and branches on "zone equipment or not" before branching on the equipment type. 

## Justification ##
The current schema for representation of delivery at

Audits/Audit/Systems/HVACSystems/HeatingAndCoolingSystems/Delivery/DeliveryType

branches on

  * Fan based
  * Convection
  * Radiant 
  * Other

before it is possible to note that there is zone equipment present without specifying the type. For a detailed audit, it is logical to assume that the auditor will see the equipment and will be able to input the type. However, for higher-level audits (e.g. ASHRAE level 1 or 2) it may be desirable to note that zone equipment is present without specifying the type. The ASHRAE Standard 211 spreadsheet does this on the "L2 - HVAC" sheet. In the category of "Cooling Distribution Equipment Type", two checkboxes ask about zone equipment but not what type of zone equipment:

  * Hydronic to zone equipment (e.g. fan coil units, packaged terminal units or radiators)
  * Refrigerant to zone equipment (e.g. fan coil units, packaged terminal units or radiators)

All of the other checkboxes can be represented without ambiguity. Non-breaking workarounds are available (e.g. add an enumeration value), but this means that the representations of the various systems are inconsistent. A breaking change that makes the representations consistent is preferable, and a making the breaking change now instead of a breaking change later will reduce the impact of the change.

## Implementation ##
The implementation will be done in two steps. First, a top-level type for fan-based equipment will be created so that the two primary children of the fan-based branch (fan coils and AHUs) can be represented similarly. The current organization of

  * FanBased
    - CentralAirDistribution
    - FanCoil
  * Convection
  * Radiant
  * Other

will be maintained. Note that one level has been omitted here under FanBased for clarity. All current tests will be verified as passing. The second step is to reorganize the schema as follows:

  * CentralAirDistribution
  * ZoneEquipment
    - FanCoil
    - Convection
    - Radiant
    - Other
  * Other

The CentralAirDistribution and ZoneEquipment/FanCoil branches will make use of the top-level type developed in step one.

## References ##
N/A
