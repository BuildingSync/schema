# Ensure adequate containerization of lists

## Overview

The BuildingSync schema contains several elements that allow for multiple records. The general practice throughout this schema is to name these elements with a singular noun and to define them as children of elements named with the same noun in the plural form. The purpose of this proposal is to ensure that all elements that allow for multiple records follow the same described practice.

## Justification

The BuildingSync XML schema code must be consistent to ensure proper code execution and facilitate future code review and possible modifications.

## Implementation

The process to identify the elements that allow for multiple records relies on the "maxOccurs" occurrence indicator. This indicator specifies how many records of a defined element can be made. Whenever an element has this indicator set equal to a number higher than 1 or to the value "unbounded," said element allows for multiple records to be created.

The following steps are to be performed in the BuildingSync.xsd document code:

1. Search for all occurrences of "maxOccurs" where the value is set to a number higher than 1 or to "unbounded."
2. Of the found elements, discard those whose name is a singular noun and whose parent element is named with the same noun in the plural form.
3. For all elements left:
   - Ensure their names are plural nouns.
   - Create a child element for them that is named with the same noun in singular form.

List 1, 2, and 3 are the lists of elements to be changed. These elements were identified using steps 1 and 2. Note that elements with repeated names each include their schema model path beside them as a comment.

List 1: elements to be changed that do not represent any special cases.

````xml
<xs:element name="LocationsOfExteriorWaterIntrusionDamage" minOccurs="0" maxOccurs="unbounded"><!-- //Added <xs:element name="LocationsOfExteriorWaterIntrusionDamages" minOccurs="0" maxOccurs="unbounded">, Example: none

<xs:element name="LocationsOfInteriorWaterIntrusionDamage" minOccurs="0" maxOccurs="unbounded"><!-- //Added <xs:element name="LocationsOfInteriorWaterIntrusionDamages" minOccurs="0">, Example: none

<xs:element name="OtherEscalationRates" minOccurs="0" maxOccurs="unbounded"><!-- //Updated to singular <xs:element name="OtherEscalationRate" minOccurs="0" maxOccurs="unbounded">, Added <xs:element name="OtherEscalationRates" minOccurs="0">, Example: none

<xs:element name="Qualifications" minOccurs="0" maxOccurs="unbounded"><!-- //Updated to singular <xs:element name="Qualification" minOccurs="0" maxOccurs="unbounded">, Added <xs:element name="Qualifications" minOccurs="0">, Example: none

<xs:element name="SpatialUnits" minOccurs="0" maxOccurs="unbounded"><!-- //Updated to singular <xs:element name="SpatialUnit" minOccurs="0" maxOccurs="unbounded">, Added <xs:element name="SpatialUnits" minOccurs="0">, Example: none

<xs:element name="Assessment" minOccurs="0" maxOccurs="unbounded"><!-- //Added <xs:element name="Assessments" minOccurs="0">, Example: DC GSA Headquarters.xml

<xs:element name="ScheduleDetails" minOccurs="0" maxOccurs="unbounded"><!-- //Updated to singular <xs:element name="ScheduleDetail" minOccurs="0" maxOccurs="0">, Added <xs:element name="ScheduleDetails" minOccurs="0">, Example: Reference Building - Primary Schoool.xml

<xs:element name="AnnualSavingsByFuel" minOccurs="0" maxOccurs="unbounded"><!-- //Added <xs:element name="AnnualSavingsByFuels" minOccurs="0">, Example: ASHRAE 211 Export.xml, DC GSA Headquarters.xml, Reference Building - Primary Schoool.xml

<xs:element name="RateSchedule" minOccurs="0" maxOccurs="unbounded><!-- //Added <xs:element name="RateSchedules" minOccurs="0">, Examples: ASHRAE 211 Export.xml, Reference Building - Primary Schoool.xml

<xs:element name="TimeOfUsePeriod" minOccurs="0" maxOccurs="unbounded"><!-- //Added <xs:element name="TimeOfUsePeriods" minOccurs="0">, Example: none-->

<xs:element name="TieredRate" minOccurs="0" maxOccurs="unbounded"><!-- //Added <xs:element name="TieredRates" minOccurs="0">, Example: none-->

