# Change Representation of Zone Equipment

## Overview

The schema presently does not allow for the representation of the presence of delivery-type zone equipment without specifying the type of zone equipment. Workarounds are possible, but all involve adding either additional enumerations or the use of user-defined fields. The proposed change splits the fan-based delivery equipment into two parts and branches on "zone equipment or not" before branching on the equipment type.

## Justification

The current schema for representation of delivery at

Audits/Audit/Systems/HVACSystems/HVACSystem/HeatingAndCoolingSystems/Delivery/DeliveryType

branches on

- Fan based
- Convection
- Radiant
- Other

Note that it is not possible to simply represent that there is zone equipment present without specifying the type. For a detailed audit, it is logical to assume that the auditor will see the equipment and will be able to input the type. However, for higher-level audits (e.g. ASHRAE level 1 or 2) it may be desirable to note that zone equipment is present without specifying the type. The ASHRAE Standard 211 spreadsheet does this on the "L2 - HVAC" sheet. In the category of "Cooling Distribution Equipment Type", two checkboxes ask about zone equipment but not what type of zone equipment:

- Hydronic to zone equipment (e.g. fan coil units, packaged terminal units or radiators)
- Refrigerant to zone equipment (e.g. fan coil units, packaged terminal units or radiators)

All of the other checkboxes can be represented without ambiguity. Non-breaking workarounds are available (e.g. add an enumeration value), but this means that the representations of the various systems are inconsistent. A breaking change that makes the representations consistent is preferable, and a making the breaking change now instead of a breaking change later will reduce the impact of the change.

## Implementation

There are three options for implementation of the Zone Equipment representation in the Delivery section.

Originally Proposed: This is what we understood to be proposed originally. It is specified with no missing relevent parent/child relationships. Pro: Reflects request. Con: Organization of information is a bit confusing with having the ZoneEquipment as a child of the FanBasedDistributionType.

Delivery

- DeliveryType
  - FanBased
    - FanBasedDistributionType
      - CentralAirDistribution
      - ZoneEquipment (New)
        - FanCoil
        - Convection
        - Radiant
        - Other
      - Other (New)

Recommended Option A: This reflects what was requested originally with small modifications to make it more intuitive where CentralAirDistribution and ZoneEquipment are children of DeliveryType not FanBasedDistributionType. Pro: Similar to request. Con: ZoneEquipment has children (Convection, Radiant, etc) which might be limiting to use cases.

Delivery

- DeliveryType
  - CentralAirDistribution
  - ZoneEquipment (New)
    - FanBased
      - FanBasedDistributionType
        - FanCoil
    - Convection
    - Radiant
    - Other
  - Other (New)

Recommended Option B: This is furthest from what was originally requested but would meet the goals of the 211 use case cleanly. Pro: Structure is intuitive. Con: Most changes.

Delivery

- DeliveryZoningType (New)
  - CentralAirDistribution
  - ZoneEquipment (New)
  - Other (New)
- DeliveryType
  - FanBased
    - FanBasedDistributionType
      - FanCoil
  - Convection
  - Radiant
  - Other

## References

https://xp20.ashrae.org/211-2018/ tab L2-HVAC
