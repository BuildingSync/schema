# Update Annual Fuel Use Native Units

## Overview

This proposal is to add `Operational` as an enum choice for `auc:ScheduleCategory`

## Justification

211 6.2.1.1.e specifies
> Schedules of occupant density, lighting, process and plug loads, and equipment use shall be provided for typical days

There is no appropriate `auc:ScheduleCategory` for process and plug loads as well as equipment use. This new category would be intended to cover those cases.