<xs:element name="RateTier" minOccurs="0" maxOccurs="unbounded"><!-- //Added <xs:element name="RateTiers" minOccurs="0">, Example: none-->

<xs:element name="UtilityMeterNumber" type="xs:string" minOccurs="0" maxOccurs="unbounded"><!-- //Added <xs:element name="UtilityMeterNumbers" minOccurs="0">, Example = none-->

<xs:element name="Emissions" minOccurs="0" maxOccurs="unbounded"><!-- //Updated to singular <xs:element name="Emissions" minOccurs="0" maxOccurs="unbounded">, Added <xs:element name="Emissions" minOccurs="0">, Example: none-->

<xs:element name="HeatingSource" minOccurs="0" maxOccurs="unbounded"><!-- //Added <xs:element name="HeatingSources" minOccurs="0">, Example: Reference Building - Primary Schoool.xml, ASHRAE 211 Export.xml, Golden Test File.xml, Multi-Facility Shared Systems.xml-->

<xs:element name="CoolingSource" minOccurs="0" maxOccurs="unbounded"><!-- //Added <xs:element name="CoolingSources" minOccurs="0">, Example: Reference Building - Primary Schoool.xml, ASHRAE 211 Export.xml, Golden Test File.xml, Multi-Facility Shared Systems.xml-->

<xs:element name="Delivery" minOccurs="0" maxOccurs="unbounded"><!-- //Added <xs:element name="Deliveries" minOccurs="0">, Example: Reference Building - Primary Schoool.xml-->

<xs:element name="CeilingInsulation" minOccurs="0" maxOccurs="unbounded"><!-- //Added <xs:element name="CeilingInsulations" minOccurs="0">, Example: none

<xs:element name="RoofInsulation" minOccurs="0" maxOccurs="unbounded"><!-- //Added <xs:element name="RoofInsulations" minOccurs="0">, Example: Reference Building - Primary Schoool.xml-->

<xs:element name="GroundCoupling" minOccurs="0" maxOccurs="unbounded"><!-- //Added <xs:element name="GroundCouplings" minOccurs="0">, Example: ASHRAE 211 Export.xml, Reference Building - Primary Schoool.xml-->

<xs:element name="EnergyUseByEndUse" minOccurs="0" maxOccurs="unbounded"><!-- //Added <xs:element name="EnergyUseByEndUses" minOccurs="0">, Example: none-->

<xs:element name="UseType" minOccurs="0" maxOccurs="unbounded"><!-- //Added <xs:element name="UseTypes" minOccurs="0">, Examples: none-->

<xs:element name="HeatingPlant" type="auc:HeatingPlantType" minOccurs="0" maxOccurs="unbounded"><!-- //Added <xs:element name="HeatingPlants" minOccurs="0">, Examples: ASHRAE 211 Export.xml, Golden Test File.xml,Multi-Facility Shared Systems.xml, Reference Building - Primary Schoool.xml-->

<xs:element name="CoolingPlant" type="auc:CoolingPlantType" minOccurs="0" maxOccurs="unbounded"><!-- //Added <xs:element name="CoolingPlants" minOccurs="0">, Examples: ASHRAE 211 Export.xml, Golden Test File.xml, Multi-Facility Shared Systems.xml-->

<xs:element name="CondenserPlant" type="auc:CondenserPlantType" minOccurs="0" maxOccurs="unbounded"><!-- //Added <xs:element name="CondenserPlants" minOccurs="0">, Examples:  ASHRAE 211 Export.xml, Golden Test File.xml, Multi-Facility Shared Systems.xml, Reference Building - Primary Schoool.xml-->

<xs:element name="RatePeriod" minOccurs="0" maxOccurs="unbounded"><!-- //auc:FlatRate/auc:RatePeriod --> <!-- added <xs:element name="RatePeriods" minOccurs="0">, Example: none-->

<xs:element name="RatePeriod" minOccurs="0" maxOccurs="unbounded"><!-- //auc:TimeOfUseRate/auc:RatePeriod --> <!-- //Added <xs:element name="RatePeriods" minOccurs="0">, Example: none-->

