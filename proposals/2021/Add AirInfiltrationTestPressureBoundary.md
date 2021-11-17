# Add AirInfiltrationTestPressureBoundary

## Overview

This proposal is to add the `AirInfiltrationTestPressureBoundary` element as a child of `AirInfiltrationSystem` element, and to restrict the options to `Whole building` and `Compartment`.

## Justification

This field was added to the Audit Template tool as part of the city of Washington, D.C., [Building Energy Performance Standards (BEPS)](https://doee.dc.gov/service/building-energy-performance-standards-beps) template.

## Implementation

```xml
<xs:element name="AirInfiltrationSystem" maxOccurs="unbounded">
  ...
  <xs:complexType>
    <xs:sequence>
      ...
      <xs:element name="AirInfiltrationTestPressureBoundary" minOccurs="0">
        <xs:annotation>
          <xs:documentation>Pressure boundary for air infiltration test performed on the building.</xs:documentation>
        </xs:annotation>
        <xs:simpleType>
          <xs:restriction base="xs:string">
            <xs:enumeration value="Whole building"/>
            <xs:enumeration value="Compartment"/>
          </xs:restriction>
        </xs:simpleType>
      </xs:element>
      ...
    </xs:sequence>
  </xs:complexType>
</xs:element>
```

## References

N/A
