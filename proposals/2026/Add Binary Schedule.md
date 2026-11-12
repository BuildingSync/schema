# Add Binary Schedule

## Overview

This proposal addresses [issue #260](https://github.com/BuildingSync/schema/issues/260) by adding binary (on/off) schedule values to `ScheduleType`. A new optional container on each schedule detail, `BinarySchedule`, holds a required `BinaryValue` (the binary state for the interval) and a required `BinaryScheduleType` (what the state means), initially `Availability` (equipment is enabled and permitted to operate) or `Operation` (equipment is scheduled on or off). The existing `PartialOperationPercentage` remains the fractional operating-level value, with its existing category-dependent meaning.

**Status: proposal only; neither the schema nor the validated XML examples are changed.** The generalized design (a binary value paired with a meaning qualifier in one container) is the preferred approach. Two lower-level design decisions remain open:

| Decision                             | Candidate A / 1              | Candidate B / 2                  | Status  |
| ------------------------------------ | ---------------------------- | -------------------------------- | ------- |
| Binary value encoding                | A: XML boolean               | B: `On`/`Off` text enumeration   | Pending |
| Relationship to operating percentage | 1: optional exclusive choice | 2: independent optional siblings | Pending |

All four combinations are candidates. Keeping two encodings in this proposal does **not** mean accepting both encodings in the eventual schema.

## Justification

### Use case

Issue #260 asks for a schedule that describes the ON/OFF operation of HVAC equipment. The [discussion that led to #260](https://github.com/BuildingSync/TestSuite/pull/37#discussion_r496136378) adds a closely related need: HVAC systems are _available or not available_, while HVAC components may partially operate. Today the only schedule value is [`PartialOperationPercentage`](../../BuildingSync.xsd#L1825-L1837), an unrestricted `xs:decimal` documented as 0–100 %. Producers must encode on/off as `100`/`0`, and consumers cannot tell whether such a schedule means "running at full load", "enabled to run", or "scheduled on". The meaning matters downstream:

- Audit tools and Audit Template-style exports report HVAC, lighting, and other equipment operating hours as on/off intervals. Several existing documents contain [time-only details](../../examples/AT_example_NYC_audit_report_property.xml#L4229-L4240), which suggest operating hours but do not state a value.
- Energy models represent HVAC on/off and availability with discrete 0/1 schedules (for example OpenStudio air-loop availability schedules), not fractional load profiles.
- ASHRAE Standard 211 Level 2 audits ask for HVAC operating schedules; today the [L200 rules](https://github.com/BuildingSync/use-cases/blob/main/ASHRAE_211/schematron/L200_Audit-1.0.0.sch) force a percentage on every schedule detail.

### Why a generalized binary schedule

A schedule of true/false values does not carry its own meaning. In EnergyPlus, an On/Off schedule gets its meaning from the object that references it (availability manager, fan operating mode, and so on). BuildingSync schedules are referenced generically, so the meaning must be stated in the data. Three options were considered:

| Option                                           | Shape                                                                                                                | Assessment                                                                                                                                     |
| ------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| **a. Binary value plus type qualifier (chosen)** | `BinarySchedule` per detail containing `BinaryValue` and `BinaryScheduleType` (`Availability`, `Operation`, `Other`) | One value element covers availability, ON/OFF operation, and future meanings. Consumers branch on one qualifier. Additive and non-breaking.    |
| b. Infer meaning from `ScheduleCategory`         | Binary value only                                                                                                    | No new qualifier, but category says _which equipment_, not _what kind of state_. HVAC availability and HVAC on/off would be indistinguishable. |
| c. One element per meaning                       | `ScheduleAvailability`, `ScheduleOperationStatus`, …                                                                 | Unambiguous, but the number of elements grows with each meaning and consumers must know them all.                                              |

Option (a) satisfies the ON/OFF request in #260 and the availability distinction from the original discussion without proliferating elements, and leaves room for other binary meanings.

### Scope of "schedule"

A schedule is planned or intended state. Observed, measured run status (for example from trend logs) belongs in `TimeSeries`, not `ScheduleType`. This proposal does not change that.

## Implementation

### Classification and compatibility

The eventual implementation is a **non-breaking MINOR addition** under [the versioning policy](../../docs/versioning.md), whichever combination is selected. The new `BinarySchedule` container is optional; its two children are required only inside the new container, so no existing document is affected. The proposal-only contribution has **No Schema Changes**.

Preserve every existing element's XML path, order relative to other existing elements, effective cardinality, type, attributes, and meaning. In particular, retain the complete existing `PartialOperationPercentage` declaration, including its unrestricted decimal value space, documentation, optionality, and optional `auc:Source`. An optional, single-occurrence XSD choice does not create an XML instance wrapper, so structure 1 also accepts every previously valid detail. No migration script is needed.

Backward compatibility for existing documents is not a promise that old schemas or downstream tools understand the new data; see [Potential consumers and adoption](#potential-consumers-and-adoption).

### New elements and paths

All paths are below `auc:BuildingSync/auc:Facilities/auc:Facility/auc:Schedules/auc:Schedule/auc:ScheduleDetails/auc:ScheduleDetail`:

| Element              | Relative path                               | Cardinality               |
| -------------------- | ------------------------------------------- | ------------------------- |
| `BinarySchedule`     | `auc:BinarySchedule`                        | 0..1 per detail           |
| `BinaryValue`        | `auc:BinarySchedule/auc:BinaryValue`        | 1..1 per `BinarySchedule` |
| `BinaryScheduleType` | `auc:BinarySchedule/auc:BinaryScheduleType` | 1..1 per `BinarySchedule` |

`BinarySchedule` extends the existing [ScheduleDetail](../../BuildingSync.xsd#L1748-L1851) at the current `PartialOperationPercentage` position (see the structure options). It reuses the detail's `DayType`, `ScheduleCategory`, `DayStartTime`, and `DayEndTime`, so no parallel detail structure is introduced. None of the three names was found in the current BuildingSync or cached gbXML schemas; repeat the collision checks against the implementation base.

Because both children are required inside the container:

- A meaning cannot appear without a binary value, and a binary value cannot appear without a meaning. A schedule whose details carry only `PartialOperationPercentage` cannot carry a stray `BinaryScheduleType`.
- The XSD cannot require all details in one schedule to use the same `BinaryScheduleType`. Producers should use one meaning per schedule and put availability and on/off data in separate schedules; use cases may enforce this with Schematron.

### `BinarySchedule`

```xml
<xs:element xmlns:xs="http://www.w3.org/2001/XMLSchema"
            xmlns:auc="http://buildingsync.net/schemas/bedes-auc/2019"
            name="BinarySchedule" minOccurs="0">
  <xs:annotation>
    <xs:documentation>Binary (on/off) schedule value for the interval of this schedule detail, with its meaning.</xs:documentation>
  </xs:annotation>
  <xs:complexType>
    <xs:sequence>
      <xs:element name="BinaryValue"><!-- encoding A or B, below --></xs:element>
      <xs:element name="BinaryScheduleType"><!-- below --></xs:element>
    </xs:sequence>
  </xs:complexType>
</xs:element>
```

### `BinaryScheduleType`

A required enumeration inside `BinarySchedule`, declared inline like other BuildingSync enumerations:

```xml
<xs:element xmlns:xs="http://www.w3.org/2001/XMLSchema"
            name="BinaryScheduleType">
  <xs:annotation>
    <xs:documentation>Meaning of the sibling BinaryValue.</xs:documentation>
  </xs:annotation>
  <xs:simpleType>
    <xs:restriction base="xs:string">
      <xs:enumeration value="Availability">
        <xs:annotation>
          <xs:documentation>True/On means the equipment is enabled and permitted to operate, subject to demand and other controls. It does not indicate that the equipment is running.</xs:documentation>
        </xs:annotation>
      </xs:enumeration>
      <xs:enumeration value="Operation">
        <xs:annotation>
          <xs:documentation>True/On means the equipment is scheduled to be on (operating); False/Off means it is scheduled to be off.</xs:documentation>
        </xs:annotation>
      </xs:enumeration>
      <xs:enumeration value="Other">
        <xs:annotation>
          <xs:documentation>Another binary meaning, described in UserDefinedFields.</xs:documentation>
        </xs:annotation>
      </xs:enumeration>
    </xs:restriction>
  </xs:simpleType>
</xs:element>
```

Rules:

- A building that needs both HVAC availability and HVAC on/off data uses two schedules, linked through the existing repeatable schedule references.
- `Occupancy` is not proposed: occupied/unoccupied is already expressed by the `Occupied`/`Unoccupied` schedule categories and occupancy density by `PartialOperationPercentage`. Further meanings can be added later as non-breaking enumeration values.

### `BinaryValue`

Common documentation:

> Binary state of the scheduled equipment during the interval. The meaning of the state is given by the sibling BinaryScheduleType.

Common rules:

- Optional `auc:Source` through `xs:simpleContent`, matching the existing provenance pattern. No `xs:complexContent`, `default`, `fixed`, or `nillable`.
- Do not derive the binary value from the operating percentage or the reverse. True/On under `Availability` does not imply 100 % operation; a zero percentage does not imply unavailable.
- Keep the existing day, category, time, and date metadata, `Schedule/@ID`, `auc:Status`, and links unchanged. No category is added or made mandatory.
- Do not redefine time boundaries, overlaps, gaps, or day-type precedence. Uncovered intervals are not implicitly false/Off.

#### Encoding A: XML boolean

```xml
<xs:element xmlns:xs="http://www.w3.org/2001/XMLSchema"
            xmlns:auc="http://buildingsync.net/schemas/bedes-auc/2019"
            name="BinaryValue">
  <xs:annotation>
    <xs:documentation>Binary state of the scheduled equipment during the interval. The meaning of the state is given by the sibling BinaryScheduleType. true and 1 mean on/available; false and 0 mean off/unavailable.</xs:documentation>
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

- **Accepted values:** `true`, `false`, `1`, `0`. Examples should prefer `true`/`false`.
- **Advantages:** standard type and native bindings; a meaning-neutral value pairs naturally with `BinaryScheduleType`.
- **Trade-offs:** four lexical forms for two states; a present `false` must not be treated as truthy text.

#### Encoding B: `On`/`Off` enumeration

Same element, with the value restricted to the exact labels `On` and `Off` through a named simple type `BinaryValueType` (restriction of `xs:string`) extended with `auc:Source`.

- **Advantages:** human-readable; matches the wording of #260; exported as an enumeration.
- **Trade-offs:** `On` reads awkwardly for `Availability` schedules ("On" meaning "available"); requires a custom type and explicit conversion to 0/1.

### Structure 1: optional exclusive choice

At the current `PartialOperationPercentage` position after `DayEndTime`, insert `xs:choice minOccurs="0" maxOccurs="1"` containing the unchanged `PartialOperationPercentage` declaration and the new `BinarySchedule`. Each detail carries a percentage, a binary schedule, or neither; both together and duplicates are rejected.

- **Advantages:** one value kind per detail; simple consumption.
- **Trade-offs:** reporting both a binary state and an operating level for the same interval requires separate schedules.

### Structure 2: independent optional siblings

Leave `PartialOperationPercentage` untouched and append optional `BinarySchedule` immediately after it. Neither, either, or both (percentage first) are allowed.

- **Advantages:** "available and operating at 40 %" fits in one detail.
- **Trade-offs:** consumers handle two quantities; inconsistent pairs (Off with a positive percentage) are not prevented by the XSD and need a consumer or use-case policy.

### Illustrative XML

The following **proposed fragment** (encoding A, either structure) is not valid against the unchanged current schema and is not a complete document:

```xml
<auc:Schedules xmlns:auc="http://buildingsync.net/schemas/bedes-auc/2019">
  <auc:Schedule ID="HVAC-OnOff">
    <auc:ScheduleDetails>
      <auc:ScheduleDetail>
        <auc:DayType>Weekday</auc:DayType>
        <auc:ScheduleCategory>HVAC equipment</auc:ScheduleCategory>
        <auc:DayStartTime>06:00:00</auc:DayStartTime>
        <auc:DayEndTime>18:00:00</auc:DayEndTime>
        <auc:BinarySchedule>
          <auc:BinaryValue auc:Source="Auditor">true</auc:BinaryValue>
          <auc:BinaryScheduleType>Operation</auc:BinaryScheduleType>
        </auc:BinarySchedule>
      </auc:ScheduleDetail>
      <auc:ScheduleDetail>
        <auc:DayType>Weekday</auc:DayType>
        <auc:ScheduleCategory>HVAC equipment</auc:ScheduleCategory>
        <auc:DayStartTime>18:00:00</auc:DayStartTime>
        <auc:DayEndTime>22:00:00</auc:DayEndTime>
        <auc:BinarySchedule>
          <auc:BinaryValue>false</auc:BinaryValue>
          <auc:BinaryScheduleType>Operation</auc:BinaryScheduleType>
        </auc:BinarySchedule>
      </auc:ScheduleDetail>
    </auc:ScheduleDetails>
  </auc:Schedule>
  <auc:Schedule ID="HVAC-Availability">
    <auc:ScheduleDetails>
      <auc:ScheduleDetail>
        <auc:DayType>Weekday</auc:DayType>
        <auc:ScheduleCategory>HVAC equipment</auc:ScheduleCategory>
        <auc:DayStartTime>05:00:00</auc:DayStartTime>
        <auc:DayEndTime>20:00:00</auc:DayEndTime>
        <auc:BinarySchedule>
          <auc:BinaryValue>true</auc:BinaryValue>
          <auc:BinaryScheduleType>Availability</auc:BinaryScheduleType>
        </auc:BinarySchedule>
      </auc:ScheduleDetail>
    </auc:ScheduleDetails>
  </auc:Schedule>
</auc:Schedules>
```

For encoding B, replace `true`/`false` with `On`/`Off`. Both schedules can be linked from a thermal zone through the existing [HVACScheduleIDs](../../BuildingSync.xsd#L1545-L1558) container:

```xml
<auc:HVACScheduleIDs xmlns:auc="http://buildingsync.net/schemas/bedes-auc/2019">
  <auc:HVACScheduleID IDref="HVAC-OnOff"/>
  <auc:HVACScheduleID IDref="HVAC-Availability"/>
</auc:HVACScheduleIDs>
```

### Potential consumers and adoption

| Consumer                                                    | Expected use                                                                                                                                                                                                                                                                                                                    | Current state and follow-up                                                                                                                                                                                                                                                                                                                                                    |
| ----------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **BOSS → OpenStudio (primary)**                             | Translate binary schedules to discrete 0/1 schedules (`ScheduleTypeLimits` On/Off) and apply them as `AirLoopHVAC`/plant-loop availability schedules, zone HVAC and terminal availability, fan operating-mode (continuous vs. cycling) schedules, exhaust fan and DHW recirculation availability, and exterior lighting on/off. | BOSS runtime schedule handling was not verified (searches found only XML fixtures). Follow-up: forward `BinarySchedule` (`BinaryValue`, `BinaryScheduleType`) in the payload BOSS builds.                                                                                                                                                                                      |
| **buildingsync-measures-gem**                               | `ModifySchedules` applies schedules to the model, including `hvac_availability_schedule_json` → `setAvailabilitySchedule`.                                                                                                                                                                                                      | [ModifySchedules](https://github.com/BuildingSync/buildingsync-measures-gem/blob/develop/lib/measures/modify_schedules/measure.rb) parses only numeric `value_percent`/`partialoperationpercentage`/`value`/`fraction`, divides percentages by 100, and uses Continuous fraction limits. Follow-up: a binary path with discrete limits that bypasses percentage normalization. |
| **use-cases (ASHRAE 211 L200)**                             | Require HVAC operating schedules as `Operation` binary schedules instead of percentages.                                                                                                                                                                                                                                        | [L200 rules](https://github.com/BuildingSync/use-cases/blob/main/ASHRAE_211/schematron/L200_Audit-1.0.0.sch) require `PartialOperationPercentage` on every detail. Follow-up: version-aware, category-aware rules; occupancy still needs percentages.                                                                                                                          |
| **Audit Template / LL87 / other audit exports**             | Report equipment operating hours as explicit On/Off intervals instead of time-only details.                                                                                                                                                                                                                                     | Producer adoption; not verified.                                                                                                                                                                                                                                                                                                                                               |
| **BuildingSync-asset-extractor / SEED / Portfolio Manager** | Derive weekly operating hours by summing On intervals of `Operation` schedules.                                                                                                                                                                                                                                                 | No schedule reader verified; confirm before planning changes.                                                                                                                                                                                                                                                                                                                  |
| **bsyncr / NMEC**                                           | Occupied/operating-mode indicators as regression inputs.                                                                                                                                                                                                                                                                        | Plausible; not verified.                                                                                                                                                                                                                                                                                                                                                       |
| **Generated clients and BuildingSync-website**              | Bindings, viewer, validator, enumeration export.                                                                                                                                                                                                                                                                                | Require the released schema; verify after release.                                                                                                                                                                                                                                                                                                                             |

Do not generate placeholder percentages to satisfy percentage-only consumers.

### Verification and acceptance criteria

After the design is selected, add focused regression contexts to [the validation spec](../../spec/validation_spec.rb) and one complete linked example. Construct invalid cases in tests rather than committing failing examples.

| Area                   | Expected checks                                                                                                                                                                                 |
| ---------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Legacy                 | All existing examples remain valid unchanged, including time-only details and small decimal percentages.                                                                                        |
| `BinarySchedule`       | Accept with both children in order; reject a missing `BinaryValue` or `BinaryScheduleType`, reversed order, duplicates, and `BinaryScheduleType` directly under `Schedule` or `ScheduleDetail`. |
| `BinaryScheduleType`   | Accept `Availability`, `Operation`, `Other`; reject other values and wrong casing.                                                                                                              |
| Encoding A             | Accept `true`, `false`, `1`, `0`; reject `2`, `0.5`, `True`, `On`, empty, and `xsi:nil`.                                                                                                        |
| Encoding B             | Accept only `On`, `Off`; reject `true`, `1`, `on`, `Available`, empty, and `xsi:nil`.                                                                                                           |
| Structure 1            | Reject percentage and `BinarySchedule` together; accept either alone or neither.                                                                                                                |
| Structure 2            | Accept both with percentage first; reject reversed order and duplicates.                                                                                                                        |
| Provenance and context | Valid `auc:Source` accepted, invalid rejected; IDs, links, dates/times, and `Status` unchanged.                                                                                                 |

Implementation checks: `bundle exec rake remove_tabs`, `bundle exec rake`, `bundle exec rake generate_data_dictionary`, and `poetry run pre-commit run --all-files`. Do not commit generated artifacts.

### Decision and scope

- **Chosen approach:** generalized binary value plus meaning qualifier (option a), paired in a `ScheduleDetail/BinarySchedule` container.
- **Pending:** value encoding (A or B) and structure (1 or 2).
- **Labels:** `No Schema Changes` for the proposal-only PR; `Non-breaking Change` and `Schema: General` for the implementation. Reference #260 without closing it in the proposal PR.
- **Out of scope:** measured run status (`TimeSeries`); changing or bounding percentage data; generalized numeric/temperature schedule types; interval/gap redesign; new links; version/changelog edits; external repository changes.

## References

- [BuildingSync/schema issue #260](https://github.com/BuildingSync/schema/issues/260).
- [Original availability-versus-operation discussion in TestSuite #37](https://github.com/BuildingSync/TestSuite/pull/37#discussion_r496136378).
- [BuildingSync versioning](../../docs/versioning.md).
- [BuildingSync proposal process](../README.md).
- [Existing schedule linking definitions](../../docs/linking_elements.md).