<xs:element name="RatePeriod" minOccurs="0" maxOccurs="unbounded"><!-- //auc:TieredRate/auc:RatePeriod --> <!-- //Added <xs:element name="RatePeriods" minOccurs="0">, Example: none-->

<xs:element name="UtilityID" minOccurs="0" maxOccurs="unbounded"><!-- //Added <xs:element name="UtilityIDs" minOccurs="0">, Example: ASHRAE 211 Export.xml, Reference Building - Primary Schoool.xml-->

<xs:element name="ContactID" minOccurs="0" maxOccurs="unbounded"><!-- //Added <xs:element name="ContactIDs" minOccurs="0">, Example: none

<xs:element name="DeliveryID" minOccurs="0" maxOccurs="unbounded"> <!-- //Added <xs:element name="DeliveryIDs" minOccurs="0">, Example: Reference Building - Primary Schoool.xml-->

<xs:element name="SkylightID" minOccurs="0" maxOccurs="unbounded"><!-- //Added <xs:element name="SkylightIDs" minOccurs="0">, Example: Reference Building - Primary Schoool.xml-->

<xs:element name="HVACScheduleID" minOccurs="0" maxOccurs="unbounded"> <!-- //<xs:element name="HVACScheduleIDs" minOccurs="0">, Example: Reference Building - Primary Schoool.xml-->

<xs:element name="OccupancyScheduleID" minOccurs="0" maxOccurs="unbounded"><!-- //Added <xs:element name="OccupancyScheduleIDs" minOccurs="0">,  Example: Reference Building - Primary Schoool.xml-->

<xs:element name="ThermalZoneID" minOccurs="0" maxOccurs="unbounded"><!-- //auc:CeilingID/auc:ThermalZoneID --><!--//Added <xs:element name="ThermalZoneIDs" minOccurs="0">, Example: none-->

<xs:element name="ThermalZoneID" minOccurs="0" maxOccurs="unbounded"><!-- //auc:FoundationID/auc:ThermalZoneID --><!--//Added <xs:element name="ThermalZoneIDs" minOccurs="0">, Example: none-->

<xs:element name="ThermalZoneID" minOccurs="0" maxOccurs="unbounded"><!-- //auc:Side/auc:ThermalZoneID --><!--//Added <xs:element name="ThermalZoneID" minOccurs="0">, Example: none-->

<xs:element name="SpaceID" minOccurs="0" maxOccurs="unbounded"><!-- //auc:CeilingID/auc:SpaceID --><!--//Added <xs:element name="SpaceIDs" minOccurs="0">, Example: Reference Building - Primary Schoool.xml

<xs:element name="SpaceID" minOccurs="0" maxOccurs="unbounded"><!-- //auc:FoundationID/auc:SpaceID --><!--//Added <xs:element name="SpaceIDs" minOccurs="0">, Example: Reference Building - Primary Schoool.xml-->

<xs:element name="LinkedSystemID" minOccurs="0" maxOccurs="unbounded"><!-- //element(*,auc:PumpSystemType)/auc:LinkedSystemID --><!--//Added <xs:element name="LinkedSystemIDs" minOccurs="0">, Example: Reference Building - Primary Schoool.xml-->

<xs:element name="LinkedSystemID" minOccurs="0" maxOccurs="unbounded"><!-- //element(*,auc:FanSystemType)/auc:LinkedSystemID --><!--//Added <xs:element name="LinkedSystemIDs" minOccurs="0">, Example: Reference Building - Primary Schoool.xml-->

<xs:element name="LinkedSystemID" minOccurs="0" maxOccurs="unbounded"><!-- //element(*,auc:MotorSystemType)/auc:LinkedSystemID --><!--//Added <xs:element name="LinkedSystemIDs" minOccurs="0">, Example: Reference Building - Primary Schoool.xml-->

<xs:element name="LinkedScheduleID" minOccurs="0" maxOccurs="unbounded"><!-- //auc:LinkedSiteID/auc:LinkedScheduleID --><!--//Added <xs:element name="LinkedScheduleIDs" minOccurs="0">, Example: Reference Building - Primary Schoool.xml-->

