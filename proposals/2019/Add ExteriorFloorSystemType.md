# ExteriorFloorSystemType - Add New Element

## Overview

> "**EXTERIOR FLOOR/SOFFIT** is a horizontal exterior partition, or a horizontal demising partition, under conditioned space. For low-rise residential occupancies, exterior floors also include those on grade." [1]

Or simply put: A raised floor exposed to air.

## Justification

Currently, BuildingSync does not support the description of exterior floors.

## Implementation

This proposal is to:

1. Reify the following elements so that they can be reused:
   - `auc:Finish`
   - `auc:Color`
   - `auc:FramingMaterial`
   - `auc:ExteriorRoughness`

2. Add an `auc:ExteriorFloorSystemType` element with `@ID` and `@Status` attributes and the following child elements:
   - `ExteriorFloorConstruction` &rarr; `auc:EnvelopeConstructionType`
   - `ExteriorFloorFinish` &rarr; `auc:Finish`
   - `ExteriorFloorColor` &rarr; `auc:Color`
   - `ExteriorFloorRValue`
   - `ExteriorFloorUFactor`
   - `ExteriorFloorFramingMaterial` &rarr; `auc:FramingMaterial`
   - `ExteriorFloorFramingSpacing`
   - `ExteriorFloorFramingDepth`
   - `ExteriorFloorFramingFactor`
   - `ExteriorFloorExteriorSolarAbsorptance`
   - `ExteriorFloorExteriorThermalAbsorptance`
   - `InteriorVisibleAbsorptance`
   - `ExteriorRoughness` &rarr; `auc:ExteriorRoughness`
   - `Quantity` &rarr; `auc:Quantity`
   - `YearInstalled` &rarr; `auc:YearInstalled`
   - `UserDefinedFields` &rarr; `auc:UserDefinedFields`

3. Add an `auc:ExteriorFloorSystems` element to the `auc:Systems` element.

4. Add an `auc:ExteriorFloors` element to the `auc:Section` element.

## References

1. [2016 BUILDING ENERGY EFFICIENCY STANDARDS / Efficiency Standards, California Code of Regulations, Title 24, Part 6 / Subchapter 1 - All Occupancies—General Provisions / SECTION 100.1 – DEFINITIONS AND RULES OF CONSTRUCTION](https://energycodeace.com/site/custom/public/reference-ace-2016/index.html#!Documents/section1001definitionsandrulesofconstruction.htm)
