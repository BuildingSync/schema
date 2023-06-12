# Add FacilityEvaluationAuditDefinition

## Overview

This proposal is to add new element `auc:FacilityEvaluationAuditDefinition` under `auc:Report` with child elements and enumerations:
* `auc:BasicOnsiteAudit`
* * ASHRAE Level 1 Audit
* * Industrial Assessment Center (IAC) Audit
* * Utility Incentive Program Audit
* `auc:DetailedOnsiteAudit`
* * ASHRAE Level 2 Audit
* * ASHRAE Level 3 Audit
* * Deep Energy Retrofit Audit
* * Preliminary Assessment (PA)
* * Investment Grade Audit (IGA)
* * Retro-Commissioning Audit
* `auc:BasicRemoteAudit`
* * Rapid/Automated Audit
* * Continuous Monitoring of Building Systems
* * Portfolio Screening Analysis
* `auc:DetailedRemoteAudit`
* * Desk Audit
* * Remote Controls Audit

## Justification

The “Facility Evaluation (Audit) Definition” field is a set of categorized enumerations that is defined by FEMP and added in Audit Template. The two layers of categories (Onsite vs. Remote, Basic vs. Detailed) are combined to simplify the structure of the new element.

## Implementation
```xml
      <xs:element name="FacilityEvaluationAuditDefinition" minOccurs="0">
        <xs:annotation>
          <xs:documentation>The facility audit terms used in the FEMP Facility Evaluation (Audit) resources that satisfy EISA 432 requirements</xs:documentation>
        </xs:annotation>
        <xs:complexType>
          <xs:choice>
            <xs:element name="BasicOnsiteAudit">
              <xs:annotation>
                <xs:documentation>A basic onsite audit meets the minimum requirements for onsite facility evaluations</xs:documentation>
              </xs:annotation>
              <xs:simpleType>
                <xs:restriction base="xs:string">
                  <xs:enumeration value="ASHRAE Level 1 Audit"/>
                  <xs:enumeration value="Industrial Assessment Center (IAC) Audit"/>
                  <xs:enumeration value="Utility Incentive Program Audit"/>
                </xs:restriction>
              </xs:simpleType>
            </xs:element>
            <xs:element name="DetailedOnsiteAudit">
              <xs:annotation>
                <xs:documentation>A more in-depth facility evaluation that is performed when project development is the focus and a more precise LCCA is required</xs:documentation>
              </xs:annotation>
              <xs:simpleType>
                <xs:restriction base="xs:string">
                  <xs:enumeration value="ASHRAE Level 2 Audit"/>
                  <xs:enumeration value="ASHRAE Level 3 Audit"/>
                  <xs:enumeration value="Deep Energy Retrofit Audit"/>
                  <xs:enumeration value="Preliminary Assessment (PA)"/>
                  <xs:enumeration value="Investment Grade Audit (IGA)"/>
                  <xs:enumeration value="Retrocommissioning Audit"/>
                </xs:restriction>
              </xs:simpleType>
            </xs:element>
            <xs:element name="BasicRemoteAudit">
              <xs:annotation>
                <xs:documentation>A facility evaluation performed without a site visit and analysis of datasets from specific building systems or operations to derive opportunities for energy efficiency, water efficiency, and renewable energy generation</xs:documentation>
              </xs:annotation>
              <xs:simpleType>
                <xs:restriction base="xs:string">
                  <xs:enumeration value="Rapid/Automated Audit"/>
                  <xs:enumeration value="Continuous Monitoring of Building Systems"/>
                  <xs:enumeration value="Portfolio Screening Analysis"/>
                </xs:restriction>
              </xs:simpleType>
            </xs:element>
            <xs:element name="DetailedRemoteAudit">
              <xs:annotation>
                <xs:documentation>A facility evaluation performed without a site visit and rigorous analysis of building systems and operations to identify opportunities for energy efficiency, water efficiency, and renewable energy generation</xs:documentation>
              </xs:annotation>
              <xs:simpleType>
                <xs:restriction base="xs:string">
                  <xs:enumeration value="Desk Audit"/>
                  <xs:enumeration value="Remote Controls Audit"/>
                </xs:restriction>
              </xs:simpleType>
            </xs:element>
          </xs:choice>
        </xs:complexType>
      </xs:element>
```

## References
[FEMP working draft](https://www.energy.gov/femp/articles/femp-facility-evaluation-audit-definitions#:~:text=An%20evaluation%20with%20a%20site,the%20discretion%20of%20the%20Agency%22)
