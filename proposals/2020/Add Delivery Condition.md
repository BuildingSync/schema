# Add Delivery Condition

## Overview

This proposal is to add `auc:DeliveryCondition` element to `auc:Delivery`

## Justification

Addressing HVAC system requirements, Standard 211 6.2.1.3.a states the report must include
> Assessment of general condition (excellent, good, average, poor) determined by observation or testing, including notation of deficiencies

This is already included for most subsystems of HVAC, `auc:CoolingSource`, `auc:HeatingSource`, `auc:CoolingPlant`, etc. but not included for `auc:Delivery`.

## Implementation

Add optional element `auc:DeliveryCondition` to `auc:Delivery`.