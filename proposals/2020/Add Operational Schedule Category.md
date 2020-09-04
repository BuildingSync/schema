# Update Annual Fuel Use Native Units

## Overview

This proposal is to add `Operational` as an enum choice for `auc:ScheduleCategory`

## Justification

211 6.2.1.1.e specifies
> Schedules of occupant density, lighting, process and plug loads, and equipment use shall be provided for typical days

There is no appropriate `auc:ScheduleCategory` for process and plug loads as well as equipment use. This new category would be intended to cover those cases.

## Implementation

```xml
...
<xs:element name="ScheduleCategory" minOccurs="0">
  <xs:annotation>
    <xs:documentation>Type of schedule (e.g., occupancy, lighting, heating, etc.) that will be specified.</xs:documentation>
  </xs:annotation>
  <xs:simpleType>
    <xs:restriction base="xs:string">
      ...
      <!-- add this enum -->
      <xs:enumeration value="Operational"/>
      ...
    </xs:restriction>
  </xs:simpleType>
</xs:element>
...
```
