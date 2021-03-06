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
	* Ensure their names are plural nouns.
	* Create a child element for them that is named with the same noun in singular form.

List 1, 2, ad 3 are the proposed lists of elements to be changed. These elements were identified using steps 1 and 2.  Note that elements with repeated names each include their schema model path beside them as a comment.


List 1: elements to be changed that do not represent any special cases.




<xs:element name="" minOccurs="0">
<xs:complexType>
<xs:sequence>

</xs:sequence>
</xs:complexType>
</xs:element>
```xml
X <xs:element name="LocationsOfExteriorWaterIntrusionDamage" minOccurs="0" maxOccurs="unbounded"> <!-- //NOT in examples, Added to .xsd <xs:element name="LocationsOfExteriorWaterIntrusionDamages" minOccurs="0" maxOccurs="unbounded">
X <xs:element name="LocationsOfInteriorWaterIntrusionDamage" minOccurs="0" maxOccurs="unbounded"> <!-- //NOT in examples, Added to .xsd <xs:element name="LocationsOfInteriorWaterIntrusionDamages" minOccurs="0">
X <xs:element name="OtherEscalationRates" minOccurs="0" maxOccurs="unbounded"> <!-- //NOT in examples, Updated to singular <xs:element name="OtherEscalationRate" minOccurs="0" maxOccurs="unbounded">, Added to .xsd <xs:element name="OtherEscalationRates" minOccurs="0">
X <xs:element name="Qualifications" minOccurs="0" maxOccurs="unbounded"><!-- //NOT in examples, Updated to singular <xs:element name="Qualification" minOccurs="0" maxOccurs="unbounded">, Added to .xsd <xs:element name="Qualifications" minOccurs="0">
X <xs:element name="SpatialUnits" minOccurs="0" maxOccurs="unbounded"><!-- //NOT in examples, Updated to Singular <xs:element name="SpatialUnit" minOccurs="0" maxOccurs="unbounded">, added to xsd <xs:element name="SpatialUnits" minOccurs="0">
X <xs:element name="Assessment" minOccurs="0" maxOccurs="unbounded"><!-- //updatede example: DC GSA Headquarters.xml,Added to .xsd <xs:element name="Assessments" minOccurs="0">
X <xs:element name="ScheduleDetails" minOccurs="0" maxOccurs="unbounded"><!-- // PARTIAL example: Reference Building - Primary Schoool.xml (750 hits), made singular, Added to .xsd <xs:element name="ScheduleDetails" minOccurs="0"> updated xs:element name="ScheduleDetail" minOccurs="0" maxOccurs
X <xs:element name="AnnualSavingsByFuel" minOccurs="0" maxOccurs="unbounded"><!-- // examples: ASHRAE 211 Export.xml (20 hits), DC GSA Headquarters.xml (7 hits), Reference Building - Primary Schoool.xml (24 hits), add to .xsd <xs:element name="AnnualSavingsByFuels" minOccurs="0">
X <xs:element name="RateSchedule" minOccurs="0" maxOccurs="unbounded">!-- // updated examples:ASHRAE 211 Export.xml (10 hits), Reference Building - Primary Schoool.xml (2 hits), added to .xsd <xs:element name="RateSchedules" minOccurs="0">
X <xs:element name="TimeOfUsePeriod" minOccurs="0" maxOccurs="unbounded"><!-- //NOT in examples, added to .xsd <xs:element name="TimeOfUsePeriods" minOccurs="0">
X<xs:element name="TieredRate" minOccurs="0" maxOccurs="unbounded"><!-- //NOT in examples, added <xs:element name="TieredRates" minOccurs="0">
X <xs:element name="RateTier" minOccurs="0" maxOccurs="unbounded"><!-- //NOT in examples, added <xs:element name="RateTiers" minOccurs="0">
X <xs:element name="UtilityMeterNumber" type="xs:string" minOccurs="0" maxOccurs="unbounded"><!-- //NOT in examples,
X <xs:element name="Emissions" minOccurs="0" maxOccurs="unbounded"><!-- //NOT in examples, updted to singular <xs:element name="Emissions" minOccurs="0" maxOccurs="unbounded">, added <xs:element name="Emissions" minOccurs="0">
X <xs:element name="HeatingSource" minOccurs="0" maxOccurs="unbounded"><!-- // updated examples:Reference Building - Primary Schoool.xml (4 hits), ASHRAE 211 Export.xml (1 hit), Golden Test File.xml (1 hit), Multi-Facility Shared Systems.xml (1 hit), added to .xsd <xs:element name="HeatingSources" minOccurs="0">
X <xs:element name="CoolingSource" minOccurs="0" maxOccurs="unbounded"><!-- //updated examples: Reference Building - Primary Schoool.xml (8 hits), ASHRAE 211 Export.xml (1 hit), Golden Test File.xml (1 hit), Multi-Facility Shared Systems.xml (1 hit), added to .xsd <xs:element name="CoolingSources" minOccurs="0">
X <xs:element name="Delivery" minOccurs="0" maxOccurs="unbounded"><!-- //examples: Reference Building - Primary Schoool.xml,  added <xs:element name="Deliveries" minOccurs="0">
X <xs:element name="CeilingInsulation" minOccurs="0" maxOccurs="unbounded"><!-- //NOT in examples, added <xs:element name="CeilingInsulations" minOccurs="0">
X <xs:element name="RoofInsulation" minOccurs="0" maxOccurs="unbounded"><!-- //example: Reference Building - Primary Schoool.xml, added <xs:element name="RoofInsulations" minOccurs="0">
X <xs:element name="GroundCoupling" minOccurs="0" maxOccurs="unbounded"> <!-- // added <xs:element name="GroundCouplings" minOccurs="0">, examples: ASHRAE 211 Export.xml, Reference Building - Primary Schoool.xml 
X <xs:element name="EnergyUseByEndUse" minOccurs="0" maxOccurs="unbounded"> <!-- // added <xs:element name="EnergyUseByEndUses" minOccurs="0">, examples: none
X <xs:element name="UseType" minOccurs="0" maxOccurs="unbounded"><!-- // added <xs:element name="UseTypes" minOccurs="0">, examples: none
X <xs:element name="HeatingPlant" type="auc:HeatingPlantType" minOccurs="0" maxOccurs="unbounded"><!-- // added <xs:element name="HeatingPlants" minOccurs="0">, examples: ASHRAE 211 Export.xml, Golden Test File.xml,Multi-Facility Shared Systems.xml, Reference Building - Primary Schoool.xml
X <xs:element name="CoolingPlant" type="auc:CoolingPlantType" minOccurs="0" maxOccurs="unbounded"><!-- // added <xs:element name="CoolingPlants" minOccurs="0">, examples: ASHRAE 211 Export.xml, Golden Test File.xml, Multi-Facility Shared Systems.xml
X <xs:element name="CondenserPlant" type="auc:CondenserPlantType" minOccurs="0" maxOccurs="unbounded"><!-- // added <xs:element name="CondenserPlants" minOccurs="0">, examples:  ASHRAE 211 Export.xml, Golden Test File.xml, Multi-Facility Shared Systems.xml, Reference Building - Primary Schoool.xml
X<xs:element name="RatePeriod" minOccurs="0" maxOccurs="unbounded"> <!-- //element(*,auc:UtilityType)/auc:RateSchedule/auc:TypeOfRateStructure/auc:FlatRate/auc:RatePeriod --> <!-- added <xs:element name="RatePeriods" minOccurs="0">, example: </RatePeriods>
X<xs:element name="RatePeriod" minOccurs="0" maxOccurs="unbounded"> <!-- //element(*,auc:UtilityType)/auc:RateSchedule/auc:TypeOfRateStructure/auc:TimeOfUseRate/auc:RatePeriod --> <!--  added <xs:element name="RatePeriods" minOccurs="0">, example: none
X<xs:element name="RatePeriod" minOccurs="0" maxOccurs="unbounded"> <!-- //element(*,auc:UtilityType)/auc:RateSchedule/auc:TypeOfRateStructure/auc:TieredRate/auc:RatePeriod --><!--   added <xs:element name="RatePeriods" minOccurs="0">, example: none


```
<xs:element name="LinkedScheduleID" minOccurs="0" maxOccurs="unbounded"> <!-- auc:LinkedPremises/auc:Site/auc:LinkedSiteID/auc:LinkedScheduleID -->
<xs:element name="LinkedScheduleID" minOccurs="0" maxOccurs="unbounded"> <!-- auc:LinkedPremises/auc:Facility/auc:LinkedFacilityID/auc:LinkedScheduleID -->
<xs:element name="LinkedScheduleID" minOccurs="0" maxOccurs="unbounded"> <!-- auc:LinkedPremises/auc:Subsection/auc:LinkedSubsectionID/auc:LinkedScheduleID -->
<xs:element name="LinkedScheduleID" minOccurs="0" maxOccurs="unbounded"> <!-- auc:LinkedPremises/auc:ThermalZone/auc:LinkedThermalZoneID/auc:LinkedScheduleID -->
<xs:element name="LinkedScheduleID" minOccurs="0" maxOccurs="unbounded"> <!-- auc:LinkedPremises/auc:Space/auc:LinkedSpaceID/auc:LinkedScheduleID -->
<xs:element name="CondenserPlantID" minOccurs="0" maxOccurs="unbounded"> <!-- //element(*,auc:CoolingPlantType)/auc:Chiller/auc:CondenserPlantID -->
<xs:element name="CondenserPlantID" minOccurs="0" maxOccurs="unbounded"> <!-- //element(*,auc:RefrigerationSystemType)/auc:RefrigerationSystemCategory/auc:CentralRefrigerationSystem/auc:CondenserPlantID -->
<xs:element name="CondenserPlantID" minOccurs="0" maxOccurs="unbounded"> <!-- //element(*,auc:HVACSystemType)/auc:HeatingAndCoolingSystems/auc:CoolingSource/auc:CoolingSourceType/auc:DX/auc:CondenserPlantID -->
<xs:element name="UtilityID" minOccurs="0" maxOccurs="unbounded">
<xs:element name="ContactID" minOccurs="0" maxOccurs="unbounded">
<xs:element name="SkylightID" minOccurs="0" maxOccurs="unbounded"><!-- //<!-- //example: Reference Building - Primary Schoool.xml 
<xs:element name="ThermalZoneID" minOccurs="0" maxOccurs="unbounded"> <!-- //element(*,auc:FacilityType)/auc:Subsections/auc:Subsection/auc:CeilingID/auc:ThermalZoneID -->
<xs:element name="SpaceID" minOccurs="0" maxOccurs="unbounded"> <!-- //element(*,auc:FacilityType)/auc:Subsections/auc:Subsection/auc:CeilingID/auc:SpaceID -->
<xs:element name="ThermalZoneID" minOccurs="0" maxOccurs="unbounded"> <!-- //element(*,auc:FacilityType)/auc:Subsections/auc:Subsection/auc:FoundationID/auc:ThermalZoneID -->
<xs:element name="SpaceID" minOccurs="0" maxOccurs="unbounded"> <!-- //element(*,auc:FacilityType)/auc:Subsections/auc:Subsection/auc:FoundationID/auc:SpaceID -->
<xs:element name="DeliveryID" minOccurs="0" maxOccurs="unbounded">
<xs:element name="SkylightID" minOccurs="0" maxOccurs="unbounded"><!-- //<!-- //example: Reference Building - Primary Schoool.xml 
<xs:element name="ThermalZoneID" minOccurs="0" maxOccurs="unbounded"> <!-- //element(*,auc:FacilityType)/auc:Subsections/auc:Subsection/auc:CeilingID/auc:ThermalZoneID -->
<xs:element name="SpaceID" minOccurs="0" maxOccurs="unbounded"> <!-- //element(*,auc:FacilityType)/auc:Subsections/auc:Subsection/auc:CeilingID/auc:SpaceID -->
<xs:element name="ThermalZoneID" minOccurs="0" maxOccurs="unbounded"> <!-- //element(*,auc:FacilityType)/auc:Subsections/auc:Subsection/auc:FoundationID/auc:ThermalZoneID -->
<xs:element name="SpaceID" minOccurs="0" maxOccurs="unbounded"> <!-- //element(*,auc:FacilityType)/auc:Subsections/auc:Subsection/auc:FoundationID/auc:SpaceID -->
<xs:element name="DeliveryID" minOccurs="0" maxOccurs="unbounded">
<xs:element name="HVACScheduleID" minOccurs="0" maxOccurs="unbounded">
<xs:element name="OccupancyScheduleID" minOccurs="0" maxOccurs="unbounded">
<xs:element name="LinkedSystemID" minOccurs="0" maxOccurs="unbounded"> <!-- //element(*,auc:PumpSystemType)/auc:LinkedSystemID -->
<xs:element name="LinkedSystemID" minOccurs="0" maxOccurs="unbounded"> <!-- //element(*,auc:FanSystemType)/auc:LinkedSystemID -->
<xs:element name="LinkedSystemID" minOccurs="0" maxOccurs="unbounded"> <!-- //element(*,auc:MotorSystemType)/auc:LinkedSystemID -->

