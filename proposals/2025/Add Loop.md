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
        * `operation` -> `FluidLoopOperationOptions`: CONTINUOUS","INTERMITTENT","SCHEDULED"
        * `operation_schedule`
        * `flow_control` -> `FluidLoopFlowControlOptions`: "FIXED_FLOW","VARIABLE_FLOW"
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
    * `FluidLoop`
    * May be duplicated with HeatingPlant/Boiler/Some flow rate values
* `Plant`/`CoolingPlant` (or only under /`Chiller`? Or also /`DistrictChilledWater`?)
    * `FluidLoop`
* `Plant`/`CondenserPlant`/`WaterCooled`
    * `FluidLoop`
* `DomesticHotWaterSystem`/`Recirculation`
    * `FluidLoop` (`HotWaterLoop`)
    * If /`HotWaterDistributionType` is "Looped"
* `HeatRecoverySystem`
    * `FluidLoop`
### USE REF (linking element)
* `HeatingAndCoolingSystems`
    * `HeatingSource`/`HeatingSourceType`/`SourceHeatingPlantID`: linked to the plant loop above 
    * `CoolingSource`/`CoolingSourceType`/`CoolingPlantID`: linked to the plant loop above
* `PumpSystem`/`LinkedSystemIDs`/`LinkedSystemID`
    * Loop for which the pump system serves
### Global element structure
Considering the shared properties/definitions of `FluidLoop`, ideal implementation of the addition is through adding global element `FluidLoop` and call/refer to it under every elements above to call the usage of `FluidLoop`
### Child elements
Some of the child properties under `loop` in 229P are already defined (in some other way) within BuildingSync, we propose to add these new childs for the added `FluidLoop`:
* `ID`
* `Type`: "HEATING","COOLING","HEATING_AND_COOLING","CONDENSER", "OTHER"
* `PumpPowerPerFlowRate`: W-s/L
* `LinkedChildLoops`/`LinkedChildLoop`
* `FluidLoopDesignAndControl`
    * `DesignSupplyTemperature`
    * `DesignReturnTemperature`
    * `MinimumFlowFraction`
    * `operation` -> `FluidLoopOperationOptions`
    * `operation_schedule`
    * `flow_control` -> `FluidLoopFlowControlOptions`
    * `temperature_reset_type`
        * `outdoor_high_for_loop_supply_reset_temperature`
        * `outdoor_low_for_loop_supply_reset_temperature`
        * `loop_supply_temperature_at_outdoor_high`
        * `loop_supply_temperature_at_outdoor_low`
        * `loop_supply_temperature_at_low_load`
Other fields: `is_sized_using_coincident_load` is too too specific to modeling; `has_integrated_waterside_economizer` is covered by existing `WaterSideEconomizer` element under `CondenserPlant`.

