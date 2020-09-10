# Add DHW Condition and Notes

## Overview

This proposal is to add `auc:DomesticHotWaterSystemCondition` and `auc:DomesticHotWaterSystemNotes` elements to `auc:DomesticHotWaterSystem`.

## Justification

SPC 211 Standard for Commercial Building Energy Audits section 6.2.1.4.c specifies the following regarding Service/Domestic Hot Water
> Assessment of general condition (excellent, good, average, poor). Determined by observation or testing and referring both to condition of equipment and energy use level, including notation of deficiencies. The report shall describe the methods of evaluation used and the basis for establishing system efficiency.

Since there is no condition element for DHW in BuildingSync, nor an element for freeform notes, these two elements are necessary.

## Implementation

Following BuildingSync convention of systems/entities with `auc:*Condition` and `auc:*Notes`, we will add the optional elements `auc:DomesticHotWaterSystemCondition` and `auc:DomesticHotWaterSystemNotes` as children to `auc:DomesticHotWaterSystem`.
