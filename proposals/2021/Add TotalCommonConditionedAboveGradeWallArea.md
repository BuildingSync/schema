# Add TotalCommonConditionedAboveGradeWallArea

## Overview

This proposal is to add the `TotalCommonConditionedAboveGradeWallArea` child element under the `Building` element. This captures the total area of the above grade wall common with other conditioned buildings.

## Justification

Audit Template Tool defines demising wall as the total area of the above grade wall common with other conditioned buildings, as an overall building characteristic. However, the term demising wall has conflicting definition in other standards (such as interior partitions). To avoid ambiguity, we adopt the descriptive name `TotalCommonConditionedAboveGradeWallArea` instead of `DemisingAboveGradeWallArea`.

### UDFs

Currently, this is conveyed in Audit template via: `/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building/auc:UserDefinedFields/auc:UserDefinedField[auc:FieldName/text() = Demising Above Grade Wall Area]/auc:FieldValue`. Our proposal is that it would rather look like:

```xml

    <Facilities>
        <Facility ID="F1">
            <Sites>
                <Site>
                    <Buildings>
                        <Building ID="G1">
                            <TotalCommonConditionedAboveGradeWallArea>1000</TotalCommonConditionedAboveGradeWallArea>
                        </Building>
                    </Buildings>
                </Site>
            </Sites>
        </Facility>
    </Facilities>

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
      <xs:element name="TotalCommonConditionedAboveGradeWallArea" minOccurs="0">
        <xs:annotation>
          <xs:documentation>The total area of the above grade wall common with other conditioned buildings. (ft2)</xs:documentation>
        </xs:annotation>
        <xs:complexType>
          <xs:simpleContent>
            <xs:extension base="auc:nonNegativeDecimal">
              <xs:attribute ref="auc:Source"/>
            </xs:extension>
          </xs:simpleContent>
        </xs:complexType>
      </xs:element>
    ...
```

## References

https://help.buildingenergyscore.com/support/solutions/articles/8000053362-facility-description-construction (even though their usage of the term demising wall is incorrect)
ASHRAE Standard 211 6.2.1.2.b
