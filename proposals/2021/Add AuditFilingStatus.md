# Add AuditFilingStatus

## Overview

This proposal

## Justification

This field is only specific to Atlanta reports, but could be a useful input for others if requested.

## UDFs

Currently this is conveyed via:
`/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report[auc:LinkedPremisesOrSystem/auc:Building/auc:LinkedBuildingID]/auc:UserDefinedFields/auc:UserDefinedField[auc:FieldName/text() = Audit Filing Status]/auc:FieldValue`. Our proposal is to add it as child element of `ReportType` and provide enumerated options (starting with `Initial filing` and `Amended Filing`).

## Example

```xml
...
    <auc:Facilities>
        <auc:Facility ID="F1">
            <auc:Reports>
                <auc:Report ID="R1">
                    <auc:AuditFilingStatus>Initial Filing</auc:AuditFilingStatus>
                </auc:Report>
            </auc:Reports>
        </auc:Facility>
    </auc:Facilities>
...
```

## Implementations

```xml
  <xs:complexType name="ReportType">
    <xs:sequence>
      ...
      <xs:element name="AuditFilingStatus" minOccurs="0">
        <xs:annotation>
          <xs:documentation>The status of audit filing.</xs:documentation>
        </xs:annotation>
        <xs:simpleType>
          <xs:restriction base="xs:string">
            <xs:enumeration value="Initial filing"/>
            <xs:enumeration value="Amended Filing"/>
          </xs:restriction>
        </xs:simpleType>
      </xs:element>
      ...
```

## References