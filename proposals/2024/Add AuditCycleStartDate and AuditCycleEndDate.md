# Add AuditCycleStartDate and AuditCycleEndDate

## Overview

This proposal is to add new elements under `AuditCycle`: 
* `auc:AuditCycleStartDate`
* `auc:AuditCycleEndDate`

## Justification

The current `AuditCycleStartYear` and `AuditCycleEndYear` elements support only year data, which may not reflect the actual program year informatio, which mostly are from June to June or Oct to Oct. The Audit Template team and CERL use case requested adding more detailed data for audit cycle start and end time information with full date type. This proposal is to add the two new elements `auc:AuditCycleStartDate` and `auc:AuditCycleEndDate` to support date type data. 

## Implementation
Under `auc:AuditCycles`:
```xml
  <xs:complexType name="AuditCycleType">
    <xs:annotation>
      <xs:documentation>A period of time in which multiple audits may be conducted</xs:documentation>
    </xs:annotation>
    <xs:sequence>
      <xs:element name="AuditCycleStartDate" type="xs:date">
        <xs:annotation>
          <xs:documentation>Date the Audit Cycle starts (CCYY-MM-DD)</xs:documentation>
        </xs:annotation>
      </xs:element>
      <xs:element name="AuditCycleEndDate" type="xs:date">
        <xs:annotation>
          <xs:documentation>Date the Audit Cycle ends (CCYY-MM-DD)</xs:documentation>
        </xs:annotation>
      </xs:element>
      ...
```
