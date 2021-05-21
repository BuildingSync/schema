# Add SpatialUnits to Section

## Overview

This proposal is to add the `SpatialUnits/SpatialUnit` element sets as a child of a `Section`. It entails breaking out the current `SpatialUnit` element into a standalone complex type for reuse, which, upon implementation, will have no change in the current usage of `SpatialUnit` at the building level, i.e. it is a non-breaking change.

## Justification

In mixed use real-estate, a particular section of a building might be designated for multi-family residential. A user would then want to associate spatial units specifically to that section of the building rather than the building at a whole. Currently, we are able to define spatial units at the building level, but not at any other level of the premise.

## Example
```xml
          <auc:Buildings>
            <auc:Building ID="b1">
            <auc:OccupancyClassification>Mixed-use commercial</auc:OccupancyClassification>
            <!-- SpatialUnit at the building level remains the same -->
              <auc:SpatialUnits>
                <auc:SpatialUnit>
                  <auc:NumberOfUnits>1</auc:NumberOfUnits>
                </auc:SpatialUnit>
              </auc:SpatialUnits>
              <auc:Sections>
                <auc:Section ID="S1">
                  <auc:SectionType>Space function</auc:SectionType>
                  <auc:OccupancyClassification>Multifamily</auc:OccupancyClassification>
                  <!-- SpatialUnit added at the Section level -->
                  <auc:SpatialUnits>
                    <auc:SpatialUnit>
                      <auc:NumberOfUnits>1</auc:NumberOfUnits>
                    </auc:SpatialUnit>
                  </auc:SpatialUnits>
                </auc:Section>
              </auc:Sections>
            </auc:Building>
```

## Implementation

The current `SpatialUnit` element is broken out into a standalone complex type as `SpatialUnitTypeType`
```xml
<xs:complexType name="SpatialUnitTypeType">
    <xs:sequence>
      <xs:element name="SpatialUnitType" minOccurs="0">
        <xs:annotation>
          <xs:documentation>Unit type within the premises.</xs:documentation>
        </xs:annotation>
        <xs:simpleType>
          <xs:restriction base="xs:string">
            <xs:enumeration value="Lots"/>
            <xs:enumeration value="Parking spaces"/>
            <xs:enumeration value="Apartment units"/>
            <xs:enumeration value="Businesses"/>
            <xs:enumeration value="Guest rooms"/>
            <xs:enumeration value="Stations"/>
            <xs:enumeration value="Buildings"/>
            <xs:enumeration value="Areas"/>
            <xs:enumeration value="Thermal Zones"/>
            <xs:enumeration value="Floors"/>
            <xs:enumeration value="Rooms"/>
            <xs:enumeration value="Bedrooms"/>
            <xs:enumeration value="Other"/>
            <xs:enumeration value="Unknown"/>
          </xs:restriction>
        </xs:simpleType>
      </xs:element>
      <xs:element name="NumberOfUnits" minOccurs="0">
        <xs:annotation>
          <xs:documentation>Number of individual units within the premises.</xs:documentation>
        </xs:annotation>
        <xs:complexType>
          <xs:simpleContent>
            <xs:extension base="xs:integer">
              <xs:attribute ref="auc:Source"/>
            </xs:extension>
          </xs:simpleContent>
        </xs:complexType>
      </xs:element>
      <xs:element name="UnitDensity" minOccurs="0">
        <xs:annotation>
          <xs:documentation>Number of units per 1,000 square feet.</xs:documentation>
        </xs:annotation>
        <xs:complexType>
          <xs:simpleContent>
            <xs:extension base="xs:decimal">
              <xs:attribute ref="auc:Source"/>
            </xs:extension>
          </xs:simpleContent>
        </xs:complexType>
      </xs:element>
      <xs:element name="SpatialUnitOccupiedPercentage" minOccurs="0">
        <xs:annotation>
          <xs:documentation>Percentage of the spatial units that are occupied. (0-100) (%)</xs:documentation>
        </xs:annotation>
        <xs:complexType>
          <xs:simpleContent>
            <xs:extension base="xs:decimal"/>
          </xs:simpleContent>
        </xs:complexType>
      </xs:element>
    </xs:sequence>
  </xs:complexType>
```

At the Building and Section level, the implementation then looks like:
```xml
    ...
      <xs:element name="SpatialUnits" minOccurs="0">
        <xs:complexType>
          <xs:sequence>
            <xs:element name="SpatialUnit" type="auc:SpatialUnitTypeType" minOccurs="1" maxOccurs="unbounded"/>
          </xs:sequence>
        </xs:complexType>
      </xs:element>
    ...
```

## References
