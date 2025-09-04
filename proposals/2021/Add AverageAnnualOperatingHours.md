# Add AverageAnnualOperatingHours to System

## Overview

This proposal is to add the `AverageAnnualOperatingHours` element as a child element of `OnsiteStorageTransmissionGenerationSystem` under `System`.

## Justification

The average operating hours per year of the onsite generation system.

## UDFs

Currently this is conveyed in Audit Template via: `/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building/auc:UserDefinedFields/auc:UserDefinedField[auc:FieldName/text() = Onsite Generation Operation Average Annual Hours]/auc:FieldValue`. Our proposal is to add it as a child element of `OnsiteStorageTransmissionGenerationSystem`.

## Example

```xml
...
    <auc:Facilities>
        <auc:Facility ID="F1">
            <auc:Systems>
                <auc:System ID="S1">
                    <auc:OnsiteStorageTransmissionGenerationSystems>
                        <auc:OnsiteStorageTransmissionGenerationSystem ID="O1">
                            <auc:AverageAnnualOperatingHours>4000</auc:AverageAnnualOperatingHours>
                        </auc:OnsiteStorageTransmissionGenerationSystem>
                    </auc:OnsiteStorageTransmissionGenerationSystems>
                </auc:System>
            </auc:Systems>
        </auc:Facility>
    </auc:Facilities>
...
```

## Implementation

```xml
...
  <xs:complexType name="OnsiteStorageTransmissionGenerationSystemType">
    <xs:sequence>
      <xs:element name="AverageAnnualOperatingHours" minOccurs="0">
        <xs:annotation>
          <xs:documentation>The average operating hours per year of the onsite generation system.</xs:documentation>
        </xs:annotation>
        <xs:simpleType>
          <xs:restriction base="xs:decimal">
            <xs:minInclusive value="0"/>
            <xs:maxInclusive value="8760"/>
          </xs:restriction>
        </xs:simpleType>
      </xs:element>
...
```

## References
