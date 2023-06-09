# Add AuditCycles

## Overview

This proposal is to add new elements related to Audit Cycle definitions: 
* `auc:AuditCycles`
* `auc:AuditCycles/auc:AuditCycle`
* `auc:AuditCycles/auc:AuditCycle/auc:AuditCycleStartYear`
* `auc:AuditCycles/auc:AuditCycle/auc:AuditCycleEndYear`
* `auc:AuditCycles/auc:AuditCycle/auc:YearOfAuditCycle` 
under `auc:Report`, following EISA 432 requirements and for the CERL use case.

## Justification

Audit Cycle is defined for CERL use case by EISA 432(?). In Audit Template, an audit cycle is defined with `Name`, `Start year` and `End year`, and `Year of Audit Cycle` is used to identify the number of year in which the audit is conducted within the cycle. Multiple cycles could co-exist and overlap within one report (e.g. a city may have separate cycles for different types of buildings) and the `Name` is used to distinguish.
We will add `auc:AuditCycles` element under `auc:Report` and allow multiple child elements of `auc:AuditCycle` for each cycle. For each `auc:AuditCycle`, `ID` attribute is required in place of `Name`, and `AuditCycleStartYear`, `AuditCycleEndYear`, `YearOfAuditCycle` are child elements. 

## Implementation
```xml
  <xs:complexType name="ReportType">
    <xs:sequence>
      ...
      <xs:element name="AuditCycles" minOccurs="0">
        <xs:complexType>
          <xs:sequence>
            <xs:element name="AuditCycle" minOccurs="0" maxOccurs="unbounded">
              <xs:annotation>
                <xs:documentation>Definition of an Audit Cycle</xs:documentation>
              </xs:annotation>
              <xs:complexType>
                <xs:sequence>
                  <xs:element name="AuditCycleStartYear" type="xs:gYear">
                    <xs:annotation>
                      <xs:documentation>Year the Audit Cycle starts (inclusive, CCYY)</xs:documentation>
                    </xs:annotation>
                  </xs:element>
                  <xs:element name="AuditCycleEndYear" type="xs:gYear">
                    <xs:annotation>
                      <xs:documentation>Last year of the Audit Cycle (inclusive, CCYY)</xs:documentation>
                    </xs:annotation>
                  </xs:element>
                  <xs:element name="YearOfAuditCycle" type="xs:positiveInteger" minOccurs="0" maxOccurs="1">
                    <xs:annotation>
                      <xs:documentation>Number of year the audit is conducted from the start of the audit cycle. 1 corresponds to auc:AuditCycleStartYear.</xs:documentation>
                    </xs:annotation>
                  </xs:element>
                </xs:sequence>
                <xs:attribute name="ID" type="xs:ID" use="required"/>
              </xs:complexType>
            </xs:element>
          </xs:sequence>
        </xs:complexType>
      </xs:element >
      ...
```
