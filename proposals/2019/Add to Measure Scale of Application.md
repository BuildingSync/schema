# MeasureScaleOfApplication - Add Enumerations

## Overview

The `auc:MeasureScaleOfApplication` element does not have enumerations for common areas and tenant areas.

## Justification

In Audit Template, for each measure, the affected portions of the building are identified as being either:
* Common areas,
* Tenant areas, or
* Entire building.

Currently, only "Entire building" is supported in BuildingSync XML.

## Implementation

This proposal is to add the following enumeration values to the `auc:MeasureScaleOfApplication` element:
* "Common areas"
* "Tenant areas"

## References

n/a
