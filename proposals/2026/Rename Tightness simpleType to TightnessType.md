# Rename Tightness simpleType to TightnessType

## Overview

This proposal renames the global `xs:simpleType` `auc:Tightness` to `auc:TightnessType` so that it no longer shares a name with the element `auc:Tightness`. It addresses [issue #428](https://github.com/BuildingSync/schema/issues/428).

## Justification

The schema currently defines both an element and a simple type named `Tightness`:

- Element: `auc:AirInfiltrationSystem/auc:Tightness` with `type="auc:Tightness"`
- Element: `auc:FenestrationSystemType/auc:TightnessFitCondition` with `type="auc:Tightness"`
- Simple type: `<xs:simpleType name="Tightness">`

XSD allows elements and types to share a name because they live in separate symbol spaces, but the duplication:

- causes name collisions in tools that generate code or documentation from the schema (e.g. classes for both the element and the type in a single namespace);
- is inconsistent with the schema's naming convention, where named types carry a `Type` suffix (e.g. `SiteType`, `HVACSystemType`);
- makes the schema harder to read, because `type="auc:Tightness"` looks like a reference to the element.

## Implementation

Rename the simple type and update its two references in `BuildingSync.xsd`:

```xml
<xs:simpleType name="TightnessType">
  <xs:restriction base="xs:string">
    <xs:enumeration value="Very Tight"/>
    <xs:enumeration value="Tight"/>
    <xs:enumeration value="Average"/>
    <xs:enumeration value="Leaky"/>
    <xs:enumeration value="Very Leaky"/>
    <xs:enumeration value="Unknown"/>
  </xs:restriction>
</xs:simpleType>
```

- `auc:AirInfiltrationSystem/auc:Tightness`: `type="auc:Tightness"` -> `type="auc:TightnessType"`
- `auc:FenestrationSystemType/auc:TightnessFitCondition`: `type="auc:Tightness"` -> `type="auc:TightnessType"`

The enumeration values, element names, element locations, and documentation are unchanged.

### Classification

Patch-level per [docs/versioning.md](../../docs/versioning.md): type names do not appear in instance documents, so every document that validated before still validates and vice versa. No migration script is needed.

Downstream tools that generate code from XSD type names (e.g. [bsyncpy](https://github.com/BuildingSync/bsyncpy)) may see the generated class for this type renamed from `Tightness` to `TightnessType`, and should be regenerated against the new schema.

## References

- [Issue #428](https://github.com/BuildingSync/schema/issues/428)
