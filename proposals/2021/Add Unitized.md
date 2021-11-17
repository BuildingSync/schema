# Add Unitized

## Overview

This proposal is to add the `Unitized` element as a child of `DomesticHotWaterSystemType` element.

## Justification

This field was added to the Audit Template tool as part of the city of Washington, D.C., [Building Energy Performance Standards (BEPS)](https://doee.dc.gov/service/building-energy-performance-standards-beps) template.

## Implementation

```xml
<xs:complexType name="DomesticHotWaterSystemType">
  <xs:sequence>
    ...
    <xs:element name="Unitized" type="xs:boolean" minOccurs="0">
      <xs:annotation>
        <xs:documentation>True if the DHW system is unitized.</xs:documentation>
      </xs:annotation>
    </xs:element>
    ...
  </xs:sequence>
<xs:complexType>
```

## References

N/A
