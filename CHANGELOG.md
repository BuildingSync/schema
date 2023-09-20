# BuildingSync

## Version 2.5.0

BuildingSync Version 2.5.0 adds new elements for Water Conservation Measures (WCMs) and emission-related fields (Greenhouse Gas Emission). Version 2.5.0 adds examples of interactive Jupyter Notebooks to illustrate the process of creating BuildingSync XML reports from building data, where the synthetic data was generated based on DOE prototype buildings (small office and primary school).

Date Range: 10/01/21 - 09/30/23

| Category       | Count |     
|----------------|-------|     
| Schema: Controls         | 0  |
| Schema: Documentation         | 7  |
| Schema: General         | 9  |
| Schema: Measures         | 6  |
| Schema: Reports         | 3  |
| Schema: Systems         | 3  |
| Schema: Validation         | 0  |
| Other         | 13  |
| **Total**      | 41 |

### Breaking Changes
 - [#457](https://github.com/BuildingSync/schema/pull/457), Create Add DiscountRate.md (`Measures`)

### Non-breaking Changes
 - [#485](https://github.com/BuildingSync/schema/pull/485), Update AuditorQualificationType (`General`) 
 - [#483](https://github.com/BuildingSync/schema/pull/483), Make migrations scripts (`No Changes`)   
 - [#481](https://github.com/BuildingSync/schema/pull/481), Add WCMs to existing categories (`Measures`)
 - [#480](https://github.com/BuildingSync/schema/pull/480), Add WCM categories (`Measures`)
 - [#478](https://github.com/BuildingSync/schema/pull/478), Add AuditCycles (`Reports`)
 - [#477](https://github.com/BuildingSync/schema/pull/477), Add FacilityEvaluationAuditDefinition (`Reports`)
 - [#476](https://github.com/BuildingSync/schema/pull/476), Add CondenserType (`Systems`)
 - [#475](https://github.com/BuildingSync/schema/pull/475), Change PrincipalHVACSystemType (`General`, `Systems`)
 - [#473](https://github.com/BuildingSync/schema/pull/473), Add PrincipalLightingSystemType (`General`)
 - [#468](https://github.com/BuildingSync/schema/pull/468), Proposal to add measures for data center energy conservation improvements (`Measures`)
 - [#467](https://github.com/BuildingSync/schema/pull/467), Proposal to add auditor certification types (`General`)
 - [#464](https://github.com/BuildingSync/schema/pull/464), Building EQ Example XML (`General`)
 - [#463](https://github.com/BuildingSync/schema/pull/463), build(deps): bump markdown-it-py from 2.1.0 to 2.2.0 in /docs/notebooks (`No Changes`)
 - [#462](https://github.com/BuildingSync/schema/pull/462), run update on Python notebook dependencies (`No Changes`)
 - [#460](https://github.com/BuildingSync/schema/pull/460), Proposal: Add RCx Auditor Qualification Types (`General`)
 - [#458](https://github.com/BuildingSync/schema/pull/458), Update Audit Template examples (`No Changes`)
 - [#456](https://github.com/BuildingSync/schema/pull/456), Update dependency lock file (`No Changes`)
 - [#454](https://github.com/BuildingSync/schema/pull/454), Create Add Emissions for MeasureSavingsAnalysis and AnnualSavingsByFu… (`General`)
 - [#453](https://github.com/BuildingSync/schema/pull/453), Create Add Package-Measure Energy Savings Analyses.md (`Measures`)
 - [#451](https://github.com/BuildingSync/schema/pull/451), Create Add Equipment ID.md (`Systems`)
 - [#449](https://github.com/BuildingSync/schema/pull/449), Update notebook for validation against multiple use cases (`No Changes`)
 - [#448](https://github.com/BuildingSync/schema/pull/448), Update notebooks quotes (`No Changes`)
 - [#447](https://github.com/BuildingSync/schema/pull/447), Notebooks protobuildings (`Documentation`)
 - [#445](https://github.com/BuildingSync/schema/pull/445), Small office prototype building level 2 audit notebook and example (`No Changes`)
 - [#444](https://github.com/BuildingSync/schema/pull/444), add instructions on how to open notebook (`Documentation`)
 - [#443](https://github.com/BuildingSync/schema/pull/443), Save notebooks as markdown (`No Changes`)
 - [#441](https://github.com/BuildingSync/schema/pull/441), update example file and point to develop of bsyncpy (`Documentation`)
 - [#439](https://github.com/BuildingSync/schema/pull/439), Schema: Update notebook (`Documentation`)
 - [#436](https://github.com/BuildingSync/schema/pull/436), Schema modifications for CO2e (`Reports`)
 - [#435](https://github.com/BuildingSync/schema/pull/435), Add example with sensor data in notebook directory (`Documentation`)
 - [#433](https://github.com/BuildingSync/schema/pull/433), Update ASHRAE 211 Export example v2 (`Documentation`)
 - [#424](https://github.com/BuildingSync/schema/pull/424), Add Implement hot aisle cold aisle design (`Measures`)
 - [#421](https://github.com/BuildingSync/schema/pull/421), refactor: allow versions without PATCH included (`General`)
 - [#419](https://github.com/BuildingSync/schema/pull/419), Docs/generic linking for develop v2 (`Documentation`)
 - [#406](https://github.com/BuildingSync/schema/pull/406), chore: point gbxml schemaLocation to BSync's fork (`General`)

### Non-schema Changes
 - [#426](https://github.com/BuildingSync/schema/pull/426), Update example version reference to 2.4 (`No Changes`)
 - [#412](https://github.com/BuildingSync/schema/pull/412), Use PyPi version of BSyncPy and Update to BuildingSync 2.4
 - [#403](https://github.com/BuildingSync/schema/pull/403), update pynb images and linked urls

### Issues

New Issues: 19 (#404, #405, #408, #411, #413, #414, #416, #420, #427, #428, #429, #450, #455, #465, #466, #469, #470, #471, #474)

Closed Issues: 22
- [#283]( https://github.com/BuildingSync/schema/issues/283 ), Deprecate: MORE in auc:eGRIDRegionCode enumeration (`bug`, `General`, `Breaking Change`)
- [#295]( https://github.com/BuildingSync/schema/issues/295 ), Generic Linking Documentation (`Documentation`, `priority-low`)
- [#314]( https://github.com/BuildingSync/schema/issues/314 ), [9/30] BuildingSync Version 3.0.0-Beta – Updated for modularization
- [#316]( https://github.com/BuildingSync/schema/issues/316 ), Addition of water conservation measures and associated fields to support EISA-432 project tracking and compliance #88
- [#362]( https://github.com/BuildingSync/schema/issues/362 ), CTS - BuildingSync versioning management (`CTS-Support`)
- [#393]( https://github.com/BuildingSync/schema/issues/393 ), Fix gbxml.org link to schema
- [#397]( https://github.com/BuildingSync/schema/issues/397 ), RFC: Repository -- Proposal for tracking schema changes
- [#404]( https://github.com/BuildingSync/schema/issues/404 ), Reach out to users abt new schemas.
- [#405]( https://github.com/BuildingSync/schema/issues/405 ), Docs: add documentation for PR labeling and CHANGELOGs
- [#408]( https://github.com/BuildingSync/schema/issues/408 ), Update examples  to 2.4
- [#411]( https://github.com/BuildingSync/schema/issues/411 ), Update Jupyter Notebook with BSync Version 2.4
- [#413]( https://github.com/BuildingSync/schema/issues/413 ), Create gbxml schemaLocation patch releases
- [#414]( https://github.com/BuildingSync/schema/issues/414 ), Update schema version attribute to generically handle patch versions
- [#416]( https://github.com/BuildingSync/schema/issues/416 ), Update reference element (i.e. IDref) names
- [#420]( https://github.com/BuildingSync/schema/issues/420 ), Fix typo in `Implement hot aisle hold aisle design` (`bug`, `Measures`)
- [#427]( https://github.com/BuildingSync/schema/issues/427 ), Remove xmlns and nX:source in example files
- [#429]( https://github.com/BuildingSync/schema/issues/429 ), Move hastack example/proposal into a single MD file
- [#455]( https://github.com/BuildingSync/schema/issues/455 ), BuldingSync and HPXML
- [#466]( https://github.com/BuildingSync/schema/issues/466 ), [6/30/23] Adding to BuildingSync's Schema Milestone
- [#469]( https://github.com/BuildingSync/schema/issues/469 ), [5/19/23] Review UDFs and new AT elements
- [#470]( https://github.com/BuildingSync/schema/issues/470 ), [6/9/23] Add UDFs and new AT elements to schema
- [#471]( https://github.com/BuildingSync/schema/issues/471 ), [6/16/23] Add GHG to example notebook

All Open Issues: 20 (#151, #154, #167, #170, #183, #195, #198, #218, #260, #285, #287, #297, #320, #356, #370, #391, #465, #428, #450, #474)

## Version 2.4.0

BuildingSync Version 2.4.0 does not introduce any breaking changes. 

Date Range: 03/11/21 - 9/30/21

| Category       | Count |
|----------------|-------|
| Controls         | 0  |
| Documentation         | 8  |
| General         | 6  |
| Measures         | 0  |
| Reports         | 3  |
| Systems         | 2  |
| Validation         | 0  |
| Other         | 4  |
| **Total**      | 23 |

| Change Type    | Count |
|----------------|-------|
| Breaking Change         | 0  |
| Non-breaking Change         | 23  |

New Issues: 30 (#305, #314, #315, #318, #320, #321, #323, #324, #325, #326, #330, #333, #336, #337, #338, #343, #347, #356, #358, #361, #362, #365, #369, #370, #375, #381, #390, #391, #393, #397)

Closed Issues: 13
- Improved [#210]( https://github.com/BuildingSync/schema/issues/210 ), Change formatting of units in XSD documentation
- Merged [#296]( https://github.com/BuildingSync/schema/issues/296 ), DuctSystem/MaximumOAFlowRate Rename
- New Feature [#304]( https://github.com/BuildingSync/schema/issues/304 ), Develop BSync user stories:
- New Feature [#305]( https://github.com/BuildingSync/schema/issues/305 ), Improve release process of schema
- Merged [#315]( https://github.com/BuildingSync/schema/issues/315 ), [9/30/21] Milestone 4-3: Update Strategy Document based on FEMP and BTO feedback     
- Improved [#323]( https://github.com/BuildingSync/schema/issues/323 ), Deduplicate elements: ActiveDehumidification through EnergySellRate
- Improved [#324]( https://github.com/BuildingSync/schema/issues/324 ), Deduplicate elements: EnergyUse through OtherControlStrategyName
- Improved [#325]( https://github.com/BuildingSync/schema/issues/325 ), Deduplicate elements: OtherControlTechnology through YearOfConstruction
- Merged [#326]( https://github.com/BuildingSync/schema/issues/326 ), Fix some tag names
- Merged [#365]( https://github.com/BuildingSync/schema/issues/365 ), Add geometry reference sheet to releases
- Merged [#369]( https://github.com/BuildingSync/schema/issues/369 ), Update URLs to selection tool
- New Feature [#381]( https://github.com/BuildingSync/schema/issues/381 ), Add eGRID subregion for Puerto Rico
- Improved [#390]( https://github.com/BuildingSync/schema/issues/390 ), Compare terms to most updated BEDES dictionary

Accepted Pull Requests: 23
- New Feature [#298]( https://github.com/BuildingSync/schema/pull/298 ), Add AuditorYearsOfExperience
- New Feature [#299]( https://github.com/BuildingSync/schema/pull/299 ), Add SpatialUnits
- New Feature [#306]( https://github.com/BuildingSync/schema/pull/306 ), Add TotalCommonConditionedAboveGradeWallArea
- New Feature [#307]( https://github.com/BuildingSync/schema/pull/307 ), Add TotalRoofArea
- New Feature [#308]( https://github.com/BuildingSync/schema/pull/308 ), Add AuditFilingStatus
- New Feature [#309]( https://github.com/BuildingSync/schema/pull/309 ), Add EarlyCompliance
- New Feature [#310]( https://github.com/BuildingSync/schema/pull/310 ), Add MultiTenant
- New Feature [#311]( https://github.com/BuildingSync/schema/pull/311 ), Add AverageAnnualOperatingHours
- New Feature [#322]( https://github.com/BuildingSync/schema/pull/322 ), test: add test for duplicate element names
- Merged [#327]( https://github.com/BuildingSync/schema/pull/327 ), build: add gh workflow for building releases
- Merged [#339]( https://github.com/BuildingSync/schema/pull/339 ), docs: add versioning documentation
- Merged [#344]( https://github.com/BuildingSync/schema/pull/344 ), docs: add notes for making pre-releases
- Merged [#349]( https://github.com/BuildingSync/schema/pull/349 ), Refactor/remove duplicates
- Merged [#366]( https://github.com/BuildingSync/schema/pull/366 ), Publish geometry reference guide on release
- Merged [#368]( https://github.com/BuildingSync/schema/pull/368 ), Docs/bsync examples
- Merged [#371]( https://github.com/BuildingSync/schema/pull/371 ), update links to buildingsync website
- Merged [#372]( https://github.com/BuildingSync/schema/pull/372 ), fix selection tool urls
- New Feature [#385]( https://github.com/BuildingSync/schema/pull/385 ), Add PRMS in eGRIDRegionCode for develop branch
- Merged [#386]( https://github.com/BuildingSync/schema/pull/386 ), Update Jupyter notebook
- New Feature [#387]( https://github.com/BuildingSync/schema/pull/387 ), Add eGRIDSubregionCodes
- Merged [#388]( https://github.com/BuildingSync/schema/pull/388 ), renamed selection tool repo to website
- Improved [#392]( https://github.com/BuildingSync/schema/pull/392 ), Update change_log.rb
- New Feature [#395]( https://github.com/BuildingSync/schema/pull/395 ), Add MaximumOutsideAirFlowRate

## Version 2.3.0

BuildingSync Version 2.3.0 does not introduce any breaking changes. 

Date Range: 09/26/20 - 12/19/20

| Category       | Count |
|----------------|-------|
| Controls         | 0  |
| General         | 2  |
| Measures         | 1  |
| Reports         | 3  |
| Systems         | 3  |
| Validation         | 0  |
| Other         | 6  |
| **Total**      | 15 |

| Change Type    | Count |
|----------------|-------|
| Breaking Change         | 0  |
| Non-breaking Change         | 15  |

New Issues: 16 (#253, #254, #259, #260, #264, #265, #268, #271, #272, #273, #274, #275, #276, #283, #284, #285)

Closed Issues: 4
- Merged [#265]( https://github.com/BuildingSync/schema/issues/265 ), Add modeling of temperature time series
- Merged [#273]( https://github.com/BuildingSync/schema/issues/273 ), TechnologyCategory annotations need to be updated
- Merged [#274]( https://github.com/BuildingSync/schema/issues/274 ), Add 'Install electrical storage' to 'Renewable Energy Systems' TechCat
- Merged [#276]( https://github.com/BuildingSync/schema/issues/276 ), Fix typo in auc:eGRIDRegionCode enumeration

Accepted Pull Requests: 15
- Merged [#255]( https://github.com/BuildingSync/schema/pull/255 ), docs: add notes on git naming conventions
- Merged [#256]( https://github.com/BuildingSync/schema/pull/256 ), Add LinkedSystemIDs to DuctSystem
- Merged [#257]( https://github.com/BuildingSync/schema/pull/257 ), Add estimated as an "engineering calculation"
- Merged [#258]( https://github.com/BuildingSync/schema/pull/258 ), docs(schema): add deprecation warning for Delivery Capacity
- Merged [#261]( https://github.com/BuildingSync/schema/pull/261 ), docs(schema): add deprecation policy
- Merged [#262]( https://github.com/BuildingSync/schema/pull/262 ), docs(examples): update Audit Template example files
- Merged [#263]( https://github.com/BuildingSync/schema/pull/263 ), Add choice for FanInstalledFlowRate. Will deprecate InstalledFanFlowRate.
- Merged [#267]( https://github.com/BuildingSync/schema/pull/267 ), Add weather station element
- Merged [#269]( https://github.com/BuildingSync/schema/pull/269 ), create TimeSeriesReadingQuantity Cost
- Merged [#277]( https://github.com/BuildingSync/schema/pull/277 ), Add derived models to reporting and scenarios
- Merged [#278]( https://github.com/BuildingSync/schema/pull/278 ), Update annotations for data dictionary
- Merged [#279]( https://github.com/BuildingSync/schema/pull/279 ), Add MROE eGridRegion
- Merged [#280]( https://github.com/BuildingSync/schema/pull/280 ), Add new measure for install electrical storage
- Merged [#281]( https://github.com/BuildingSync/schema/pull/281 ), Add GH Actions and Issue Templates
- Merged [#282]( https://github.com/BuildingSync/schema/pull/282 ), `<p>` formatting in XSD

## Version 2.2.0

BuildingSync Version 2.2.0 does not introduce any breaking changes. Version 2.2.0 adds new elements required for a 
complete audit report for ASHRAE Standard 211 Level 2. This version also introduces references to the 
[gbXML schema](https://www.gbxml.org/). See the [documentation here](docs/gbXML_reference.md) for more information 
about this integration with gbXML.  

Note that some elements are beginning to be deprecated. To ensure future conformance to the schema, these elements 
should be updated to their alternative names:

| Element being deprecated | New element |
|----------------|-------|
| auc:HeatingSource/auc:OutputCapacity | auc:HeatingSource/auc:Capacity |
| auc:Boiler/auc:OutputCapacity | auc:Boiler/auc:Capacity |
| auc:DistrictHeating/auc:OutputCapacity | auc:DistrictHeating/auc:Capacity |
| auc:SolarThermal/auc:OutputCapacity | auc:SolarThermal/auc:Capacity |
| auc:PrimaryHVACSystemType | auc:PrincipalHVACSystemType |


Date Range: 07/31/20 - 09/25/20

| Category       | Count |
|----------------|-------|
| Controls         | 0  |
| General         | 8  |
| Measures         | 1  |
| Reports         | 13  |
| Systems         | 10  |
| Validation         | 1  |
| Other         | 4  |
| **Total**      | 37 |

| Change Type    | Count |
|----------------|-------|
| Breaking Change         | 0  |
| Non-breaking Change         | 37  |

New Issues: 7 (#212, #218, #230, #233, #234, #235, #236)

Closed Issues: 4
- Merged [#172]( https://github.com/BuildingSync/schema/issues/172 ), Promote UDF - PrincipalHVACType as part of Section.
- Merged [#172]( https://github.com/BuildingSync/schema/issues/172 ), Promote UDF - PrincipalHVACType as part of Section.
- Merged [#173]( https://github.com/BuildingSync/schema/issues/173 ), Promote UDF - PrincipalLightingSystemType as part of Section.
- Merged [#212]( https://github.com/BuildingSync/schema/issues/212 ), Question concerning some "Other delivered" auc:FuelTypes

Accepted Pull Requests: 37
- Merged [#156]( https://github.com/BuildingSync/schema/pull/156 ), gbXML External Reference
- Merged [#200]( https://github.com/BuildingSync/schema/pull/200 ), Add ReadingType Cost to TimeSeries
- Merged [#203]( https://github.com/BuildingSync/schema/pull/203 ), Add ResourceUseNotes to ResourceUse
- Merged [#204]( https://github.com/BuildingSync/schema/pull/204 ), Add AnnualFuelCost to ResourceUse
- Merged [#205]( https://github.com/BuildingSync/schema/pull/205 ), Add SimpleImpactAnalysis and CostCategory to PackageOfMeasures
- Merged [#207]( https://github.com/BuildingSync/schema/pull/207 ), Add ExcludedSectionIDs to FloorArea
- Merged [#208]( https://github.com/BuildingSync/schema/pull/208 ), Add LinkedPremises to Schedule
- Merged [#213]( https://github.com/BuildingSync/schema/pull/213 ), Add AnnualFuelUseLinkedTimeSeriesIDs to ResourceUse
- Merged [#214]( https://github.com/BuildingSync/schema/pull/214 ), Add multiple elements for energy use in AllResourceTotal
- Merged [#215]( https://github.com/BuildingSync/schema/pull/215 ), Add choice between PrimaryHVACSystemType and PrincipalHVACSystemType
- Merged [#216]( https://github.com/BuildingSync/schema/pull/216 ), pull rate elements out as distinct element types to reduce redundancy
- Merged [#217]( https://github.com/BuildingSync/schema/pull/217 ), update tiered rate to include demand rate start and end dates
- Merged [#219]( https://github.com/BuildingSync/schema/pull/219 ), feat(proposals): add proposal for versioning
- Merged [#221]( https://github.com/BuildingSync/schema/pull/221 ), Release 2.2.0-pr1
- Merged [#222]( https://github.com/BuildingSync/schema/pull/222 ), Add Operational enum to ScheduleCategories
- Merged [#223]( https://github.com/BuildingSync/schema/pull/223 ), Add choice for multiple auc:WallIDs within auc:Side
- Merged [#224]( https://github.com/BuildingSync/schema/pull/224 ), Add auc:NumberOfSides to auc:Section
- Merged [#225]( https://github.com/BuildingSync/schema/pull/225 ), Add Air/WaterInfiltrationNotes to Air/WaterInfiltrationSystem
- Merged [#226]( https://github.com/BuildingSync/schema/pull/226 ), Add Air/WaterInfiltrationNotes to Air/WaterInfiltrationSystem
- Merged [#227]( https://github.com/BuildingSync/schema/pull/227 ), Add DeliveryCondition to Delivery
- Merged [#228]( https://github.com/BuildingSync/schema/pull/228 ), Add None enum to ReheatSource
- Merged [#229]( https://github.com/BuildingSync/schema/pull/229 ), Add None enum to AirSideEconomizerType
- Merged [#231]( https://github.com/BuildingSync/schema/pull/231 ), Add choice for multiple auc:DoorIDs in auc:Side
- Merged [#232]( https://github.com/BuildingSync/schema/pull/232 ), Add choice for multiple auc:WindowIDs in auc:Side
- Merged [#237]( https://github.com/BuildingSync/schema/pull/237 ), Add Condition and Notes elements for auc:DomesticHotWaterSystem
- Merged [#238]( https://github.com/BuildingSync/schema/pull/238 ), Add LightingAutomationSystem to Building and LightingSystem
- Merged [#239]( https://github.com/BuildingSync/schema/pull/239 ), Add ConveyanceSystemCondition to ConveyanceSystem
- Merged [#240]( https://github.com/BuildingSync/schema/pull/240 ), Add None enum to WaterSideEconomizerType
- Merged [#241]( https://github.com/BuildingSync/schema/pull/241 ), Add capacity to condenser plant types
- Merged [#242]( https://github.com/BuildingSync/schema/pull/242 ), Change OutputCapacity for HeatingSource and HeatingPlant types
- Merged [#243]( https://github.com/BuildingSync/schema/pull/243 ), Add OverallDoorToWallRatio to Building
- Merged [#244]( https://github.com/BuildingSync/schema/pull/244 ), Add EIA ID to Utility
- Merged [#245]( https://github.com/BuildingSync/schema/pull/245 ), Add IntervalDuration and IntervalDurationUnits to TimeSeries
- Merged [#246]( https://github.com/BuildingSync/schema/pull/246 ), Add PeakType to TimeSeries
- Merged [#247]( https://github.com/BuildingSync/schema/pull/247 ), Add Load factor enum to ReadingType
- Merged [#248]( https://github.com/BuildingSync/schema/pull/248 ), Add MeterID and ParentResourceUseID to ResourceUse
- Merged [#250]( https://github.com/BuildingSync/schema/pull/250 ), Add NonquantifiableFactors to PackageOfMeasures

## Version 2.1.0

BuildingSync Version 2.1.0 does not introduce any breaking changes; however, the `version` attribute is now required 
as part of the root `BuildingSync` element. Version 2.1.0 includes many validation updates and additions
to support reporting auditing data. Also, the release versions now include the patch version (e.g., 
major.minor.patch).

Date Range: 12/21/19 - 07/30/20


| Category       | Count |
|----------------|-------|
| Controls         | 0  |
| General         | 7  |
| Measures         | 0  |
| Reports         | 0  |
| Systems         | 2  |
| Validation         | 2  |
| Other         | 5  |
| **Total**      | 16 |

| Change Type    | Count |
|----------------|-------|
| Breaking Change         | 0  |
| Non-breaking Change         | 16  |


New Issues: 9 (#177, #183, #184, #187, #189, #195, #197, #198, #210))

Closed Issues: 7
- Closed [#159]( https://github.com/BuildingSync/schema/issues/159 ), Key / Keyref instead of ID / IDRef for limiting scope using Xpaths
- Closed [#160]( https://github.com/BuildingSync/schema/issues/160 ), Create larger test suite with more comprehensive examples. Include different 'levels', then additionally create most typical HVAC systems
- Closed [#177]( https://github.com/BuildingSync/schema/issues/177 ), Validate format of telephone number
- Closed [#184]( https://github.com/BuildingSync/schema/issues/184 ), Add version attribute to BuildingSync element
- Closed [#187]( https://github.com/BuildingSync/schema/issues/187 ), Change ID attributes for following elements to use="required"
- Closed [#189]( https://github.com/BuildingSync/schema/issues/189 ), Add LinkedPremises to FanSystem and MotorSystem
- Closed [#197]( https://github.com/BuildingSync/schema/issues/197 ), Review use of talking about standards within documentation

Accepted Pull Requests: 17
- Merged [#178]( https://github.com/BuildingSync/schema/pull/178 ), Validate format of telephone number
- Merged [#179]( https://github.com/BuildingSync/schema/pull/179 ), Validate format of postal codes.
- Merged [#180]( https://github.com/BuildingSync/schema/pull/180 ), Update Audit Template examples
- Merged [#185]( https://github.com/BuildingSync/schema/pull/185 ), Add EnergyCostIndex element
- Merged [#186]( https://github.com/BuildingSync/schema/pull/186 ), Add BRICR example generated by Audit Template
- Merged [#188]( https://github.com/BuildingSync/schema/pull/188 ), Feat/canadian provinces
- Merged [#192]( https://github.com/BuildingSync/schema/pull/192 ), add LinkedPremises to FanSystem and MotorSystem
- Merged [#193]( https://github.com/BuildingSync/schema/pull/193 ), feat/require IDs on all elements with an ID attribute
- Merged [#194]( https://github.com/BuildingSync/schema/pull/194 ), feat/require version attribute with semantic versioning restriction
- Merged [#196]( https://github.com/BuildingSync/schema/pull/196 ), update OccupantQuantityType enumerations with definitions
- Merged [#199]( https://github.com/BuildingSync/schema/pull/199 ), update PrimaryHVACSystemType enumerations in line with AT tool
- Merged [#201]( https://github.com/BuildingSync/schema/pull/201 ), use BEDES term for referring to ASHRAE 211
- Merged [#202]( https://github.com/BuildingSync/schema/pull/202 ), feat/add OriginalOccupancyClassification element to Section
- Merged [#209]( https://github.com/BuildingSync/schema/pull/209 ), Update annotations for consistency

## Version 2.0

Official release of BuildingSync Version 2.0.
 
Date Range: 02/01/19 - 12/20/19:

Closed Issues: 6
- Closed [#153]( https://github.com/BuildingSync/schema/issues/153 ), Daylighting setpoint needs to be footcandles (IP units)
- Closed [#171]( https://github.com/BuildingSync/schema/issues/171 ), 2x Typos in 'Virtual' definition
- Closed [#135]( https://github.com/BuildingSync/schema/issues/135 ), Bound 0-100 Percentages
- Closed [#152]( https://github.com/BuildingSync/schema/issues/152 ), Support arbitrary scores and ratings
- Closed [#73]( https://github.com/BuildingSync/schema/issues/73 ), Fractions and percentages appear to be unevenly implemented
- Closed [#117]( https://github.com/BuildingSync/schema/issues/117 ), Typo in definition of "CoolRoof" element


Accepted Pull Requests: 70
- Merged [#169]( https://github.com/BuildingSync/schema/pull/169 ), Modify DaylightingIlluminanceSetpoint units
- Merged [#174]( https://github.com/BuildingSync/schema/pull/174 ), PrimaryHVACSystemType and PrimaryLightingSystemType
- Merged [#175]( https://github.com/BuildingSync/schema/pull/175 ), Fix spelling errors in documentation for SectionType element
- Merged [#155]( https://github.com/BuildingSync/schema/pull/155 ), Fix capitalization - Prefix 'Yearof' should be 'YearOf'
- Merged [#157]( https://github.com/BuildingSync/schema/pull/157 ), Add missing @type attribute to 'Other' element in schema for 'DeliveryType' element.
- Merged [#158]( https://github.com/BuildingSync/schema/pull/158 ), Pluralize `auc:ControlSystemType` element for plants
- Merged [#161]( https://github.com/BuildingSync/schema/pull/161 ), Add <auc:MeasureName> enumeration to <auc:TechnologyCategory> element for 'BuildingEnvelopeModifications'.
- Merged [#162]( https://github.com/BuildingSync/schema/pull/162 ), Bound percentages
- Merged [#163]( https://github.com/BuildingSync/schema/pull/163 ), Add BenchmarkValue element
- Merged [#164]( https://github.com/BuildingSync/schema/pull/164 ), Add LinkedPremises child element to Benchmark element.
- Merged [#79]( https://github.com/BuildingSync/schema/pull/79 ), Add Address to Building Element
- Merged [#80]( https://github.com/BuildingSync/schema/pull/80 ), Add ID to Report and Qualification
- Merged [#81]( https://github.com/BuildingSync/schema/pull/81 ), Update Ownership Enumerations
- Merged [#82]( https://github.com/BuildingSync/schema/pull/82 ), Update Linear Fluorescent Enumerations
- Merged [#83]( https://github.com/BuildingSync/schema/pull/83 ), Enable Multiple Reports
- Merged [#84]( https://github.com/BuildingSync/schema/pull/84 ), Add AuditorQualificationType Enumerations
- Merged [#85]( https://github.com/BuildingSync/schema/pull/85 ), Add Blue Roof
- Merged [#86]( https://github.com/BuildingSync/schema/pull/86 ), Consolidate MELs and Plug Loads
- Merged [#87]( https://github.com/BuildingSync/schema/pull/87 ), Allow None for FenestrationGasFill Enumeration
- Merged [#88]( https://github.com/BuildingSync/schema/pull/88 ), Add ContactRoles Container and Submitter Enum
- Merged [#90]( https://github.com/BuildingSync/schema/pull/90 ), Add UDF to CondenserPlant
- Merged [#91]( https://github.com/BuildingSync/schema/pull/91 ), Add YearInstalled to Plant Elements
- Merged [#92]( https://github.com/BuildingSync/schema/pull/92 ), Add YearBurnerInstalled
- Merged [#93]( https://github.com/BuildingSync/schema/pull/93 ), New TerminalUnit Enumerations
- Merged [#94]( https://github.com/BuildingSync/schema/pull/94 ), Multiple Audit Dates in Report
- Merged [#95]( https://github.com/BuildingSync/schema/pull/95 ), AirInfiltrationSystem ID, UDF on Package of Measures, enums on GenerationTechnology, OccupancyClassification, and PlugLoadType
- Merged [#96]( https://github.com/BuildingSync/schema/pull/96 ), Move Miscellaneous Gas Loads under ProcessLoad
- Merged [#97]( https://github.com/BuildingSync/schema/pull/97 ), Update casing of OnSite to Onsite
- Merged [#98]( https://github.com/BuildingSync/schema/pull/98 ), Package of Measures ID
- Merged [#99]( https://github.com/BuildingSync/schema/pull/99 ), VentilationType Enum and VentilationControlMethods
- Merged [#101]( https://github.com/BuildingSync/schema/pull/101 ), FanBased Optional
- Merged [#102]( https://github.com/BuildingSync/schema/pull/102 ), Add WeatherDataType, SimulationCompletionStatus, CalculationMethod, CustomMeasureName, AnnualPeakNativeUnits, and AnnualPeakConsistentUnits
- Merged [#103]( https://github.com/BuildingSync/schema/pull/103 ), Location Elements on Plants/Sources
- Merged [#104]( https://github.com/BuildingSync/schema/pull/104 ), Add FootprintShape to BuildingType
- Merged [#105]( https://github.com/BuildingSync/schema/pull/105 ), Ballast type enumeration values
- Merged [#106]( https://github.com/BuildingSync/schema/pull/106 ), Scenario notes
- Merged [#109]( https://github.com/BuildingSync/schema/pull/109 ), Add <auc:RoofCondition> element to <auc:RoofID> element
- Merged [#110]( https://github.com/BuildingSync/schema/pull/110 ), Add "None" value to <auc:ControlTechnology> enumeration
- Merged [#111]( https://github.com/BuildingSync/schema/pull/111 ), Add <auc:PrimaryFuel> Element to Plants
- Merged [#114]( https://github.com/BuildingSync/schema/pull/114 ), Enable Multiple Special Roof Classifications
- Merged [#115]( https://github.com/BuildingSync/schema/pull/115 ), Rename Subsection to Section
- Merged [#116]( https://github.com/BuildingSync/schema/pull/116 ), Enable multiple roofs, ceilings, and foundations
- Merged [#118]( https://github.com/BuildingSync/schema/pull/118 ), Fix coolroof name
- Merged [#120]( https://github.com/BuildingSync/schema/pull/120 ), Refactor Controls
- Merged [#121]( https://github.com/BuildingSync/schema/pull/121 ), General: Annotations and Version Tag
- Merged [#122]( https://github.com/BuildingSync/schema/pull/122 ), MeasureScaleOfApplication - Add Enumerations
- Merged [#123]( https://github.com/BuildingSync/schema/pull/123 ), Add AuditorQualificationType enumerations
- Merged [#124]( https://github.com/BuildingSync/schema/pull/124 ), Add EfficiencyUnits enumerations
- Merged [#125]( https://github.com/BuildingSync/schema/pull/125 ), Add FuelTypes enumerations for "Fuel oil no 5 and 6"
- Merged [#126]( https://github.com/BuildingSync/schema/pull/126 ), Add FuelTypes enumerations
- Merged [#127]( https://github.com/BuildingSync/schema/pull/127 ), Add ElectricResistance to HeatingSourceType
- Merged [#128]( https://github.com/BuildingSync/schema/pull/128 ), Pluralize LinkedDeliveryID
- Merged [#129]( https://github.com/BuildingSync/schema/pull/129 ), Add OccupancyClassification enumerations
- Merged [#130]( https://github.com/BuildingSync/schema/pull/130 ), Rename ProcessGasElecLoadType element
- Merged [#131]( https://github.com/BuildingSync/schema/pull/131 ), Remove Trailing Whitespace from Laboratory
- Merged [#132]( https://github.com/BuildingSync/schema/pull/132 ), CondensingOperation - Add Enumerations
- Merged [#133]( https://github.com/BuildingSync/schema/pull/133 ), Modify capitalization of term "Timestamp"
- Merged [#134]( https://github.com/BuildingSync/schema/pull/134 ), DraftBoundary - Add Enumerations
- Merged [#136]( https://github.com/BuildingSync/schema/pull/136 ), Add <xs:complexType> child element to definition of "Pneumatic" element
- Merged [#137]( https://github.com/BuildingSync/schema/pull/137 ), Add FuelType enumerations
- Merged [#138]( https://github.com/BuildingSync/schema/pull/138 ), Add CondensingOperation and DraftBoundary elements wherever DraftType
- Merged [#139]( https://github.com/BuildingSync/schema/pull/139 ), Add Gas Engine Enumeration to Chiller Compressor Driver
- Merged [#140]( https://github.com/BuildingSync/schema/pull/140 ), Add Percent Leased by Owner to Building
- Merged [#141]( https://github.com/BuildingSync/schema/pull/141 ), Add Spatial Unit Occupied Percentage
- Merged [#142]( https://github.com/BuildingSync/schema/pull/142 ), Fix "Dual fuel" typo
- Merged [#144]( https://github.com/BuildingSync/schema/pull/144 ), Pluralize and rename PrimaryHVACControlSystemType Element to HVACControlSystemType
- Merged [#145]( https://github.com/BuildingSync/schema/pull/145 ), Replicate Site Elements in Building Element
- Merged [#146]( https://github.com/BuildingSync/schema/pull/146 ), Add ExteriorFloorSystemType Element
- Merged [#147]( https://github.com/BuildingSync/schema/pull/147 ), Harmonize Tightness and TightnessFitCondition elements
- Merged [#148]( https://github.com/BuildingSync/schema/pull/148 ), Remove minOccurs="1" constraint for auc:AllResourceTotal element


## Version 1.0

Date Range: 05/31/18 - 01/31/19:

Schema Related Changes:
- Merged [#53]( https://github.com/BuildingSync/schema/pull/53 ), Spaces (not tabs). JSON schema
- Merged [#56]( https://github.com/BuildingSync/schema/pull/56 ), Remove Double Dash in Annotations
- Merged [#57]( https://github.com/BuildingSync/schema/pull/57 ), Change Representation of Zone Equipment
- Merged [#58]( https://github.com/BuildingSync/schema/pull/58 ), Add Program Identifier to Support Other Projects
- Merged [#59]( https://github.com/BuildingSync/schema/pull/59 ), Harmonize definitions of `PremisesAffected` and `LinkedPremises`
- Merged [#63]( https://github.com/BuildingSync/schema/pull/63 ), Add UBID
- Merged [#64]( https://github.com/BuildingSync/schema/pull/64 ), Rename root element to BuildingSync/Facilities
- Merged [#65]( https://github.com/BuildingSync/schema/pull/65 ), Ensure all “IDREF” instances in BuildingSync.xsd are consistent and W3C compliant
- Merges [#67]( https://github.com/BuildingSync/schema/pull/67 ), Ensure adequate containerization of lists
- Merged [#68]( https://github.com/BuildingSync/schema/pull/68 ), Update the list of qualified auditors

Other Changes:
- Merged [#47]( https://github.com/BuildingSync/schema/issues/47 ), Formal process for using the issue feature for requesting extensions to BuildingSync
- Merged [#51]( https://github.com/BuildingSync/schema/pull/51 ), Feature Proposal Procedure
- Merged [#61]( https://github.com/BuildingSync/schema/pull/61 ), Add Golden Test File


## Version 0.3

- Merged [#12]( https://github.com/BuildingSync/schema/pull/12 ), Removed SpaceID from Sides, since it's redundant with what's defined in thermal zone. (KMFM, per PNNL)
- Merged [#13]( https://github.com/BuildingSync/schema/pull/13 ), Add New CTS Example
- Merged [#14]( https://github.com/BuildingSync/schema/pull/14 ), Changed cooling tower control to separate types - fan, temperature, and cell. (KMFM, per PNNL)
- Merged [#15]( https://github.com/BuildingSync/schema/pull/15 ), Updates based on revisions in BEDES Version 2.0
- Merged [#23]( https://github.com/BuildingSync/schema/pull/23 ), Added user defined fields to Heating-Source and Cooling-Source in HVAC
- Merged [#25]( https://github.com/BuildingSync/schema/pull/25 ), Change Heating Plant Type
- Merged [#26]( https://github.com/BuildingSync/schema/pull/26 ), Burner Additions
- Merged [#27]( https://github.com/BuildingSync/schema/pull/27 ), Equipment Condition
- Merged [#28]( https://github.com/BuildingSync/schema/pull/28 ), Add Annual Peak Reduction Element
- Merged [#30]( https://github.com/BuildingSync/schema/pull/30 ), Add COP to SHW units
- Merged [#31]( https://github.com/BuildingSync/schema/pull/31 ), Initial Multi-Tenant Support
- Merged [#32]( https://github.com/BuildingSync/schema/pull/32 ), Move Utility and Use References
- Merged [#33]( https://github.com/BuildingSync/schema/pull/33 ), Remove unbounded from auc:PremisesIdentifiers.
- Merged [#34]( https://github.com/BuildingSync/schema/pull/34 ), ECM categories and enumerations
- Merged [#35]( https://github.com/BuildingSync/schema/pull/35 ), Common_tenant_area
- Merged [#36]( https://github.com/BuildingSync/schema/pull/36 ), Fix example file failure
- Merged [#37]( https://github.com/BuildingSync/schema/pull/37 ), Feature/fix undefined xsd attributes and elements
- Merged [#46]( https://github.com/BuildingSync/schema/pull/46 ), Update license
- Merged [#49]( https://github.com/BuildingSync/schema/pull/49 ), Add a Sharing Example
- Merged [#50]( https://github.com/BuildingSync/schema/pull/50 ), Add FloorAreas to LinkedPremises

Specific changes:

* "Public housing" added to OccupancyClassification
* Added several new "ContactRole" options to enumeration, and dropped "Finance Specialist"
* Added ContactTitle as a new element
* Changed enumeration for OperatorType to match BEDES 2.0
* "Fair" dropped from DuctInsulationCondition
* RoofExteriorSolarReflectanceIndex was added as a new element
* "Wind" was added to the enumeration for OtherEnergyGenerationTechnology
* MeasureInstallationCost and MeasureMaterialCost were added as elements of measure costs.
* Several new options for CostEffectivenessScreeningMethod were added.
* Several new choices under TypeOfRateStructure were added. Detailed information was not, because they are really just subtypes of Tiered Rate, and if details are important they should be entered there.
* NOx and SO2 were added as options under EmissionsType.
* Pluralize MeasureIDs under PackageOfMeasure Reporting Scenario
* Pluralize TechnologyCategory to TechnologyCategories

## Version 0.2

Version 0.2 changes are listed below. The big change for 0.2 was the resetting of the version number from 2.0 to 0.2.

#### 3/22/2016 
* Hendron changed Space element to unconstrained.

#### 2/24/2016-3/2/2016 Hendron - BEDES V1.2 updates
* DefrostType renamed to DefrostingType and enumeration was updated
* Updated enumerations slightly for DishwasherMachineType and DishwasherConfiguration to match BEDES
* Updated enumeration slightly for WasherDryerType to match BEDES
* Added "Backup" to PumpingConfiguration
* Added "Water to air heat exchanger" and "Water to water heat exchanger" to HeatRecoveryType
* Updated enumeration for EnvelopeConstructionType to remove hyphens
* Updated enumeration for ExteriorWallFinish, RoofFinish, CeilingFinish
* Added "Reflective" to enumeration for ExteriorWallColor, RoofColor
* Removed hyphens from enumeration for WallInsulationApplication, RoofInsulationApplication, CeilingInsulationApplication
* Updated enumeration for InsulationMaterialType
* Shortened definition of WallFramingSpacing, RoofFramingSpacing
* Updated enumeration for AirInfiltrationValueUnits
* Updated enumeration for RoofSlope
* Updated punctuation in enumeration for GlassType, FenestrationGlassLayers, FenestrationFrameMaterial
* Updated enumeration for ExteriorShadingType to include trees and buildings
* Updated enumeration for SkylightWindowTreatments to match BEDES Shading System options
* Renamed CrawlspaceVenting options to match BEDES terminology (ventilated vs vented)
* Updated BasementConditioning options
* Added Linoleum to FloorCovering enumeration
* Moved FloorConstructionType to the main FoundationType level from the vented crawlspace
* Removed Combination from enumeration for FoundationWallInsulationCondition
* Added FoundationWallUFactor element for basements and unvented crawlspaces
* Renamed Set Top Box under PlugLoadType to match BEDES
* Deleted Motor from ProcessLoadType enumeration because there is a separate category for motor data
* Replaced stand-alone DutyCycle element with the global element DutyCycle under ProcessLoadType
* Updated enumeration for PhotovoltaicSystemLocation, changing Ground to On Grade and deleting hyphen
* Updated punctuation for ExternalPowerSupply
* Deleted acronyms and updated punctuation in enumeration for EnergyStorageTechnology
* Deleted fountains, etc., from PoolType because there is a separate category for water used in landscaping features
* Changed Indoors and Outdoors to Interior and Exterior in enumeration for Location to match BEDES
* Updated punctuation in enumeration for FuelTypes and deleted Combination
* Updated enumeration for CapacityUnits
* Added values to enumeration for Source
* Renamed ModificationRetrocommissioning to Modification to allow clean mapping to BEDES
* Deleted hyphens in enumeration for WeatherDataSource
* Changed name of Simulated element to Modeled to match BEDES terminology.
* Added enumeration to CodeName matching BEDES, except 189.1 because ASHRAE was already in the list. Previously it was free text. A new element CodeVersion was added as free text to allow more specific definition of the relevant code or standard.
* Removed hyphens from EndUse enumeration and aligned several options with BEDES. The "Whole building" option in BuildingSync was changed to "All end uses", because the associated premises are defined in a separate element, and it may be less than the whole building.
* Changed EnergyResource enumeration to global type FuelType 
* Deleted acronyms and updated punctuation in enumeration for CostEffectivenessScreeningMethod
* Corrected definition of PercentResource
* Updated enumeration for ResourceUnits
* Updated definition of FixedMonthlyCharge
* Updated enumeration for MeteringConfiguration
* Updated enumeration for SharedResourceSystem but corrected a typo in BEDES ("buildings" vs "building")
* Updated enumeration for EmissionsFactorSource
* Hyphens removed from TimeSeriesReadingQuantity
* Updated enumeration for IntervalFrequency
* Updated enumeration for AuditorQualificationType
* Deleted AuditTeamMemberCertificationType because it's fairly redundant.


#### 2/23/2016-3/2/2016 Hendron - Minor cleanup
* Changed definition of Story element under Subsection to "The story of the given subsection." 
* Made FacilityClassification optional
* Capitalized "facility"
* Deleted SpecialCeilingClassification (other cleanup of ceiling/roof split is needed to remove redundancies)
* Deleted RoofVisibleAbsorptance, because this is only important as a ceiling property
* Deleted DeckType, CeilingSlope, RadiantBarrier, CeilingExteriorSolarAbsorptance, CeilingExteriorThermalAbsorptance from CeilingSystemType because they are more appropriate as roof attributes
* Renamed all CeilingInsulation elements to have "Ceiling" modifier instead of "Roof"
* Added references to CeilingID, CeilingArea, and CeilingInsulatedArea under Subsection, and redistributed relevant elements from under RoofID
* Split Ceiling and Roof under SystemCategoryAffected
* Dropped Not Discarded from enumeration for DiscardReason. The existence of the element implies that the measure was discarded.
* Added WeatherDataSource element under AdjustedToYear. Appears to have been an oversight.
* Copied AnnualDemandSavingsCost from MeasureType to PackageOfMeasures for consistency
* Updated definition of NetMetering because it is no longer a boolean.
* Fixed error in datatype for ApplicableStartTimeForEnergyRate, ApplicableEndTimeForEnergyRate, ApplicableStartTimeForDemandRate, and ApplicableEndTimeForDemandRate (from date to time)
* DaylitFloorArea (added recently by NREL) was deleted as a separate element. "Daylit" was already an option for FloorAreaType, so it was redundant.
* Added "Mixed use commercial" and "Other" to enumeration for FacilityClassification
* Renamed CommercialFacility global type to Facility for consistency.

##### 11/20/2015 - 12/10/2015

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
* Remove Blocks. Make subsections contain multiple ThermalZones and each ThermalZone can have multiple Spaces.
* Add Country to Address
* Add FloorsAboveGrade and FloorsBelowGrade to the Facility 
* Add Story to FloorArea Type
* Add AssemblyType to Windows and Skylights (double hung, curb mounted, etc)
* Add Space->Daylit Area
* Add Story to subsection
* Add WallInsulationRValue to WallInsulation
* Add another level for WallInsulations in WallSystems
* Rename CommercialFacility to Facility and add enum to specify the facility type
* Break out ceiling system from RoofCeilingSystem


## Version 2.0 - Legacy

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


## BuildingSync v1.0 - Legacy

##### 2014-10-13

* First release
