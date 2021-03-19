# Add EarlyCompliance

## Overview

This proposal is to add the `EarlyCompliance` element as a child of `ReportType` element, with boolean options when True stands for .

## Justification

This field originally took place in the audit reports for the city of Atlanta, but we believe it is a good field and therefore propose to add it to the schema.

## UDFs

Currently this is conveyed via:
`/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report[auc:LinkedPremisesOrSystem/auc:Building/auc:LinkedBuildingID]/auc:UserDefinedFields/auc:UserDefinedField[auc:FieldName/text() = Early Compliance]/auc:FieldValue` in the Audit Template Field Group ATL. Our proposal is to add it as a child element of `ReportType` with boolean options.

## Example

```xml
...
    <auc:Facilities>
        <auc:Facility ID="F1">
            <auc:Reports>
                <auc:Report ID="R1">
                    <auc:EarlyCompliance>True</auc:EarlyCompliance>
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
      <xs:element name="EarlyCompliance" type="xs:boolean" minOccurs="0">
        <xs:annotation>
          <xs:documentation>True if.</xs:documentation>
        </xs:annotation>
      </xs:element>
      ...
```

## References