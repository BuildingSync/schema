# Add Emissions Fields

## Overview

This proposal is to add several Emissions related fields to the BuildingSync schema to capture information on GHG emissions, in units of MtCO2e. 

1. Added to AllResourceTotal:
	- AnnualAverageGHGEmissions
	- AnnualMarginalGHGEmissions
  - AnnualGHGEmissionIntensity
1. Added to ResourceUse -> Emissions -> Emission:
	- EmissionsLinkedTimeSeriesIDs -> EmissionsLinkedTimeSeriesID
1. Added to TimeSeries -> TimeSeriesReadingQuantity
	- Enum "Emissions"
1. Scenario Type changes by scenario_type:
	1. Added to ScenarioType -> CurrentBuilding, ScenarioType -> Benchmark, and ScenarioType -> Derived Model
		- no changes
	1. Added to ScenarioType -> Target, ScenarioType -> PackageOfMeasures, and ScenarioType -> Other:
		- AnnualSavingsAverageGHGEmissions
		- AnnualSavingsMarginalGHGEmissions
    - AnnualSavingsGHGEmissionIntensity

## Justification

The BuildingSync schema needs to be modified to accommodate a standard way of reporting GHG emissions (in MtCO2e) to support the focus on decarbonization efforts.

## Implementation

```xml
 <xs:element name="AnnualSavingsAverageGHGEmissions">
    <xs:annotation>
      <xs:documentation>Average GHG emissions savings per year. (MtCO2e/year)</xs:documentation>
    </xs:annotation>
    <xs:complexType>
      <xs:simpleContent>
        <xs:extension base="xs:decimal">
          <xs:attribute ref="auc:Source"/>
        </xs:extension>
      </xs:simpleContent>
    </xs:complexType>
  </xs:element>
  <xs:element name="AnnualSavingsMarginalGHGEmissions">
    <xs:annotation>
      <xs:documentation>Marginal GHG emissions savings per year. (MtCO2e/year)</xs:documentation>
    </xs:annotation>
    <xs:complexType>
      <xs:simpleContent>
        <xs:extension base="xs:decimal">
          <xs:attribute ref="auc:Source"/>
        </xs:extension>
      </xs:simpleContent>
    </xs:complexType>
  </xs:element>
  <xs:element name="AnnualSavingsGHGEmissionIntensity">
    <xs:annotation>
      <xs:documentation>Annual GHG emissions intensity savings per year. (kg CO2e/ft2/year)</xs:documentation>
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
```xml
  <xs:element name="AnnualAverageGHGEmissions" minOccurs="0">
    <xs:annotation>
      <xs:documentation>Annual Average GHG Emissions. (MtCO2e)</xs:documentation>
    </xs:annotation>
    <xs:complexType>
      <xs:simpleContent>
        <xs:extension base="xs:decimal">
          <xs:attribute ref="auc:Source"/>
        </xs:extension>
      </xs:simpleContent>
    </xs:complexType>
  </xs:element>
  <xs:element name="AnnualMarginalGHGEmissions" minOccurs="0">
    <xs:annotation>
      <xs:documentation>Annual Marginal GHG Emissions. (MtCO2e)</xs:documentation>
    </xs:annotation>
    <xs:complexType>
      <xs:simpleContent>
        <xs:extension base="xs:decimal">
          <xs:attribute ref="auc:Source"/>
        </xs:extension>
      </xs:simpleContent>
    </xs:complexType>
  </xs:element>
  <xs:element name="AnnualGHGEmissionIntensity" minOccurs="0">
    <xs:annotation>
      <xs:documentation>Annual GHG Emission Intensity. (kg CO2e/ft2/year)</xs:documentation>
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

```xml
 <xs:element name="Emissions" minOccurs="0">
  <xs:complexType>
    <xs:sequence>
      <xs:element name="Emission" minOccurs="0" maxOccurs="unbounded">
        <xs:complexType>
          <xs:sequence>
          	
          	...

          	<xs:element minOccurs="0" name="EmissionsLinkedTimeSeriesIDs">
              <xs:annotation>
                <xs:documentation>Links to all time series data used to calculate the GHGEmissions</xs:documentation>
              </xs:annotation>
              <xs:complexType>
                <xs:sequence>
                  <xs:element maxOccurs="unbounded" minOccurs="1" name="EmissionsLinkedTimeSeriesID">
                    <xs:complexType>
                      <xs:attribute name="IDref" type="xs:IDREF"/>
                    </xs:complexType>
                  </xs:element>
                </xs:sequence>
              </xs:complexType>
            </xs:element>
          </xs:sequence>
        </xs:complexType>
      </xs:element>
    </xs:sequence>
  </xs:complexType>
</xs:element>
```

