# HeatingSourceType - Add ElectricResistance

## Overview

Add `auc:ElectricResistance` to the choice for `auc:HeatingSourceType`.

## Justification

In Audit Template, electric resistance is a valid heating source type; however, it is not a valid `auc:HeatingSourceType` in BuildingSync XML.

It should be noted that electric resistance is currently valid as a `auc:DirectTankHeatingSource` and/or `auc:InstantaneousWaterHeatingSource` in BuildingSync XML.

## Implementation

This proposal is to add `auc:ElectricResistance` to the choice for `auc:HeatingSourceType`.

## References

n/a
