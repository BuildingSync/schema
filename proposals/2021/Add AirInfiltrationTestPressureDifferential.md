# Add AirInfiltrationTestPressureDifferential

## Overview

This proposal is to add the `AirInfiltrationTestPressureDifferential` element as a child of `AirInfiltrationSystem` element.

## Justification

This field was added to the Audit Template tool as part of the city of Washington, D.C., [Building Energy Performance Standards (BEPS)](https://doee.dc.gov/service/building-energy-performance-standards-beps) template.

## Implementation

```xml
<xs:element name="AirInfiltrationSystem" maxOccurs="unbounded">
  ...
  <xs:complexType>
    <xs:sequence>
      ...
      <xs:element name="AirInfiltrationTestPressureDifferential" minOccurs="0">
        <xs:annotation>
          <xs:documentation>Pressure differential for air infiltration test performed on the building. (Pa)</xs:documentation>
        </xs:annotation>
        <xs:complexType>
          <xs:simpleContent>
            <xs:extension base="xs:decimal">
              <xs:attribute ref="auc:Source"/>
            </xs:extension>
          </xs:simpleContent>
        </xs:complexType>
      </xs:element>
      ...
    </xs:sequence>
  </xs:complexType>
</xs:element>
```

## References

N/A
