# Add BenchmarkValue element

## Overview

This proposal is to add the `auc:EnergyCostIndex` child element to the `auc:AllResourceTotalType` element.

## Justification

The `auc:EnergyCostIndex` element is specified as a required calculation per Standard 211 5.2.3.2. The `auc:EnergyCost` element already exists. This mimics the `auc:SiteEnergyUse` and `auc:SiteEnergyUseIntensity` pair of elements.

## Implementation

```xml
      <xs:element name="EnergyCostIndex" minOccurs="0">
        <xs:annotation>
          <xs:documentation>The Energy Cost divided by the premises gross floor area. ($/ft2)</xs:documentation>
        </xs:annotation>
        <xs:complexType>
          <xs:simpleContent>
            <xs:extension base="xs:decimal">
              <xs:attribute ref="auc:Source"/>
            </xs:extension>
          </xs:simpleContent>
        </xs:complexType>
      </xs:element>
```

## References

Standard 211 5.2.3.2
