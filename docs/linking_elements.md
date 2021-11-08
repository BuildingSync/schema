# Linking elements with ID and IDref

## Introduction to ID and ID referencing in BuildingSync

BuildingSync uses `xs:ID` to identify an element and `xs:IDREF` to link to that element. Due to unrestricted linking mechanism between `ID` element and `IDREF` elements in xml schema, BuildingSync was unable to specify the mapping between linked elements within the schema for now. This document, however, can provide clear definition and guidance for all valid linking elements in the BuildingSync Schema.

## Annotations for linking elements

The following table lists all elements that require an `IDREF` attribute, and annotates the valid `ID` elements they can link to. Ideally, this annotation should be standardized and "programmable" in the future, for editing and validation purpose.

| element_name | linked elements | full paths |
| --- | --- | --- |
| ExistingSystemReplaced* | \*\*\*System | BuildingSync/Facilities/Facility/Systems/\*\*\*Systems/\*\*\*System |
| AlternativeSystemReplacement* | \*\*\*System | BuildingSync/Facilities/Facility/Systems/\*\*\*Systems/\*\*\*System |
| ExistingSystemAffected* | \*\*\*System | BuildingSync/Facilities/Facility/Systems/\*\*\*Systems/\*\*\*System |
| ModifiedSystem* | \*\*\*System | BuildingSync/Facilities/Facility/Systems/\*\*\*Systems/\*\*\*System |
| AlternativeSystemAdded* | \*\*\*System | BuildingSync/Facilities/Facility/Systems/\*\*\*Systems/\*\*\*System |
| ExistingSystemRemoved* | \*\*\*System | BuildingSync/Facilities/Facility/Systems/\*\*\*Systems/\*\*\*System |
| SystemIDReceivingHeat | \*\*\*System | BuildingSync/Facilities/Facility/Systems/\*\*\*Systems/\*\*\*System |
| SystemIDProvidingHeat | \*\*\*System | BuildingSync/Facilities/Facility/Systems/\*\*\*Systems/\*\*\*System |
| LinkedSystemID | \*\*\*System | BuildingSync/Facilities/Facility/Systems/\*\*\*Systems/\*\*\*System |
| LinkedBuildingID | Building | BuildingSync/Facilities/Facility/Sites/Site/Buildings/Building |
| CeilingID | CeilingSystem | BuildingSync/Facilities/Facility/Systems/CeilingSystems/CeilingSystem |
| CondenserPlantID | CondenserPlant | BuildingSync/Facilities/Facility/Systems/HVACSystems/HVACSystem/Plants/CondenserPlants/| CondenserPlant |
| ContactID | Contact | BuildingSync/Facilities/Facility/Contacts/Contact |
| CertifiedAuditTeamMemberContactID | Contact | BuildingSync/Facilities/Facility/Contacts/Contact |
| AuditorContactID | Contact | BuildingSync/Facilities/Facility/Contacts/Contact |
| PrimaryContactID | Contact | BuildingSync/Facilities/Facility/Contacts/Contact |
| CoolingPlantID | CoolingPlant | BuildingSync/Facilities/Facility/Systems/HVACSystems/HVACSystem/Plants/CoolingPlants/CoolingPlant |
| CoolingSourceID | CoolingSource | BuildingSync/Facilities/Facility/Systems/HVACSystems/HVACSystem/HeatingAndCoolingSystems/CoolingSources/CoolingSource |
| DeliveryID* | Delivery | BuildingSync/Facilities/Facility/Systems/HVACSystems/HVACSystem/HeatingAndCoolingSystems/Deliveries/Delivery |
| HeatingDeliveryID | Delivery | BuildingSync/Facilities/Facility/Systems/HVACSystems/HVACSystem/HeatingAndCoolingSystems/Deliveries/Delivery |
| CoolingDeliveryID | Delivery | BuildingSync/Facilities/Facility/Systems/HVACSystems/HVACSystem/HeatingAndCoolingSystems/Deliveries/Delivery |
| LinkedDeliveryID | Delivery | BuildingSync/Facilities/Facility/Systems/HVACSystems/HVACSystem/HeatingAndCoolingSystems/Deliveries/Delivery |
| DoorID | Door | BuildingSync/Facilities/Facility/Systems/FenestrationSystems/FenestrationSystem/FenestrationType/Door |
| ExteriorFloorID | ExteriorFloorSystem | BuildingSync/Facilities/Facility/Systems/ExteriorFloorSystems/ExteriorFloorSystem |
| LinkedFacilityID | Facility | BuildingSync/Facilities/Facility |
| FoundationID | FoundationSystem | BuildingSync/Facilities/Facility/Systems/FoundationSystems/FoundationSystem |
| SourceHeatingPlantID* | HeatingPlant | BuildingSync/Facilities/Facility/Systems/HVACSystems/HVACSystem/Plants/HeatingPlants/HeatingPlant |
| LinkedHeatingPlantID* | HeatingPlant | BuildingSync/Facilities/Facility/Systems/HVACSystems/HVACSystem/Plants/HeatingPlants/HeatingPlant |
| ReheatPlantID | HeatingPlant | BuildingSync/Facilities/Facility/Systems/HVACSystems/HVACSystem/Plants/HeatingPlants/HeatingPlant |
| HeatingPlantID | HeatingPlant | BuildingSync/Facilities/Facility/Systems/HVACSystems/HVACSystem/Plants/HeatingPlants/HeatingPlant |
| HeatingSourceID | HeatingSource | BuildingSync/Facilities/Facility/Systems/HVACSystems/HVACSystem/HeatingAndCoolingSystems/HeatingSources/HeatingSource |
| MeasureID | Measure | BuildingSync/Facilities/Facility/Measures/Measure |
| BaselinePeriodModelID | Model | BuildingSync/Facilities/Facility/Reports/Report/Scenarios/Scenario/ScenarioType/DerivedModel/Models/Model |
| ReportingPeriodModelID | Model | BuildingSync/Facilities/Facility/Reports/Report/Scenarios/Scenario/ScenarioType/DerivedModel/Models/Model |
| ParentResourceUseID | ResourceUse | BuildingSync/Facilities/Facility/Reports/Report/Scenarios/Scenario/ResourceUses/ResourceUse |
| ResourceUseID | ResourceUse | BuildingSync/Facilities/Facility/Reports/Report/Scenarios/Scenario/ResourceUses/ResourceUse |
| RoofID | RoofSystem | BuildingSync/Facilities/Facility/Systems/RoofSystems/RoofSystem |
| MeasuredScenarioID | Scenario | BuildingSync/Facilities/Facility/Reports/Report/Scenarios/Scenario |
| ReferenceCase* | Scenario | BuildingSync/Facilities/Facility/Reports/Report/Scenarios/Scenario |
| HVACScheduleID | Schedule | BuildingSync/Facilities/Facility/Schedules/Schedule |
| OccupancyScheduleID | Schedule | BuildingSync/Facilities/Facility/Schedules/Schedule |
| ExistingScheduleAffected* | Schedule | BuildingSync/Facilities/Facility/Schedules/Schedule |
| LinkedScheduleID | Schedule | BuildingSync/Facilities/Facility/Schedules/Schedule |
| ModifiedSchedule* | Schedule | BuildingSync/Facilities/Facility/Schedules/Schedule |
| ExcludedSectionID | Section | BuildingSync/Facilities/Facility/Sites/Site/Buildings/Building/Sections/Section |
| LinkedSectionID | Section | BuildingSync/Facilities/Facility/Sites/Site/Buildings/Building/Sections/Section |
| LinkedSiteID | Site | BuildingSync/Facilities/Facility/Sites/Site |
| SkylightID | Skylight | BuildingSync/Facilities/Facility/Systems/FenestrationSystems/FenestrationSystem/FenestrationType/Skylight |
| LinkedSpaceID | Space | BuildingSync/Facilities/Facility/Sites/Site/Buildings/Building/Sections/Section/ThermalZones/ThermalZone/Spaces/Space |
| SpaceID | Space | BuildingSync/Facilities/Facility/Sites/Site/Buildings/Building/Sections/Section/ThermalZones/ThermalZone/Spaces/Space |
| MakeupAirSourceID* | Space | BuildingSync/Facilities/Facility/Sites/Site/Buildings/Building/Sections/Section/ThermalZones/ThermalZone/Spaces/Space |
| TenantID | Tenant | BuildingSync/Facilities/Facility/Tenants/Tenant |
| LinkedThermalZoneID | ThermalZone | BuildingSync/Facilities/Facility/Sites/Site/Buildings/Building/Sections/Section/ThermalZones/ThermalZone |
| ThermalZoneID | ThermalZone | BuildingSync/Facilities/Facility/Sites/Site/Buildings/Building/Sections/Section/ThermalZones/ThermalZone |
| LinkedTimeSeriesID | TimeSeries | "BuildingSync/Facilities/Facility/Reports/Report/Scenarios/Scenario/TimeSeriesData/TimeSeries, BuildingSync/Facilities/Facility/Reports/Report/Scenarios/Scenario/ScenarioType/DerivedModel/SavingSummaries/SavingSummary/\*\*\*Data/TimeSeries, BuildingSync/Facilities/Facility/Reports/Report/Scenarios/Scenario/ScenarioType/DerivedModel/Models/Model/ModeledTimeSeriesData/TimeSeries" |
| UtilityID | Utility | BuildingSync/Facilities/Facility/Reports/Report/Utilities/Utility |
| WallID | WallSystem | BuildingSync/Facilities/Facility/Systems/WallSystems/WallSystem |
| WeatherStationID | WeatherStation | BuildingSync/Facilities/Facility/Sites/Site/(Buildings/Building/)WeatherStations/WeatherStation |
| WindowID | Window | BuildingSync/Facilities/Facility/Systems/FenestrationSystems/FenestrationSystem/FenestrationType/Window |
