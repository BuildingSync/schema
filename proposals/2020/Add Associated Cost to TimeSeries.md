# Add Associated Cost to TimeSeries

## Overview

This proposal is to include a method for associating cost ($) with time series data.

## Justification

The monthly resource use cost is required information per Standard 211 6.1.2.1 (i), which states

> Monthly utility data, including the following, for a minimum of 12 consecutive months (although three consecutive years is preferable), aggregated for the whole building by energy supplier, shall be reported using the forms in Normative Annex C (“Metered Energy” tab) ... **Annual site fuel (or other energy source) use in therms, gallons, lbs, MJ, or Btu, as appropriate, and cost ($); if fuel is delivered as a liquid or solid, a report of the annual amount used from actual delivered quantities or inventory change for each year**

An important note is that STD 211 requires Total, Peak, and Cost for each Monthly metering interval.

## Implementation

There are multiple options for implementation.

### Option 1

Define a new enum for `auc:ReadingType`, `Cost`, in `auc:TimeSeries`.

```xml
<auc:Scenario>
    <auc:TimeSeriesData>
        <auc:TimeSeries>
            <auc:ReadingType>Total</auc:ReadingType>
            <auc:StartTimestamp>2019-01-01T00:00:00</auc:StartTimestamp>
            <auc:EndTimestamp>2019-02-01T00:00:00</auc:EndTimestamp>
            <auc:IntervalFrequency>Month</auc:IntervalFrequency>
            <auc:IntervalReading>123</auc:IntervalReading>
            <auc:ResourceUseID IDref="ResourceUse-Electricity" />
        </auc:TimeSeries>
        <auc:TimeSeries>
            <auc:ReadingType>Peak</auc:ReadingType>
            <auc:StartTimestamp>2019-01-01T00:00:00</auc:StartTimestamp>
            <auc:EndTimestamp>2019-02-01T00:00:00</auc:EndTimestamp>
            <auc:IntervalFrequency>Month</auc:IntervalFrequency>
            <auc:IntervalReading>123</auc:IntervalReading>
            <auc:ResourceUseID IDref="ResourceUse-Electricity" />
        </auc:TimeSeries>
        <auc:TimeSeries>
            <!-- Add this type -->
            <auc:ReadingType>Cost</auc:ReadingType>
            <auc:StartTimestamp>2019-01-01T00:00:00</auc:StartTimestamp>
            <auc:EndTimestamp>2019-02-01T00:00:00</auc:EndTimestamp>
            <auc:IntervalFrequency>Month</auc:IntervalFrequency>
            <auc:IntervalReading>1000</auc:IntervalReading>
            <auc:ResourceUseID IDref="ResourceUse-Electricity" />
        </auc:TimeSeries>
    </auc:TimeSeriesData>
</auc:Scenario>
```

#### Pros

- non-breaking change

#### Cons

- linking a cost to another reading (eg Total use) is non-trivial and must be done using Start and End Timestamps as well as the ResourceUseID's IDref. Specifically, one must:

1. Find all auc:ReadingType=Cost associated with a ResourceUse
1. Ensure start and end timestamps align across different auc:TimeSeries elements (i.e. the cost and the reading are referring to the same period of time).

### Option 2

Change `auc:TimeSeries` to include `auc:IntervalReadings` which could contain multiple reading types.

```xml
<auc:Scenario>
    <auc:TimeSeriesData>
        <auc:TimeSeries>
            <!-- Add this element -->
            <auc:IntervalReading>
                <auc:Total>123</auc:Total>
                <auc:Peak>123</auc:Peak>
                <auc:Cost>1000</auc:Cost>
            </auc:IntervalReading>
            <auc:StartTimestamp>2019-01-01T00:00:00</auc:StartTimestamp>
            <auc:EndTimestamp>2019-02-01T00:00:00</auc:EndTimestamp>
            <auc:IntervalFrequency>Month</auc:IntervalFrequency>
            <auc:ResourceUseID IDref="ResourceUse-Electricity" />
        </auc:TimeSeries>
    </auc:TimeSeriesData>
</auc:Scenario>
```

#### Pros

- More concise modeling of meter data required by STD 211
- easy to find associated cost with a reading, and can handle cost that's associated with multiple reading types

#### Cons

- breaking change
- another layer of nesting, which is unnecessary if most people just use it for reporting only one reading type

## Decision

We will implement Option 1 for now since it is non-breaking, and will move to Option 2 at a later time.
