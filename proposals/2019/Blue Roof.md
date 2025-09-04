# Add Blue Roof to SpecialRoofClassification

## Overview

The schema needs to be extended to allow for Blue Roof classification.

```xml
	<xs:enumeration value="Cool roof"/>
	<xs:enumeration value="Green roof"/>
	<xs:enumeration value="Other"/>
```

## Justification

For Local Law 87 the auditor is able to select a Blue Roof. There needs to exist a place in the schema for this request as it is expected to expand beyond the scope of LL87.

## Implementation

Add the following to the SpecialRoofClassification located at `BuildingSync/Facilities/Facility/Systems/RoofSystems/RoofSystem/SpecialRoofClassification`

```xml
<xs:enumeration value="Blue roof"/>
```

## References

N/A
