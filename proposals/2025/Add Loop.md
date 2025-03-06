# Add Loop elements

## Overview

This proposal is to add new elements related to Loop components used in BEM tools such as EnergyPlus/OpenStudio, and to map with the standardized usage of Loop or `FluidLoop` elements in ASHRAE Standard 229P - Protocols for Evaluating Ruleset Application in Building Performance Models. In 229P, `FluidLoop` element is defined and used in [schema](https://github.com/open229/ruleset-model-description-schema/blob/6509fdcc546053e13f06eb78b3fba99328fda58d/docs229/ASHRAE229.schema.json#L3316) for elements as follow:
* `FluidLoop` -> `fuild_loop`: list of all loops and sources to link from
  * `id`
  * `Type`: "HEATING","COOLING","HEATING_AND_COOLING","CONDENSER", "OTHER"
  * `pump_power_per_flow_rate`: W-s/L
  * `child_loops`
  * `cooling_or_condensing_design_and_control` -> `FluidLoopDesignAndControl`
  * `heating_design_and_control` -> `FluidLoopDesignAndControl`
    * `design_supply_temperature`
    * `design_return_temperature`
    * `is_sized_using_coincident_load`
    * `minimum_flow_fraction`
    * `operation` -> `FluidLoopOperationOptions`
    * `operation_schedule`
    * `flow_control` -> `FluidLoopFlowControlOptions`
    * `temperature_reset_type`
    * `outdoor_high_for_loop_supply_reset_temperature`
    * `outdoor_low_for_loop_supply_reset_temperature`
    * `loop_supply_temperature_at_outdoor_high`
    * `loop_supply_temperature_at_outdoor_low`
    * `loop_supply_temperature_at_low_load`
    * `has_integrated_waterside_economizer`
* `HeatingSystem`
  * `HeatingSystemOptions`[FLUID_LOOP]
  * `hot_water_loop`: link to the loop of a boiler
  * `water_source_heat_pump_loop`
  * `HeatingMetricOptions`[COEFFICIENT_OF_PERFORMANCE_xxx_TO_xxx_LOOP]
* `Boiler`
  * `loop`
* `CoolingSystem`
  * `CoolingSystemOptions`[FLUID_LOOP]
  * `chilled_water_loop`: link to the loop of a chiller
  * `condenser_water_loop`: link to the loop of a condenser
  * `CoolingMetricOptions`[COEFFICIENT_OF_PERFORMANCE_xxx_TO_xxx_LOOP]
* `Chiller`
  * `cooling_loop`
  * `condensing_loop`
  * `heat_recovery_loop`
* `ServiceWaterHeatingEquipment`
  * `hot_water_loop`
* `HeatRejection`/`loop`
* `MiscellaneousEquipment`
  * `remaining_fraction_to_loop`
  * `energy_from_loop`
* `Terminal`
  * `heating_from_loop`
  * `cooling_from_loop`
* `ExternalFuildSource`/`loop`

## Justification
Considering the hierarchy of systems in BuildingSync and the loop elements really used in [OpenStudio](https://openstudio-sdk-documentation.s3.amazonaws.com/cpp/OpenStudio-3.2.1-doc/model/html/classopenstudio_1_1model_1_1_loop.html), we propose (for the first stage of mapping) to add loop elements for
### ADD
* `Plant`/`HeatingPlant` (or only under /`Boiler`? Or also /`DistricHeating`?)
  * `Loop`
  * May be duplicated with HeatingPlant/Boiler/Some flow rate values
* `Plant`/`CoolingPlant` (or only under /`Chiller`? Or also /`DistrictChilledWater`?)
  * `Loop`
* `Plant`/`CondenserPlant`/`WaterCooled`
  * `Loop`
* `DomesticHotWaterSystem`
  * `Loop` or `HotWaterLoop`
  * If /`HotWaterDistributionType` is "Looped"
* `HeatRecoverySystem`
  * `Loop`
### USE REF (linking element)
* `HeatingAndCoolingSystems`
  * `HeatingSource`/`HeatingSourceType`/`SourceHeatingPlantID`: linked to the plant loop above 
  * `CoolingSource`/`CoolingSourceType`/`CoolingPlantID`: linked to the plant loop above
* `PumpSystem`
  * `LinkedSystemID`: linked to the system with loop for which the pump system serves
### Global element structure
Considering the shared properties/definitions of `loop`, ideal implementation of the addition is through adding global element `loop` and call/refer to it under every elements above to call the usage of `loop`

## Implementation


## Reference
