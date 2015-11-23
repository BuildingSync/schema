# BuildingSync

## Unreleased Version

##### 11/20/2015

* Remove `<true>` elements
* Spelling fixes
* Fixed NoCooling spelling for CoolingPlantType
* DaylightingIlluminanceSetPoint is now DaylightingIlluminanceSetpoint
* Added another level to Measure/PremisesAffected to follow the plural pattern
* Remove recommended enum from ImplementationStatus as the recommended element covers this
* Rename InfiltrationIntrustion to AirInfiltrationSystem and WaterInfiltrationSystem. Add layer for plural pattern
* Added another level to AnnualSavingsFyFuel to follow the plural pattern
* Add level to Site/PremisesIndentifies
* Rename Zone to ThermalZone to conform to BEDES

## Version 2.0

##### 9/23/2015 - Hendron

* eProjectBuilder updates
    * Facilitator, Finance Specialist, and ESCO were added to the enumeration for ContactRole.
    * ImplementationPeriod was added under PackageOfMeasures scenario type.
    * WaterPriceEscalationRate and OtherEscalationRates were added under Report.
    * InflationRate was added under Report.
    * RecurringIncentives added under PackageOfMeasures scenario type.
    * PercentGuaranteedSavings, ImplementationPeriodCostSavings, and ProjectMarkup added under PackageOfMeasures scenario type.
    * AnnualDemandSavingsCost and OtherCostAnnualSavings were added under MeasureSavingsAnalysis.

9/14/2015 - Hendron

* BEDES 1.1 related updates
    * Enumeration for OccupancyClassification was updated
    * Custom was added to the IdentifierLabel enumeration.
    * For detailed address types, the StreetNumber element was split into Prefix, Numeric, and Suffix.
    * Enumerations were added for StreetDirSuffix, StreetSuffix, and StreetDirPrefix.
    * UnitNumber was split into an enumerated SubaddressType and a free text SubaddressIdentifier.
    * List of state abbreviations was updated to include U.S. territories and military sites.
    * Typo corrected, replacing EnergyStart with EnergyStar under ClimateZoneType.
    * WeatherDataStationID changed from integer to string.
    * Enumeration for ContactRole was updated to match BEDES.
    * Administrator, PMLastModifiedDate, ServiceAndProductProvider, and SharedBy were deleted as elements under PortfolioManager.
    * YearPMBenchmarked was replaced with PMBenchmarkDate, referring to the date that the building was benchmarked
    * The enumeration for OccupantQuantityType was updated.
    * Certification elements were converted to Assessment, and enumerations were updated to match BEDES. AssessmentValue was added as a new element.
    * Vertical and Horizontal Abutments were replaced with Horizontal and Vertical Surroundings, respectively.
    * Length was changed to SideLength for greater clarity, and the units (ft) were added to the definition.
    * FloorAreaSource was dropped because it is covered by metadata (Source attribute)
    * Enumeration for ScheduleCategory was updated.
    * "All days" was changed to "All week" in the DayType enumeration.
    * An unbound SpatialUnits parent element was added, and SpatialUnitType was added as a child element, grouped with Number of Units and Unit Density. This will allow multiple ways to count units for a premise.
    * Heating and compressor staging enumerations were updated.
    * Priority for HVAC systems was changed from integer to a constrained list (primary, secondary, etc.)
    * Evaporative Cooling Entering Supply Air DB Temperature, and Evaporative Cooling Entering Supply Air WB Temperature were dropped because they aren't directly controlled.
    * Water-Side Economizer Temperature Setpoint was dropped because it isn't directly controlled.
    * Fan Coil Type enumeration was updated.
    * Recessed was dropped in the Lighting Direction enumeration.
    * A new element for Water Heater Efficiency Type, with options for Energy Factor and Thermal Efficiency, was added.
    * SetpointTemperature was renamed HotWaterSetpointTemperature for clarity.
    * Type of Cooking Equipment enumeration was updated.
    * All occurrences of Other/combination were changed to Other.
    * Size was changed to RefrigerationUnitSize for clarity.
    * Defrost Type enumeration and name were modified to match BEDES.
    * Size was changed to FanSize for clarity.
    * EnvelopeConstructionType enumeration was updated.
    * WallInsulation was added as an unbounded parent element for the insulation details, allowing multiple insulation types to be included for a single wall type.
    * InfiltrationIntrusion was added as a new system category to capture infiltration and water intrustion data at any level. A LinkedPremisesId was included.
    * Estimated was dropped from the enumeration for Air Infiltration Test.
    * Roof Slope enumeration was updated.
    * Window Layout enumeration was updated.
    * PeakPower and StandbyPower were renamed to be more specific to the end use type (e.g. ITPeakPower).
    * NominalPower was added for several system categories to replace EnergyIntensity.
    * Active Mode was dropped from the enumeration for External Power Supply.
    * The enumeration for PoolType was updated to include addition water features.
    * A WaterResource element was added to provide more options than Potable, which was deleted.
    * The numbering system was dropped from the measure Technology Categories.
    * TechnologyCategory names were updated.
    * Commissioning/Retro Commissioning was dropped as a TechnologyCategory, as it was in BEDES and CTS.
    * MeasureCoverage was moved under PremisesAffected, and redefined to refer to the premises instead of the whole building.
    * The Measure Notes element was dropped, because there is already a LongDescription element that serves the purpose.
    * A new DiscardReason element was added, and the ImplementationStatus enumeration was streamlined.
    * "Satisfactory Repair Not Achieved" was changed to "Unsatisfactory" in the ImplementationStatus enumeration.
    * The Qualifier global element was split into Temporal Status, Normalization, Resource Boundary, Emission Boundary, and Water Resource. The new elements were moved to the relevant locations in the schema.
    * Measured Energy Source element was dropped because it is covered by the metadata.
    * The duplicate occurrence of TMY3 was deleted from the Weather Data Source enumeration.
    * Units for emissions were changed from MtCO2e to kgCO2e.
    * FirstCost was renamed PackageFirstCost for clarity.
    * CompleteResource and CompleteEndUse boolean elements were replaced with PercentResource and PercentEndUse decimal elements.
    * Type of Resource Meter enumeration was updated.
    * The final -hh:mm was deleted from the StartTimeStamp and EndTimeStamp data format.
    * Quantity Power was replaced with Energy in the TimeSeriesReadingQuantity enumeration, to make it more logical for natural gas and kWh data.
    * Water was dropped from the TimeSeriesReadingQuantity enumeration, because it is covered by Volumetric Flow.

