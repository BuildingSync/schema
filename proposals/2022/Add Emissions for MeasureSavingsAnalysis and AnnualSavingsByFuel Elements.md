# Add Emissions Fields to `MeasureSavingsAnalysis` and `AnnualSavingsByFuel` Elements

## Overview

This proposal is to add Carbon emissions-related fields to the `MeasureSavingsAnalysis` and `AnnualSavingsByFuel` elements.

## Justification

In 2022, [new fields were added to the schema](https://github.com/BuildingSync/schema/blob/develop-v2/proposals/2022/Add%20Emissions.md) to enable the exchange of Carbon emissions data for energy savings packages, resource uses, and time series data points.
The new fields for energy savings packages enable the exchange of **net** Carbon emissions savings data for the package **as a whole** (i.e., not for individual savings by fuel source or for individual measures that comprise said package).

### Measure-level Emissions

The `//Measure/MeasureSavingsAnalysis` element is defined for energy savings measures.

The `MeasureSavingsAnalysis` element does not have `AnnualSavingsAverageGHGEmissions`, `AnnualSavingsMarginalGHGEmissions`, and `AnnualSavingsGHGEmissionIntensity` child elements.

### Fuel-source-level Emissions

The `//PackageOfMeasures/AnnualSavingsByFuel` and `//Measure/MeasureSavingsAnalysis/AnnualSavingsByFuel` elements are defined for energy savings packages and measures, respectively.

The `AnnualSavingsByFuel` element does not have `AnnualSavingsAverageGHGEmissions`, `AnnualSavingsMarginalGHGEmissions`, and `AnnualSavingsGHGEmissionIntensity` child elements.

## Implementation

### Measure-level Emissions

```xml
<xs:element name="MeasureSavingsAnalysis" minOccurs="0">
  <xs:complexType>
    <xs:sequence>
      <!-- ... -->
      <xs:element ref="auc:AnnualSavingsAverageGHGEmissions" minOccurs="0"/>
      <xs:element ref="auc:AnnualSavingsMarginalGHGEmissions" minOccurs="0"/>
      <xs:element ref="auc:AnnualSavingsGHGEmissionIntensity" minOccurs="0"/>
      <!-- ... -->
    </xs:sequence>
  </xs:complexType>
</xs:element>
```

### Fuel-source-level Emissions

```xml
<xs:element name="AnnualSavingsByFuel" maxOccurs="unbounded">
  <xs:complexType>
    <xs:sequence>
      <!-- ... -->
      <xs:element ref="auc:AnnualSavingsAverageGHGEmissions" minOccurs="0"/>
      <xs:element ref="auc:AnnualSavingsMarginalGHGEmissions" minOccurs="0"/>
      <xs:element ref="auc:AnnualSavingsGHGEmissionIntensity" minOccurs="0"/>
      <!-- ... -->
    </xs:sequence>
  </xs:complexType>
</xs:element>
```
