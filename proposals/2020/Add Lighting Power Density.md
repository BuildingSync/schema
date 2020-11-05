# Add LightingPowerDensity element

## Overview

This proposal is to add the `auc:LightingPowerDensity` child element to the `auc:LightingSystemType` element.

## Justification
An `auc:LightingSystemType` currently has the following elements related to energy consumption of the system:
- `auc:InstalledPower`: Installed power for this system. (kW)
- `auc:LampPower`: The number of watts per lamp. (W)

A typical measure of the energy consumption for lighting is Lighting Power Density, which this proposal adds.

## Implementation

```xml
<xs:complexType name="LightingSystemType">
    <xs:sequence>
        ...
      <xs:element name="LightingPowerDensity" minOccurs="0">
        <xs:annotation>
          <xs:documentation>The maximum lighting power per unit area based on space function. (W/ft2)</xs:documentation>
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
```

## References

- No definition found in BEDES
- Definition found in ASHRAE Terminology: https://xp20.ashrae.org/terminology/index.php?term=lighting+power&submit=Search