XList 2: elements that are defined outside of the main schema path (at the bottom of the code) and are referenced throughout the schema code. For mor information, reference the following pull request comment: https://github.com/BuildingSync/schema/pull/67#issuecomment-456912360 
Approved
```xml
X <xs:element name="EnergyUseByFuelType"><!-- // added <xs:element name="EnergyUseByFuelTypes">,updated ref's to <xs:element ref="auc:EnergyUseByFuelTypes" plural example: none
X <xs:element name="TenantID"><!-- // added  added <xs:element name="TenantIDs">, updated ref's to <xs:element ref="auc:TenantIDs" plural, example: MultitenantBySubsections.xml

```
<xs:element name="">
<xs:complexType>
<xs:sequence>

</xs:sequence>
</xs:complexType>
</xs:element>

List 3: unique cases to be reviewed by the BuildingSync technical lead to define approach.


*Unique case A: We recommend that the following listed elements each get treated as the elements in List 2. This case is unique because it is unclear whether the maxOccurs="unbounded" should be added to the listed elements or to their parents instead.
X Nick input: under child of Type of Measure insert Replacements, ModificationRetrocommissions, Additions, Removals
```xml

X<xs:element name="Replacement" minOccurs="0"><!-- //added <xs:element name="Replacements" minOccurs="0"> Replacement doesn't have maxOccurs ="unbounded", examples: DC GSA Headquarters.xml,Reference Building - Primary Schoool.xml
for
<xs:element name="ExistingSystemReplaced" minOccurs="0" maxOccurs="unbounded"> <!-- //element(*,auc:MeasureType)/auc:TypeOfMeasure/auc:Replacement/auc:ExistingSystemReplaced --> 
<xs:element name="AlternativeSystemReplacement" minOccurs="0" maxOccurs="unbounded"> <!-- //element(*,auc:MeasureType)/auc:TypeOfMeasure/auc:Replacement/auc:AlternativeSystemReplacement -->
<xs:element name="ExistingScheduleAffected" minOccurs="0" maxOccurs="unbounded"> <!-- //element(*,auc:MeasureType)/auc:TypeOfMeasure/auc:Replacement/auc:ExistingScheduleAffected -->
<xs:element name="ModifiedSchedule" minOccurs="0" maxOccurs="unbounded"> <!-- //element(*,auc:MeasureType)/auc:TypeOfMeasure/auc:Replacement/auc:ModifiedSchedule -->

X<xs:element name="ModificationRetrocommissioning" minOccurs="0"> <!-- // added <xs:element name="ModificationRetrocommissions" minOccurs="0">, examples: DC GSA Headquarters.xml,Reference Building - Primary Schoool.xml
for
<xs:element name="ExistingSystemAffected" minOccurs="0" maxOccurs="unbounded"> <!-- //element(*,auc:MeasureType)/auc:TypeOfMeasure/auc:ModificationRetrocommissioning/auc:ExistingSystemAffected -->
<xs:element name="ModifiedSystem" minOccurs="0" maxOccurs="unbounded"> <!-- //element(*,auc:MeasureType)/auc:TypeOfMeasure/auc:ModificationRetrocommissioning/auc:ModifiedSystem -->
<xs:element name="ExistingScheduleAffected" minOccurs="0" maxOccurs="unbounded"> <!-- //element(*,auc:MeasureType)/auc:TypeOfMeasure/auc:ModificationRetrocommissioning/auc:ExistingScheduleAffected -->
<xs:element name="ModifiedSchedule" minOccurs="0" maxOccurs="unbounded"> <!-- //element(*,auc:MeasureType)/auc:TypeOfMeasure/auc:ModificationRetrocommissioning/auc:ModifiedSchedule -->

X<xs:element name="Addition" minOccurs="0"><!-- //added <xs:element name="Additions" minOccurs="0">, example: DC GSA Headquarters.xml
for
<xs:element name="AlternativeSystemAdded" minOccurs="0" maxOccurs="unbounded"> <!-- //element(*,auc:MeasureType)/auc:TypeOfMeasure/auc:Addition/auc:AlternativeSystemAdded -->
<xs:element name="ExistingScheduleAffected" minOccurs="0" maxOccurs="unbounded"> <!-- //element(*,auc:MeasureType)/auc:TypeOfMeasure/auc:Addition/auc:ExistingScheduleAffected -->
<xs:element name="ModifiedSchedule" minOccurs="0" maxOccurs="unbounded"> <!-- //element(*,auc:MeasureType)/auc:TypeOfMeasure/auc:Addition/auc:ModifiedSchedule -->

X <xs:element name="Removal" minOccurs="0"><!-- // added <xs:element name="Removals" minOccurs="0">, example: Golden Test File.xml
for
<xs:element name="ExistingSystemRemoved" minOccurs="0" maxOccurs="unbounded"> <!-- //element(*,auc:MeasureType)/auc:TypeOfMeasure/auc:Removal/auc:ExistingSystemRemoved -->
<xs:element name="ExistingScheduleAffected" minOccurs="0" maxOccurs="unbounded"> <!-- //element(*,auc:MeasureType)/auc:TypeOfMeasure/auc:Removal/auc:ExistingScheduleAffected -->
<xs:element name="ModifiedSchedule" minOccurs="0" maxOccurs="unbounded"> <!-- //element(*,auc:MeasureType)/auc:TypeOfMeasure/auc:Removal/auc:ModifiedSchedule -->
```
Examples: none
<xs:element name="" minOccurs="0">
<xs:complexType>
<xs:sequence>

</xs:sequence>
</xs:complexType>
</xs:element>
                                                                                                                                                                                                            
*Unique case C: The following element is a child of another element of the same exact name. Since this one is the child element, it should be in singular form. Proposed approach: remove the 's' at the end of the following element's name. 
APPROVED
```xml
X <xs:element name="DuctSystems" type="auc:DuctSystemType" maxOccurs="unbounded"/> <!-- //changed to <xs:element name="DuctSystem" type="auc:DuctSystemType" maxOccurs="unbounded"/>, example: Reference Building - Primary Schoool.xml
```

## References

For more information on occurrence indicators: https://www.w3schools.com/xml/schema_complex_indicators.asp
