# Update FenestrationGasFill Enumerations

## Overview

Presently there are several types of fenestration gas fill types including Other and Unknown; however, there is not a *None* enumeration. Current list of enumerations are:

```xml
	<xs:enumeration value="Argon"/>
	<xs:enumeration value="Krypton"/>
	<xs:enumeration value="Other Insulating Gas"/>
	<xs:enumeration value="Air"/>
	<xs:enumeration value="Other"/>
	<xs:enumeration value="Unknown"/>
```

## Justification

It is currently assumed that if there is no FenerationGasFill element in the schema, then there is no gas fill in the window. It is ideal to be explicit in specifying this and will make mapping easier for users of the schema.


## Implementation

Proposing to add the following to the path BuildingSync/Facilities/Facility/Systems/FenestrationSystems/FenestrationSystem/FenestrationGasFill.

```xml
	<xs:enumeration value="None"/>
```

## References

N/A

