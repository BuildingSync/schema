# Add AuditorYearsOfExperience

## Overview

This proposal is to add the `AuditorYearsOfExperience` child element to the `Qualification` element. This mirrors where other qualification data for an auditor is currently housed.

## Justification

Certain AHJs require a minimum number of years experience for an auditor. This element would address the need to add that to the schema.

### UDFs
Currently, this is conveyed in Audit template via: `/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report[auc:LinkedPremisesOrSystem/auc:Building/auc:LinkedBuildingID]/auc:UserDefinedFields/auc:UserDefinedField[auc:FieldName/text() = Auditor Years Of Experience]/auc:FieldValue`. Our proposal is that it would rather look like:

```xml
<BuildingSync xmlns="http://buildingsync.net/schemas/bedes-auc/2019" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://buildingsync.net/schemas/bedes-auc/2019 https://raw.githubusercontent.com/BuildingSync/schema/v2.2.0/BuildingSync.xsd" version="2.2.0">
  <Facilities>
    <Facility ID="F1">
      <Reports>
        <Report ID="R1">
          <Qualifications>
            <Qualification ID="Q1">
              <AuditorQualification>Professional Engineer (PE)</AuditorQualification>
              <AuditorYearsOfExperience>4</AuditorYearsOfExperience> <-->
            </Qualification>
          </Qualifications>
          <AuditorContactID IDref="C1"/>
        </Report>
      </Reports>
      <Contacts>
        <Contact ID="C1">
          <ContactRoles>
            <ContactRole>Energy Auditor</ContactRole>
          </ContactRoles>
        </Contact>
      </Contacts>
    </Facility>
  </Facilities>
</BuildingSync>
```

## Implementation

```xml

<xs:element name="Qualification" minOccurs="0" maxOccurs="unbounded">
    <xs:annotation>
    <xs:documentation>Qualifications of audit team.</xs:documentation>
    </xs:annotation>
    <xs:complexType>
    <xs:sequence>
        ...
      <xs:element name="AuditorYearsOfExperience" minOccurs="0">
        <xs:annotation>
          <xs:documentation>The number of years the energy auditor has been conducting audits professionally.</xs:documentation>
        </xs:annotation>
        <xs:complexType>
          <xs:simpleContent>
            <xs:extension base="xs:integer">
              <xs:attribute ref="auc:Source"/>
            </xs:extension>
          </xs:simpleContent>
        </xs:complexType>
      </xs:element>
      ...
    </xs:sequence>
</xs:element>
```

## References

