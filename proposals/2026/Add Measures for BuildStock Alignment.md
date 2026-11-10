# Add Measures for BuildStock Alignment

## Overview

Address [issue #287, Add Measures](https://github.com/BuildingSync/schema/issues/287) by aligning BuildingSync `MeasureName` enumerations with the retrofit upgrades modeled in BuildStock (NREL's [ComStock][comstock-readme] and [ResStock][resstock-readme]) and other typical building energy modeling (BEM) workflows.

The goal is that, after implementation, every BuildStock upgrade measure maps to **one BuildingSync measure enumeration, or a `PackageOfMeasures` of several enumerations**. This proposal:

1. Adds eleven `MeasureName` enumerations where no existing value gives a clear mapping (all non-breaking).
2. Publishes a non-normative crosswalk (Appendix A) from BuildStock upgrades to BuildingSync measures, reviewed as of 2026-11-03.
3. Designates [BOSS][boss-readme] (BuildingSync OpenStudio Simulator) as the downstream workflow that consumes and maintains the crosswalk.

The crosswalk is **informative, not a BuildingSync requirement**. A BuildingSync document is valid and complete without any BuildStock reference, and a measure name alone is not an executable simulation specification.

## Justification

### The issue

Issue #287 lists `Replace HVAC system type to VRF` and `Replace HVAC system type to PZHP` as custom measures in the former BuildingSync-gem. `PZHP` is read as **PSZ-HP**, the packaged single-zone heat pump system of ASHRAE 90.1 Appendix G and openstudio-standards. `PZHP` is not an established system abbreviation, whereas BuildingSync-gem built HVAC systems with openstudio-standards, whose standard system names include both PSZ-HP and VRF. Since the issue pairs PZHP with VRF as replacement system types, PSZ-HP is the only consistent reading. VRF is already covered by `Install variable refrigerant flow system`; PSZ-HP is not. The broader request is for standard measure names that map to simulation workflows rather than relying on `Other` plus free text.

### Gap analysis

Every `MeasureName` enumeration in schema revision `e24c54cd7e2ebf6c222881089b2b092f839f5cc5` (329 values across 29 technology categories) was compared with the BuildStock upgrade inventories in Appendix A. Most upgrades already map cleanly (Appendix A, "Existing" rows). The following do not:

| BuildStock upgrade(s)                                                                          | Closest existing value                                            | Why it is not a clear mapping                                                                                     |
| ---------------------------------------------------------------------------------------------- | ----------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| ComStock heat-pump RTU (`upgrade_hvac_add_heat_pump_rtu`); PSZ-HP                              | `Install air source heat pump`; `Replace package units`           | Cannot distinguish a packaged rooftop heat pump from split or terminal heat pumps, or from a like-for-like RTU.   |
| ComStock air-to-water heat pump replacing a boiler (`upgrade_hvac_replace_boiler_by_heatpump`) | `Replace boiler`                                                  | Implies a new boiler; the technology is a heat pump.                                                              |
| ComStock DOAS with heat-pump mini-splits; VRF with DOAS                                        | none                                                              | No value for adding a dedicated outdoor air system.                                                               |
| ComStock electric kitchen equipment; ResStock induction/electric range                         | `Replace with ENERGY STAR-qualified steam cookers...` and similar | Existing kitchen values are water-focused or efficiency-only; none expresses fuel switching of cooking equipment. |
| ResStock furnace upgrades (95% AFUE, minimum-efficiency furnaces)                              | `Replace burner`                                                  | A burner is a component; no value replaces a furnace.                                                             |
| ResStock minimum-efficiency air conditioners                                                   | `Replace package units`                                           | No value replaces a split-system air conditioner.                                                                 |
| ComStock `upgrade_df_load_shed`; ResStock HVAC on-peak load shedding                           | `Upgrade operating protocols...`                                  | No value describes demand-response load shedding.                                                                 |
| ComStock `upgrade_df_thermostat_control_load_shift`; ResStock pre-peak load shifting           | `Install thermal energy storage`                                  | Pre-conditioning shifts load without storage equipment.                                                           |
| ResStock EV charging with demand flexibility                                                   | none                                                              | No value for managed EV charging.                                                                                 |
| ResStock EV adoption with Level 1 / Level 2 charging                                           | none                                                              | No value for installing EV charging equipment.                                                                    |
| ComStock `upgrade_add_thermostat_setback`; residential setback/smart thermostat                | `Add or upgrade controls`                                         | Too broad to distinguish a setback schedule from any other control upgrade.                                       |

`Other` with a `CustomMeasureName` can carry each of these today, but free text does not aggregate across producers, and use cases such as ASHRAE L100 then require extra custom names. A small set of tool-neutral values fixes this without copying study-specific labels into the schema.

### Principles for the mapping

- **Technology, not study label.** Enumerations describe a physical or operational intervention. Efficiency levels, performance curves, backup-fuel choices, sizing rules and study names belong in linked system records, `CustomMeasureName`, `LongDescription`, or the crosswalk.
- **One BuildStock upgrade maps to one value or a package.** Bundled upgrades (e.g. ComStock "Package 1-5", ResStock envelope + heat pump packages) map to `ScenarioType/PackageOfMeasures/MeasureIDs` referencing several measures.
- **Reuse before adding.** New values are added only where Appendix A finds no clear existing value.
- **Bundled options are separate measures.** For example, ComStock's heat-pump RTU measure can also add energy recovery, DCV, economizer and setback changes (`modify_setbacks` defaults to `true` as of 2026-11-03). Each enabled option maps to its own existing BuildingSync measure in the package.

### PSZ-HP and heat-pump RTU decision

`PrincipalHVACSystemType = Packaged Rooftop Heat Pump` already exists, and the [buildingsync-measures-gem Modify HVAC guidance][modify-hvac] maps it to the openstudio-standards PSZ-HP system. ComStock's heat-pump RTU upgrade targets packaged single-zone systems. The new measure is therefore named `Install packaged rooftop heat pump`, matching the system-type value, and its documentation names PSZ-HP and HP RTU as equivalent simulation terms. ComStock scenarios (`hprtu_scenario` = `two_speed_standard_eff`, `two_speed_lab_data`, `variable_speed_high_eff`, `cchpc_2027_spec`) and backup-fuel options are crosswalk parameters, not separate enumerations.

### Alternatives not proposed

- **One enumeration per BuildStock upgrade:** rejected. Upgrade names, scenarios and packages change between releases and mix several technologies.
- **A `BuildStock` technology category or study-name attribute:** rejected. The schema stays tool-neutral.
- **Making the crosswalk normative (XSD or Schematron):** rejected. BuildStock releases follow their own schedule; binding them to BuildingSync versions would force schema releases for tool changes.
- **A typed executable-measure/argument structure in XML:** deferred until the BOSS crosswalk pilot shows `LinkedFiles`, `CustomMeasureName` and `UserDefinedFields` are insufficient.

## Implementation

### 1. XSD changes (non-breaking, MINOR)

Add the following `xs:enumeration` values, each with `xs:annotation/xs:documentation`, to the existing inline `MeasureName` restrictions under `/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Measures/auc:Measure/auc:TechnologyCategories/auc:TechnologyCategory/auc:<Category>/auc:MeasureName`. Insert each new value before the category's `Clean and/or repair`/`Other` entries unless a position is given.

| #   | Category                            | New enumeration value                                 | Position                                                                                    | Documentation text                                                                                                                                                                                                                                                                                                                                                                                                                   |
| --- | ----------------------------------- | ----------------------------------------------------- | ------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| 1   | `OtherHVAC`                         | `Install packaged rooftop heat pump`                  | After `Install air source heat pump` ([L4126](../../BuildingSync.xsd#L4126))                | Installation of a factory-assembled, air-source rooftop heat pump providing space heating and cooling, including replacement of existing equipment. Corresponds to the packaged single-zone heat pump (PSZ-HP) system type and to heat pump rooftop unit (HP RTU) retrofits. Excludes packaged terminal, split, and ground-source heat pumps. Does not specify efficiency, compressor staging, backup heat, or ventilation controls. |
| 2   | `OtherHVAC`                         | `Install dedicated outdoor air system`                | After #1                                                                                    | Installation of a dedicated outdoor air system (DOAS) that conditions ventilation air separately from the zone heating and cooling equipment. Pair with the zone-equipment measure (for example, variable refrigerant flow or heat pump) when both are installed.                                                                                                                                                                    |
| 3   | `OtherHVAC`                         | `Replace furnace`                                     | After `Replace burner` ([L4113](../../BuildingSync.xsd#L4113))                              | Replacement of a warm-air furnace with a new furnace of any fuel. Use a heat pump measure instead when the furnace is replaced by a heat pump.                                                                                                                                                                                                                                                                                       |
| 4   | `OtherHVAC`                         | `Replace split-system air conditioner`                | After #3                                                                                    | Replacement of a split-system (central or ductless) air conditioner with a new air conditioner. Use a heat pump measure instead when the replacement also provides heating.                                                                                                                                                                                                                                                          |
| 5   | `BoilerPlantImprovements`           | `Replace boiler with air-to-water heat pump`          | After `Replace boiler` ([L4009](../../BuildingSync.xsd#L4009))                              | Replacement or supplementation of a hot-water boiler with an air-to-water heat pump serving the hydronic heating system. Backup heat source and supply temperature are specified separately.                                                                                                                                                                                                                                         |
| 6   | `KitchenImprovements`               | `Replace fossil-fuel cooking equipment with electric` | After `Install steam kettle with condensate return` ([L4682](../../BuildingSync.xsd#L4682)) | Replacement of gas or propane cooking equipment (ranges, ovens, fryers, griddles, and similar) with electric or induction equipment, in commercial or residential kitchens.                                                                                                                                                                                                                                                          |
| 7   | `ElectricalPeakShavingLoadShifting` | `Implement HVAC load shedding`                        | After `Install thermal energy storage` ([L4493](../../BuildingSync.xsd#L4493))              | Temporary reduction of HVAC electric demand during peak or grid-event periods, for example by thermostat setpoint offsets, without shifting the load to another period.                                                                                                                                                                                                                                                              |
| 8   | `ElectricalPeakShavingLoadShifting` | `Implement HVAC load shifting`                        | After #7                                                                                    | Shifting of HVAC electric demand away from peak periods using building thermal mass, for example by pre-cooling or pre-heating before the peak period. Use `Install thermal energy storage` when dedicated storage equipment is installed.                                                                                                                                                                                           |
| 9   | `ElectricalPeakShavingLoadShifting` | `Implement managed electric vehicle charging`         | After #8                                                                                    | Scheduling or curtailment of electric vehicle charging to reduce or shift peak electric demand.                                                                                                                                                                                                                                                                                                                                      |
| 10  | `EnergyDistributionSystems`         | `Install electric vehicle charging equipment`         | After `Upgrade transformers` ([L4400](../../BuildingSync.xsd#L4400))                        | Installation of electric vehicle supply equipment. The charger level and number of ports are specified separately.                                                                                                                                                                                                                                                                                                                   |
| 11  | `BuildingAutomationSystems`         | `Implement thermostat setback and setup schedules`    | After `Add or upgrade controls` ([L4083](../../BuildingSync.xsd#L4083))                     | Implementation or deepening of unoccupied-period heating setback and cooling setup, by schedule or by a programmable or smart thermostat.                                                                                                                                                                                                                                                                                            |

(Eleven values: the gap table's demand-flexibility row is split into shed, shift and EV management.)

No element, attribute, global type, cardinality, sequence, or IDref changes. No existing enumeration is removed, renamed, deprecated, or reinterpreted. Historical documents remain valid, so this is **non-breaking (MINOR)**; no migration script is needed. Documents using a new value require the updated schema. Implementation PR labels: `Non-breaking Change` and `Schema: Measures`. The implementing PR may be split by category if maintainers prefer one change per PR.

### 2. Reuse of existing structure

- `TypeOfMeasure/Replacements/Replacement` (`ExistingSystemReplaced`, `AlternativeSystemReplacement`) or `Additions/Addition` link the existing and proposed systems; the proposed system carries type, efficiency and capacity (for example `PrincipalHVACSystemType = Packaged Rooftop Heat Pump`, `Status = Proposed`).
- `LinkedPremises` and `MeasureScaleOfApplication` give scope; `CustomMeasureName` can hold the BuildStock upgrade name; `LongDescription` holds assumptions.
- `ScenarioType/PackageOfMeasures/MeasureIDs` groups measures for packaged upgrades. Package membership does not define execution order.
- `Measure/LinkedFiles` can reference a workflow file (for example an OSW) for reproducible execution. Consumers must not automatically download or execute referenced code.

### 3. Crosswalk status and BOSS

- Appendix A reflects the BuildStock measures as reviewed on **2026-11-03** and is not pinned to a BuildStock release or revision. ComStock's measure set mixes upgrades introduced across its 2023-2025 releases, and ResStock does not publish a single stable upgrade list, so a release pin would be neither accurate nor durable. Sources reviewed: ComStock [`resources/measures`][comstock-measures] (upgrade names from `ymls/national.yml`) and ResStock project upgrade definitions (`project_national`).
- The crosswalk is maintained here as informative guidance only. It is not part of the XSD, the data dictionary, or any use case, and BuildingSync releases do not wait on BuildStock releases.
- **BOSS** is the reference consumer. Proposed BOSS follow-up (requires separate approval; no BOSS changes or issues have been made):
  - Implement recommendation-to-workflow selection keyed on (`TechnologyCategory`, `MeasureName`, linked system type) using Appendix A, citing this proposal as its source.
  - Record the ComStock/ResStock measure source each simulation actually ran (BOSS's [external-measure manifest][boss-manifest] currently uses `ref: main`) so individual results are reproducible; this is a BOSS run record, not a requirement on the crosswalk.
  - Report applicability per measure (applied, not applicable, unsupported, failed); schema validity is not execution success.
  - Keep its machine-readable mapping file in sync with Appendix A; when they diverge, update this proposal's appendix (or a successor doc in `docs/`, if maintainers prefer) and BOSS together.

### 4. Other downstream impact (follow-ups, separate approval)

| Repository                   | Impact                                                                                                                                                            |
| ---------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| BOSS                         | See section 3. The [reader][boss-reader] maps `PrincipalHVACSystemType` for baselines only; new measure names are not yet workflow selectors.                     |
| buildingsync-measures-gem    | [Modify HVAC][modify-hvac] already distinguishes `packaged_rooftop_heat_pump`; check argument mapping for the new HVAC values.                                    |
| use-cases                    | [L100][l100] and [SEED][seed] rules accept any valid `MeasureName`; test an example using new values.                                                             |
| BuildingSync-asset-extractor | The CTS [catalog][cts-catalog] matches exact names; the [parser][cts-parser] drops unmatched names from counts. Map each new value to a CTS bucket and add tests. |
| Website, bsyncpy             | Pick up new enumerations through the normal release process.                                                                                                      |

### 5. Work sequence and acceptance criteria

1. Review the proposal: confirm the eleven values and wording, and the informative status of the crosswalk.
2. Implement the enumerations; add an example with a heat-pump RTU replacement (existing and proposed systems linked) and a package containing several new values.
3. Run `bundle exec rake remove_tabs`, `bundle exec rake`, `bundle exec rake generate_data_dictionary` (do not commit generated artifacts), and pre-commit.
4. Separately, pilot the BOSS crosswalk with at least the heat-pump RTU (two `hprtu_scenario` profiles), boiler-to-heat-pump, and one package; record actual execution outcomes.

## Appendix A. BuildStock to BuildingSync crosswalk (informative)

"New #n" refers to the table in Implementation section 1. "Package" means a `PackageOfMeasures` containing the listed measures. Category abbreviations: HVAC = `OtherHVAC`, Boiler = `BoilerPlantImprovements`, Chiller = `ChillerPlantImprovements`, BAS = `BuildingAutomationSystems`, Env = `BuildingEnvelopeModifications`, Dist = `ChilledWaterHotWaterAndSteamDistributionSystems`, SHW = `ServiceHotWaterSystems`, Light = `LightingImprovements`, RE = `RenewableEnergySystems`, Peak = `ElectricalPeakShavingLoadShifting`, Kitchen = `KitchenImprovements`, Plug = `PlugLoadReductions`, EDS = `EnergyDistributionSystems`.

### A.1 ComStock (reviewed 2026-11-03)

| ComStock measure (published upgrade name)                                           | BuildingSync mapping                                                                                        | Mapping detail                                                                               |
| ----------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------- |
| `upgrade_hvac_add_heat_pump_rtu` (HP RTU E Backup, G Backup, + ER, Std Performance) | HVAC: New #1                                                                                                | `hprtu_scenario`, `backup_ht_fuel_scheme`; + ER adds HVAC `Add energy recovery` as a package |
| `upgrade_hvac_rtu_adv`                                                              | HVAC: `Replace package units`                                                                               | Proposed system efficiency                                                                   |
| `upgrade_advanced_rtu_control` (Advanced RTU Controls)                              | Package: HVAC `Add or repair economizer`, `Install demand control ventilation`, `Improve distribution fans` |                                                                                              |
| `upgrade_hvac_vrf_hr_doas` (VRF with DOAS; 25% upsizing)                            | Package: HVAC `Install variable refrigerant flow system` + New #2                                           | Heat recovery, upsizing in system detail                                                     |
| `upgrade_hvac_doas_hp_minisplits` (DOAS HP Minisplits)                              | Package: New #2 + HVAC `Install air source heat pump`                                                       | Ductless heat pump in system detail                                                          |
| `upgrade_hvac_packaged_gshp` (Packaged GHP)                                         | HVAC: `Replace AC and heating units with ground coupled heat pump systems` (+ DCV, economizer as package)   |                                                                                              |
| `upgrade_hvac_console_gshp` (Console GHP)                                           | HVAC: `Replace AC and heating units with ground coupled heat pump systems`                                  | Console configuration in system detail                                                       |
| `upgrade_hvac_hydronic_gshp` (Hydronic GHP)                                         | HVAC: `Replace AC and heating units with ground coupled heat pump systems`                                  | Water-to-water in system detail                                                              |
| Comprehensive GHP                                                                   | Package of the three GSHP rows                                                                              |                                                                                              |
| `upgrade_hvac_replace_boiler_by_heatpump` (HP Boiler E/G Backup)                    | Boiler: New #5                                                                                              | Backup fuel                                                                                  |
| `upgrade_hvac_condensing_boiler`                                                    | Boiler: `Replace boiler`                                                                                    | Condensing in system detail                                                                  |
| `upgrade_hvac_electric_boiler`                                                      | Boiler: `Replace boiler` (+ `Convert to Cleaner Fuels` if fuel switching is emphasized)                     |                                                                                              |
| `upgrade_hvac_chiller`                                                              | Chiller: `Replace chiller`                                                                                  |                                                                                              |
| `upgrade_hvac_dcv` (DCV)                                                            | HVAC: `Install demand control ventilation`                                                                  |                                                                                              |
| `upgrade_hvac_economizer` (Economizer)                                              | HVAC: `Add or repair economizer`                                                                            |                                                                                              |
| `upgrade_hvac_exhaust_air_energy_or_heat_recovery` (Energy Recovery)                | HVAC: `Add energy recovery`                                                                                 |                                                                                              |
| `upgrade_hvac_fan_static_pressure_reset`                                            | BAS: `Upgrade operating protocols, calibration, and/or sequencing`                                          | Broad mapping (Appendix B)                                                                   |
| `upgrade_hvac_multispeed_minimum_flow`                                              | HVAC: `Improve distribution fans`                                                                           | Broad mapping (Appendix B)                                                                   |
| `upgrade_unoccupied_oa_controls` (Unoccupied AHU Control)                           | BAS: `Upgrade operating protocols, calibration, and/or sequencing`                                          | Broad mapping (Appendix B)                                                                   |
| `upgrade_hvac_pump`                                                                 | Dist: `Replace with higher efficiency pump` or `Replace with variable speed pump`                           |                                                                                              |
| `upgrade_add_thermostat_setback`                                                    | BAS: New #11                                                                                                |                                                                                              |
| `upgrade_df_load_shed`                                                              | Peak: New #7                                                                                                |                                                                                              |
| `upgrade_df_thermostat_control_load_shift`                                          | Peak: New #8                                                                                                |                                                                                              |
| `upgrade_light_led` (LED Lighting)                                                  | Light: `Retrofit with light emitting diode technologies`                                                    |                                                                                              |
| `upgrade_light_lighting_controls`                                                   | Light: `Add occupancy sensors` and/or `Add daylight controls`                                               |                                                                                              |
| `upgrade_env_exterior_wall_insulation` (Wall Insulation)                            | Env: `Increase wall insulation`                                                                             |                                                                                              |
| `upgrade_env_roof_insul_aedg` (Roof Insulation)                                     | Env: `Increase roof insulation`                                                                             |                                                                                              |
| `upgrade_env_new_aedg_windows` (New Windows)                                        | Env: `Replace windows`                                                                                      |                                                                                              |
| `upgrade_env_secondary_windows` (Secondary Windows)                                 | Env: `Add secondary window systems/attachments`                                                             |                                                                                              |
| `upgrade_env_window_film` (Window Film)                                             | Env: `Add window films`                                                                                     |                                                                                              |
| `upgrade_env_latest_envelope_code`                                                  | Package: Env `Increase wall insulation`, `Increase roof insulation`, `Replace windows`                      |                                                                                              |
| `upgrade_ppl_electric_kitchen_equipment` (Electric Kitchen Equipment)               | Kitchen: New #6                                                                                             |                                                                                              |
| `upgrade_add_pvwatts`                                                               | RE: `Install photovoltaic system`                                                                           |                                                                                              |
| Packages 1-5                                                                        | Package of the component rows above                                                                         | Component list per release configuration                                                     |

### A.2 ResStock (reviewed 2026-11-03)

| ResStock upgrade                                              | BuildingSync mapping                                                                                                                  | Mapping detail                                                       |
| ------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------- |
| Natural gas / propane / fuel oil furnace (95% or 88% AFUE)    | HVAC: New #3                                                                                                                          | AFUE and fuel in system detail                                       |
| Minimum-efficiency furnaces and air conditioners              | Package: HVAC New #3, New #4 (and `Replace boiler`, `Install air source heat pump` where applicable)                                  |                                                                      |
| Cold-climate ducted ASHP (standard, limited, existing backup) | HVAC: `Install air source heat pump`                                                                                                  | Ducted, cold-climate, backup in detail                               |
| Dual fuel heat pump                                           | HVAC: `Install air source heat pump`                                                                                                  | Fuel backup and switchover in detail                                 |
| Single-, dual-, variable-speed geothermal heat pumps          | HVAC: `Replace AC and heating units with ground coupled heat pump systems`                                                            |                                                                      |
| Heat pump water heater                                        | SHW: `Install heat pump SHW system`                                                                                                   |                                                                      |
| High-efficiency natural gas tankless water heater             | SHW: `Install tankless water heaters`                                                                                                 |                                                                      |
| Air sealing; general air sealing                              | Env: `Air seal envelope`                                                                                                              |                                                                      |
| Attic floor insulation                                        | Env: `Increase ceiling insulation`                                                                                                    |                                                                      |
| Duct sealing and insulation                                   | Package: HVAC `Repair leaks / seal ducts`, `Add duct insulation`                                                                      |                                                                      |
| Drill-and-fill wall insulation with air sealing               | Package: Env `Increase wall insulation`, `Air seal envelope`                                                                          |                                                                      |
| ENERGY STAR windows                                           | Env: `Replace windows`                                                                                                                |                                                                      |
| Envelope packages (air sealing, attic, ducts, walls)          | Package of the component rows above                                                                                                   |                                                                      |
| Geothermal heat pump + envelope packages                      | Package of the GSHP row and envelope rows                                                                                             |                                                                      |
| EV adoption with Level 1 / Level 2 charging; efficient EV     | EDS: New #10                                                                                                                          | EV adoption is a load change, not a building measure; see Appendix B |
| EV Level 2 charging with demand flexibility                   | Package: EDS New #10 + Peak New #9                                                                                                    |                                                                      |
| HVAC on-peak load shedding (2°F, 4°F)                         | Peak: New #7                                                                                                                          | Offset in `LongDescription`/crosswalk                                |
| HVAC pre-peak load shifting (2°F/4°F, 1 h/4 h)                | Peak: New #8                                                                                                                          |                                                                      |
| Whole-home electrification (earlier releases)                 | Package: `Install air source heat pump`, `Install heat pump SHW system`, Plug `Replace clothes dryers`, Kitchen New #6, envelope rows |                                                                      |
| PV, battery (option-level)                                    | RE: `Install photovoltaic system`; `Install electrical storage`                                                                       |                                                                      |

Earlier ResStock releases also combined heat pump options with heat pump water heaters or envelope measures; these map as packages of the rows above.

## Appendix B. Notes and broad mappings

- **Broad mappings** (several BuildStock measures share one BuildingSync value): unoccupied outdoor-air control, fan static pressure reset, multi-speed minimum flow, radiant barrier, rim-joist insulation. Add specific values later only if consumers show a need to distinguish them.
- **Not mapped:** ComStock `upgrade_hvac_enable_ideal_air_loads`, `fault_*`, and baseline variability or setup measures (`add_*`, `set_*`, `replace_baseline_windows`, etc.) are modeling devices, not retrofits.
- **EV adoption** (adding vehicles) is a load change outside BuildingSync's measure scope; only the charging equipment and managed charging are mapped.
- **Water heating and refrigeration:** ComStock has no upgrade measures in these areas as of 2026-11-03; existing BuildingSync SHW and Refrigeration values cover typical audit measures.
- **Other typical workflows:** buildingsync-measures-gem measures already map through existing system types; extend the crosswalk as BOSS adds workflows.

## References

- [BuildingSync issue #287](https://github.com/BuildingSync/schema/issues/287); [proposal process](../README.md); [versioning](../../docs/versioning.md).
- [ComStock][comstock-readme], [ComStock measures][comstock-measures], [heat-pump RTU README][comstock-rtu-doc], [VRF/DOAS README][comstock-vrf] (accessed 2026-11-03).
- [ResStock][resstock-readme].
- [BOSS][boss-readme], [BOSS reader][boss-reader], [BOSS external-measure manifest][boss-manifest].
- [Modify HVAC mapping guidance][modify-hvac]; [L100 rules][l100]; [SEED rules][seed]; [CTS catalog][cts-catalog]; [CTS parser][cts-parser].
- [BRICR proposal](../2019/BRICR%20Support.md) for `CustomMeasureName` background.

[comstock-readme]: https://github.com/NatLabRockies/ComStock/blob/HEAD/README.md
[comstock-measures]: https://github.com/NatLabRockies/ComStock/tree/HEAD/resources/measures
[comstock-rtu-doc]: https://github.com/NatLabRockies/ComStock/blob/HEAD/resources/measures/upgrade_hvac_add_heat_pump_rtu/README.md
[comstock-vrf]: https://github.com/NatLabRockies/ComStock/blob/HEAD/resources/measures/upgrade_hvac_vrf_hr_doas/README.md
[resstock-readme]: https://github.com/NatLabRockies/resstock
[boss-readme]: https://github.com/BuildingSync/BOSS/blob/e8d8a14b36bc5ba641b2b55354992c2089a1aad5/README.md
[boss-reader]: https://github.com/BuildingSync/BOSS/blob/e8d8a14b36bc5ba641b2b55354992c2089a1aad5/lib/BOSS/buildingsync_reader/buildingsync_reader.rb
[boss-manifest]: https://github.com/BuildingSync/BOSS/blob/e8d8a14b36bc5ba641b2b55354992c2089a1aad5/config/external_measure_repos.yml
[modify-hvac]: https://github.com/BuildingSync/buildingsync-measures-gem/blob/c40c2ed65952a1c3bfe82bf1daa542ce5e1ee8d6/lib/measures/modify_hvac/README.md
[l100]: https://github.com/BuildingSync/use-cases/blob/88d1e5e4ce741fef4d81d93a411e67a70d96aa25/ASHRAE_211/schematron/L100_Audit-1.0.0.sch
[seed]: https://github.com/BuildingSync/use-cases/blob/88d1e5e4ce741fef4d81d93a411e67a70d96aa25/SEED/schematron/SEED-1.0.0.sch
[cts-catalog]: https://github.com/BuildingSync/BuildingSync-asset-extractor/blob/f857322ce53329e3942ef279b9aa1078e8b46838/buildingsync_asset_extractor/cts/energy_and_water_conservation_measures.py
[cts-parser]: https://github.com/BuildingSync/BuildingSync-asset-extractor/blob/f857322ce53329e3942ef279b9aa1078e8b46838/buildingsync_asset_extractor/cts/parsers.py
