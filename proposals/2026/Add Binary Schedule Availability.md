# Add Binary Schedule Availability

## Overview

This proposal addresses [issue #260](https://github.com/BuildingSync/schema/issues/260) by adding explicit binary availability data to `ScheduleType`. Availability describes whether equipment is enabled and permitted to operate; it does not indicate that the equipment is actually running. The existing `PartialOperationPercentage` remains the operating-level value, with its existing category-dependent meaning.

**Status: proposal only; neither the schema nor the validated XML examples are changed.** Two independent design decisions remain open:

| Decision                             | Candidate A / 1              | Candidate B / 2                  | Status  |
| ------------------------------------ | ---------------------------- | -------------------------------- | ------- |
| Availability encoding                | A: XML boolean               | B: text enumeration              | Pending |
| Relationship to operating percentage | 1: optional exclusive choice | 2: independent optional siblings | Pending |

All four combinations are candidates. Keeping two encodings in this proposal does **not** mean accepting both encodings in the eventual schema. Select one encoding and one structure before implementing the feature.

## Justification

The [discussion that led to #260](https://github.com/BuildingSync/TestSuite/pull/37#discussion_r496136378) distinguishes HVAC availability from partial operation of HVAC components. An HVAC system may be available to operate while controls or demand keep it idle. A component's operating percentage describes a different quantity. Expressing availability through a percentage alone loses that distinction.

The current [schedule value definition](../../BuildingSync.xsd#L1825-L1837) provides only optional `PartialOperationPercentage`, implemented as unrestricted `xs:decimal` with optional `auc:Source`. Its documentation describes occupancy relative to typical maximum occupancy, or equipment power relative to installed capacity. Although the documentation says 0–100 (%), those bounds are not XSD restrictions.

Some existing documents contain [time-only details](../../examples/AT_example_NYC_audit_report_property.xml#L4229-L4240), without an explicit value. Those records must remain valid; omitted data is not an explicit unavailable state. Other documents contain [small decimal percentages](../../examples/Single_building_gbxml_externalreference_geometry.xml#L8200-L8230). Their fraction-versus-percentage interpretation is separate work: values below one alone do not establish an incorrect scale, and this proposal neither converts nor tightens them.

A dedicated availability field makes the two data meanings explicit without renaming existing elements, changing schedule links, or undertaking the broader generalized schedule-type-limits design discussed in the original issue.

## Implementation

### Classification and compatibility

The eventual implementation is a **non-breaking MINOR addition** under [the versioning policy](../../docs/versioning.md), whichever of the four combinations is selected. The proposal-only contribution has **No Schema Changes**.

Preserve every existing element's XML path, order relative to other existing elements, effective cardinality, type, attributes, and meaning. In particular, retain the complete existing `PartialOperationPercentage` declaration, including its unrestricted decimal value space, documentation, optionality, and optional `auc:Source`.

An optional, single-occurrence XSD choice at the existing percentage position does not create an XML instance wrapper or make the percentage required. It continues to accept every previously valid detail. Independent optional siblings likewise preserve all existing details. Neither structure requires a migration script or deferral to a major release.

This is backward compatibility for existing documents, not a promise that old schemas or downstream tools understand new availability data. Adoption requirements are listed below. Do not change schema version declarations or the changelog in this feature contribution.

### Common element and semantics

The working name is `ScheduleAvailability`. Add it as an optional child of `ScheduleDetail` in [ScheduleType](../../BuildingSync.xsd#L1748-L1851), with this proposed instance path:

`auc:BuildingSync/auc:Facilities/auc:Facility/auc:Schedules/auc:Schedule/auc:ScheduleDetails/auc:ScheduleDetail/auc:ScheduleAvailability`

Use the following common definition sentence in its documentation:

> Indicates whether the equipment associated with the schedule is enabled and available to operate during the interval. Availability does not indicate actual operation or an operating percentage. Omission means availability is not supplied.

The encoding-specific definitions below add the corresponding value meanings. Common rules are:

- Available means operation is permitted by this schedule, subject to demand and other controls. Unavailable means operation is not enabled by this schedule. This is not a hardware failure or equipment-condition indicator.
- Availability does not imply 100% operation. A zero operating percentage does not, by itself, imply that equipment is unavailable.
- Do not derive either quantity from the other or introduce an implicit value. No `default`, `fixed`, or `nillable="true"` is proposed.
- Use optional `auc:Source` on the new scalar through `xs:simpleContent`, matching the existing provenance pattern. Do not use `xs:complexContent`.
- Keep the existing optional day, category, time, and date metadata. Keep `Schedule/@ID`, `auc:Status`, `LinkedPremises`, and other schedule content unchanged.
- Existing categories such as `HVAC equipment`, `Cooling equipment`, and `Heating equipment` can describe the equipment. No category is added, renamed, or made mandatory, and no category-dependent restriction is added to the base XSD.
- The element name identifies the availability data; no schedule-level data-kind discriminator is introduced. Neither structural candidate enforces a uniform value kind across every detail in a schedule.
- Do not redefine time boundaries, overlapping intervals, uncovered periods, or day-type precedence. The illustrative intervals below are partial examples, not instructions to fill gaps with false, zero, or the previous value.

The proposed element name and the enumeration type name below were not found in the current BuildingSync or cached gbXML schemas during planning. Repeat the collision checks against the implementation base before adding them.

### Encoding A: XML boolean

Use an inline complex type whose simple content extends `xs:boolean`, with optional `auc:Source`:

```xml
<xs:element xmlns:xs="http://www.w3.org/2001/XMLSchema"
            xmlns:auc="http://buildingsync.net/schemas/bedes-auc/2019"
            name="ScheduleAvailability" minOccurs="0">
  <xs:annotation>
    <xs:documentation>Indicates whether the equipment associated with the schedule is enabled and available to operate during the interval. Availability does not indicate actual operation or an operating percentage. Omission means availability is not supplied. The values true and 1 mean available; false and 0 mean unavailable.</xs:documentation>
  </xs:annotation>
  <xs:complexType>
    <xs:simpleContent>
      <xs:extension base="xs:boolean">
        <xs:attribute ref="auc:Source"/>
      </xs:extension>
    </xs:simpleContent>
  </xs:complexType>
</xs:element>
```

- **Accepted values:** `true`, `false`, `1`, and `0`, with standard XML boolean whitespace handling. Examples and producer guidance should prefer `true` and `false`.
- **Advantages:** standard XML typing, native boolean mappings, no custom simple type.
- **Trade-offs:** four lexical forms represent two states. A consumer must parse the value rather than test whether the element exists or whether its text is nonempty. In particular, a present `false` is not true.

### Encoding B: text enumeration

Add a named simple type `ScheduleAvailabilityType`, restricting `xs:string` to the exact labels `Available` and `Unavailable`:

```xml
<xs:simpleType xmlns:xs="http://www.w3.org/2001/XMLSchema"
               name="ScheduleAvailabilityType">
  <xs:annotation>
    <xs:documentation>Binary availability of equipment during a scheduled interval, distinct from actual operation or an operating percentage.</xs:documentation>
  </xs:annotation>
  <xs:restriction base="xs:string">
    <xs:enumeration value="Available">
      <xs:annotation>
        <xs:documentation>Equipment is enabled and permitted to operate by this schedule, subject to demand and other controls.</xs:documentation>
      </xs:annotation>
    </xs:enumeration>
    <xs:enumeration value="Unavailable">
      <xs:annotation>
        <xs:documentation>Equipment is not enabled to operate by this schedule.</xs:documentation>
      </xs:annotation>
    </xs:enumeration>
  </xs:restriction>
</xs:simpleType>
```

The optional element would extend that type to support provenance:

```xml
<xs:element xmlns:xs="http://www.w3.org/2001/XMLSchema"
            xmlns:auc="http://buildingsync.net/schemas/bedes-auc/2019"
            name="ScheduleAvailability" minOccurs="0">
  <xs:annotation>
    <xs:documentation>Indicates whether the equipment associated with the schedule is enabled and available to operate during the interval. Availability does not indicate actual operation or an operating percentage. Omission means availability is not supplied. Available means enabled; Unavailable means not enabled.</xs:documentation>
  </xs:annotation>
  <xs:complexType>
    <xs:simpleContent>
      <xs:extension base="auc:ScheduleAvailabilityType">
        <xs:attribute ref="auc:Source"/>
      </xs:extension>
    </xs:simpleContent>
  </xs:complexType>
</xs:element>
```

- **Accepted values:** exactly `Available` and `Unavailable`, with this casing. Using `xs:string` does not introduce whitespace trimming.
- **Advantages:** explicit availability meaning, human-readable values, an enumeration available to generated documentation and clients.
- **Trade-offs:** requires a custom simple type and explicit conversion to simulation availability values rather than native boolean parsing.
- Do not use `On`/`Off` or `Operating`/`Closed`, which can suggest actual operation. Do not add `Unknown` or `Other`: this field has two states, and omission represents unsupplied data.

The encoding blocks are alternative **XSD fragments**, not standalone schemas. Namespace declarations make the fragments readable independently; the schema already declares these namespaces. Only the selected encoding would be inserted into the XSD.

### Structure 1: optional exclusive choice

At the current `PartialOperationPercentage` position immediately after `DayEndTime` in the detail's sequence:

1. Insert `xs:choice` with `minOccurs="0"` and `maxOccurs="1"`.
2. Put the existing, unchanged optional `PartialOperationPercentage` declaration inside it.
3. Add the optional `ScheduleAvailability` declaration from encoding A or B as the other branch.
4. Leave every other sequence member in place. Declare each element only once; do not duplicate the percentage definition elsewhere.

This permits a percentage alone, availability alone, or neither. It rejects both values in the same detail and rejects repeated values. The choice is per detail, not per whole schedule.

**Advantages:** XSD enforces a single value kind per detail, and consumers can distinguish the two kinds by element name.

**Trade-offs:** reporting both independent quantities requires separate entries or schedules, potentially duplicating interval metadata. Separate schedules can use the existing repeatable schedule links; no new linking element is needed.

The following **proposed XML fragment** illustrates encoding A with structure 1. These new availability elements are not valid against the unchanged current schema. It is not a complete BuildingSync document.

```xml
<auc:Schedules xmlns:auc="http://buildingsync.net/schemas/bedes-auc/2019">
  <auc:Schedule ID="HVAC-Availability">
    <auc:ScheduleDetails>
      <auc:ScheduleDetail>
        <auc:DayType>Weekday</auc:DayType>
        <auc:ScheduleCategory>HVAC equipment</auc:ScheduleCategory>
        <auc:DayStartTime>06:00:00</auc:DayStartTime>
        <auc:DayEndTime>18:00:00</auc:DayEndTime>
        <auc:ScheduleAvailability auc:Source="Auditor">true</auc:ScheduleAvailability>
      </auc:ScheduleDetail>
      <auc:ScheduleDetail>
        <auc:DayType>Weekday</auc:DayType>
        <auc:ScheduleCategory>HVAC equipment</auc:ScheduleCategory>
        <auc:DayStartTime>18:00:00</auc:DayStartTime>
        <auc:DayEndTime>22:00:00</auc:DayEndTime>
        <auc:ScheduleAvailability>false</auc:ScheduleAvailability>
      </auc:ScheduleDetail>
    </auc:ScheduleDetails>
  </auc:Schedule>
  <auc:Schedule ID="HVAC-Operation">
    <auc:ScheduleDetails>
      <auc:ScheduleDetail>
        <auc:DayType>Weekday</auc:DayType>
        <auc:ScheduleCategory>HVAC equipment</auc:ScheduleCategory>
        <auc:DayStartTime>06:00:00</auc:DayStartTime>
        <auc:DayEndTime>18:00:00</auc:DayEndTime>
        <auc:PartialOperationPercentage auc:Source="Auditor">40</auc:PartialOperationPercentage>
      </auc:ScheduleDetail>
    </auc:ScheduleDetails>
  </auc:Schedule>
</auc:Schedules>
```

For encoding B with structure 1, replace only availability values: `true` becomes `Available` and `false` becomes `Unavailable`. The percentage remains `40`, not `0.4`, `1`, or `Available`.

For example, an existing [thermal-zone schedule link container](../../BuildingSync.xsd#L1545-L1558) can refer to both schedule IDs above. This link fragment belongs under a `ThermalZone`, not inside `Schedules`:

```xml
<auc:HVACScheduleIDs xmlns:auc="http://buildingsync.net/schemas/bedes-auc/2019">
  <auc:HVACScheduleID IDref="HVAC-Availability"/>
  <auc:HVACScheduleID IDref="HVAC-Operation"/>
</auc:HVACScheduleIDs>
```

### Structure 2: independent optional siblings

Leave the current optional `PartialOperationPercentage` declaration exactly where it is. Append optional `ScheduleAvailability` from encoding A or B immediately after it in the detail's sequence, with `minOccurs="0"` and the default `maxOccurs="1"`.

This permits neither value, either value, or both once. When both appear, the percentage must precede availability. Reversed order and duplicate values are invalid.

**Advantages:** independently reports availability and operating level with shared interval metadata. Being available and operating at 40% is not the same as being 40% available.

**Trade-offs:** consumers must handle two quantities. There is no automatic conversion, precedence, or overwriting of either field. An unavailable interval with a positive reported operating percentage would require domain reconciliation; this proposal does not introduce a cross-value consistency constraint into the base XSD. A consumer or use case would need an explicit policy rather than silently changing the supplied values.

The following **proposed XML fragment** illustrates encoding B with structure 2. It belongs within `ScheduleDetails` and is not valid against the unchanged current schema:

```xml
<auc:ScheduleDetail xmlns:auc="http://buildingsync.net/schemas/bedes-auc/2019">
  <auc:DayType>Weekday</auc:DayType>
  <auc:ScheduleCategory>HVAC equipment</auc:ScheduleCategory>
  <auc:DayStartTime>06:00:00</auc:DayStartTime>
  <auc:DayEndTime>18:00:00</auc:DayEndTime>
  <auc:PartialOperationPercentage auc:Source="Auditor">40</auc:PartialOperationPercentage>
  <auc:ScheduleAvailability auc:Source="Auditor">Available</auc:ScheduleAvailability>
</auc:ScheduleDetail>
```

For encoding A with structure 2, replace `Available` with `true`. Both structures also allow an availability-only detail, so the explicitly unavailable interval shown under structure 1 remains expressible without inventing an operating percentage.

### Downstream compatibility and follow-up

The following findings were checked during planning on 2026-10-29. They distinguish preserved behavior for old percentage documents from support for newly introduced availability data. These are follow-up recommendations, not external changes or already-opened issues.

| Repository / consumer                          | Verified evidence or search limitation                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | Proposed follow-up                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| ---------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **use-cases / TestSuite**                      | In the current [L200 rules](https://github.com/BuildingSync/use-cases/blob/main/ASHRAE_211/schematron/L200_Audit-1.0.0.sch), `general_schedule_requirements` requires `auc:PartialOperationPercentage` on every `ScheduleDetail`. The separate `occupancy_schedules` rule requires it for `Occupied`. Availability-only details would fail the current L200 schedules phase even if valid against the candidate XSD.                                                                                                                                                              | Review a version-aware, category- and meaning-aware rule update, including the [source CSV](https://github.com/BuildingSync/use-cases/blob/main/ASHRAE_211/src/L200_Audit-1.0.0.csv), generated Schematron, and fixtures. Do not globally replace the percentage assertion with an unrestricted either/or: occupancy-density requirements still need operating percentages. Coordinate use-case adoption; no TestSuite library change is established by this finding. |
| **buildingsync-measures-gem**                  | [ModifySchedules](https://github.com/BuildingSync/buildingsync-measures-gem/blob/develop/lib/measures/modify_schedules/measure.rb) accepts JSON/compact payloads, not raw BuildingSync XML. `parse_schedule_payload` reads `value_percent`, `partialoperationpercentage`, `value`, or `fraction`; missing values are errors. It uses numeric conversion, divides explicit percentages by 100, and clamps to 0–1. The `hvac_availability_schedule_json` target currently uses the same fraction schedule machinery, including Continuous limits, before `setAvailabilitySchedule`. | Add explicit parsing/mapping for the selected availability encoding and discrete 0/1 availability values, separate from percentage normalization. Preserve legacy numeric behavior and test false/unavailable distinctly from omission. A payload carrying only the new availability key is not currently supported.                                                                                                                                                  |
| **BOSS**                                       | Exact `PartialOperationPercentage` searches returned no matches; `ScheduleDetail` matches were XML fixtures. Those searches do not establish how runtime code handles schedules or what defaults it uses.                                                                                                                                                                                                                                                                                                                                                                         | Trace the relevant XML-to-measure payload handoff and determine whether availability needs additional forwarding, selection, or unsupported-data reporting. Do not claim end-to-end support from fixture presence.                                                                                                                                                                                                                                                    |
| **BuildingSync-asset-extractor**               | Exact percentage searches returned no matches; schedule-detail matches were test fixtures. No direct availability consumer was established.                                                                                                                                                                                                                                                                                                                                                                                                                                       | Confirm whether any extraction path consumes schedules before deciding whether implementation changes are needed. A bounded search is not proof of no impact.                                                                                                                                                                                                                                                                                                         |
| **Generated clients and BuildingSync-website** | Newly introduced elements/types require consumers to adopt the corresponding schema. No compatibility result for the candidate feature has been established for current generated clients, the viewer, or the hosted validator.                                                                                                                                                                                                                                                                                                                                                   | Verify generated bindings, documentation/viewer presentation, enumeration output if encoding B is selected, and validation against the eventual released schema. Do not expect an older released schema to accept availability data.                                                                                                                                                                                                                                  |

The existing schedule paths and links are not renamed, moved, or deprecated. However, schema backward compatibility alone does not make new availability-only data usable by percentage-only consumers. Do not generate placeholder percentages just to bypass an older consumer's requirements.

### Verification and acceptance criteria

After selecting the design, add focused regression contexts to [the existing validation spec](../../spec/validation_spec.rb), reusing its `@xsd` and local gbXML import handling. Add one complete, linked example only when its representation is supported by the implemented schema. Invalid cases should be constructed in tests, not committed as failing examples.

| Area                        | Expected checks                                                                                                                                                                                                                                                               |
| --------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Legacy percentages          | All existing examples remain valid without edits. Preserve `0`, `1`, `40`, `100`, small decimal values, and optional `auc:Source`. Include unrestricted decimal edge cases to catch accidental bounds tightening; those are compatibility tests, not recommended data values. |
| Legacy omission             | Preserve time-only details, empty details, an empty optional `ScheduleDetails`, and omitted schedule metadata wherever currently valid. Absence is not automatically false or zero.                                                                                           |
| Availability and provenance | Explicit available and unavailable values validate, with and without valid `auc:Source`. Invalid provenance values fail. Omission remains valid; empty content and `xsi:nil="true"` fail.                                                                                     |
| Encoding A, if selected     | Accept `true`, `false`, `1`, `0`, and XML boolean whitespace normalization. Reject `2`, `-1`, `0.5`, `1.0`, `True`, `yes`, and `Available`. Consumers must distinguish false/0 from an omitted value.                                                                         |
| Encoding B, if selected     | Accept only `Available` and `Unavailable`. Reject `On`, `Off`, `true`, `false`, `0`, `1`, `Unknown`, `Other`, wrong casing, and surrounding whitespace.                                                                                                                       |
| Structure 1, if selected    | Accept either value or neither. Reject both together in either order and duplicates of either value. Separate details/schedules may report different data kinds.                                                                                                              |
| Structure 2, if selected    | Accept both once with percentage before availability, as well as either alone or neither. Reject reversed order and duplicates. Do not impose an undocumented cross-value calculation.                                                                                        |
| Unchanged context           | Preserve date/time types, day/category enumerations, required schedule IDs, optional status, and existing IDref paths. Check that example references resolve to the intended schedules, not merely an arbitrary ID.                                                           |
| Documentation and consumers | Explain available-but-not-running and available-plus-40%-operation. Verify candidate documentation/type exports and list downstream adoption limitations separately from XSD results.                                                                                         |

For the proposal-only contribution, review all fragments, links, required headings, and the two pending decisions, and run `poetry run pre-commit run --all-files`. Keep all candidate XML embedded here rather than adding it to the currently validated examples.

For the later implementation, run `bundle exec rake remove_tabs`, `bundle exec rake`, `bundle exec rake generate_data_dictionary`, and pre-commit. Inspect formatting changes and remove generated release artifacts after inspection; do not commit those artifacts or unrelated formatting changes.

### Decision and scope

- **Agreed requirement:** binary availability/enabled data alongside continued support for percentage operating schedules.
- **Encoding decision:** pending, A or B.
- **Structure decision:** pending, 1 or 2.
- **Implementation gate:** obtain design approval and implementation authorization before changing the schema, examples, or regression tests. This proposal does not claim team acceptance or resolution of #260.
- **Contribution labels:** `No Schema Changes` for the proposal-only PR. An eventual additive implementation would use `Non-breaking Change` and `Schema: General`. Reference #260 without closing it in the proposal-only contribution.
- **Out of scope:** interpreting availability as measured running status; changing or normalizing percentage data; new percentage bounds; generalized numeric/temperature/integer schedule types; schedule-wide discriminators; interval/overlap/gap redesign; new links; version/changelog edits; external repository edits or issue creation.

## References

- [BuildingSync/schema issue #260](https://github.com/BuildingSync/schema/issues/260).
- [Original availability-versus-operation discussion in TestSuite #37](https://github.com/BuildingSync/TestSuite/pull/37#discussion_r496136378).
- [BuildingSync versioning](../../docs/versioning.md).
- [BuildingSync proposal process](../README.md).
- [Existing schedule linking definitions](../../docs/linking_elements.md).
- [Earlier proposal comparing occupancy schedule linking alternatives](../2020/Add%20Occupancy%20Schedule%20Linking.md).