* CTS updates
    * RetrocommissioningAudit element added under Report to align with CTS
    * Deleted "Add heat recovery" measure from the EnergyManagementControlSystems category.
    * Added "Add energy recovery" measure under BoilerPlantImprovements
    * Added "Other heating", "Other cooling", "Other ventilation", and "Other distribution" to the enumeration for OtherHVAC, to better align with CTS.
    * Split "Improve fans" into "Improve distribution fans" and "Improve ventilation fans" to better align with CTS.
    * Added "Improve data center efficiency" under the AppliancePlugLoadReductions category.


##### 9/11/2015 - Swindler/Hendron

* Asset Score updates
    * Added PercentPremisesServed and LampPower to LightingType to allow mapping to and from Asset Score.
    * No Heating option added for HeatingSource.
    * CondenserPlant type was modified to separate GroundSource from WaterCooled. This better matches the Sink/Source type used in Asset Score.
    * SupplyAirTemperatureResetControl definition was corrected to refer to outside air temperature instead of critical zone.
    * SourceHeatingPlantID was corrected. Originally referred to cooling plant.
    * Integration and LinkedDeliveryID elements were added for ventilation systems, dehumidifiers, etc, connected to a local or central air distribution system versus stand-alone.
    * "Dedicated outdoor air system" was added as a VentilationType.
    * "Automatically controlled register" and "Manually controlled register" were added as options under TerminalUnit.
    * LinkedHeatingPlantID was added under HeatingSourceType/HeatPump
    * SpecialRoofClassification was added for green roofs and cool roofs, and they were removed from the enumeration for RoofConstruction

