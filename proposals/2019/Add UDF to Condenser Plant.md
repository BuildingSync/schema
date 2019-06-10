# Add User-Defined Fields to CondenserPlant

## Overview

There is no user-defined fields section under the CondenserPlant path

## Justification

There exists a need for certain users to add user-defined fields (such as “PlantName”, “PlantNotes”, “SourceName”, and “SourceNotes” attributes) under the CondenserPlant path.  This is what the UserDefinedFields schema section is for.

## Implementation

This proposal is to:
1. Add BuildingSync/Facilities/Facility/Systems/HVACSystems/HVACSystem/Plants/CondenserPlants/CondenserPlant/UserDefinedFields element.
2. Add BuildingSync/Facilities/Facility/Systems/HVACSystems/HVACSystem/Plants/CondenserPlants/CondenserPlant/UserDefinedFields/UserDefinedField element.
2. Add BuildingSync/Facilities/Facility/Systems/HVACSystems/HVACSystem/Plants/CondenserPlants/CondenserPlant/UserDefinedFields/UserDefinedField/FieldName element.
3. Add BuildingSync/Facilities/Facility/Systems/HVACSystems/HVACSystem/Plants/CondenserPlants/CondenserPlant/UserDefinedFields/UserDefinedField/FieldValue element.

## References

N/A
