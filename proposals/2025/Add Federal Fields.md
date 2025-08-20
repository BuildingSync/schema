# Add Federal Fields

## Overview

This proposal is to add new elements under the `FederalBuilding` element:

* `auc:Agency` - this field already exists. It is a text field and should probably stay that way to map to different tools. For the CERL use case, this maps to "DOD"
* `auc:SubAgency` - Sub Agency according to agency's organizational structure. For CERL's workflow, this would be "Army".
* `auc:SubAgencySubLevel1` - Sub Agency Sub Level 1 represents another level down in the agency's organizational structure. For CERL's workflow, this would be the "Accountable Organization".
* `auc:SubAgencySubLevel2` - Sub Agency Sub Level 2 represents another level down in the agency's organization structure. For CERL's workflow this would be the "Accountable Sub Organization".
* `Facility` - Federal Facility represents another level down in the agency's organization structure. For CERL's workflow, this would be the "Installation".
* `FacilitySubLevel1` - Federal Facility Sub Level 1 represents another level down in the agency's organization structure. For CERL's workflow, this would be the "Site".
* `FacilitySubLevel2` - Federal Facility Sub Level 2 represents another level down in the agency's organization structure. For CERL's workflow, this would also be "Site".
* `FacilityNumber` - Identifier of a federal facility. This is not likely a unique identifier.
* `PrimaryCategoryCode` - The Building's primary category code, indicating the building classification.

## Justification

The addition of these fields will facilitate data transfer between SEED and Audit Template to support the CERL workflow.

## Implementation

Under `auc:FederalBuilding`:

```xml
  <xs:element name="FederalBuilding" minOccurs="0">
        <xs:annotation>
          <xs:documentation>If exists then the building is owned by the federal government.</xs:documentation>
        </xs:annotation>
        <xs:complexType>
          <xs:sequence>
            <xs:element name="Agency" type="xs:string" minOccurs="0">
              <xs:annotation>
                <xs:documentation>Federal agency, required to designate a building as a federal property in ENERGY STAR Portfolio Manager.</xs:documentation>
              </xs:annotation>
            </xs:element>
            <xs:element name="SubAgency" type="xs:string" minOccurs="0">
              <xs:annotation>
                <xs:documentation>Federal sub agency, according to organizational structure of the specified agency.</xs:documentation>
              </xs:annotation>
            </xs:element>
            <xs:element name="SubAgencySubLevel1" type="xs:string" minOccurs="0">
              <xs:annotation>
                <xs:documentation>Federal sub agency sub level 1, according to organizational structure of the specified agency.</xs:documentation>
              </xs:annotation>
            </xs:element>
            <xs:element name="SubAgencySubLevel2" type="xs:string" minOccurs="0">
              <xs:annotation>
                <xs:documentation>Federal sub agency sub level 2, according to organizational structure of the specified agency.</xs:documentation>
              </xs:annotation>
            </xs:element>
            <xs:element name="Facility" type="xs:string" minOccurs="0">
              <xs:annotation>
                <xs:documentation>Federal facility, according to organization structure of the specified agency.</xs:documentation>
              </xs:annotation>
            </xs:element>
            <xs:element name="FacilitySubLevel1" type="xs:string" minOccurs="0">
              <xs:annotation>
                <xs:documentation>Federal facility sub level 1, according to organization structure of the specified agency.</xs:documentation>
              </xs:annotation>
            </xs:element>
            <xs:element name="FacilitySubLevel2" type="xs:string" minOccurs="0">
              <xs:annotation>
                <xs:documentation>Federal facility sub level 2, according to organization structure of the specified agency.</xs:documentation>
              </xs:annotation>
            </xs:element>
            <xs:element name="FacilityNumber" type="xs:string" minOccurs="0">
              <xs:annotation>
                <xs:documentation>Unique federal facility number.</xs:documentation>
              </xs:annotation>
            </xs:element>
            <xs:element name="PrimaryCategoryCode" type="xs:string" minOccurs="0">
              <xs:annotation>
                <xs:documentation>Category code classification of the building.</xs:documentation>
              </xs:annotation>
            </xs:element>
            <xs:element name="DepartmentRegion" type="xs:string" minOccurs="0">
              <xs:annotation>
                <xs:documentation>Federal department/region, required to designate a building as a federal property in ENERGY STAR Portfolio Manager.</xs:documentation>
              </xs:annotation>
            </xs:element>
          </xs:sequence>
        </xs:complexType>
      </xs:element>
```

## Example XML

```xml
<auc:BuildingSync xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:auc="http://buildingsync.net/schemas/bedes-auc/2019" xsi:schemaLocation="http://buildingsync.net/schemas/bedes-auc/2019 https://raw.github.com/BuildingSync/schema/v2.6.0/BuildingSync.xsd" version="2.6.0">
  <auc:Facilities>
    <auc:Facility ID="Facility-1">
      <auc:Sites>
        <auc:Site ID="Site-1">
          <auc:Buildings>
            <auc:Building ID="Building-1">
              <auc:FederalBuilding>
                <auc:Agency>DOD</auc:Agency>
                <auc:SubAgency>Army</auc:SubAgency>
                <auc:SubAgencySubLevel1>Accountable Organization</auc:SubAgencySubLevel1>
                <auc:SubAgencySubLevel2>Accountable Sub Org</auc:SubAgencySubLevel2>
                <auc:Facility>Installation</auc:Facility>
                <auc:FacilitySubLevel1>Site</auc:FacilitySubLevel1>
                <auc:FacilitySubLevel2>Site</auc:FacilitySubLevel2>
                <auc:FacilityNumber>123456</auc:FacilityNumber>
                <auc:PrimaryCategoryCode>123456</auc:PrimaryCategoryCode>
              </auc:FederalBuilding>
              <auc:PremisesName>Test Property</auc:PremisesName>
              ...
            </auc:Building>
          </auc:Buildings>
        </auc:Site>
      </auc:Sites>
    </auc:Facility>
  </auc:Facilities>
</auc:BuildingSync>
```
