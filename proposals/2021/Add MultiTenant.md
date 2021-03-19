# Add MultiTenant to Building

## Overview

This proposal is to add the `MultiTenant` element as a child element of `Building` element, with boolean options.  

## Justification

Is it necessary? True if .

## UDFs

Currently this is conveyed in Audit Template via:
`/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building/auc:UserDefinedFields/auc:UserDefinedField[auc:FieldName/text() = Multi Tenant]/auc:FieldValue`.
Our proposal is to add it under a `Building`.

## Example

```xml
    <auc:Facilities>
        <auc:Facility ID="F1">
            <auc:Buildings>
                <auc:Building ID="B1">
                    <auc:MultiTenant>True</auc:MultiTenant>
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
      <xs:element name="MultiTenant" type="xs:boolean" minOccurs="0">
        <xs:annotation>
          <xs:documentation>True if.</xs:documentation>
        </xs:annotation>
      </xs:element>
      ...
```

## References