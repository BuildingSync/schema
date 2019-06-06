# Consolidate MEL and Plug Load Elements

## Overview
The current schema has MELs and plug loads in the same list and uses the name `PlugLoadType` twice. This proposal consolidates the two types and renames the XML type so there is no repeated use. This is a breaking change.

## Justification
The current organization is not consistent with the rest of the schema and the repeated use of the name trips up some automatic processors.

## Implementation
The XSD complex type `PlugLoadType` will be renamed to `PlugElectricLoadType`, which eliminates the double use of `PlugLoadType`. This is not a breaking change because the XSD type is not visible to the user in this case.

Next, two changes will be made to `PlugElectricLoadType` so that the information that was previously represented by the `MiscellaneousElectricLoad` element can be fully represented.

  1. Add an element to represent weighted average electric loads in W/ft2
  2. Add `Miscellaneous Electric Load` to the `PlugLoadType` enumeration

Finally, the `MiscellaneousElectricLoad` element will be removed. This is a breaking change.
