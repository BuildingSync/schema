# Move Plants from HVAC Systems to Facilities

## Overview

This proposal is to move the `<auc:Plants>` element from the `<auc:HVACSystemType>` element to the `<auc:Facility>` element.

## Justification

The justification is three-fold:

1. Plants cannot be asserted without first asserting the HVAC system, i.e., the `<auc:Plants>` element can only be included in an XML document if it is a child element of an `<auc:HVACSystemType>` element.

2. If there is more than one HVAC system in a given facility and a plant is shared between two or more HVAC systems, then there is no rule for where the plant should be asserted, i.e., the `<auc:Plants>` element can be included as the child element of any `<auc:HVACSystemType>` element within a given XML document.

3. If a given XML document describes more than one facility and a plant of one facility is shared with another, then it is not possible to assert a facility and its plants only.

This proposal resolves the above issues, allowing the following XML to validate:

```xml
<BuildingSync>
  <Facilities>
    <Facility ID="Facility1">
      <Plants>
        <HeatingPlant ID="HeatingPlant1">
          <Boiler/>
        </HeatingPlant>
      </Plants>
    </Facility>
    <Facility ID="Facility2">
      <Systems>
        <HVACSystems>
          <HVACSystem ID="HVACSystem1">
            <HeatingAndCoolingSystems>
              <HeatingSources>
                <HeatingSource ID="HeatingSource1">
                  <HeatingSourceType>
                    <SourceHeatingPlantID IDref="HeatingPlant1"/>
                  </HeatingSourceType>
                </HeatingSource>
              </HeatingSources>
            </HeatingAndCoolingSystems>
          </HVACSystem>
        </HVACSystems>
      </System>
    </Facility>
  </Facilities>
</BuildingSync>
```

In the above example, we assert the existence of two facilities, where the plant of the first facility is shared with the heating source for the HVAC system of the second facility.

## Implementation

This proposal is to move `//BuildingSync/Facilities/Facility/Systems/HVACSystems/HVACSystem/Plants` to `//BuildingSync/Facilities/Facility/Plants`.

## References

n/a
