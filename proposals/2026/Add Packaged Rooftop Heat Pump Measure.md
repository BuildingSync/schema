# Add Packaged Rooftop Heat Pump Measure

## Overview

Address a specific gap in [issue #287, Add Measures](https://github.com/BuildingSync/schema/issues/287): introduce `Install packaged rooftop heat pump` as a standardized `OtherHVAC/MeasureName`, and define how this technology classification can support mappings to building energy modeling (BEM) workflows such as OpenStudio and ComStock.

This is a scoped first step, not a proposal to copy the entire ComStock catalog into BuildingSync. It distinguishes:

1. **Technology/action:** the audit recommendation, standardized in BuildingSync.
2. **Equipment and scope:** the existing and proposed systems and premises affected.
3. **Executable implementation:** the external measure, revision, arguments, applicability rules, and workflow ordering.

A technology name can narrow the candidate implementations; it is not, by itself, an executable specification or a guarantee of simulation support. Keep #287 open until maintainers agree whether this scope resolves its remaining requests.

## Justification

### The issue and the current schema

The original issue explicitly lists `Replace HVAC system type to VRF` and `Replace HVAC system type to PZHP` as custom measures in the former BuildingSync-gem. It is not an empty request for an unspecified measure list. However, the current schema already includes a VRF measure, so adding another spelling for the same technology is unnecessary.

The following inventory was checked against schema revision `e24c54cd7e2ebf6c222881089b2b092f839f5cc5` on 2026-11-03. Local line links refer to that working-tree baseline.

| Requirement                                           | Existing representation                                                                                                                                                                           | Remaining gap                                                                                                                     |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| Install or replace equipment with VRF                 | `Install variable refrigerant flow system` in [OtherHVAC](../../BuildingSync.xsd#L4092-L4145), combined with `TypeOfMeasure`                                                                      | No new generic VRF enum is needed. Heat recovery, ventilation configuration, and execution parameters still require detail.       |
| Install an air-source heat pump                       | `Install air source heat pump` in [OtherHVAC](../../BuildingSync.xsd#L4125-L4127)                                                                                                                 | Does not distinguish a packaged rooftop unit from other air-source configurations at the measure-name level.                      |
| Replace packaged equipment                            | `Replace package units` and `Replace packaged terminal units` in [OtherHVAC](../../BuildingSync.xsd#L4112-L4113)                                                                                  | Neither identifies a rooftop heat-pump conversion specifically. A terminal heat pump is not a rooftop heat pump.                  |
| Describe the proposed rooftop heat-pump equipment     | `PrincipalHVACSystemType = Packaged Rooftop Heat Pump` in the [existing system-type vocabulary](../../BuildingSync.xsd#L7338-L7364), referenced by [HVACSystemType](../../BuildingSync.xsd#L6047) | Already possible when the producer supplies a proposed system record; a sparse audit recommendation need not include that record. |
| Identify replaced and proposed equipment              | [TypeOfMeasure/Replacements/Replacement](../../BuildingSync.xsd#L3836-L3868) contains `ExistingSystemReplaced` and `AlternativeSystemReplacement` IDrefs                                          | Existing links should be reused, not replaced with new linking elements.                                                          |
| Preserve a study-specific measure name or description | [CustomMeasureName and LongDescription](../../BuildingSync.xsd#L4868-L4877); [UserDefinedFields](../../BuildingSync.xsd#L5016)                                                                    | Free text can carry information but does not establish a shared technology vocabulary or executable contract.                     |
| Attach a reproducible external workflow               | [Measure/LinkedFiles](../../BuildingSync.xsd#L3987), [LinkedFileID](../../BuildingSync.xsd#L12526-L12539), and [FileType](../../BuildingSync.xsd#L2094-L2144)                                     | Attachment and workflow-profile conventions require agreement; the XSD does not validate the contents of an attached workflow.    |

**A schema change is not necessary simply to represent or simulate this retrofit.** The generic heat-pump measure plus a linked proposed system can already describe it, and an external workflow can be attached. The justification for the narrow addition is a stable, tool-neutral classification directly on the measure: producers can exchange and aggregate a rooftop heat-pump recommendation without inventing custom names or supplying a full equipment description.

If maintainers prefer all specialization to remain in linked system records, a documentation/mapping-only resolution is viable. The recommendation here is the small enum addition because it supports both sparse audit recommendations and detailed BEM mappings, without making simulation metadata mandatory for ordinary audits.

### Concrete ComStock evidence and boundaries

The reviewed ComStock source is pinned to `e2ba328df6683b724bac2e3da1fe31b54d6d23bc`; this is a source snapshot, not a claim that every behavior is present in a published study release. See the [RTU measure documentation][comstock-rtu-doc] and [implementation][comstock-rtu-code].

The executable directory is `upgrade_hvac_add_heat_pump_rtu`, its Ruby class is `AddHeatPumpRtu`, and its reported name is `add_heat_pump_rtu`. These identifiers are distinct from a study's upgrade label and from BuildingSync's `MeasureName`.

| Reviewed workflow case                                           | BuildingSync classification                                                   | Mapping detail, not another enum                                                                                                                        |
| ---------------------------------------------------------------- | ----------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Standard-efficiency heat-pump RTU                                | Proposed `Install packaged rooftop heat pump`                                 | `hprtu_scenario = two_speed_standard_eff`                                                                                                               |
| Heat-pump RTU using laboratory performance data                  | Same proposed value                                                           | `hprtu_scenario = two_speed_lab_data`; this distinguishes performance assumptions, not a new equipment family.                                          |
| Higher-efficiency variable-speed heat-pump RTU                   | Same proposed value                                                           | `hprtu_scenario = variable_speed_high_eff`                                                                                                              |
| Cold-climate challenge RTU performance case                      | Same proposed value                                                           | `hprtu_scenario = cchpc_2027_spec`; the source describes a hypothetical four-stage unit, not a certification claim.                                     |
| [VRF with heat recovery and dedicated outdoor air][comstock-vrf] | Existing `Install variable refrigerant flow system` for the VRF component     | DOAS, heat-recovery configuration, and `vrf_defrost_strategy` are additional specification. The generic VRF enum does not imply this whole combination. |
| [Packaged ground-source heat-pump replacement][comstock-gshp]    | Existing `Replace AC and heating units with ground coupled heat pump systems` | Use linked system detail and the `upgrade_hvac_packaged_gshp` implementation; no additional generic ground-source enum is justified here.               |

The RTU implementation also exposes `backup_ht_fuel_scheme`, `htg_sizing_option`, `performance_oversizing_factor`, `clg_oversizing_estimate`, `htg_to_clg_hp_ratio`, and `hp_min_comp_lockout_temp_f`. For example, backup heat can retain the original primary heating fuel or use electric resistance. Thus, **a heat-pump recommendation does not necessarily mean complete removal of fossil-fuel backup**.

The same implementation has `hr`, `dcv`, `econ`, `roof`, `window`, and setback options. Turning these on can add other interventions; a study upgrade is not necessarily one indivisible technology. In the reviewed source, `modify_setbacks` defaults to `true`, so accepting all defaults does not mean an equipment-only replacement. Existing BuildingSync measures such as `Add energy recovery`, `Install demand control ventilation`, and `Add or repair economizer` should be reused where applicable, rather than adding an enum for every combination.

The RTU source selects eligible single-zone systems and excludes, among other cases, water-coil systems, existing heat pumps, and multi-zone air loops. Its complete applicability logic remains authoritative. The proposed BuildingSync enum is broader than that implementation's eligibility and must not automatically dispatch every rooftop system to it. The issue's `PZHP` label is read as `PSZ-HP`, the packaged single-zone heat pump system in ASHRAE 90.1 Appendix G and openstudio-standards, which the legacy BuildingSync-gem synthesized. BuildingSync already pairs `PrincipalHVACSystemType = Packaged Rooftop Heat Pump` with that system ([Modify HVAC guidance][modify-hvac]), and ComStock's "HP RTU" upgrade targets packaged single-zone systems. The proposed value therefore keeps the existing rooftop wording, so that one measure name maps to one system type, and its documentation names PSZ-HP and HP RTU as the corresponding simulation terms.

### Alternatives not proposed

- **One enum per ComStock upgrade/scenario:** rejected. A study label can combine equipment, controls, envelope changes, and modeling assumptions, and can change independently of BuildingSync releases.
- **New `ComStock` technology category:** rejected. Retain the existing FEMP-aligned `OtherHVAC` category and keep the technology vocabulary tool-neutral.
- **Duplicate VRF or ground-source enums:** unnecessary for the reviewed cases. More specialized combinations can be evaluated separately if existing system details demonstrably cannot express them.
- **A general executable-measure/argument schema:** deferred. The current schema has no `BCLMeasure` or `MeasureArgument` element, but `CustomMeasureName`, `UserDefinedFields`, and file attachments already support a mapping pilot. A typed, self-contained execution contract would be a separate feature justified by that pilot, not a prerequisite for this enum.

## Implementation

### 1. Exact proposed XSD change

Change only the existing inline `xs:string` restriction for:

`/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Measures/auc:Measure/auc:TechnologyCategories/auc:TechnologyCategory/auc:OtherHVAC/auc:MeasureName`

The schema declaration is within `xs:complexType[@name='MeasureType']`, at [OtherHVAC/MeasureName](../../BuildingSync.xsd#L4092-L4145).

Add exactly one `xs:enumeration`, immediately after `Install air source heat pump`:

| Property                 | Proposed content                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Enumeration value        | `Install packaged rooftop heat pump`                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| Annotation               | Add `xs:annotation/xs:documentation` on the new enumeration.                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| Exact documentation text | Installation of a factory-assembled, air-source rooftop heat pump providing space heating and cooling, including replacement of existing equipment. Corresponds to the packaged single-zone heat pump (PSZ-HP) system type and to heat pump rooftop unit (HP RTU) retrofits. Excludes packaged terminal, split, and ground-source heat pumps. This value does not specify efficiency, compressor staging, backup heat, ventilation controls, or a simulation implementation; describe these separately when known. |

Retain every existing enum and its meaning, including `Install air source heat pump`, `Replace package units`, and the `Other` variants. Do not deprecate, rename, or reinterpret any old value. Preserve the existing `TechnologyCategories` optionality, repeating `TechnologyCategory`, category choice, `MeasureName` cardinality of one-or-more, namespace, and sequence order. Add no elements, attributes, global types, or IDrefs.

This widens one enumeration, so historical valid documents remain valid under the updated schema. Documents using the new value will require that updated schema; old validators and exact-match consumers are not automatically forward-compatible. No migration script or linking-table change is needed. No version-number or changelog edit belongs in the feature implementation.

### 2. Reuse existing data for equipment and scope

- Use `TypeOfMeasure/Replacements/Replacement` for a replacement and `TypeOfMeasure/Additions/Addition` for an addition. Do not create a second enum solely to distinguish these actions.
- For a detailed replacement, link the actual existing and proposed records with `ExistingSystemReplaced` and `AlternativeSystemReplacement`. The proposed `HVACSystem` can use `PrincipalHVACSystemType = Packaged Rooftop Heat Pump` and `auc:Status = Proposed`, plus applicable heating, cooling, delivery, capacity, and efficiency fields.
- Retain `LinkedPremises` and `MeasureScaleOfApplication` for scope. A workflow adapter must resolve these links to model objects; a BuildingSync ID is not inherently an OpenStudio object name.
- Retain `CustomMeasureName` for a study/user-facing designation and `LongDescription` for assumptions. The [BRICR proposal](../2019/BRICR%20Support.md) already introduced `CustomMeasureName` for simulated-measure names. Do not make its free text a globally unique executable identifier.
- Prefer the specific enum when the rooftop configuration is known. Continue using the generic heat-pump enum when it is not. Do not automatically rewrite historical generic recommendations or count a generic and specific label as two independent retrofits.

### 3. Mapping pilot, without another schema extension

After proposal acceptance and separate authorization for downstream work, develop a versioned crosswalk in the workflow adapter, not an XSD copy of the OpenStudio measure catalog. Its initial test case should map the proposed rooftop classification to the ComStock RTU implementation **only after** selecting an explicit performance profile and checking system applicability.

Use two initial profiles with the same proposed BuildingSync enum and executable directory: `hprtu_scenario = two_speed_standard_eff` and `hprtu_scenario = variable_speed_high_eff`. These are illustrative profile selections, not names of verified published study packages. Preserve the source study configuration as well when reproducing a published result.

Each crosswalk/profile entry should specify:

| Mapping information         | Required behavior for the pilot                                                                                                                                                                                                                                                                                                                  |
| --------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| BuildingSync selector       | Record the technology category, exact measure name, action, and applicable system/premises evidence. Generic air-source heat pump alone must not select a rooftop implementation.                                                                                                                                                                |
| Implementation identity     | Record repository URL, immutable revision, measure directory, and any relevant measure UID/version identifier. A mutable branch or display name alone is insufficient.                                                                                                                                                                           |
| Arguments and defaults      | Record typed values and units, including the selected `hprtu_scenario`, backup heat, sizing, and controls. Materialize or explicitly document defaults from the pinned revision; do not silently inherit future defaults.                                                                                                                        |
| Applicability and targeting | Resolve BuildingSync links, map to model systems, and evaluate the implementation's checks. The RTU implementation selects eligible loops internally rather than accepting BuildingSync system IDs; verify that its affected loops match the intended audit scope. Unknown or contradictory information requires review, not a guessed topology. |
| Runtime and dependencies    | Record compatible OpenStudio/EnergyPlus and library versions, performance data, weather/model inputs, and prerequisites needed for reproducibility. Source revision alone is insufficient.                                                                                                                                                       |
| Composition and ordering    | Record the ordered steps and all added interventions. Do not run a bundled option and a separate measure for the same intervention. Distinguish alternatives from an ordered package.                                                                                                                                                            |
| Outcome                     | Preserve whether the implementation was applied, not applicable, unsupported, or failed. Successful schema validation must not be reported as successful execution.                                                                                                                                                                              |

For an equipment-only pilot, explicitly disable optional added interventions and setback modification, and verify any remaining automatic changes in the pinned implementation. A generic model-modification measure and a particular ComStock retrofit are not assumed to produce equivalent systems or savings.

For interchange, use an existing `Measure/LinkedFiles/LinkedFileID` reference to a `Facility/Files/File` record containing the workflow/profile URL, description, media type, and an integrity checksum where available. An attachment should identify the BuildingSync measure and targeted systems and contain the implementation/argument information above. It may be an OSW plus companion metadata. This is proposed application guidance, not a new XSD-validated attachment format or a claim that current consumers already read it. A consumer must not automatically download or execute arbitrary referenced code.

Study packages can reuse the existing [ScenarioType/PackageOfMeasures/MeasureIDs](../../BuildingSync.xsd#L2313-L2335). That membership does not define OpenStudio step order; retain execution order in the workflow artifact. When one executable changes several technologies, document all of them and avoid duplicating costs/savings across component records.

If this pilot establishes a need for a portable, machine-validated execution reference inside XML rather than an attachment, prepare a separate optional-structure proposal with a concrete producer and consumer. Do not add a generic argument bag speculatively in this change.

### 4. Downstream assessment and proposed follow-ups

Read-only review covered the following repositories on 2026-11-03. These findings are source inspection, not end-to-end simulation results. No external issues, comments, or changes have been made.

| Repository                   | Verified evidence                                                                                                                                                                                                                                                      | Proposed follow-up, requiring separate approval                                                                                                                                                                              |
| ---------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| BOSS                         | The [reader][boss-reader] maps `PrincipalHVACSystemType` for baseline generation. The [external-measure manifest][boss-manifest] already includes ComStock measure roots, using `ref: main`. Neither makes a new `MeasureName` an automatic ComStock upgrade selector. | Add/test explicit recommendation-to-workflow selection, system targeting, applicability reporting, and immutable dependency/profile resolution. Do not describe baseline system generation as applying the studied retrofit. |
| buildingsync-measures-gem    | [Modify HVAC guidance][modify-hvac] distinguishes `packaged_rooftop_heat_pump`, terminal heat pumps, and VRF, and documents generic equipment modification/synthesis.                                                                                                  | Test compatibility of the selected adapter and avoid treating this generic measure as numerically equivalent to ComStock's RTU performance models.                                                                           |
| use-cases                    | [ASHRAE L100 rules][l100] require a `MeasureName` and a custom name for `Other`; [SEED rules][seed] also impose cardinality requirements. XSD validity alone is not use-case validity.                                                                                 | Test a new-enum example against applicable use cases. Keep any BEM-specific requirements in a dedicated profile; do not require simulation metadata for all audits.                                                          |
| BuildingSync-asset-extractor | The CTS [catalog][cts-catalog] includes exact category/name mappings such as `Install air source heat pump`. The [parser][cts-parser] warns on unmatched measures and increments counts only after a match.                                                            | Explicitly map the new rooftop value to the appropriate existing CTS heat-pump reporting bucket and add a regression test. Otherwise the new value may be omitted from both measure and category counts.                     |

Schema release adoption by the website, dictionary/enumeration exports, and generated clients should follow the normal release process. The addition does not change XPath locations, but consumers that enumerate values may need regeneration or explicit mapping updates.

### 5. Work sequence and acceptance criteria

1. **Review this proposal first.** Confirm the need for a measure-level rooftop discriminator, approve the exact wording and definition, and confirm the `PZHP` = PSZ-HP reading with the issue author. Choose documentation-only instead if the existing linked-system representation is preferred. No implementation starts before this decision.
2. **After approval, implement the single enum.** Add a complete example linking an existing RTU, a proposed heat pump, the measure, and affected premises. Include a second recommendation demonstrating that detailed proposed equipment remains optional. Keep examples free of deprecated fields.
3. **Validate the schema change.** Test acceptance of the new enum in `OtherHVAC`, rejection under a restricted unrelated category such as `LightingImprovements`, continued acceptance of every old value, and preservation of paths/cardinalities. Validate all historical examples and dictionary generation. Run the repository's XML formatting, RSpec, data-dictionary, and pre-commit checks; do not commit generated release artifacts. Implementation PR labels: `Non-breaking Change` and `Schema: Measures`.
4. **Validate the separately approved mapping pilot.** Test two RTU performance profiles using the same new enum but different explicit arguments; generic/ambiguous heat pumps; ineligible water-coil or multi-zone systems; unresolved system links; and a bundled-controls case without duplicate application. Capture actual execution outcomes before claiming direct workflow support. Test CTS counting separately.
5. **Expand only from demonstrated gaps.** Inventory additional study measures as already covered, missing stable technology, missing equipment detail, or workflow-only parameter/composition. Propose further enums only for the second group; route other gaps to the appropriate schema or adapter proposal. VRF-with-DOAS combinations and cold-climate performance definitions require their own evidence before becoming new standard terms.

## References

- [BuildingSync issue #287](https://github.com/BuildingSync/schema/issues/287).
- [Current measure vocabulary](../../BuildingSync.xsd#L3988-L4145), [system vocabulary](../../BuildingSync.xsd#L7338-L7364), [proposal process](../README.md), and [versioning](../../docs/versioning.md).
- [ComStock project overview][comstock-readme], [RTU documentation][comstock-rtu-doc], [RTU source][comstock-rtu-code], [VRF/DOAS documentation][comstock-vrf], and [packaged GSHP documentation][comstock-gshp].
- [BOSS overview][boss-readme], [reader][boss-reader], and [external-measure manifest][boss-manifest].
- [BuildingSync measures overview][measures-readme] and [Modify HVAC mapping guidance][modify-hvac].
- [Use-cases overview][use-cases-readme], [L100 rules][l100], and [SEED rules][seed].
- [Asset extractor overview][cts-readme], [CTS measure catalog][cts-catalog], and [CTS parser][cts-parser].

[comstock-readme]: https://github.com/NatLabRockies/ComStock/blob/e2ba328df6683b724bac2e3da1fe31b54d6d23bc/README.md
[comstock-rtu-doc]: https://github.com/NatLabRockies/ComStock/blob/e2ba328df6683b724bac2e3da1fe31b54d6d23bc/resources/measures/upgrade_hvac_add_heat_pump_rtu/README.md
[comstock-rtu-code]: https://github.com/NatLabRockies/ComStock/blob/e2ba328df6683b724bac2e3da1fe31b54d6d23bc/resources/measures/upgrade_hvac_add_heat_pump_rtu/measure.rb
[comstock-vrf]: https://github.com/NatLabRockies/ComStock/blob/e2ba328df6683b724bac2e3da1fe31b54d6d23bc/resources/measures/upgrade_hvac_vrf_hr_doas/README.md
[comstock-gshp]: https://github.com/NatLabRockies/ComStock/blob/e2ba328df6683b724bac2e3da1fe31b54d6d23bc/resources/measures/upgrade_hvac_packaged_gshp/README.md
[boss-readme]: https://github.com/BuildingSync/BOSS/blob/e8d8a14b36bc5ba641b2b55354992c2089a1aad5/README.md
[boss-reader]: https://github.com/BuildingSync/BOSS/blob/e8d8a14b36bc5ba641b2b55354992c2089a1aad5/lib/BOSS/buildingsync_reader/buildingsync_reader.rb
[boss-manifest]: https://github.com/BuildingSync/BOSS/blob/e8d8a14b36bc5ba641b2b55354992c2089a1aad5/config/external_measure_repos.yml
[measures-readme]: https://github.com/BuildingSync/buildingsync-measures-gem/blob/c40c2ed65952a1c3bfe82bf1daa542ce5e1ee8d6/README.md
[modify-hvac]: https://github.com/BuildingSync/buildingsync-measures-gem/blob/c40c2ed65952a1c3bfe82bf1daa542ce5e1ee8d6/lib/measures/modify_hvac/README.md
[use-cases-readme]: https://github.com/BuildingSync/use-cases/blob/88d1e5e4ce741fef4d81d93a411e67a70d96aa25/README.md
[l100]: https://github.com/BuildingSync/use-cases/blob/88d1e5e4ce741fef4d81d93a411e67a70d96aa25/ASHRAE_211/schematron/L100_Audit-1.0.0.sch
[seed]: https://github.com/BuildingSync/use-cases/blob/88d1e5e4ce741fef4d81d93a411e67a70d96aa25/SEED/schematron/SEED-1.0.0.sch
[cts-readme]: https://github.com/BuildingSync/BuildingSync-asset-extractor/blob/f857322ce53329e3942ef279b9aa1078e8b46838/README.md
[cts-catalog]: https://github.com/BuildingSync/BuildingSync-asset-extractor/blob/f857322ce53329e3942ef279b9aa1078e8b46838/buildingsync_asset_extractor/cts/energy_and_water_conservation_measures.py
[cts-parser]: https://github.com/BuildingSync/BuildingSync-asset-extractor/blob/f857322ce53329e3942ef279b9aa1078e8b46838/buildingsync_asset_extractor/cts/parsers.py
