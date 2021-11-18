# Rename reference elements

## Overview

This proposal is to standardize the naming format of the `IDREF` elements.

## Justification

We will include *ID* in the names of elements that reference an `ID` elements, i.e. `IDREF` elements. In addition, some element names are redundant as overlapping with other names (e.g. `SourceHeatingPlantID`, `LinkedHeatingPlantID` and `HeatingPlantID`). 

We propose the following changes:

`AlternativeSystemAdded` -> `AlternativeSystemIDAdded`
`AlternativeSystemReplacement` -> `AlternativeSystemIDReplacement`
`ExistingScheduleAffected` -> `ExistingScheduleIDAffected`
`ExistingSystemAffected` -> `ExistingSystemIDAffected`
`ExistingSystemRemoved` -> `ExistingSystemIDRemoved`
`ExistingSystemReplaced` -> `ExistingSystemIDReplaced`
`SourceHeatingPlantID` -> `HeatingPlantID`
`LinkedHeatingPlantID` -> `HeatingPlantID`
`DeliveryID` -> `LinkedDeliveryID`
`MakeupAirSourceID` -> `MakeupAirSpaceID`
`ModifiedSchedule` -> `ModifiedScheduleID`
`ModifiedSystem` -> `ModifiedSystemID`
`ReferenceCase` -> `ReferenceScenarioID`

Meanwhile, we will add the valid referenced `ID` element(s) in the documentation (description) of the `IDREF` element. Refer to [#295] for all documented linking elements.

## Implementation example

Change
```xml
<xs:element name="AlternativeSystemReplacement" minOccurs="0" maxOccurs="unbounded">
    <xs:annotation>
        <xs:documentation>ID numbers of alternative systems that would replace the existing systems.</xs:documentation>
    </xs:annotation>
    <xs:complexType>
        <xs:attribute name="IDref" type="xs:IDREF" use="required"/>
    </xs:complexType>
</xs:element>
```
to
```xml
<xs:element name="AlternativeSystemIDReplacement" minOccurs="0" maxOccurs="unbounded">
    <xs:annotation>
        <xs:documentation>ID numbers of alternative systems that would replace the existing systems. Valid reference paths: BuildingSync/Facilities/Facility/Systems/***Systems/***System.</xs:documentation>
    </xs:annotation>
    <xs:complexType>
        <xs:attribute name="IDref" type="xs:IDREF" use="required"/>
    </xs:complexType>
</xs:element>
```

## References
[#295]
