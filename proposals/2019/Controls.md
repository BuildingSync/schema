# Reconcile Controls

## Overview

The control elements in BuildingSync need to be updated to be more consistent and allow for more flexibility. The justification section outlines several of the items that need to be updated along with the reason/justification.


## Justification

Controls are under-defined within BuildingSync. First, the ability to specify that a system has multiple types of controls is not possible. Although it is ideal that each system only has one type of control, that is not always the case, especially when there can be more than one type of control strategy (e.g. timer and EMCS). Second, the controls only specify the control technology and often mixes the type of control system and control strategy. Third, when a system has customized controls (e.g. lighting systems), then the additional control elements are not part of the controls tag.

The definitions of controllers has been updated to be the following:

	* ControlSytemType - Type of controller (e.g. analog, digital, ddc, pneumatic).
	* CommunicationProtocol - Method of communicating data over a computer network.
	* ControlTechnology - Device that enables control of the system. (e.g. EMCS, thermostat, timer) [bedes](https://bedes.lbl.gov/bedes-online/control-technology)
	* ControlStrategy - Control logic or strategy that is programed into the system. (e.g. schedules, manual, demand, aquastat) [bedes](https://bedes.lbl.gov/bedes-online/control-strategy)
	

* The element `BuildingSync/Facilities/Facility/Systems/HVACSystems/HVACSystem/PrimaryHVACControlStrategy` is used to define the type of controller (e.g. pneumatic, BAS, or electronic). This element needs to be renamed to a more generic name such as `PrimaryHVACControlSystemType`.

## Implementation

There are two proposals that are in discussion--based on user feedback only one of these will be implemented and this proposal will be updated. The first proposal is a more simple approach designed to have the most flexibility but will require humans to ensure that valid combinations are present. The second proposal approach is an overhaul and allows for future extensibility.

1. The ControlTechnology element will be renamed to simply controls made into a list (Controls) and the previous ControlTechnology element will be converted to Control and have sub-elements. In brief, the update will look like the following:

	* Controls
		* Control (unbounded)
			* ControlSytemType
			* CommunicationProtocol
			* ControlTechnology
			* ControlStrategy

The difficulty with this proposal is that the 4 defined elements above have many invalid combinations (e.g. pneumatic/bacnet/thermostat/programmable). 

2. The second proposed implementation will structure the controls based on their respective areas. This will allow for controls to be re-purposed based on lighting, HVAC, occupancy, or other. In each area, the controls are broken up into the conventional types such as pneumatic, digital, electronic, and other. Each of the types is further specified into the technologies, protocols, and strategies. The structure would look like the following:

	* Controls
		* HVACControl (unbounded)
			* Pneumatic
				* ControlTechnology 
					* Thermostat
						* ControlStrategy
							- Always On
							- Manual
					* Timer
						* ControlStrategy
							- Always On
							- Aquastat
							- Demand
							- Manual
							- Programmable
							- Scheduled
					* Other
						* ControlStrategy
							- Always On
							- Aquastat
							- Demand
							- Manual
							- Programmable
							- Scheduled
			* Analog (see schema)
			* DirectDigitalControl (see schema)
			* Other (see schema)
		* LightingControl (unbounded)
		* OccupantBasedControl (unbounded)
		* OtherControl (unbounded)

All ControlStrategy elements will include the Other, Unknown, and None enumerations.
With proposal 2, the lighting controls will be moved under the controls section, these include: LightingControlTypeOccupancy, LightingControlTypeTimer, LightingControlTypeDaylighting, LightingControlTypeManual. 

** Note: The schema has this only stubbed out for the LightingSystem **

## Mappings

Below are the mapping for option 2 to demonstrate how the new format may look.

BuildingSync/Facilities/Facility/Systems/HVACSystems/HVACSystem/HeatingAndCoolingSystems/CoolingSources/CoolingSource/ControlTechnology

| AT Field - Value     | XPath								  |
|----------------------|------------------------------------- |
| Zone Controls - None | BuildingSync/Facilities/Facility/Systems/LightingSystems/LightingSystem/Controls_2/HVACControl/Other/ControlTechnology/None |
| Zone Controls - Manual Pneumatic Thermostat | BuildingSync/Facilities/Facility/Systems/LightingSystems/LightingSystem/Controls_2/HVACControl/Pneumatic/ControlTechnology/Thermostat/ControlStrategy - Manual |
| Zone Controls - Programmable DDC Thermostat | BuildingSync/Facilities/Facility/Systems/LightingSystems/LightingSystem/Controls_2/HVACControl/DirectDigitalControl/ControlTechnology/Thermostat/ControlStrategy |
| Zone Controls - Direct Digital Controls | Needs to be selected with the thermostat |
| Zone Controls - Pneumatic Controls | Needs to be selected with the thermostat |
| Central Plant - Direct Digital | BuildingSync/Facilities/Facility/Systems/LightingSystems/LightingSystem/Controls_2/HVACControl/DirectDigitalControl/ControlTechnology/ECMS/ControlStrategy - Other |
| Central Plant - Building Automation System | BuildingSync/Facilities/Facility/Systems/LightingSystems/LightingSystem/Controls_2/HVACControl/DirectDigitalControl/ControlTechnology/ECMS/ControlStrategy - Programmable |
| Central Plant - Pneumatic Controls | BuildingSync/Facilities/Facility/Systems/LightingSystems/LightingSystem/Controls_2/HVACControl/Pneumatic/ControlTechnology/Other/ControlStrategy - Other |
| Lighting Controls - Occupancy Sensor | BuildingSync/Facilities/Facility/Systems/LightingSystems/LightingSystem/Controls_2/LightingControl/Digital/ControlTechnology/Occupancy/ControlStrategy |
| Lighting Controls - Photocell | BuildingSync/Facilities/Facility/Systems/LightingSystems/LightingSystem/Controls_2/LightingControl/Digital/ControlTechnology/Photocell/ControlStrategy - Other |
| Lighting Controls - Timer | BuildingSync/Facilities/Facility/Systems/LightingSystems/LightingSystem/Controls_2/LightingControl/Digital/ControlTechnology/Timer/ControlStrategy | 
| Lighting Controls - Building Automation System | BuildingSync/Facilities/Facility/Systems/LightingSystems/LightingSystem/Controls_2/LightingControl/Digital/ControlTechnology/ECMS/ControlStrategy |
| Lighting Controls - Advanced | BuildingSync/Facilities/Facility/Systems/LightingSystems/LightingSystem/Controls_2/LightingControl/Digital/ControlTechnology/Other/ControlStrategy - Advanced |
| Lighting Controls - Other | BuildingSync/Facilities/Facility/Systems/LightingSystems/LightingSystem/Controls_2/LightingControl/Digital/ControlTechnology/Other/ControlStrategy - Unknown |


## Questions

Programmable and Scheduled are the same term in BEDES, see [programmable](https://bedes.lbl.gov/bedes-online/programmable) and [scheduled](https://bedes.lbl.gov/bedes-online/scheduled). There should only be a single term and recommend "Programmable" as it is more abstract. 

## TODO

* Determine if we should flip control technologies and control type
* Plant controls
* How to handle high-level ask if the building has analog, digital, or pneumatic
* Do not put 0-10V as an enum (use voltage | current)
## References

* ASHRAE Handbook of Fundamentals Section 2.3 - Controllers
* https://bedes.lbl.gov/bedes-online/control-strategy
* https://bedes.lbl.gov/bedes-online/control-technology
