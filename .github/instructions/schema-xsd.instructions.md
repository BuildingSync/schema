---
applyTo: "BuildingSync.xsd"
description: "Conventions for editing the BuildingSync XSD"
---

# Editing BuildingSync.xsd

Read the surrounding region first and keep edits minimal; do not reformat unrelated content. Classify the change (breaking / non-breaking / patch, per [docs/versioning.md](../../docs/versioning.md)) before editing.

## Structure

- Indent with 2 spaces, never tabs; no XMLSpy comments (run `bundle exec rake remove_tabs` after editing).
- Never use `xs:complexContent` (test-enforced); compose with named types, `xs:sequence`, and `ref`.
- New elements are optional (`minOccurs="0"`) unless a breaking change is intended and approved.
- Inserting a new optional element into an `xs:sequence` is fine; moving or reordering existing elements is breaking.
- `xs:element` names must be unique across the schema. To reuse a structure, define a named `xs:complexType`/`xs:simpleType` (suffix `Type`) or a global element used via `ref="auc:..."`.
- Global names must not collide with gbXML global names.
- Do not modify the header (`version` attribute, title documentation, root `version` enumeration) outside a release; see [docs/release_instructions.md](../../docs/release_instructions.md).

## Documentation

- Every new element, type, and enumeration-bearing element gets `<xs:annotation><xs:documentation>`.
- Write a clear definition sentence; put units in parentheses at the end, e.g. `... gross floor area. (ft2)`, `(kBtu/ft2)`, `($)`, `(cfm)`, `(W/ft2)`.
- Documentation-only changes are patch-level.

## Enumerations

- Adding a value is non-breaking; removing or renaming one is breaking (deprecate instead).
- Follow the existing wording/casing style of sibling values; include `Other` and `Unknown` where siblings do.

## Common patterns

- Identity: `<xs:attribute name="ID" type="xs:ID" use="required"/>`.
- Links: element with `<xs:attribute name="IDref" type="xs:IDREF" use="required"/>`; document the valid target in [docs/linking_elements.md](../../docs/linking_elements.md).
- Data provenance: `<xs:attribute ref="auc:Source"/>`; system state: `ref="auc:Status"`.
- Extensibility: `<xs:element ref="auc:UserDefinedFields" minOccurs="0"/>`.
- gbXML content uses the `gbxml` prefix (see [docs/gbXML_reference.md](../../docs/gbXML_reference.md)).

## Deprecation

- Never remove elements outside a major version (XSD header Rule #1).
- Mark deprecated items in documentation: `WARNING: This element is being deprecated, use <Replacement> instead.` (for enum values: `WARNING: This enumeration is being deprecated, use ... instead`).
- Update examples to use the replacement.

## Verify

`bundle exec rake` and `bundle exec rake generate_data_dictionary` must pass.
