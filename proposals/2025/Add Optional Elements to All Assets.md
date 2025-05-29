# Add Optional Elements to All Assets

## Overview

In BuildingSync XML schema, the following optional `xs:element`s are defined for almost all `xs:complexType`s for &ldquo;assets&rdquo; (plants, systems, units of equipment, etc.):

* EquipmentCondition
* EquipmentID
* LinkedPremises
* Location
* Manufacturer
* ModelNumber
* PrimaryFuel
* Quantity
* ThirdPartyCertification
* UserDefinedFields
* YearInstalled
* YearOfManufacture

The use case for the definition of these optional `xs:element`s is asset tracking and management. They include, but are not limited to, the manufacturer name, year of manufacture, model number, and tag for the asset, along with its year of installation, location, and condition. They also include BuildingSync-specific `xs:element`s for linking the asset to premises that it serves and for representing software-specific, user-defined fields.

This proposal is to add these optional `xs:element`s to the `xs:complexType`s for all assets.

The changes that are recommended by this proposal are non-breaking because all the `xs:element`s are optional (viz., `minOccurs="0"`).

## Justification

The following table shows which optional `xs:element`s are currently defined for each `xs:complexType`:

| |EquipmentCondition|EquipmentID|LinkedPremises|Location|Manufacturer|ModelNumber|PrimaryFuel|Quantity|ThirdPartyCertification|UserDefinedFields|YearInstalled|YearOfManufacture|
|-|-|-|-|-|-|-|-|-|-|-|-|-|
|AirInfiltrationSystem|N|N|Y|N|N|N|N|N|N|Y|N|N|
|AntiSweatHeaters|N|Y|N|N|Y|Y|N|N|N|N|N|N|
|CeilingSystemType|N|N|N|N|N|N|N|Y|N|Y|Y|N|
|CondenserPlantType|Y|N|N|Y|N|N|Y|N|N|Y|Y|N|
|ConveyanceSystemType|Y|Y|Y|Y|Y|Y|Y|Y|Y|Y|Y|Y|
|CookingSystemType|N|Y|Y|Y|Y|Y|Y|Y|Y|Y|Y|Y|
|CoolingPlantType|Y|N|N|Y|N|N|Y|N|N|Y|Y|N|
|CoolingSource|Y|Y|N|Y|Y|Y|Y|Y|Y|Y|Y|Y|
|CriticalITSystemType|N|Y|Y|Y|Y|Y|Y|Y|Y|Y|Y|Y|
|Delivery|Y|Y|N|N|Y|Y|Y|Y|Y|N|Y|Y|
|DishwasherSystemType|N|Y|Y|Y|Y|Y|Y|Y|Y|Y|Y|Y|
|DomesticHotWaterSystemType|Y|Y|Y|Y|Y|Y|Y|Y|Y|Y|Y|Y|
|DuctSystemType|N|N|Y|Y|Y|Y|N|Y|N|Y|Y|Y|
|ExteriorFloorSystemType|N|N|N|N|N|N|N|Y|N|Y|Y|N|
|FanSystemType|N|Y|Y|Y|Y|Y|Y|Y|Y|Y|Y|Y|
|FenestrationSystemType|N|Y|N|N|Y|Y|N|Y|Y|Y|Y|N|
|FoundationSystemType|N|N|N|N|N|N|N|Y|N|Y|Y|N|
|HVACSystemType|N|N|Y|Y|N|N|N|Y|N|Y|N|N|
|HeatRecoverySystemType|N|Y|N|Y|Y|Y|N|Y|Y|Y|Y|Y|
|HeatingPlantType|Y|N|N|Y|N|N|Y|N|N|Y|Y|N|
|HeatingSource|Y|Y|N|Y|Y|Y|Y|Y|N|Y|Y|Y|
|LaundrySystemType|N|Y|Y|Y|Y|Y|Y|Y|Y|Y|Y|Y|
|LightingSystemType|N|Y|Y|Y|Y|Y|Y|Y|Y|Y|Y|Y|
|MotorSystemType|N|Y|Y|Y|Y|Y|Y|Y|Y|Y|Y|Y|
|OnsiteStorageTransmissionGenerationSystemType|N|Y|Y|Y|Y|Y|N|Y|Y|Y|Y|Y|
|OtherHVACSystemType|Y|Y|Y|Y|Y|Y|Y|Y|N|Y|Y|Y|
|PlugElectricLoadType|N|Y|Y|Y|Y|Y|Y|Y|Y|Y|Y|Y|
|PoolType|N|Y|Y|Y|Y|Y|N|Y|Y|Y|Y|N|
|ProcessGasElectricLoadType|N|Y|Y|Y|Y|Y|Y|Y|Y|Y|Y|Y|
|PumpSystemType|N|Y|N|Y|Y|Y|Y|Y|Y|Y|Y|Y|
|RefrigerationSystemType|N|Y|Y|Y|Y|Y|Y|Y|Y|Y|Y|Y|
|RoofSystemType|N|N|N|N|N|N|N|Y|N|Y|Y|N|
|WallSystemType|N|N|N|N|N|N|N|Y|N|Y|Y|N|
|WaterInfiltrationSystem|N|N|Y|N|N|N|N|N|N|Y|N|N|
|WaterUseType|N|Y|Y|Y|Y|Y|N|Y|Y|Y|Y|Y|
|**Total**|9/35|23/35|20/35|25/35|24/35|24/35|20/35|29/35|20/35|33/35|31/35|21/35|

## Implementation

When they are absent, the optional `xs:element`s are added to the `xs:complexType`s.
