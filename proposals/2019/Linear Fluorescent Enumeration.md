# Linear Fluorescent Enumeration

## Overview

There are no T12 High Output lighting fixtures

## Justification

T12 High Output lighting systems exist and need to be added. Current enumerations at BuildingSync/Facilities/Facility/Systems/LightingSystems/LightingSystem/LampType/LinearFluorescent/LampLabel are:

```xml
	<xs:enumeration value="Super T8"/>
	<xs:enumeration value="T12"/>
	<xs:enumeration value="T5"/>
	<xs:enumeration value="T5HO"/>
	<xs:enumeration value="T8"/>
	<xs:enumeration value="T12U"/>
	<xs:enumeration value="T8U"/>
	<xs:enumeration value="Other"/>
	<xs:enumeration value="Unknown"/>
```

## Implementation

The new elements will be:

```xml
	<xs:enumeration value="T12HO"/>
```

## References

https://www.lightbulbsdirect.com/t12ho
