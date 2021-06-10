# Deprecate OutputCapacity

## Overview

This proposal is to deprecate the `OutputCapacity` elements under `HeatingPlant` types and `HeatingSource`.

## Justification

As discussed in [BuildingSync/TestSuite#31](https://github.com/BuildingSync/TestSuite/issues/31), `OutputCapacity` should be replaced with `Capacity` under the following elements.
`auc:HeatingPlant/auc:Boiler`
`auc:HeatingPlant/auc:DistrictHeating`
`auc:HeatingPlant/auc:SolarThermal`
`auc:HeatingAndCoolingSystems/auc:HeatingSources/auc:HeatingSource`

`Capacity` was added as a choice in parallel with `OutputCapacity` in PR [#242](https://github.com/BuildingSync/schema/pull/242) to avoid breaking change. In version 3.0, we propose to deprecate `OutputCapacity` and keep only `Capacity`.

## References
