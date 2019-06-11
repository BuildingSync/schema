# Add User-Defined Fields to CondenserPlant

## Overview

There is no user-defined fields section under the CondenserPlant path.  

For consistency, user-defined fields should be added for all plants:  HeatingPlants, CoolingPlants, and CondenserPlants

## Justification

There exists a need for certain users to add user-defined fields (such as “PlantName”, “PlantNotes”, “SourceName”, and “SourceNotes” attributes) under the CondenserPlant path.  This is what the UserDefinedFields schema section is for.

## Implementation

This proposal is to:
1. Add the following elements under path BuildingSync/Facilities/Facility/Systems/HVACSystems/HVACSystem/Plants/CondenserPlants/CondenserPlant/:
	1. UserDefinedFields
	2. UserDefinedFields/UserDefinedField
	3. UserDefinedFields/UserDefinedField/FieldName
	4. UserDefinedFields/UserDefinedField/FieldValue

2. Add the following elements under path BuildingSync/Facilities/Facility/Systems/HVACSystems/HVACSystem/Plants/CoolingPlants/CoolingPlant/:
	1. UserDefinedFields
	2. UserDefinedFields/UserDefinedField
	3. UserDefinedFields/UserDefinedField/FieldName
	4. UserDefinedFields/UserDefinedField/FieldValue

3. Add the following elements under path BuildingSync/Facilities/Facility/Systems/HVACSystems/HVACSystem/Plants/HeatingPlants/HeatingPlant/:
	1. UserDefinedFields
	2. UserDefinedFields/UserDefinedField
	3. UserDefinedFields/UserDefinedField/FieldName
	4. UserDefinedFields/UserDefinedField/FieldValue

## References

N/A