##### Pre 9/11/2015

* Enum value in `MeasureType:SystemCategoryAffected` renamed

        Old: "On-Site Storage, Transmission,  Generation"
        New: "On-Site Storage, Transmission, Generation"

* Enum values in `MeasureType:TechnologyCategory:BoilerPlantImprovements:MeasureName` renamed

        Old: "Boiler decentralization"
        New: "Decentralize boiler"

        Old: "Boiler room Insulation"
        New: "Insulate boiler room"

        Old: "Cleaning and repair"
        New: "Clean and/or repair"

        Old: "Training and/or documentation"
        New: "Implement training and/or documentation"

        Old: "Operating protocols, calibration, and/or sequencing"
        New: "Upgrade operating protocols, calibration, and/or sequencing"

* Enum values in `MeasureType:TechnologyCategory:ChillerPlantImprovements:MeasureName` renamed

        Old: "Add heat recovery"
        New: "Add energy recovery"

        Old: "Gas cooling"
        New: "Install gas cooling"

        Old: "Economizer cycle"
        New: "Add or repair economizer cycle"

        Old: "Cleaning and/or repair"
        New: "Clean and/or repair"

        Old: "Training and/or documentation"
        New: "Implement training and/or documentation"

        Old: "Operating protocols, calibration, and/or sequencing"
        New: "Upgrade operating protocols, calibration, and/or sequencing"

* Enum values in `MeasureType:TechnologyCategory:EnergyManagementControlSystems:MeasureName` renamed

        Old: "Pneumatic to DDC convert"
        New: "Convert pneumatic controls to DDC"

        Old: "Operating protocols, calibration, and/or sequencing"
        New: "Upgrade operating protocols, calibration, and/or sequencing"

* Enum values in `MeasureType:TechnologyCategory:OtherHVAC:MeasureName` renamed

        Old: "Replace/modify AHU"
        New: "Replace or modify AHU"

        Old: "Operating protocols, calibration, and/or sequencing"
        New: "Upgrade operating protocols, calibration, and/or sequencing"

        Old: "Balancing"
        New: "Balance ventilation/distribution system"

        Old: "HVAC damper and controller repair or replacement"
        New: "Repair or replace HVAC damper and controller"

        Old: "Passive solar heating installation"
        New: "Install passive solar heating"

        Old: "Replacement of AC and heating units with ground coupled heat pump systems"
        New: "Replace AC and heating units with ground coupled heat pump systems"

        Old: "Add heat recovery"
        New: "Add energy recovery"

        Old: "Gas cooling"
        New: "Install gas cooling"

        Old: "Economizer cycle"
        New: "Add or repair economizer"

        Old: "Enhanced dehumidification"
        New: "Add enhanced dehumidification"

        Old: "Solar ventilation preheating system installation"
        New: "Install solar ventilation preheating system"

        Old: "Cleaning and repair"
        New: "Clean and/or repair"

        Old: "Training and/or documentation"
        New: "Implement training and/or documentation"

* Enum values in `MeasureType:TechnologyCategory:LightingImprovements:MeasureName` renamed

        Old: "Spectrally enhanced lighting"
        New: "Install spectrally enhanced lighting"

        Old: "Fiber optic lighting technologies"
        New: "Retrofit with fiber optic lighting technologies"

        Old: "Light emitting diode technologies"
        New: "Retrofit with light emitting diode technologies"

        Old: "Add daylight dimming"
        New: "Add daylight controls"

        Old: "Cleaning and/or repair"
        New: "Clean and/or repair"

        Old: "Training and/or documentation"
        New: "Implement training and/or documentation"

        Old: "Operation protocols, calibration, and/or sequencing"
        New: "Upgrade operating protocols, calibration, and/or sequencing"

* Enum values in `MeasureType:TechnologyCategory:BuildingEnvelopeModifications:MeasureName` renamed

        Old: "Air sealing"
        New: "Air seal envelope"

        Old: "Insulate thermal bypass"
        New: "Insulate thermal bypasses"

        Old: "Cool/green roof installed"
        New: "Install cool/green roof"

        Old: "Insulation or replacement of solar screens"
        New: "Install or replace solar screens"

        Old: "Window replacement"
        New: "Replace windows"

        Old: "Cleaning and/or repair"
        New: "Clean and/or repair"

