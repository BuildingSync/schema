# Reconcile Controls

## Overview

The control elements in BuildingSync need to be updated to be more consistent and allow for more flexibility. The justification section outlines several of the items that need to be updated along with the reason/justification.


## Justification

Controls are under-defined within BuildingSync. First, the ability to specify that a system has multiple types of controls is not possible. Although it is ideal that each system only has one type of control, that is not always the case, especially when there can be more than one type of control strategy (e.g. timer and EMCS). Second, the controls only specify the control technology and often mixes the type of control system and control strategy. Third, when a system has customized controls (e.g. lighting systems), then the additional control elements are not part of the controls tag.

The definitions of controllers has been updated to be the following:

	* ControlSytemType - Type of controller (e.g. analog, digital, ddc, pneumatic).
	* CommunicationProtocol - Method of communicating data over a computer network.
	* ControlTechnology - Device that enables control of the system (e.g. BAS/EMCS, thermostat, timer). This will now be part of the control section and not explicity named. [bedes](https://bedes.lbl.gov/bedes-online/control-technology)
	* ControlStrategy - Control logic or strategy that is programed into the system. (e.g. schedules, manual, demand, aquastat) [bedes](https://bedes.lbl.gov/bedes-online/control-strategy)
	

* The element `BuildingSync/Facilities/Facility/Systems/HVACSystems/HVACSystem/PrimaryHVACControlStrategy` is used to define the type of controller (e.g. pneumatic, BAS, or electronic). This element needs to be renamed to a more generic name such as `PrimaryHVACControlSystemType`.

## Implementation

The proposed implementation will include a significant restructuring of the controls sections to allow for more versatility and more specific control system characteristics.


The controls will be based on their respective areas (e.g. LightingControl, HVACControl, etc.). This will allow for controls to be re-purposed based on lighting, HVAC, occupancy, or other. In each area, the controls are broken up into the conventional types such as pneumatic, digital, electronic, and other. Each of the types is further specified into the technologies, protocols, and strategies. The structure would look like the following:

The ControlType is a global complex type with the following elements that are referenced in multiple places:

	* ControlType
		* Analog
			* CommunicationProtocol
				* List of multiple analog protocols
		* Digital
			* CommunicationProtocol
				* List of multiple digital protocols
		* Pneumatic
		* Other
			* OtherCommunicationProtocol


The Lighting System has the following updated controls section:

	* Controls
		* Control (unbounded)
			* AdvancedPowerStrip
				* ControlType
				* ControlStrategy
					* List of multiple lighting-based control strategies
				* OtherControlStrategyName
			* Daylighting
				* ControlType
				* ControlSensor
					* List
				* ControlSteps
				* ControlStrategy
				* OtherControlStrategyName
			* Manual
				* ... same as above ...
			* Occupancy
			 	* ... same as above ...
			 	* ControlSensor
			 		* IR, Ultrasonic, etc.
			* Timer
				* ... same as above ...
			* OtherControlTechnology
				* ... same as above ...
			 	* OtherControlTechnologyName

The HVAC Systems, specifically the HeatingSource ... to be completed.

	* Controls
		* HVACControlType (unbounded)
			* AdvancedPowerStrip
				* CioAnalog
					* CommunicationProtocol
					* ControlStrategy
						* 
				* Digital
				* Other
			* Thermostat
			* OtherControlTechnology




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
		* LightingSystem
							
						* 

		* OccupantBasedControl (unbounded)
		* OtherControl (unbounded)

Each functional area will be a complex type allowing for easy reuse. 

All ControlStrategy elements will include the Other, Unknown, and None enumerations.

Items under lighting controls will be moved under the new LightingControls section, these include: LightingControlTypeOccupancy, LightingControlTypeTimer, LightingControlTypeDaylighting, LightingControlTypeManual. 


## Mappings

Mapping of existing control technologies (old term) to newer terms.

| Previous Field     | New XPath                 | Paired XPath             |
|--------------------|---------------------------|------------------------- |
| Programmable Thermostat | //element(auc:ControlHVACType)/auc:Thermostat/auc:ControlStrategy - Programmable | None |
| Manual Analog Thermostat | //element(auc:ControlHVACType)/auc:Thermostat/auc:ControlStrategy - Manual | //element(auc:ControlHVACType)/auc:Thermostat/auc:ControlType/auc:Analog | 
| Manual Digital Thermostat | //element(auc:ControlHVACType)/auc:Thermostat/auc:ControlStrategy - Manual | //element(auc:ControlHVACType)/auc:Thermostat/auc:ControlType/auc:Digital | 
| Manual On/Off | //element(auc:ControlHVACType)/auc:Manual/auc:ControlStrategy - Manual | None |
| EMCS | //element(auc:ControlHVACType)/auc:Thermostat/auc:ControlStrategy - EMCS | None |
| Always On | //element(auc:ControlHVACType)/auc:Thermostat/auc:ControlStrategy - Always On | None |
| Timer | //element(auc:ControlHVACType)/auc:Thermostat/auc:ControlStrategy - Timer | None |
| Other | //element(auc:ControlHVACType)/auc:Thermostat/auc:ControlStrategy - Other | None |
| Unknown | //element(auc:ControlHVACType)/auc:Thermostat/auc:ControlStrategy - Unknown | None |
| None | //element(auc:ControlHVACType)/auc:Thermostat/auc:ControlStrategy - None | None |


| AT Field - Value     | XPath								  | Paired XPath            |
|----------------------|--------------------------------------|------------------------ |
| Zone Controls - None | //element(auc:ControlHVACType)/auc:Thermostat/auc:ControlStrategy - None | None |
| Zone Controls - Manual Pneumatic Thermostat | //element(auc:ControlHVACType)/auc:Thermostat/auc:ControlStrategy - Manual | //element(auc:ControlHVACType)/auc:Thermostat/auc:ControlType/auc:Pneumatic | 
| Zone Controls - Programmable DDC Thermostat | //element(auc:ControlHVACType)/auc:Thermostat/auc:ControlStrategy - Programmable | //element(auc:ControlHVACType)/auc:Thermostat/auc:ControlType/auc:Digital |
| Zone Controls - Direct Digital Controls | Needs to be selected with the thermostat | //element(auc:ControlHVACType)/auc:Thermostat/auc:ControlType/auc:Digital | 
| Zone Controls - Pneumatic Controls | Needs to be selected with the thermostat | //element(auc:ControlHVACType)/auc:Thermostat/auc:ControlType/auc:Pneumatic |
| Central Plant - Direct Digital | | |
| Central Plant - Building Automation | | |
| Central Plant - Pneumatic Controls | | |
| Lighting Controls - Manual | //element(auc:ControlLightingType)/auc:Manual | None |
| Lighting Controls - Occupancy Sensor | //element(auc:ControlLightingType)/auc:Occupancy | None |
| Lighting Controls - Photocell | //element(auc:ControlLightingType)/auc:Daylighting/auc:ControlSensor - Photocell | None | 
| Lighting Controls - Timer | //element(auc:ControlLightingType)/auc:Timer | None |
| Lighting Controls - Building Automation System | //element(auc:ControlLightingType)/auc:OtherControlTechnology/auc:ControlStrategy - Programmable | //element(auc:ControlLightingType)/auc:OtherControlTechnology/auc:ControlType/auc:Digital |
| Lighting Controls - Advanced | //element(auc:ControlLightingType)/auc:OtherControlTechnology/auc:ControlStrategy - None | None |
| Lighting Controls - Other | //element(auc:ControlLightingType)/auc:OtherControlTechnology/auc:ControlStrategy - Other | None |

Programmable and Scheduled are the same term in BEDES, see [programmable](https://bedes.lbl.gov/bedes-online/programmable) and [scheduled](https://bedes.lbl.gov/bedes-online/scheduled). There should only be a single term and recommend "Programmable" as it is more abstract. This has been implemented.

## TODO

* Plant controls
* How to handle high-level ask if the building has analog, digital, or pneumatic
* BuildingSync/Facilities/Facility/Systems/HVACSystems/HVACSystem/HeatingAndCoolingSystems/CoolingSources/CoolingSource/ControlTechnology


## References

* ASHRAE Handbook of Fundamentals Section 2.3 - Controllers
* https://bedes.lbl.gov/bedes-online/control-strategy
* https://bedes.lbl.gov/bedes-online/control-technology
