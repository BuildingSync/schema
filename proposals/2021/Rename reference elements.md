# Rename reference elements

## Overview

This proposal is to standardize the naming format of the `IDREF` elements.

## Justification

1. We will include *ID* in the names of elements that reference an `ID` elements, i.e. `IDREF` elements. In addition, some element names are redundant as overlapping with other names (e.g. `SourceHeatingPlantID`, `LinkedHeatingPlantID` and `HeatingPlantID`). 

We propose the following changes:

`AlternativeSystemAdded` -> `AlternativeSystemIDAdded`
`AlternativeSystemReplacement` -> `AlternativeSystemIDReplacement`
`ExistingScheduleAffected` -> `ExistingScheduleIDAffected`
`ExistingSystemAffected` -> `ExistingSystemIDAffected`
`ExistingSystemRemoved` -> `ExistingSystemIDRemoved`
`ExistingSystemReplaced` -> `ExistingSystemIDReplaced`
`SourceHeatingPlantID` -> `HeatingPlantID`
`LinkedHeatingPlantID` -> `HeatingPlantID`
`DeliveryIDs` -> `LinkedDeliveryIDs`
`DeliveryID` -> `LinkedDeliveryID`
`MakeupAirSourceID` -> `MakeupAirSpaceID`
`ModifiedSchedule` -> `ModifiedScheduleID`
`ModifiedSystem` -> `ModifiedSystemID`
`ReferenceCase` -> `ReferenceScenarioID`

2. Meanwhile, we will add the valid referenced `ID` element(s) in the documentation (description) of the `IDREF` element. Refer to [#295] for all documented linking elements.

3. Refactor/deprecate the prior use of `MakeupAirSpaceID`. Currently `MakeupAirSourceID` does not work in the same way as the other `IDREF` elements, it contains the referenced `ID` in value(text) field instead of attribute field:
```xml
<auc:MakeupAirSourceID>ReferencedSpaceID</auc:MakeupAirSourceID>
```
To standardize the usage of `IDREF` elements, we prefer to use:
```xml
<auc:MakeupAirSourceID IDref="ReferencedSpaceID"></auc:MakeupAirSourceID>
```
This is also the formal usage of ID and IDREF attributes of xml elements.

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

Also change
```xml
<xs:element name="MakeupAirSpaceID">
    <xs:annotation>
        <xs:documentation>ID number of the Space that provides makeup air for exhaust ventilation. Valid reference paths: BuildingSync/Facilities/Facility/Sites/Site/Buildings/Building/Sections/Section/ThermalZones/ThermalZone/Spaces/Space.</xs:documentation>
    </xs:annotation>
    <xs:complexType>
        <xs:simpleContent>
        <xs:extension base="xs:IDREF">
            <xs:attribute name="IDref" type="xs:IDREF"/>
        </xs:extension>
        </xs:simpleContent>
    </xs:complexType>
</xs:element>
```
to
```xml
<xs:element name="MakeupAirSpaceID">
    <xs:annotation>
        <xs:documentation>ID number of the Space that provides makeup air for exhaust ventilation. Valid reference paths: BuildingSync/Facilities/Facility/Sites/Site/Buildings/Building/Sections/Section/ThermalZones/ThermalZone/Spaces/Space.</xs:documentation>
    </xs:annotation>
    <xs:complexType>
        <xs:attribute name="IDref" type="xs:IDREF" use="required"/>
    </xs:complexType>
</xs:element>
```

## References
[#295]