* Enum values in `MeasureType:TechnologyCategory:ChilledWaterHotWaterAndSteamDistributionSystems:MeasureName` renamed

        Old: "Steam trap repair and replacement"
        New: "Repair and/or replace steam traps"

        Old: "Chiller plant pumping, piping, and controls retrofits and replacements"
        New: "Retrofit and replace chiller plant pumping, piping, and controls"

        Old: "Repair or replacement of existing condensate return systems and installation of new condensate return systems"
        New: "Repair or replace existing condensate return systems or install new condensate return systems"

        Old: "Replace or upgrade heater"
        New: "Replace or upgrade water heater"

        Old: "Add Heat Recovery"
        New: "Add energy recovery"

        Old: "Solar hot water system installation"
        New: "Install solar hot water system"

        Old: "Cleaning and/or repair"
        New: "Clean and/or repair"

        Old: "Training and/or documentation"
        New: "Implement training and/or documentation"

        Old: "Operation protocols, calibration, and/or sequencing"
        New: "Upgrade operating protocols, calibration, and/or sequencing"

* Enum values in `MeasureType:TechnologyCategory:ElectricMotorsAndDrives:MeasureName` renamed

        Old: "Replace with VSD"
        New: "Add VSD motor controller"

        Old: "Cleaning and/or repair"
        New: "Clean and/or repair"

        Old: "Training and/or documentation"
        New: "Implement training and/or documentation"

        Old: "Operation protocols, calibration, and/or sequencing"
        New: "Upgrade operating protocols, calibration, and/or sequencing"

* Enum values in `MeasureType:TechnologyCategory:Refrigeration:MeasureName` renamed

        Old: "Replacement of ice/refrigeration equipment with high efficiency units"
        New: "Replace ice/refrigeration equipment with high efficiency units"

        Old: "Cleaning and/or repair"
        New: "Clean and/or repair"

        Old: "Training and/or documentation"
        New: "Implement training and/or documentation"

        Old: "Operation protocols, calibration, and/or sequencing"
        New: "Upgrade operating protocols, calibration, and/or sequencing"

* Enum values in `MeasureType:TechnologyCategory:DistributedGeneration:MeasureName` renamed

        Old: "CHP/cogeneration systems installation"
        New: "Install CHP/cogeneration systems"

        Old: "Fuel cells installation"
        New: "Install fuel cells"

        Old: "Microturbines installation"
        New: "Install microturbines"

        Old: "Fuel conversion"
        New: "Convert fuels"

        Old: "Cleaning and/or repair"
        New: "Clean and/or repair"

        Old: "Training and/or documentation"
        New: "Implement training and/or documentation"

        Old: "Operation protocols, calibration, and/or sequencing"
        New: "Upgrade operating protocols, calibration, and/or sequencing"

* Enum values in `MeasureType:TechnologyCategory:RenewableEnergySystems:MeasureName` renamed

        Old: "Landfill gas, wastewater treatment plant digester gas, and coal bed methane power plant installation"
        New: "Install landfill gas, wastewater treatment plant digester gas, or coal bed methane power plant"

        Old: "Photovoltaic system installation"
        New: "Install photovoltaic system"

        Old: "Wind energy system installation"
        New: "Install wind energy system"

        Old: "Wood waste, other organic waste stream heating or power plant installation"
        New: "Install wood waste or other organic waste stream heating or power plant"

        Old: "Cleaning and/or repair"
        New: "Clean and/or repair"

        Old: "Training and/or documentation"
        New: "Implement training and/or documentation"

        Old: "Operation protocols, calibration, and/or sequencing"
        New: "Upgrade operating protocols, calibration, and/or sequencing"