<xs:element name="LinkedScheduleID" minOccurs="0" maxOccurs="unbounded"><!-- //auc:LinkedFacilityID/auc:LinkedScheduleID --><!--//Added <xs:element name="LinkedScheduleIDs" minOccurs="0">, Example: Reference Building - Primary Schoool.xml-->

<xs:element name="LinkedScheduleID" minOccurs="0" maxOccurs="unbounded"><!-- //auc:LinkedSubsectionID/auc:LinkedScheduleID --><!--//Added <xs:element name="LinkedScheduleIDs" minOccurs="0">, Example: Reference Building - Primary Schoool.xml-->

<xs:element name="LinkedScheduleID" minOccurs="0" maxOccurs="unbounded"><!-- //auc:LinkedSpaceID/auc:LinkedScheduleID --><!--//Added <xs:element name="LinkedScheduleIDs" minOccurs="0">, Example: Reference Building - Primary Schoool.xml-->

<xs:element name="CondenserPlantID" minOccurs="0" maxOccurs="unbounded"> <!-- //auc:Chiller/auc:CondenserPlantID --><!--//Added <xs:element name="CondenserPlantIDs" minOccurs="0">, Example: Reference Building - Primary Schoool.xml, ASHRAE 211 Export.xml, Golden Test File.xml, Multi-Facility Shared Systems.xml-->

<xs:element name="CondenserPlantID" minOccurs="0" maxOccurs="unbounded"> <!-- //auc:CentralRefrigerationSystem/auc:CondenserPlantID --><!--//Added <xs:element name="CondenserPlantIDs" minOccurs="0">, Primary Schoool.xml, ASHRAE 211 Export.xml, Golden Test File.xml, Multi-Facility Shared Systems.xml-->

<xs:element name="CondenserPlantID" minOccurs="0" maxOccurs="unbounded"> <!-- //auc:CoolingSourceType/auc:DX/auc:CondenserPlantID --><!--//Added <xs:element name="CondenserPlantIDs" minOccurs="0">, Example: Primary Schoool.xml, ASHRAE 211 Export.xml, Golden Test File.xml, Multi-Facility Shared Systems.xml-->

Format used:
<xs:element name="" minOccurs="0">
<xs:complexType>
<xs:sequence>

</xs:sequence>
</xs:complexType>
</xs:element>

List 2: elements that are defined outside of the main schema path (at the bottom of the code) and are referenced throughout the schema code. For more information, reference the following pull request comment: https://github.com/BuildingSync/schema/pull/67#issuecomment-456912360

<xs:element name="EnergyUseByFuelType"><!-- //Added <xs:element name="EnergyUseByFuelTypes">,Updated ref's to plural <xs:element ref="auc:EnergyUseByFuelTypes", Example: none

<xs:element name="TenantID"><!-- //Added <xs:element name="TenantIDs">, Updated ref's to plural <xs:element ref="auc:TenantIDs", Example: MultitenantBySubsections.xml

Format used:
<xs:element name="">
<xs:complexType>
<xs:sequence>

</xs:sequence>
</xs:complexType>
</xs:element>

List 3: unique cases to be reviewed by the BuildingSync technical lead to define approach.


