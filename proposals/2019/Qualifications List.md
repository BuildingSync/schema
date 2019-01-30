# Update the Qualifications List

## Overview

The current list of Auditor Qualifications is missing a few popular items. The current list includes the following (see below).

```xml
  <xs:simpleType name="AuditorQualificationType">
    <xs:restriction base="xs:string">
      <xs:enumeration value="Professional Engineer (PE)"/>
      <xs:enumeration value="Certified Energy Manager (CEM)"/>
      <xs:enumeration value="Building Operator Certification (BOC)"/>
      <xs:enumeration value="Building Performance Institute (BPI) Certification"/>
      <xs:enumeration value="Building Performance Institute: Building Analyst (BA)"/>
      <xs:enumeration value="Building Performance Institute: Advanced Home Energy Professional (HEP)"/>
      <xs:enumeration value="Building Performance Institute: Advanced Home Energy Professional - Energy Auditor (HEP-EA)"/>
      <xs:enumeration value="Building Performance Institute: Advanced Home Energy Professional - Quality Control Inspector (HEP-QCI)"/>
      <xs:enumeration value="Building Performance Institute: Advanced Home Energy Professional - Retrofit Installer (HEP-RI)"/>
      <xs:enumeration value="Building Performance Institute: Advanced Home Energy Professional - Crew Leader (HEP-CL)"/>
      <xs:enumeration value="Building Performance Institute: Multifamily Building Analyst"/>
      <xs:enumeration value="Residential Energy Services Network (RESNET) Certification"/>
      <xs:enumeration value="Residential Energy Services Network (RESNET) - Home Partner"/>
      <xs:enumeration value="Registered Architect (RA)"/>
      <xs:enumeration value="Refrigerating System Operating Engineer"/>
      <xs:enumeration value="High Pressure Boiler Operating Engineer"/>
      <xs:enumeration value="Certified Commissioning Professional (CCP)"/>
      <xs:enumeration value="Associate Commissioning Professional (ACP)"/>
      <xs:enumeration value="Existing Building Commissioning Professional (EBCP)"/>
      <xs:enumeration value="Commissioning Process Management Professional (CPMP)"/>
      <xs:enumeration value="Accredited Commissioning Process Authority Professional (CxAP)"/>
      <xs:enumeration value="NYSERDA FlexTech Consultant"/>
      <xs:enumeration value="Certified Energy Auditor (CEA)"/>
      <xs:enumeration value="High-Performance Building Design Professional (HBDP)"/>
      <xs:enumeration value="Other"/>
      <xs:enumeration value="None"/>
    </xs:restriction>
  </xs:simpleType>
```

## Justification

The list of qualified auditors is expected to have additions over time as more organizations see the value in performing building energy audits. The changes include minor additions and a few breaking changes. The breaking changes are to further qualify the Building Operator Certification and adding the organization that oversees the qualification.


## Implementation

This proposal is to:
1. Add AEE to the CEA and CEM qualification. The new elements are shown below. This is a breaking change:

    previous
    
    ```xml
    <xs:enumeration value="Certified Energy Auditor (CEA)"/>
    <xs:enumeration value="Certified Energy Manager (CEM)"/>
    ```
    
    new
    
	```xml
	<xs:enumeration value="Association of Energy Engineers Certified Energy Manager (CEM)"/>
	<xs:enumeration value="Association of Energy Engineers Certified Energy Auditor (CEA)"/>
	```

2. Add BOC levels to enumerations. This is a breaking change:
	
	previous
	
	```xml
	<xs:enumeration value="Building Operator Certification (BOC)"/>
	```
	
	new
	
	```xml
	<xs:enumeration value="Building Operator Certification (BOC): Level 1"/>
	<xs:enumeration value="Building Operator Certification (BOC): Level 2"/>
	```

3. Add BPI acronym to multifamily building analyst to keep consistency. This is a breaking change:

    previous
    
    ```xml
    <xs:enumeration value="Building Performance Institute (BPI) Certification"/>
    <xs:enumeration value="Building Performance Institute: Building Analyst (BA)"/>   
    <xs:enumeration value="Building Performance Institute: Advanced Home Energy Professional (HEP)"/>
    <xs:enumeration value="Building Performance Institute: Advanced Home Energy Professional - Energy Auditor (HEP-EA)"/>
    <xs:enumeration value="Building Performance Institute: Advanced Home Energy Professional - Quality Control Inspector (HEP-QCI)"/>
    <xs:enumeration value="Building Performance Institute: Advanced Home Energy Professional - Retrofit Installer (HEP-RI)"/>
    <xs:enumeration value="Building Performance Institute: Advanced Home Energy Professional - Crew Leader (HEP-CL)"/>
    <xs:enumeration value="Building Performance Institute: Multifamily Building Analyst"/>
    ```
    
    updated

    ```xml
    <xs:enumeration value="Building Performance Institute (BPI): Building Analyst (BA)"/>   
    <xs:enumeration value="Building Performance Institute (BPI): Advanced Home Energy Professional (HEP)"/>
    <xs:enumeration value="Building Performance Institute (BPI): Advanced Home Energy Professional - Energy Auditor (HEP-EA)"/>
    <xs:enumeration value="Building Performance Institute (BPI): Advanced Home Energy Professional - Quality Control Inspector (HEP-QCI)"/>
    <xs:enumeration value="Building Performance Institute (BPI): Advanced Home Energy Professional - Retrofit Installer (HEP-RI)"/>
    <xs:enumeration value="Building Performance Institute (BPI): Advanced Home Energy Professional - Crew Leader (HEP-CL)"/>
    <xs:enumeration value="Building Performance Institute (BPI): Multifamily Building Analyst"/>
    ```
    
    
4. Add the following enumerations to the AuditorQualificationType:restriction element:

    ```xml
    <xs:enumeration value="ASHRAE Building Energy Assessment Professional (BEAP)"/>
    <xs:enumeration value="Department of Buildings (DOB) Approved Agent"/>
    ```


## References

N/A