* Enum values in `MeasureType:TechnologyCategory:EnergyUtilityDistributionSystems:MeasureName` renamed

        Old: "Power factor correction"
        New: "Implement power factor corrections"

        Old: "Power quality upgrades"
        New: "Implement power quality upgrades"

        Old: "Transformers installation"
        New: "Upgrade transformers"

        Old: "Gas distribution systems installation"
        New: "Install gas distribution systems"

        Old: "Cleaning and/or repair"
        New: "Clean and/or repair"

        Old: "Training and/or documentation"
        New: "Implement training and/or documentation"

        Old: "Operation protocols, calibration, and/or sequencing"
        New: "Upgrade operating protocols, calibration, and/or sequencing"

* Enum values in `MeasureType:TechnologyCategory:WaterAndSewerConservationSystems:MeasureName` renamed

        Old: "Low-flow faucets and showerheads"
        New: "Install low-flow faucets and showerheads"

        Old: "Low-flow plumbing equipment"
        New: "Install low-flow plumbing equipment"

        Old: "On-site sewer treatment systems"
        New: "Install on-site sewer treatment systems"

        Old: "Water efficient irrigation"
        New: "Implement water efficient irrigation"

        Old: "Cleaning and/or repair"
        New: "Clean and/or repair"

        Old: "Training and/or documentation"
        New: "Implement training and/or documentation"

        Old: "Operation protocols, calibration, and/or sequencing"
        New: "Upgrade operating protocols, calibration, and/or sequencing"

* Enum values in `MeasureType:TechnologyCategory:ElectricalPeakShavingLoadShifting:MeasureName` renamed

        Old: "Thermal energy storage"
        New: "Install thermal energy storage"

        Old: "Training and/or documentation"
        New: "Implement training and/or documentation"

        Old: "Operation protocols, calibration, and/or sequencing"
        New: "Upgrade operating protocols, calibration, and/or sequencing"

* Enum values in `MeasureType:TechnologyCategory:EnergyCostReductionThroughRateAdjustments:MeasureName` renamed

        Old: "Lower energy cost supplier(s) (where applicable)"
        New: "Change to lower energy cost supplier(s)"

* Enum values in `MeasureType:TechnologyCategory:EnergyRelatedProcessImprovements:MeasureName` renamed

        Old: "Industrial process improvement"
        New: "Implement industrial process improvements"

        Old: "Production and/or manufacturing improvements"
        New: "Implement production and/or manufacturing improvements"

        Old: "Cleaning and/or repair"
        New: "Clean and/or repair"

        Old: "Training and/or documentation"
        New: "Implement training and/or documentation"

        Old: "Operation protocols, calibration, and/or sequencing"
        New: "Upgrade operating protocols, calibration, and/or sequencing"

* Enum values in `MeasureType:TechnologyCategory:Commissioning:MeasureName` added and renamed

        New: "Commission or retrocommission"

        Old: "Cleaning and/or repair"
        New: "Clean and/or repair"

        Old: "Training and/or documentation"
        New: "Implement training and/or documentation"

        Old: "Operation protocols, calibration, and/or sequencing"
        New: "Upgrade operating protocols, calibration, and/or sequencing"

* Enum values in `MeasureType:TechnologyCategory:AdvancedMeteringSystems:MeasureName` renamed

        Old: "Cleaning and/or repair"
        New: "Clean and/or repair"

        Old: "Training and/or documentation"
        New: "Implement training and/or documentation"

        Old: "Operation protocols, calibration, and/or sequencing"
        New: "Upgrade operating protocols, calibration, and/or sequencing"

* Enum values in `MeasureType:TechnologyCategory:AppliancePlugLoadReductions:MeasureName` renamed

        Old: "Replace with Energy Star rated"
        New: "Replace with ENERGY STAR rated"

        Old: "Plug timers"
        New: "Install plug load controls"

        Old: "Cleaning and/or repair"
        New: "Clean and/or repair"

        Old: "Training and/or documentation"
        New: "Implement training and/or documentation"

        Old: "Operation protocols, calibration, and/or sequencing"
        New: "Upgrade operating protocols, calibration, and/or sequencing"


## BuildingSync v1.0

##### 2014-10-13

* First release
