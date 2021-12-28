# Add Podium

## Overview

This proposal is to add the `Podium` element as a child of `GroundCoupling` element.

## Justification

This field was added to the Audit Template tool as part of the city of Washington, D.C., [Building Energy Performance Standards (BEPS)](https://doee.dc.gov/service/building-energy-performance-standards-beps) template.

## Implementation

```xml
<xs:element name="GroundCoupling" minOccurs="0" maxOccurs="unbounded">
  ...
  <xs:complexType>
    <xs:choice>
      ...
      <xs:element name="Podium" minOccurs="0">
        <xs:complexType>
          <xs:sequence>
            ...
          </xs:sequence>
        </xs:complexType>
      </xs:element>
      ...
    </xs:choice>
  </xs:complexType>
  ...
</xs:element>
```

## References

N/A
