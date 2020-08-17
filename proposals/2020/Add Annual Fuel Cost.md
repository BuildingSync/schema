# Add AnnualFuelCost element

## Overview

This proposal is to add the `auc:AnnualFuelCost` child element to the `auc:ResourceUse` element.

## Justification

Standard 211 sections 6.1.2.1.g and 6.1.2.1.i specifies
> ... Annual electric use (kWh) and cost (\$) for each year
> ... Annual site fuel (or other energy source) use in therms,
gallons, lbs, MJ, or Btu, as appropriate, and cost (\$)...

This proposal suggests that having an element `auc:AnnualFuelCost` in `auc:ResourceUse` would best address these requirements.

## Implementation

```xml
<xs:complexType name="ResourceUseType">
    <xs:sequence>
        ...
        <xs:element name="AnnualFuelCost" minOccurs="0" type="xs:string">
            <xs:annotation>
                <xs:documentation>Annual cost of the resource ($)</xs:documentation>
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

Standard 211 6.1.2.1.g and 6.1.2.1.i
