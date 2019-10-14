# MeasureScaleOfApplication - Add Enumerations

## Overview

The percentage of dwellings occupied (or any spatial unit) is not defined. 

## Justification

Standard 211 requests the percentage of multifamily dwellings that are occupied.

## Implementation

Since the spatial unit is a complex type, this will be a new element in the complex type.

The new element name will be SpatialUnitOccupiedPercentage similar to the FloorAreaPercentage. 

```
//element(*,auc:BuildingType)/auc:SpatialUnits/auc:SpatialUnit/auc:SpatialUnitOccupiedPercentage
```

## References

n/a
