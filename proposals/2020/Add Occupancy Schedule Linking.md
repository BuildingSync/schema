# Add occupancy schedule linking

## Overview

This proposal is to address the need of linking a schedule related to occupancy to sections (specifically space functions).

## Justification

Standard 211 6.2.1.1.e states:
> Schedules of **occupant density**, lighting, process and plug loads, and equipment use shall be provided for typical days.

It's been decided these schedules should be specified at the level of space functions.

Currently, there are two patterns for linking schedules to "premises" in BuildingSync
1. Through a system. Most (all?) systems have an `auc:LinkedPremises` element. This provides the ability to link a system to a premise, and _also_ specify the schedule associated (using `auc:LinkedScheduleIDs`)
1. Premise -> schedule linking. For example, in `auc:Space` (in `auc:ThermalZone/auc:Spaces`) BuildingSync allows linking to schedules (related to occupancy) through `auc:OccupancyScheduleIDs`.

Since there's no way to currently link occupancy schedules to sections (space functions), (there is no system which can be used to link it, and there is no `auc:OccupancyScheduleIDs` at the level of `auc:Section`), BuildingSync needs this addition.

## Implementation

### Option 1
Add `auc:OccupancyScheduleIDs` to `auc:Section`
```xml
<auc:Building>
  <auc:Sections>
    <auc:Section ID="SpaceFunction-A">
      <auc:SectionType>Space function</auc:SectionType>
      ...
      <!-- add this element -->
      <auc:OccupancyScheduleIDs>
        <auc:OccupancyScheduleID IDref="Schedule-Weekdays"/>
        <auc:OccupancyScheduleID IDref="Schedule-Weekend"/>
      </auc:OccupancyScheduleIDs>
    </auc:Section>
  </auc:Sections>
</auc:Building>
...
<auc:Schedules>
  <auc:Schedule ID="Schedule-Weekdays">
    <auc:ScheduleDetails>
      <auc:ScheduleDetail>
        <auc:DayType>Weekday</auc:DayType>
        <auc:ScheduleCategory>Occupied</auc:ScheduleCategory>
        <auc:PartialOperationPercentage>80</auc:PartialOperationPercentage>
      </auc:ScheduleDetail>
    </auc:ScheduleDetails>
  </auc:Schedule>
  <auc:Schedule ID="Schedule-Weekend">
    <auc:ScheduleDetails>
      <auc:ScheduleDetail>
        <auc:DayType>Weekend</auc:DayType>
        <auc:ScheduleCategory>Occupied</auc:ScheduleCategory>
        <auc:PartialOperationPercentage>40</auc:PartialOperationPercentage>
      </auc:ScheduleDetail>
    </auc:ScheduleDetails>
  </auc:Schedule>
<auc:Schedules>
```

#### Pros
- non-breaking
- follows pattern of `auc:Spaces`

#### Cons
- only solves specific problem. What if we eventually want to link occupancy schedules to buildings and not spaces?

### Option 2
Add `auc:LinkedPremises` to `auc:Schedule`
```xml
<auc:Building>
  <auc:Sections>
    <auc:Section ID="SpaceFunction-A">
      <auc:SectionType>Space function</auc:SectionType>
      ...
    </auc:Section>
  </auc:Sections>
</auc:Building>
...
<auc:Schedules>
  <auc:Schedule ID="Schedule-Weekdays">
    <auc:ScheduleDetails>
      <auc:ScheduleDetail>
        <auc:DayType>Weekday</auc:DayType>
        <auc:ScheduleCategory>Occupied</auc:ScheduleCategory>
        <auc:PartialOperationPercentage>80</auc:PartialOperationPercentage>
      </auc:ScheduleDetail>
    </auc:ScheduleDetails>
    <!-- add this element -->
    <auc:LinkedPremises>
      <auc:Section>
        <auc:LinkedSectionID IDref="SpaceFunction-A"/>
      </auc:Section>
    <auc:LinkedPremises>
  </auc:Schedule>
  <auc:Schedule ID="Schedule-Weekend">
    <auc:ScheduleDetails>
      <auc:ScheduleDetail>
        <auc:DayType>Weekend</auc:DayType>
        <auc:ScheduleCategory>Occupied</auc:ScheduleCategory>
        <auc:PartialOperationPercentage>40</auc:PartialOperationPercentage>
      </auc:ScheduleDetail>
    </auc:ScheduleDetails>
    <!-- add this element -->
    <auc:LinkedPremises>
      <auc:Section>
        <auc:LinkedSectionID IDref="SpaceFunction-A"/>
      </auc:Section>
    <auc:LinkedPremises>
  </auc:Schedule>
<auc:Schedules>
```

#### Pros
- non-breaking
- solves linking of occupancy schedules to any premise type

#### Cons
- could be very confusing if a user sees they can link a schedule through a system, or directly to a premise
- allows users to link a schedule to another schedule, which probably doesn't make any sense

#### Variations
- don't use LinkedPremises, but come up with a new linking element which is basically the same but doesn't allow linking to schedules

## References

Standard 211 6.2.1.1.e