## Implementation
Global definition
```xml
    <xs:complexType name="FluidLoopProperties">
        <xs:annotation>
            <xs:documentation>An list of properties of a general fluid loop.</xs:documentation>
        </xs:annotation>
        <xs:sequence>
            <xs:element name="FluidLoopType" minOccurs="0">
                <xs:annotation>
                    <xs:documentation>General type of fluid loop.</xs:documentation>
                </xs:annotation>
                <xs:simpleType>
                    <xs:restriction base="xs:string">
                        <xs:enumeration value="Heating"/>
                        <xs:enumeration value="Cooling"/>
                        <xs:enumeration value="Heating and cooling"/>
                        <xs:enumeration value="Condenser"/>
                        <xs:enumeration value="Other"/>
                        <xs:enumeration value="Unknown"/>
                    </xs:restriction>
                </xs:simpleType>
            </xs:element>
            <xs:element name="PumpPowerPerFlowRate" minOccurs="0"/>
                <xs:annotation>
                  <xs:documentation>Total design pump power divided by the loop design flow rate. (W-s/L)</xs:documentation>
                </xs:annotation>
                <xs:complexType>
                    <xs:simpleContent>
                        <xs:extension base="xs:decimal">
                            <xs:attribute ref="auc:Source"/>
                        </xs:extension>
                    </xs:simpleContent>
                </xs:complexType>
            </xs:element>
            <xs:element name="LinkedChildLoops" minOccurs="0">
                <xs:annotation>
                    <xs:documentation>List of other fluid loops connected to this one as children (secondary loops).</xs:documentation>
                </xs:annotation>
                <xs:complexType>
                    <xs:sequence>
                        <xs:element name="LinkedChildLoopID">
                            <xs:annotation>
                                <xs:documentation>ID number of the child loop.</xs:documentation>
                            </xs:annotation>
                            <xs:complexType>
                                <xs:attribute name="IDref" type="xs:IDREF" use="required"/>
                            </xs:complexType>
                        </xs:element>
                    </xs:sequence>
                </xs:complexType>
            </xs:element>
            <xs:element name="FluidLoopDesignAndControl" minOccurs="0">
                <xs:complexType>
                    <xs:sequence>
                        <xs:element name="DesignSupplyTemperature">
                            <xs:annotation>
                                <xs:documentation>Design Supply Temperature. (°C)</xs:documentation>
                            </xs:annotation>
                            <xs:complexType>
                                <xs:simpleContent>
                                    <xs:extension base="xs:decimal">
                                        <xs:attribute ref="auc:Source"/>
                                    </xs:extension>
                                </xs:simpleContent>
                            </xs:complexType>
                        </xs:element>
                        <xs:element name="DesignReturnTemperature">
                            <xs:annotation>
                                <xs:documentation>Design Return Temperature. (°C)</xs:documentation>
                            </xs:annotation>
                            <xs:complexType>
                                <xs:simpleContent>
                                    <xs:extension base="xs:decimal">
                                        <xs:attribute ref="auc:Source"/>
                                    </xs:extension>
                                </xs:simpleContent>
                            </xs:complexType>
                        </xs:element>
                        <xs:element name="MinimumFlowFraction">
                            <xs:annotation>
                                <xs:documentation>Minimum fraction of full flow allowed. (0-1)</xs:documentation>
                            </xs:annotation>
                            <xs:complexType>
                                <xs:simpleContent>
                                    <xs:extension base="xs:decimal">
                                        <xs:attribute ref="auc:Source"/>
                                    </xs:extension>
                                </xs:simpleContent>
                            </xs:complexType>
                        </xs:element>
                        <xs:element name="FluidLoopOperationTypes" minOccurs="0">
                            <xs:annotation>
                                <xs:documentation>Type of operation used by loop.</xs:documentation>
                            </xs:annotation>
                            <xs:simpleType>
                                <xs:restriction base="xs:string">
                                    <xs:enumeration value="Continuous"/>
                                    <xs:enumeration value="Intermittent"/>
                                    <xs:enumeration value="Demand"/>
                                    <xs:enumeration value="Scheduled"/>
                                    <xs:enumeration value="Other"/>
                                    <xs:enumeration value="Unknown"/>
                                </xs:restriction>
                            </xs:simpleType>
                        </xs:element>
                        <xs:element ref="auc:LinkedScheduleIDs" minOccurs="0"/>
                        <xs:element name="FluidLoopFlowControlTypes" minOccurs="0">
                            <xs:annotation>
                                <xs:documentation>Type of flow control used by loop.</xs:documentation>
                            </xs:annotation>
                            <xs:simpleType>
                                <xs:restriction base="xs:string">
                                    <xs:enumeration value="Fixed flow"/>
                                    <xs:enumeration value="Variable flow"/>
                                    <xs:enumeration value="Other"/>
                                    <xs:enumeration value="Unknown"/>
                                </xs:restriction>
                            </xs:simpleType>
                        </xs:element>
                        <xs:element name="TemperatureResetTypes" minOccurs="0">
                            <xs:annotation>
                                <xs:documentation>Type of temperature reset used by loop.</xs:documentation>
                            </xs:annotation>
                            <xs:complexType>
                                <xs:choice>
                                    <xs:element name="NoReset" minOccurs="0"/>
                                    <xs:element name="OutsideAirReset" minOccurs="0">
                                        <xs:complexType>
                                            <xs:sequence>
                                                <xs:element name="OutdoorHighForLoopSupplyTemperatureReset" minOccurs="0">
                                                    <xs:annotation>
                                                        <xs:documentation>Outdoor high for loop supply temp reset. (°C)</xs:documentation>
                                                    </xs:annotation>
                                                    <xs:complexType>
                                                        <xs:simpleContent>
                                                            <xs:extension base="xs:decimal">
                                                                <xs:attribute ref="auc:Source"/>
                                                            </xs:extension>
                                                        </xs:simpleContent>
                                                    </xs:complexType>
                                                </xs:element>
                                                <xs:element name="OutdoorLowForLoopSupplyTemperatureReset" minOccurs="0">
                                                    <xs:annotation>
                                                        <xs:documentation>Outdoor low for loop supply temp reset. (°C)</xs:documentation>
                                                    </xs:annotation>
                                                    <xs:complexType>
                                                        <xs:simpleContent>
                                                            <xs:extension base="xs:decimal">
                                                                <xs:attribute ref="auc:Source"/>
                                                            </xs:extension>
                                                        </xs:simpleContent>
                                                    </xs:complexType>
                                                </xs:element>
                                                <xs:element name="LoopSupplyTemperatureAtOutdoorHigh" minOccurs="0">
                                                    <xs:annotation>
                                                        <xs:documentation>Loop supply temperature at outdoor high temperature. (°C)</xs:documentation>
                                                    </xs:annotation>
                                                    <xs:complexType>
                                                        <xs:simpleContent>
                                                            <xs:extension base="xs:decimal">
                                                                <xs:attribute ref="auc:Source"/>
                                                            </xs:extension>
                                                        </xs:simpleContent>
                                                    </xs:complexType>
                                                </xs:element>
                                                <xs:element name="LoopSupplyTemperatureAtOutdoorLow" minOccurs="0">
                                                    <xs:annotation>
                                                        <xs:documentation>Loop supply temperature at outdoor low temperature. (°C)</xs:documentation>
                                                    </xs:annotation>
                                                    <xs:complexType>
                                                        <xs:simpleContent>
                                                            <xs:extension base="xs:decimal">
                                                                <xs:attribute ref="auc:Source"/>
                                                            </xs:extension>
                                                        </xs:simpleContent>
                                                    </xs:complexType>
                                                </xs:element>
                                            </xs:sequence>
                                        </xs:complexType>
                                    </xs:element>
                                    <xs:element name="LoadReset" minOccurs="0">
                                        <xs:complexType>
                                            <xs:sequence>
                                                <xs:element name="LoopSupplyTemperatureAtLowLoad" minOccurs="0">
                                                    <xs:annotation>
                                                        <xs:documentation>Loop supply temperature at low load. (°C)</xs:documentation>
                                                    </xs:annotation>
                                                    <xs:complexType>
                                                        <xs:simpleContent>
                                                            <xs:extension base="xs:decimal">
                                                                <xs:attribute ref="auc:Source"/>
                                                            </xs:extension>
                                                        </xs:simpleContent>
                                                    </xs:complexType>
                                                </xs:element>
                                            </xs:sequence>
                                        </xs:complexType>
                                    </xs:element>
                                    <xs:element ref="auc:Other" minOccurs="0"/>
                                    <xs:element ref="auc:Unknown" minOccurs="0"/>
                                </xs:choice>
                            </xs:complexType>
                        </xs:element>
                    </xs:sequence>
                </xs:complexType>
            </xs:element>
            <xs:element ref="auc:LinkedSystemIDs" minOccurs="0"/>
            <xs:element ref="auc:UserDefinedFields" minOccurs="0"/>
        </xs:sequence>
        <xs:attribute name="ID" type="xs:ID" use="required"/>
    </xs:complexType>
```
Under `HeatingPlant`
```xml
    <xs:complexType name="HeatingPlantType">
        <xs:sequence>
            ...
            <xs:element name="FluidLoops" minOccurs="0">
                <xs:annotation>
                    <xs:documentation>List of fluid loops for HeatingSource.</xs:documentation>
                </xs:annotation>
                <xs:complexType>
                    <xs:sequence>
                        <xs:element name="FluidLoop" type="auc:FluidLoopProperties" maxOccurs="unbounded">
                            <xs:annotation>
                                <xs:documentation>fluid loop for HeatingSource.</xs:documentation>
                            </xs:annotation>
                        </xs:element>
                    </xs:sequence>
                </xs:complexType>
            </xs:element>
            ...
```
Similar to above, we will add the `FluidLoops` elements under other elements: `CoolingPlant`, `CondenserPlant`/`WaterCooled`, `DomesticHotWaterSystem`/`Recirculation`, and `HeatRecoverySystem`.

## Reference
FluidLoop definition: https://github.com/open229/ruleset-model-description-schema/blob/e300b9fb864d7b5099f7e2c0e1e96b6a897bd0ff/docs229/ASHRAE229.schema.json#L3316
