# Add LifeCycleSavings elements

## Overview

This proposal is to add new elements related to Life Cycle savings data for mapping FEMP's Compliance Tracking System fields to BuildingSync Schema: 
* Estimated Life-Cycle Energy Savings (Million Btu)
* Estimated Present Value Life-Cycle Energy Cost Savings (Dollars)
* Estimated Life-Cycle Water Savings (Thou. Gallons)
* Estimated Present Value Life-Cycle Water Cost Savings (Dollars)
* Estimated Other Present Value Life-Cycle Ancillary Cost Savings (Dollars)
We proposed to add
* `auc:LifeCycleSavingsEnergy`
* `auc:LifeCycleSavingsEnergyCost`
* `auc:LifeCycleSavingsWater`
* `auc:LifeCycleSavingsWaterCost`
* `auc:LifeCycleSavingsAncillaryCost`
under 
1. `auc:Measure/auc:MeasureSavingsAnalysis`
2. `auc:Report/auc:Scenarios/auc:Scenario/auc:ScenarioType/auc:Target`
3. `auc:Report/auc:Scenarios/auc:Scenario/auc:ScenarioType/auc:PackageOfMeasures`
4. `auc:Report/auc:Scenarios/auc:Scenario/auc:ScenarioType/auc:Other`
5. `auc:Report/auc:Scenarios/auc:Scenario/auc:ScenarioType/auc:PackageOfMeasures/auc:MeasureIDs/auc:MeasureID/auc:MeasureSavingsAnalysis`

## Justification

These elements work similarly with the current simple annual savings data such as `auc:AnnualSavingsSiteEnergy` and `auc:AnnualSavingsCost`, so they should be at least added in the same places (above 5 paths). 
As proposed in ways for eProjectBuilder mapping efforts, a Project class will be added in parallel with Sites, Reports and Measures, and all the project related data will be added/linked under it. This way the life-cycle analysis data could be added in the new project fields in the future. 

## Implementation
Globally definition:
```xml
  <xs:element name="LifeCycleSavingsEnergy">
    <xs:annotation>
      <xs:documentation>Estimated total energy savings in the whole life cycle (MMBtu)</xs:documentation>
    </xs:annotation>
    <xs:complexType>
      <xs:simpleContent>
        <xs:extension base="xs:decimal">
          <xs:attribute ref="auc:Source"/>
        </xs:extension>
      </xs:simpleContent>
    </xs:complexType>
  </xs:element>
  <xs:element name="LifeCycleSavingsEnergyCost">
    <xs:annotation>
      <xs:documentation>Estimated present value of total savings in energy costs in the whole life cycle ($)</xs:documentation>
    </xs:annotation>
    <xs:complexType>
      <xs:simpleContent>
        <xs:extension base="xs:decimal">
          <xs:attribute ref="auc:Source"/>
        </xs:extension>
      </xs:simpleContent>
    </xs:complexType>
  </xs:element>
  <xs:element name="LifeCycleSavingsWater">
    <xs:annotation>
      <xs:documentation>Estimated total water savings in the whole life cycle (gal)</xs:documentation>
    </xs:annotation>
    <xs:complexType>
      <xs:simpleContent>
        <xs:extension base="xs:decimal">
          <xs:attribute ref="auc:Source"/>
        </xs:extension>
      </xs:simpleContent>
    </xs:complexType>
  </xs:element>
  <xs:element name="LifeCycleSavingsWaterCost">
    <xs:annotation>
      <xs:documentation>Estimated present value of total savings in water costs in the whole life cycle ($)</xs:documentation>
    </xs:annotation>
    <xs:complexType>
      <xs:simpleContent>
        <xs:extension base="xs:decimal">
          <xs:attribute ref="auc:Source"/>
        </xs:extension>
      </xs:simpleContent>
    </xs:complexType>
  </xs:element>
  <xs:element name="LifeCycleSavingsAncillaryCost">
    <xs:annotation>
      <xs:documentation>Estimated present value of total cost savings in ancillary/other costs in the whole life cycle ($)</xs:documentation>
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
Under `auc:MeasureSavingsAnalysis`:
```xml
  <xs:element name="MeasureSavingsAnalysis">
    <xs:complexType>
      <xs:sequence>
        <xs:element ref="auc:LifeCycleSavingsEnergy" minOccurs="0"/>
        <xs:element ref="auc:LifeCycleSavingsEnergyCost" minOccurs="0"/>
        <xs:element ref="auc:LifeCycleSavingsWater" minOccurs="0"/>
        <xs:element ref="auc:LifeCycleSavingsWaterCost" minOccurs="0"/>
        <xs:element ref="auc:LifeCycleSavingsAncillaryCost" minOccurs="0"/>
      ...
```
Under `auc:Scenario/auc:ScenarioType/auc:Target`:
```xml
  <xs:element name="Target" minOccurs="0">
    <xs:complexType>
      <xs:sequence>
        <xs:element ref="auc:LifeCycleSavingsEnergy" minOccurs="0"/>
        <xs:element ref="auc:LifeCycleSavingsEnergyCost" minOccurs="0"/>
        <xs:element ref="auc:LifeCycleSavingsWater" minOccurs="0"/>
        <xs:element ref="auc:LifeCycleSavingsWaterCost" minOccurs="0"/>
        <xs:element ref="auc:LifeCycleSavingsAncillaryCost" minOccurs="0"/>
      ...
```
Under `auc:Scenario/auc:ScenarioType/auc:PackageOfMeasures`:
```xml
  <xs:element name="PackageOfMeasures" minOccurs="0">
    <xs:complexType>
      <xs:sequence>
        <xs:element ref="auc:LifeCycleSavingsEnergy" minOccurs="0"/>
        <xs:element ref="auc:LifeCycleSavingsEnergyCost" minOccurs="0"/>
        <xs:element ref="auc:LifeCycleSavingsWater" minOccurs="0"/>
        <xs:element ref="auc:LifeCycleSavingsWaterCost" minOccurs="0"/>
        <xs:element ref="auc:LifeCycleSavingsAncillaryCost" minOccurs="0"/>
      ...
```
Under `auc:Scenario/auc:ScenarioType/auc:Other`:
```xml
  <xs:element name="Other" minOccurs="0">
    <xs:complexType>
      <xs:sequence>
        <xs:element ref="auc:LifeCycleSavingsEnergy" minOccurs="0"/>
        <xs:element ref="auc:LifeCycleSavingsEnergyCost" minOccurs="0"/>
        <xs:element ref="auc:LifeCycleSavingsWater" minOccurs="0"/>
        <xs:element ref="auc:LifeCycleSavingsWaterCost" minOccurs="0"/>
        <xs:element ref="auc:LifeCycleSavingsAncillaryCost" minOccurs="0"/>
      ...
```
