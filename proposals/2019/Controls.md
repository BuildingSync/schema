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
					* List of multiple lighting-based control strategies
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
			 	* OtherControlStrategyName

Items under lighting controls will be moved under the new LightingControls section, these include: LightingControlTypeOccupancy, LightingControlTypeTimer, LightingControlTypeDaylighting, LightingControlTypeManual. 

The remaining controls were lumped into a general control complex type with the following structure:

	* AdvancedPowerStrip
		* ControlType
		* ControlStrategy
			* List of multiple general control strategies
		* OtherControlStrategyName
	* Manual
		* ... same as above ...
	* Occupancy
	 	* ... same as above ...
	 	* ControlSensor
	 		* IR, Ultrasonic, etc.
	* Timer
		* ... same as above ...
	* Thermostat
		* ... same as above ...
	* OtherControlTechnology
		* ... same as above ...
	 	* OtherControlTechnologyName

Their were several existing systems that had existing ControlTechnologies. These systems were updated with the ControlHVACType complex element. The systems included: HeatingSource, CoolingSource, Delivery, OtherHVACSystems, Solar, DomesticHotWater, DishwasherSystem, LaundrySystem, PumpSystem, FanSystems, MotorSystems, HeatRecoverySystem, Pool/Heated, WaterUse, ProcessLoads, PlugLoads, CriticalITSystems, ConveyanceSystems.

The `PrimaryHVACControlStrategy` will be renamed to `PrimaryControlSystemType`.

The BuildingAutomationSystem element was made global and repeated in the HeatingPlant, CoolingPlant, CondenserPlant to allow the user to specify that the system is connected to a BAS/EMCS.

## Mappings

Mapping of existing control technologies (old term) to newer terms.

| Previous Field     | New XPath                 | Paired XPath             |
|--------------------|---------------------------|------------------------- |
| Programmable Thermostat | //element(ControlHVACType)/Thermostat/ControlStrategy - Programmable | None |
| Manual Analog Thermostat | //element(ControlHVACType)/Thermostat/ControlStrategy - Manual | //element(ControlHVACType)/Thermostat/ControlSystemType/Analog | 
| Manual Digital Thermostat | //element(ControlHVACType)/Thermostat/ControlStrategy - Manual | //element(ControlHVACType)/Thermostat/ControlSystemType/Digital | 
| Manual On/Off | //element(ControlHVACType)/Manual/ControlStrategy - Manual | None |
| EMCS | //element(ControlHVACType)/Thermostat/ControlStrategy - EMCS | None |
| Always On | //element(ControlHVACType)/Thermostat/ControlStrategy - Always On | None |
| Timer | //element(ControlHVACType)/Thermostat/ControlStrategy - Timer | None |
| Other | //element(ControlHVACType)/Thermostat/ControlStrategy - Other | None |
| Unknown | //element(ControlHVACType)/Thermostat/ControlStrategy - Unknown | None |
| None | //element(ControlHVACType)/Thermostat/ControlStrategy - None | None |


| AT Field - Value     | XPath								  | Paired XPath            |
|----------------------|--------------------------------------|------------------------ |
| Zone Controls - None | //element(ControlHVACType)/Thermostat/ControlStrategy - None | None |
| Zone Controls - Manual Pneumatic Thermostat | //element(ControlHVACType)/Thermostat/ControlStrategy - Manual | //element(ControlHVACType)/Thermostat/ControlSystemType/Pneumatic | 
| Zone Controls - Programmable DDC Thermostat | //element(ControlHVACType)/Thermostat/ControlStrategy - Programmable | //element(ControlHVACType)/Thermostat/ControlSystemType/Digital |
| Zone Controls - Direct Digital Controls | Needs to be selected with the thermostat | //element(ControlHVACType)/Thermostat/ControlSystemType/Digital | 
| Zone Controls - Pneumatic Controls | Needs to be selected with the thermostat | //element(ControlHVACType)/Thermostat/ControlSystemType/Pneumatic |
| Heating Central Plant - Direct Digital | BuildingSync/Facilities/Facility/Systems/HVACSystems/HVACSystem/Plants/HeatingPlants/HeatingPlant/ControlSystemType/Digital | |
| Heating Central Plant - Building Automation | BuildingSync/Facilities/Facility/Systems/HVACSystems/HVACSystem/Plants/HeatingPlants/HeatingPlant/BuildingAutomationSystem | |
| Heating Central Plant - Pneumatic Controls | BuildingSync/Facilities/Facility/Systems/HVACSystems/HVACSystem/Plants/HeatingPlants/HeatingPlant/ControlSystemType/Pneumatic | |
| Cooling Central Plant - Direct Digital | BuildingSync/Facilities/Facility/Systems/HVACSystems/HVACSystem/Plants/CoolingPlants/CoolingPlant/ControlSystemType/Digital | |
| Cooling Central Plant - Building Automation | BuildingSync/Facilities/Facility/Systems/HVACSystems/HVACSystem/Plants/CoolingPlants/CoolingPlant/BuildingAutomationSystem | |
| Cooling Central Plant - Pneumatic Controls | BuildingSync/Facilities/Facility/Systems/HVACSystems/HVACSystem/Plants/CoolingPlants/CoolingPlant/ControlSystemType/Pneumatic | |
| Condenser Central Plant - Direct Digital | BuildingSync/Facilities/Facility/Systems/HVACSystems/HVACSystem/Plants/CondenserPlants/CondenserPlant/ControlSystemType/Digital | |
| Condenser Central Plant - Building Automation | BuildingSync/Facilities/Facility/Systems/HVACSystems/HVACSystem/Plants/CondenserPlants/CondenserPlant/BuildingAutomationSystem | |
| Condenser Central Plant - Pneumatic Controls | BuildingSync/Facilities/Facility/Systems/HVACSystems/HVACSystem/Plants/CondenserPlants/CondenserPlant/ControlSystemType/Pneumatic  | |
| Lighting Controls - Manual | //element(ControlLightingType)/Manual | None |
| Lighting Controls - Occupancy Sensor | //element(ControlLightingType)/Occupancy | None |
| Lighting Controls - Photocell | //element(ControlLightingType)/Daylighting/ControlSensor - Photocell | None | 
| Lighting Controls - Timer | //element(ControlLightingType)/Timer | None |
| Lighting Controls - Building Automation System | //element(ControlLightingType)/OtherControlTechnology/ControlStrategy - Programmable | //element(ControlLightingType)/OtherControlTechnology/ControlSystemType/Digital |
| Lighting Controls - Advanced | //element(ControlLightingType)/OtherControlTechnology/ControlStrategy - None | None |
| Lighting Controls - Other | //element(ControlLightingType)/OtherControlTechnology/ControlStrategy - Other | None |

Programmable and Scheduled are the same term in BEDES, see [programmable](https://bedes.lbl.gov/bedes-online/programmable) and [scheduled](https://bedes.lbl.gov/bedes-online/scheduled). There should only be a single term and recommend "Programmable" as it is more abstract. This has been implemented.

## TODO

* Plant controls

## References

* ASHRAE Handbook of Fundamentals Section 2.3 - Controllers
* https://bedes.lbl.gov/bedes-online/control-strategy
* https://bedes.lbl.gov/bedes-online/control-technology
