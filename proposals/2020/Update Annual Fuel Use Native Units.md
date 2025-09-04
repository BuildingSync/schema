# Update Annual Fuel Use Native Units

## Overview

This proposal is to modify the `auc:AnnualFuelUseNativeUnits` element in order to more clearly specify how it's value was calculated.

## Justification

In the 211 Spreadsheet, annual fuel use is calculated using the "Main Data For Analysis - <resource name>" table (All - Metered Energy tab) for each resource. The calculation is `annual fuel use = (total resource use) / (total number of days in monthly meter report) * 365`. For BuildingSync, the calculation of this value, annual fuel use, can be ambiguous: which `auc:TimeSeries` were included in the calculation? This is an issue because the standard allows more than just 12 consecutive months, and we don't have a way to specify which data were included in the calculation.

## Implementation

### Option 1

Update documentation specifying that, for 211 reports, `auc:AnnualFuelUseNativeUnits` should only include the 12 most recent monthly meter readings. This isn't too different from the existing documentation.

#### Pros

- simple, no changes to schema

#### Cons

- validation can be a bit tricky (verifying the calculation was done correctly), e.g. what if they report the data in weekly intervals?

### Option 2

Add new attributes to `auc:AnnualFuelUseNativeUnits`, `auc:StartDate` and `auc:EndDate`, which indicate the time frame used to calculate the annual

```xml
      <xs:element name="AnnualFuelUseNativeUnits" minOccurs="0">
        <xs:annotation>
          <xs:documentation>Sum of all time series values for the past year, in the original units. (units/yr)</xs:documentation>
        </xs:annotation>
        <xs:complexType>
          <xs:simpleContent>
            <xs:extension base="xs:decimal">
              <xs:attribute ref="auc:Source"/>
              <!-- new attributes -->
              <xs:attribute name="StartDate" type="xs:date"/>
              <xs:attribute name="EndDate" type="xs:date"/>
            </xs:extension>
          </xs:simpleContent>
        </xs:complexType>
      </xs:element>
```

#### Pros

- explicit, calculations easily replicable.

#### Cons

- more complexity

## Option 3

Add `AnnualFuelUseIncludedTimeSeries` to `auc:ResourceUse`, which contains a list of linked `auc:TimeSeries` IDs.

```xml
      <xs:element name="AnnualFuelUseIncludedTimeSeries" minOccurs="0">
        <xs:annotation>
          <xs:documentation>Links to all time series data used to calculate the AnnualFuelUse values.</xs:documentation>
        </xs:annotation>
        <xs:complexType>
          <xs:sequence>
            <xs:element name="LinkedTimeSeriesID" maxOccurs="unbounded">
              <xs:complexType>
                <xs:attribute name="IDref" type="xs:IDREF" use="required"/>
              </xs:complexType>
            </xs:element>
          </xs:sequence>
        </xs:complexType>
      </xs:element>
```

## Decision

Option 1 is not compatible with the way Audit Template Tool calculates AnnualFuelUse, so we ruled it out. Option 2 is less desirable because it's valid to define even when TimeSeries data isn't included in the document, which isn't ideal.

We are moving forward with Option 3 because it follows the general pattern of linking in BuildingSync and is very explicit.
