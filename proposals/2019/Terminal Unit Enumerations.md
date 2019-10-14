# Update TerminalUnit Enumerations

## Overview

Add new terminal unit enumerations. The current list of enums on BuildingSync/Facilities/Facility/Systems/HVACSystems/HVACSystem/HeatingAndCoolingSystems/Deliveries/Delivery/DeliveryType/CentralAirDistribution/TerminalUnit are:

```xml
	<xs:enumeration value="CAV terminal box with reheat"/>
	<xs:enumeration value="VAV terminal box fan powered no reheat"/>
	<xs:enumeration value="VAV terminal box fan powered with reheat"/>
	<xs:enumeration value="VAV terminal box not fan powered no reheat"/>
	<xs:enumeration value="VAV terminal box not fan powered with reheat"/>
	<xs:enumeration value="Automatically controlled register"/>
	<xs:enumeration value="Manually controlled register"/>
	<xs:enumeration value="Uncontrolled register"/>
	<xs:enumeration value="Other"/>
	<xs:enumeration value="Unknown"/>
```

## Justification

For mapping between New York LL87 and Asset Score using BuildingSync there needs to exist a CAV terminal box without reheat and a powered induction terminal unit.

## Implementation

Add the following enumerations:

```xml
	<xs:enumeration value="CAV terminal box no reheat"/>
	<xs:enumeration value="Powered induction unit"/>
```

## References

N/A

