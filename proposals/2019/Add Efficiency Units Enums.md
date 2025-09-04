# AnnualCoolingEfficiencyUnits, AnnualHeatingEfficiencyUnits and WaterHeaterEfficiencyType - Add Enumerations And Harmonize Names

## Overview

The `auc:AnnualCoolingEfficiencyUnits` and `auc:AnnualHeatingEfficiencyUnit` elements are inconsistently named.

The `auc:AnnualHeatingEfficiencyUnits` and `auc:WaterHeaterEfficiencyType` elements are missing enumerations.

## Justification

The name of the `auc:AnnualCoolingEfficiencyUnits` element is pluralized, whereas the name of the `auc:AnnualHeatingEfficiencyUnit` element is not.

In Audit Template, "Thermal Efficiency" is a valid unit for heating sources.

In Audit Template, "AFUE" is a valid unit for domestic hot water systems.

## Implementation

This proposal is to:

1. Rename `auc:AnnualHeatingEfficiencyUnit` to `auc:AnnualHeatingEfficiencyUnits` (so that is consistent with `auc:AnnualCoolingEfficiencyUnits`).

2. Add the following enumerations to the `auc:AnnualHeatingEfficiencyUnits` element:

- "Thermal Efficiency"

3. Add the following enumerations to the `auc:WaterHeaterEfficiencyType` element:

- "AFUE"

## References

n/a
