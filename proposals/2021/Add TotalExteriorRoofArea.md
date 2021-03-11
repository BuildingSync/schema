# Add TotalExteriorRoofArea to Building

## Overview

This proposal is to add the `TotalExteriorRoofArea` element as a child of `Building` element. 

## Justification

Although RoofArea of individual roof types can currently be captured via `Section[SectionType/text() = 'Whole building']/Roofs/Roof/RoofID/RoofArea`, there is no way to capture the aggrergated roof area. This mirrows existing implementations for walls (`Building/TotalExteriorAboveGradeWallArea`).

## Example

Currently this is conveyed in Audit Template via:
`/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building/auc:UserDefinedFields/auc:UserDefinedField[auc:FieldName/text() = Roof Area]/auc:FieldValue`.
Our proposal is to add it under a `Building` such as:

```xml
    <auc:Facilities>
        <auc:Facility ID="F1">
            <auc:Buildings>
                <auc:Building ID="G1">
                    <auc:TotalExteriorRoofArea>3000</auc:TotalExteriorRoofArea>
                </auc:Building>
            </auc:Buildings>
        </auc:Facility>
    </auc:Facilities>
```

## Implementation

```xml

      <xs:element name="Buildings" minOccurs="0">
        <xs:complexType>
          <xs:sequence>
            <xs:element name="Building" type="auc:BuildingType" maxOccurs="unbounded">
              <xs:annotation>
                <xs:documentation>A building is a single structure wholly or partially enclosed within exterior walls, or within exterior and abutment walls (party walls), and a roof, affording shelter to persons, animals, or property. A building can be two or more units held in the condominium form of ownership that are governed by the same board of managers.</xs:documentation>
              </xs:annotation>
            </xs:element>
          </xs:sequence>
        </xs:complexType>
      </xs:element>
      ...
      <xs:element name="TotalExteriorRoofArea" minOccurs="0">
        <xs:annotation>
          <xs:documentation>Total roof area exposed to the elements. (ft2)</xs:documentation>
        </xs:annotation>
        <xs:complexType>
          <xs:simpleContent>
            <xs:extension base="xs:decimal">
              <xs:attribute ref="auc:Source"/>
            </xs:extension>
          </xs:simpleContent>
        </xs:complexType>
      </xs:element>
      ...
```

## References