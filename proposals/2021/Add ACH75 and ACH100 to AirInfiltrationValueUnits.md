# Add ACH75 and ACH100 to AirInfiltrationValueUnits

## Overview

This proposal is to add `ACH75` and `ACH100` enumerations to the `AirInfiltrationValueUnits` element.

## Justification

These enumerations were added to the Audit Template tool as part of the city of Washington, D.C., [Building Energy Performance Standards (BEPS)](https://doee.dc.gov/service/building-energy-performance-standards-beps) template.

## Implementation

```xml
<xs:element name="AirInfiltrationSystem" maxOccurs="unbounded">
  ...
  <xs:complexType>
    <xs:sequence>
      ...
      <xs:element name="AirInfiltrationValueUnits" minOccurs="0">
        <xs:annotation>
          <xs:documentation>Units associated with Air Infiltration Value.</xs:documentation>
        </xs:annotation>
        <xs:simpleType>
          <xs:restriction base="xs:string">
            <xs:enumeration value="CFM25"/>
            <xs:enumeration value="CFM50"/>
            <xs:enumeration value="CFM75"/>
            <xs:enumeration value="CFMnatural"/>
            <xs:enumeration value="ACH50"/>
            <!-- vvv -->
            <xs:enumeration value="ACH75"/>
            <xs:enumeration value="ACH100"/>
            <!-- ^^^ -->
            <xs:enumeration value="ACHnatural"/>
            <xs:enumeration value="Effective Leakage Area"/>
            <xs:enumeration value="Other"/>
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
