# Add Simple Impact Analysis

## Overview

This proposal is to add the `auc:SimpleImpactAnalysis` child element to the `auc:PackageOfMeasures` element. It also includes the suggestion that we move some of the direct children of `auc:PackageOfMeasures` into a new element `auc:ComplexImpactAnalysis`.

## Justification

Standard 211 6.1.5.c-6.1.5.g as well as 6.1.6.d-6.1.6.g requires a summary of the impact of each recommended measure. Specifically, it states:
> c. Impact on occupant comfort (improved thermal comfort, indoor air quality [IAQ], lighting quality, acoustics)
> d. Estimated cost (high, medium, low)
> e. Estimated level (high, medium, low) of annual savings
> f. Estimated level (high, medium, low) of return on investment (ROI)
> g. Priority (high, medium, low)

Additionally, Standard 211 is explicit in discriminating the "Low-Cost and No-Cost" recommendations (section 6.1.5) from the "Capital" recommendations (section 6.1.6), so it might not be a bad idea to add a category to specify this.

## Implementation

```xml
<xs:element name="PackageOfMeasures" minOccurs="0">
    <xs:complexType>
        <xs:sequence>
            ...
            <xs:element name="SimpleImpactAnalysis">
                <xs:element name="CostCategory">
                    <xs:simpleType>
                        <xs:restriction base="xs:string">
                            <xs:enumeration value="Low-Cost or No-Cost">
                                <xs:enumeration value="Capital">
                        </xs:restriction>
                    </xs:simpleType>
                </xs:element>
                <xs:element name="ImpactOnOccupantComfort" type="xs:string"></xs:element>
                <xs:element name="EstimatedCost" type="LowMedHighType"></xs:element>
                <xs:element name="EstimatedAnnualEnergySavings" type="LowMedHighType"></xs:element>
                <xs:element name="EstimatedROI" type="LowMedHighType"></xs:element>
                <xs:element name="Priority" type="LowMedHighType"></xs:element>
            </xs:element>
            <xs:element name="ComplexImpactAnalysis">
                <!-- elements to be moved here -->
                ...
            </xs:element>
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

### elements moved
These elements would be moved from `auc:PackageOfMeasures` into ` auc:ComplexImpactAnalysis`
- `auc:AnnualSavingsSiteEnergy`
- `auc:AnnualSavingsSourceEnergy`
- `auc:AnnualSavingsCost`
- `auc:AnnualSavingsByFuels`
- `auc:SummerPeakElectricityReduction`
- `auc:WinterPeakElectricityReduction`
- `auc:AnnualPeakElectricityReduction`
- `auc:AnnualDemandSavingsCost`
- `auc:AnnualWaterSavings`
- `auc:AnnualWaterCostSavings`
- `auc:ImplementationPeriod`
- `auc:PackageFirstCost`
- `auc:MVCost`
- `auc:OMCostAnnualSavings`
- `auc:EquipmentDisposalAndSalvageCosts`
- `auc:ImplementationPeriodCostSavings`
- `auc:PercentGuaranteedSavings`
- `auc:ProjectMarkup`
- `auc:FundingFromIncentives`
- `auc:FundingFromTaxCredits`
- `auc:OtherFinancialIncentives`
- `auc:RecurringIncentives`
- `auc:NPVofTaxImplications`
- `auc:CostEffectivenessScreeningMethod`
- `auc:SimplePayback`
- `auc:NetPresentValue`
- `auc:InternalRateOfReturn`
- `auc:AssetScore`
- `auc:ENERGYSTARScore`

## References

Standard 211 6.1.5.c-6.1.5.g
