# Add DemisingAboveGradeWallArea

## Overview

This proposal is to add the `DemisingAboveGradeWallArea` child element to the `Building` element. Demising wall is defined as the envelope for spaces adjacent to unenclosed spaces. The added element captures the amount of "exterior / semi-exterior" wall area of a building that separates conditioned space from unconditioned space.

## Justification

Audit Template Tool defines demising wall as (internal) partition that separates tenant spaces from common areas. However, we adopt the definition of demising wall in the ASHRAE Standard 90.1-2010 Performance Rating Method Reference Manual, as described above.

### UDFs
Currently, this is conveyed in Audit template via: `/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building/auc:UserDefinedFields/auc:UserDefinedField[auc:FieldName/text() = Demising Above Grade Wall Area]/auc:FieldValue`. Our proposal is that it would rather look like:

```xml
<BuildingSync xmlns="http://buildingsync.net/schemas/bedes-auc/2019" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://buildingsync.net/schemas/bedes-auc/2019 https://raw.githubusercontent.com/BuildingSync/schema/v2.2.0/BuildingSync.xsd" version="2.2.0">
  <Facilities>
    <Facility ID="F1">
      <Sites>
          <Site>
              <Buildings>
                  <Building>
                      <DemisingAboveGradeWallArea>1000</DemisingAboveGradeWallArea>
                  </Building>
              </Buildings>
          </Site>
      </Sites>
    </Facility>
  </Facilities>
</BuildingSync>
```

## Implementation

```xml

<xs:element name="Building" type="auc:BuildingType" maxOccurs="unbounded">
    <xs:annotation>
        <xs:documentation>A building is a single structure wholly or partially enclosed within exterior walls, or within exterior and abutment walls (party walls), and a roof, affording shelter to persons, animals, or property. A building can be two or more units held in the condominium form of ownership that are governed by the same board of managers.</xs:documentation>
    </xs:annotation>
    ...
    <xs:element name="DemisingAboveGradeWallArea" minOccurs="0">
        <xs:annotation>
            <xs:documentation>Above grade demising wall area. (ft2)</xs:documentation>
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
</xs:element>
```

## References
https://www.pnnl.gov/main/publications/external/technical_reports/PNNL-25130.pdf