*Unique case A: Under child of Type of Measure insert Replacements, ModificationRetrocommissions, Additions, Removals
```xml

<xs:element name="Replacement" minOccurs="0"><!-- //Added <xs:element name="Replacements" minOccurs="0">, Note: Replacement doesn't have maxOccurs ="unbounded", Examples: DC GSA Headquarters.xml,Reference Building - Primary Schoool.xml-->
for
<xs:element name="ExistingSystemReplaced" minOccurs="0" maxOccurs="unbounded"> <!-- //element(*,auc:MeasureType)/auc:TypeOfMeasure/auc:Replacement/auc:ExistingSystemReplaced -->
<xs:element name="AlternativeSystemReplacement" minOccurs="0" maxOccurs="unbounded"> <!-- //element(*,auc:MeasureType)/auc:TypeOfMeasure/auc:Replacement/auc:AlternativeSystemReplacement -->
<xs:element name="ExistingScheduleAffected" minOccurs="0" maxOccurs="unbounded"> <!-- //element(*,auc:MeasureType)/auc:TypeOfMeasure/auc:Replacement/auc:ExistingScheduleAffected -->
<xs:element name="ModifiedSchedule" minOccurs="0" maxOccurs="unbounded"> <!-- //element(*,auc:MeasureType)/auc:TypeOfMeasure/auc:Replacement/auc:ModifiedSchedule -->

<xs:element name="ModificationRetrocommissioning" minOccurs="0"><!-- //Added <xs:element name="ModificationRetrocommissions" minOccurs="0">, Examples: DC GSA Headquarters.xml,Reference Building - Primary Schoool.xml-->
for
<xs:element name="ExistingSystemAffected" minOccurs="0" maxOccurs="unbounded"> <!-- //element(*,auc:MeasureType)/auc:TypeOfMeasure/auc:ModificationRetrocommissioning/auc:ExistingSystemAffected -->
<xs:element name="ModifiedSystem" minOccurs="0" maxOccurs="unbounded"> <!-- //element(*,auc:MeasureType)/auc:TypeOfMeasure/auc:ModificationRetrocommissioning/auc:ModifiedSystem -->
<xs:element name="ExistingScheduleAffected" minOccurs="0" maxOccurs="unbounded"> <!-- //element(*,auc:MeasureType)/auc:TypeOfMeasure/auc:ModificationRetrocommissioning/auc:ExistingScheduleAffected -->
<xs:element name="ModifiedSchedule" minOccurs="0" maxOccurs="unbounded"> <!-- //element(*,auc:MeasureType)/auc:TypeOfMeasure/auc:ModificationRetrocommissioning/auc:ModifiedSchedule -->

<xs:element name="Addition" minOccurs="0"><!-- //Added <xs:element name="Additions" minOccurs="0">, Example: DC GSA Headquarters.xml,Reference Building - Primary Schoool.xml-->
for
<xs:element name="AlternativeSystemAdded" minOccurs="0" maxOccurs="unbounded"> <!-- //element(*,auc:MeasureType)/auc:TypeOfMeasure/auc:Addition/auc:AlternativeSystemAdded -->
<xs:element name="ExistingScheduleAffected" minOccurs="0" maxOccurs="unbounded"> <!-- //element(*,auc:MeasureType)/auc:TypeOfMeasure/auc:Addition/auc:ExistingScheduleAffected -->
<xs:element name="ModifiedSchedule" minOccurs="0" maxOccurs="unbounded"> <!-- //element(*,auc:MeasureType)/auc:TypeOfMeasure/auc:Addition/auc:ModifiedSchedule -->

<xs:element name="Removal" minOccurs="0"><!-- //Added <xs:element name="Removals" minOccurs="0">, Example: Golden Test File.xml-->
for
<xs:element name="ExistingSystemRemoved" minOccurs="0" maxOccurs="unbounded"> <!-- //element(*,auc:MeasureType)/auc:TypeOfMeasure/auc:Removal/auc:ExistingSystemRemoved -->
<xs:element name="ExistingScheduleAffected" minOccurs="0" maxOccurs="unbounded"> <!-- //element(*,auc:MeasureType)/auc:TypeOfMeasure/auc:Removal/auc:ExistingScheduleAffected -->
<xs:element name="ModifiedSchedule" minOccurs="0" maxOccurs="unbounded"> <!-- //element(*,auc:MeasureType)/auc:TypeOfMeasure/auc:Removal/auc:ModifiedSchedule -->

Format used:
Examples: none
<xs:element name="" minOccurs="0">
<xs:complexType>
<xs:sequence>

</xs:sequence>
</xs:complexType>
</xs:element>

*Unique case C: The following element is a child of another element of the same exact name. Since this one is the child element, it should be in singular form. Remove the 's' at the end of the following element's name.

<xs:element name="DuctSystems" type="auc:DuctSystemType" maxOccurs="unbounded"/><!-- //Updated to <xs:element name="DuctSystem" type="auc:DuctSystemType" maxOccurs="unbounded"/>, Example: Reference Building - Primary Schoool.xml
````

## References

For more information on occurrence indicators: https://www.w3schools.com/xml/schema_complex_indicators.asp
