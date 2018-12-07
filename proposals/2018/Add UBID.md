# Add UBID to the set of IdentifierLabels

## Overview


The BuildingSync XML (BSync) schema has several identifiers for buildings shown below. The purpose of this proposal
would be to add UBID as an enumeration.


```xml
    <xs:element name="IdentifierLabel">
		<xs:annotation>
			<xs:documentation>Identifier used in a specific program or dataset. There can be multiple instances of Identifier Types within a dataset, such as a Listing ID, a Tax Map Number ID, and a Custom ID.</xs:documentation>
		</xs:annotation>
		<xs:simpleType>
			<xs:restriction base="xs:string">
				<xs:enumeration value="Premises"/>
				<xs:enumeration value="Listing"/>
				<xs:enumeration value="Name"/>
				<xs:enumeration value="Portfolio Manager Property ID"/>
				<xs:enumeration value="Portfolio Manager Standard"/>
				<xs:enumeration value="Federal real property"/>
				<xs:enumeration value="Tax book number"/>
				<xs:enumeration value="Tax map number"/>
				<xs:enumeration value="Assessor parcel number"/>
				<xs:enumeration value="Tax parcel letter"/>
				<xs:enumeration value="Custom"/>
				<xs:enumeration value="Other"/>
			</xs:restriction>
		</xs:simpleType>
	</xs:element>
```

## Justification

The UBID is becoming the defacto standard for defining the location of a building/facility. Adding the UBID to the list will give users the ability to enter the UBID without using the `IdentifierCustomName` object.

## Implementation

This proposal is:
1. To add the following enumeration to the IdentifierLabel element.

    ```xml
    <xs:enumeration value="UBID"/>
    ```

## References

More information on the UBID can be found [here](https://buildingid.pnnl.gov/)
