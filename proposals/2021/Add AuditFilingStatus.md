# Add AuditFilingStatus

## Overview

This proposal is to add the `AuditFilingStatus` element as a child of `ReportType` element, and to restrict the options with `Initial filing` and `Amended filing`.

## Justification

This field originally took place in the audit reports for the city of Atlanta, but we believe it is a good field and therefore propose to add it to the schema.

## UDFs

Currently this is conveyed via:
`/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report[auc:LinkedPremisesOrSystem/auc:Building/auc:LinkedBuildingID]/auc:UserDefinedFields/auc:UserDefinedField[auc:FieldName/text() = Audit Filing Status]/auc:FieldValue` in the Audit Template Field Group ATL. Our proposal is to add it as a child element of `ReportType` and provide enumerated options (starting with `Initial filing` and `Amended filing`).

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
          <xs:documentation>The status of an audit filing, used to clarify whether or not this audit report is an initial submission (Initial filing) or an amendment to a previously submitted report (Amended filing).</xs:documentation>
        </xs:annotation>
        <xs:simpleType>
          <xs:restriction base="xs:string">
            <xs:enumeration value="Initial filing"/>
            <xs:enumeration value="Amended filing"/>
          </xs:restriction>
        </xs:simpleType>
      </xs:element>
      ...
```

## References