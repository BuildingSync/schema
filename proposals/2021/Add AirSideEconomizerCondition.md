# Add AirSideEconomizerCondition

## Overview

This proposal is to add the `AirSideEconomizerCondition` element as a child of `AirSideEconomizer` element.

## Justification

This field was added to the Audit Template tool as part of the city of Washington, D.C., [Building Energy Performance Standards (BEPS)](https://doee.dc.gov/service/building-energy-performance-standards-beps) template.

## Implementation

```xml
<xs:element name="AirSideEconomizerType" minOccurs="0">
  ...
  <xs:complexType>
    <xs:sequence>
      ...
      <xs:element name="AirSideEconomizerCondition" type="auc:EquipmentCondition" minOccurs="0">
        <xs:annotation>
          <xs:documentation>Description of the air economizer's condition.</xs:documentation>
        </xs:annotation>
      </xs:element>
      ...
    </xs:sequence>
  </xs:complexType>
</xs:element>
```

## References

N/A
