# Rename OnSite and On-site to Onsite

## Overview

It was discovered that we are inconsistently using OnSite, On-site, and Onsite.

## Justification

There is a general need to keep BuildingSync consistent and this needs to be addressed. These will be breaking changes.

## Implementation

Rename elements that have OnSite to Onsite. This follows the BEDES definition of Onsite.

This impacts the following paths:

* BuildingSync/Facilities/Facility/Systems/OnsiteStorageTransmissionGenerationSystems/OnsiteStorageTransmissionGenerationSystem
* BuildingSync/Facilities/Facility/Systems/OnsiteStorageTransmissionGenerationSystems/OnsiteStorageTransmissionGenerationSystem/EnergyConversionType/Generation/OnsiteGenerationType
* Enum in auc:BuildingSync/auc:Facilities/auc:Facility/auc:Measures/auc:Measure/auc:SystemCategoryAffected
* Enum in auc:BuildingSync/auc:Facilities/auc:Facility/auc:Measures/auc:Measure/auc:TechnologyCategories/auc:TechnologyCategory/auc:WaterAndSewerConservationSystems/auc:MeasureName
* Various annotations

## References

https://bedes.lbl.gov/bedes-online/onsite
