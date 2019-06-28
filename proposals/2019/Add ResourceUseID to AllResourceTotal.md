# Add ResourceUseID to AllResourceTotal

## Overview

This proposal is to add the `<auc:ResourceUseID>` element to the `<auc:AllResourceTotal>` element.

## Justification

The capability for a time series to refer to a given energy resource is currently available; however, when a scenario contains time series that include data for more than one energy resource, there should be a complementary mechanism to assert which energy resources are being summarized by a given total.

This proposal resolves the above issue, allowing the following XML to validate:

```xml
<BuildingSync>
  <Facilities>
    <Facility ID="Facility1">
      <Scenarios>
        <Scenario ID="Scenario1">
          <ResourceUses>
            <ResourceUse ID="ResourceUse1">
              <EnergyResource>Diesel</EnergyResource>
            </ResourceUse>
            <ResourceUse ID="ResourceUse2">
              <EnergyResource>Natural gas</EnergyResource>
            </ResourceUse>
          </ResourceUses>
          <TimeSeriesData>
            <TimeSeries ID="TimeSeries1">
              <auc:ReadingType>Point</auc:ReadingType>
              <auc:TimeSeriesReadingQuantity>Energy</auc:TimeSeriesReadingQuantity>
              <auc:StartTimeStamp>2019-06-28T00:00:00+00:00</auc:StartTimeStamp>
              <auc:EndTimeStamp>2019-06-28T00:00:00+00:00</auc:EndTimeStamp>
              <auc:IntervalReading>100.0</auc:IntervalReading>
              <auc:ResourceUseID IDref="ResourceUse1"/>
            </TimeSeries>
            <TimeSeries ID="TimeSeries2">
              <auc:ReadingType>Point</auc:ReadingType>
              <auc:TimeSeriesReadingQuantity>Energy</auc:TimeSeriesReadingQuantity>
              <auc:StartTimeStamp>2019-06-28T00:00:00+00:00</auc:StartTimeStamp>
              <auc:EndTimeStamp>2019-06-28T00:00:00+00:00</auc:EndTimeStamp>
              <auc:IntervalReading>50.0</auc:IntervalReading>
              <auc:ResourceUseID IDref="ResourceUse2"/>
            </TimeSeries>
          </TimeSeriesData>
          <AllResourceTotals>
            <AllResourceTotal ID="AllResourceTotal1">
              <ResourceUseIDs>
                <ResourceUseID IDref="ResourceUse1"/>
              </ResourceUseIDs>
            </AllResourceTotal>
            <AllResourceTotal ID="AllResourceTotal2">
              <ResourceUseIDs>
                <ResourceUseID IDref="ResourceUse2"/>
              </ResourceUseIDs>
            </AllResourceTotal>
          </AllResourceTotals>
        </Scenario>
      </Scenarios>
    </Facility>
  </Facilities>
</BuildingSync>
```

In the above example, we assert the existence of a scenario where a time series includes data for two energy resources.

## Implementation

This proposal is to add the following XPaths:
* `//BuildingSync/Facilities/Facility/Scenarios/Scenario/AllResourceTotals/AllResourceTotal/ResourceUseIDs/ResourceUseID`

## References

n/a
