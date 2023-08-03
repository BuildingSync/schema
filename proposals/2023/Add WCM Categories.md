# Add WCM Categories

## Overview

This proposal is to add new water conservation measure categories under `auc:Measure/auc:TechnologyCategories/auc:TechnologyCategory` and associated WCM measures.

## Justification

Based on discussion with FEMP on Water Conservation Measure from [WCM resources](https://www.energy.gov/femp/water-efficient-technology-opportunities) and PNNL measure development team on measure formatting, BuildingSync proposed to add several new measure categories related to WCMs, as well as associated measure names as enumerations. The new categories and associated measures are:
### AlternativeWaterSources
- Install condensate capture equipment
- Install atmospheric water generator
- Install wastewater treatment plant
- Install rainwater harvesting system
- Install cooling tower blowdown for appropriate applications
- Install desalinated water treatment for reuse
- Use discharged water from water purification processes
- Install foundation water treatment for reuse
- Install greywater reuse system
### KitchenImprovements
- Retrofit single-pass cooling ice machine to closed loop
- Install food disposal load sensing device
- Replace with ENERGY STAR-qualified commercial dishwashers
- Replace with ENERGY STAR-qualified steam cookers or boilerless commercial steam cookers
- Replace with ENERGY STAR-qualified ice machine
- Replace food disposal with food pulper system
- Install WaterSense-qualified pre-rinse spray valves 
- Install in-line flow restrictor on dipper wells
- Install steam kettle with condensate return
### LaboratoryAndMedicalEquipments
- Install dry vacuum air-cooled vacuum pump
- Install digital photographic or X-ray equipment
- Retrofit liquid-ring vacuum pump with a water recovery system
- Install water-efficient glassware washer with water recycling system
- Retrofit glassware washer with water recycling system
- Retrofit traditional photographic or X-ray equipment with a water recycling system
- Install pretreatment of water purification equipment to increase system recovery
- Install high efficiency water purification system with high recovery rate
- Install steam sterilizer system with automated tempering system and automatic shut off
- Retrofit vivarium washing equipment with water recycling system
- Install water-efficient vivarium washing equipment with advanced controls and water recycling
- Install water-efficient vivarium watering equipment with recirculation system
- Install steam sterilizer condensate retrofit kit
### IrrigationSystemsAndLandscapingImprovements
- Install advanced weather-based irrigation controller
- Install advanced soil-moisture based irrigation controller
- Install water-efficient irrigation sprinkler heads
- Reprogram irrigation controller to water-efficient settings
- Install irrigation meter
- Install micro-irrigation or drip irrigation 
- Install irrigation sprinkler shut-off device
- Remove or Recirculate ornamental water feature
- Install native/adaptive plants
- Remove high water consuming plants or replace with native/adaptive plants
### WashingEquipmentsAndTechiques
- Install automatic shutoff nozzle for self-service vehicle wash
- Implement water-efficient optimization for vehicle washing equipment
- Retrofit vehicle washing equipment with water recycling system
- Install high-pressure self-service vehicle washer
- Install ozone system for laundry equipment
- Install water-efficient conveyor/in-bay vehicle washing equipment
- Install Energy STAR-qualified laundry washing machines
- Install water-efficient industrial/commercial laundry equipment
- Retrofit laundry washing equipment with water recycling system
- Install meter on vehicle wash system
In addition to the specific measures, all new categories will include an `Other` option to capture possible unclarified measures or measures not specified in the list.

## Implementation
The new categories and their enumerations will be added in the way identical to the existing measures in the hierarchy of `auc:Measure`
    `auc:TechnologyCategories`
        `auc:TechnologyCategory`
            `auc:<CategoryName>`
                `auc:MeasureName`
                    `[enumerations]`.
Thus in the updated schema, under `auc:TechnologyCategories`:
```xml
    <xs:element name="TechnologyCategory" maxOccurs="unbounded">
        <xs:complexType>
            <xs:choice>
                <xs:element name="AlternativeWaterSources" minOccurs="0">
                    <xs:complexType>
                        <xs:sequence>
                            <xs:element name="MeasureName" maxOccurs="unbounded">
                                <xs:simpleType>
                                    <xs:restriction base="xs:string">
                                        <xs:enumeration value="Install condensate capture equipment"/>
                                        ...
                                    </xs:restriction>
                                </xs:simpleType>
                            </xs:element>
                        </xs:sequence>
                    </xs:complexType>
                </xs:element>
                <xs:element name="KitchenImprovements" minOccurs="0">
                    <xs:complexType>
                        <xs:sequence>
                            <xs:element name="MeasureName" maxOccurs="unbounded">
                                <xs:simpleType>
                                    <xs:restriction base="xs:string">
                                        <xs:enumeration value="Retrofit single-pass cooling ice machine to closed loop"/>
                                        ...
                                    </xs:restriction>
                                </xs:simpleType>
                            </xs:element>
                        </xs:sequence>
                    </xs:complexType>
                </xs:element>
                ...
            </xs:choice>
        </xs:complexType>
    </xs:element>
```
