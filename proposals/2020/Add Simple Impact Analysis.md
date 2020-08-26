# Add Simple Impact Analysis

## Overview

This proposal is to add the `auc:SimpleImpactAnalysis` and `auc:CostCategory` child elements to the `auc:PackageOfMeasures` element.

## Justification

Standard 211 6.1.5.c-6.1.5.g as well as 6.1.6.d-6.1.6.g requires a summary of the impact of each recommended measure. Specifically, it states:
> c. Impact on occupant comfort (improved thermal comfort, indoor air quality [IAQ], lighting quality, acoustics)
> d. Estimated cost (high, medium, low)
> e. Estimated level (high, medium, low) of annual savings
> f. Estimated level (high, medium, low) of return on investment (ROI)
> g. Priority (high, medium, low)

Additionally, Standard 211 is explicit in discriminating the "Low-Cost and No-Cost" recommendations (section 6.1.5) from the "Capital" recommendations (section 6.1.6), so it might not be a bad idea to add a category to specify this.

## Implementation

In `auc:SimpleImpactAnalysis` add these elements which can have the values of `Low` `Medium` or `High`
- EstimatedCost
- EstimatedAnnualSavings
- EstimatedROI
- Priority

Note that we tried to determine what _type_ of savings `EstimatedAnnualSavings` should represent (cost or energy) however neither STD 211 nor the normative spreadsheet specify this information, which is why we decided to just use the same wording.

Also add `CostCategory` to `PackageOfMeasures` to specify if it's a low/no-cost or capital package.

Also add `ImpactOnOccupantComfort`, but it should be a freeform text field b/c per 211 it captures and describes multiple things.

```xml
<xs:element name="PackageOfMeasures" minOccurs="0">
    <xs:complexType>
        <xs:sequence>
            ...
            <xs:element name="CostCategory">
                <xs:simpleType>
                    <xs:restriction base="xs:string">
                        <xs:enumeration value="Low-Cost or No-Cost">
                        <xs:enumeration value="Capital">
                    </xs:restriction>
                </xs:simpleType>
            </xs:element>
            <xs:element name="SimpleImpactAnalysis">
                <xs:element name="ImpactOnOccupantComfort" type="xs:string"></xs:element>
                <xs:element name="EstimatedCost" type="LowMedHighType"></xs:element>
                <xs:element name="EstimatedAnnualSavings" type="LowMedHighType"></xs:element>
                <xs:element name="EstimatedROI" type="LowMedHighType"></xs:element>
                <xs:element name="Priority" type="LowMedHighType"></xs:element>
            </xs:element>
            ...
        </xs:sequence>
    </xs:complexType>
</xs:element>
...
<xs:simpleType name="LowMedHighType">
    <xs:restriction base="xs:string">
        <xs:enumeration value="Low"/>
        <xs:enumeration value="Medium"/>
        <xs:enumeration value="High"/>
    </xs:restriction>
</xs:simpleType>
```

## References

Standard 211 6.1.5.c-6.1.5.g
