# Add YearInstalled to FenestrationSystemType

## Overview

This proposal is to add the `YearInstalled` element as a child of the `Window`, `Skylight`, `Door`, and `Other` elements (c.f., `FenestrationSystemType`).

## Justification

This field was added to the Audit Template tool as part of the city of Washington, D.C., [Building Energy Performance Standards (BEPS)](https://doee.dc.gov/service/building-energy-performance-standards-beps) template.

## Implementation

```xml
<xs:complexType name="FenestrationSystemType">
  ...
  <xs:sequence>
    <xs:element name="FenestrationType" minOccurs="0">
      ...
      <xs:complexType>
        <xs:choice>
          <xs:element name="Window" minOccurs="0">
            <xs:complexType>
              <xs:sequence>
                ...
                <xs:element ref="auc:YearInstalled" minOccurs="0"/>
                ...
              </xs:sequence>
            </xs:complexType>
          </xs:element>
          ...
        </xs:choice>
      </xs:complexType>
    </xs:element>
    ...
  </xs:sequence>
</xs:complexType>

```

## References

N/A
