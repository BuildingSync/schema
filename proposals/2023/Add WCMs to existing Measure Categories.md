# Add WCM Categories

## Overview

This proposal is to add new water conservation measure enumerations for existing categories under `auc:Measure/auc:TechnologyCategories/auc:TechnologyCategory`.

## Justification

Based on discussion with FEMP on Water Conservation Measure from [WCM resources](https://www.energy.gov/femp/water-efficient-technology-opportunities) and PNNL measure development team on measure formatting, BuildingSync proposed to add various WCMs (and a few ECMs) to the existing measure categories. The categories and new measures are:
### BoilerPlantImprovements
- Add boiler automatic chemical feed system
- Install boiler condensate return system
- Install boiler automatic blowdown system
- Install boiler blowdown heat exchanger (ECM)
- Install boiler expansion flash tank (ECM)
- Install meters on boiler make-up lines
- Install dehumidification system (ECM)
### ChilledWaterHotWaterAndSteamDistributionSystems
- Install leak detection system
### ChillerPlantImprovements
- Implement advanced cooling tower controls to manage cycles of concentration
- Install cooling tower water treatment system
- Install automated chemical feed systems for cooling tower management
- Install conductivity controller for cooling tower management
- Install covers on open distribution decks on top of cooling tower 
- Install flow meters on make-up and blowdown lines for cooling tower management
- Install side-stream filtration system for cooling tower management
### OtherHVAC
- Retrofit single-pass cooling with an automatic shut-off device
- Retrofit single-pass cooling to eliminate single pass with closed loop/recirculation system
- Install water-efficient evaporative cooler 
- Replace water-cooled equipment with air-cooled equipment
### WaterAndSewerConservationSystems
- Remove water softeners with timers
- Install high-efficiency faucet aerator in lavatory public restrooms
- Install WaterSense-qualified faucet aerator in lavatory private restrooms
- Install WaterSense-qualified showerhead
- Install WaterSense-qualified flushometer toilets
- Install WaterSense-qualified tank toilets
- Install WaterSense-qualified flushing urinal
- Install leak detection system
- Install temporary shut-off or foot-operated valves with kitchen faucets

## Implementation
The enumerations will be added in the way identical to the existing measures in the hierarchy of 
`auc:Measure`
    `auc:TechnologyCategories`
        `auc:TechnologyCategory`
            `auc:<CategoryName>`
                `auc:MeasureName`
                    `[enumerations]`.
