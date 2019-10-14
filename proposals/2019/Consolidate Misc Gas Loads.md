# Consolidate Miscellaneous Gas Loads

## Overview
The current schema has miscellaneous gas loads and process loads in the same list and uses the name `ProcessLoadType` twice. This proposal consolidates the two types and renames the XML type so there is no repeated use. This is a breaking change.

## Justification
The current organization is not consistent with the rest of the schema and the repeated use of the name trips up some automatic processors.

## Implementation
The following changes will be made to `ProcessLoadType` so that the information that was previously represented by the `MiscellaneousGasLoad` element can be fully represented.

  1. The XSD complex type `ProcessLoadType` will be renamed to `ProcessGasElecLoadType`, which eliminates the double use of `ProcessLoadType`. This is not a breaking change because the XSD type is not visible to the user in this case. 
  2. Add an element to represent weighted average process loads in W/ft2. Note that the previous miscellaneous gas load element was represented in kBtu/ft2 and we are proposing to change it to W/ft2 to stay consistent with other elements in the `ProcessGasElecLoadType`.
  3. Add `Miscellaneous Gas Load` to the `ProcessLoadType` enumeration,
  4. Add `Source` attributes to both the `PlugLoadType` and `ProcessGasElecLoadType`

The `MiscellaneousGasLoad` element will be removed. This is a breaking change.
