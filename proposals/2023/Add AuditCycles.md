# Add AuditCycles

## Overview

This proposal is to add new elements related to Audit Cycle definitions: 
* `auc:AuditCycles`
* `auc:AuditCycles/auc:AuditCycle`
* `auc:AuditCycles/auc:AuditCycle/auc:AuditCycleName`
* `auc:AuditCycles/auc:AuditCycle/auc:AuditCycleNotes`
* `auc:AuditCycles/auc:AuditCycle/auc:AuditCycleStartYear`
* `auc:AuditCycles/auc:AuditCycle/auc:AuditCycleEndYear`
under `auc:Facility`, following EISA 432 requirements and for the CERL use case. And add
* `auc:LinkedAuditCycles`
* `auc:LinkedAuditCycles/auc:LinkedAuditCycle`
* `auc:LinkedAuditCycles/auc:LinkedAuditCycle/auc:IndexYearOfAuditCycle` 
under `auc:Report`.
An `ID` is required for each `auc:AuditCycle`, and it should be referred via `auc:LinkedAuditCycles/auc:LinkedAuditCycle`.

## Justification

Audit Cycle is defined for CERL use case by EISA 432(?). In Audit Template, an audit cycle is defined with `Name`, `Start year` and `End year`, and `Year of Audit Cycle` is used to identify the number of year in which the audit is conducted within the cycle. Multiple cycles could co-exist and overlap within one report (e.g. a city may have separate cycles for different types of buildings) and the `Name` is used to distinguish.
We will add `auc:AuditCycles` element under `auc:Facility` and allow multiple child elements of `auc:AuditCycle` for each cycle. For each `auc:AuditCycle`, `ID` attribute is required, and `auc:AuditCycleName`, `auc:AuditCycleNotes`, `auc:AuditCycleStartYear`, `auc:AuditCycleEndYear` are child elements. We will add `auc:LinkedAuditCycles/auc:LinkedAuditCycle` under `auc:Report` to link to an associated `auc:AuditCycle` through `IDref`.

## Implementation
Under `auc:Facility`:
```xml
  <xs:element name="Facility" maxOccurs="unbounded">
    <xs:sequence>
      ...
      <xs:element name="AuditCycles" minOccurs="0">
        <xs:complexType>
          <xs:sequence>
            <xs:element name="AuditCycle" type="auc:AuditCycleType" maxOccurs="unbounded"/>
          </xs:sequence>
        </xs:complexType>
      </xs:element >
      ...
```
Global definition:
```xml
...
  <xs:complexType name="AuditCycleType">
    <xs:sequence>
      <xs:element name="AuditCycleName" type="xs:string" minOccurs="0">
      </xs:element>
      <xs:element name="AuditCycleNotes" type="xs:string" minOccurs="0">
      </xs:element>
      <xs:element name="AuditCycleStartYear" type="xs:gYear">
      </xs:element>
      <xs:element name="AuditCycleEndYear" type="xs:gYear">
      </xs:element>
      <xs:element ref="auc:UserDefinedFields" minOccurs="0"/>
    </xs:sequence>
    <xs:attribute name="ID" type="xs:ID" use="required"/>
  </xs:complexType>
  ...
  <xs:element name="LinkedAuditCycle">
    <xs:complexType>
      <xs:sequence>
        <xs:element name="IndexYearOfAuditCycle" type="xs:positiveInteger" minOccurs="0" maxOccurs="1">
        </xs:element>
      </xs:sequence>
      <xs:attribute name="IDref" type="xs:IDREF" use="required"/>
    </xs:complexType>
  </xs:element>
  <xs:element name="LinkedAuditCycles">
    <xs:complexType>
      <xs:sequence>
        <xs:element ref="auc:LinkedAuditCycle" minOccurs="0" maxOccurs="unbounded"/>
      </xs:sequence>
    </xs:complexType>
  </xs:element>
...
```
Under `auc:Report`:
```xml
  <xs:complexType name="ReportType">
    <xs:sequence>
      ...
      <xs:element ref="auc:LinkedAuditCycles" minOccurs="0"/>
      ...
```
