# Multiple ContactRoles for Contact

## Overview

If the same contact has multiple roles, then the entire contact has to be duplicated. Also, there needs to be a submitter as a contact role. The current list of contact roles is the following:

```xml
	<xs:enumeration value="Premises"/>
    <xs:enumeration value="Occupant"/>
    <xs:enumeration value="Agency"/>
    <xs:enumeration value="Owner"/>
    <xs:enumeration value="Customer"/>
    <xs:enumeration value="Customer agreement"/>
    <xs:enumeration value="Administrator"/>
    <xs:enumeration value="Qualified Assessor"/>
    <xs:enumeration value="Contributor"/>
    <xs:enumeration value="Property Management Company"/>
    <xs:enumeration value="Operator"/>
    <xs:enumeration value="Energy Auditor"/>
    <xs:enumeration value="Energy Modeler"/>
    <xs:enumeration value="Contractor"/>
    <xs:enumeration value="Implementer"/>
    <xs:enumeration value="Financier"/>
    <xs:enumeration value="Commissioning Agent"/>
    <xs:enumeration value="MV Agent"/>
    <xs:enumeration value="Evaluator"/>
    <xs:enumeration value="Builder"/>
    <xs:enumeration value="Service"/>
    <xs:enumeration value="Billing"/>
    <xs:enumeration value="Architect"/>
    <xs:enumeration value="Mechanical Engineer"/>
    <xs:enumeration value="Energy Consultant"/>
    <xs:enumeration value="Service and Product Provider"/>
    <xs:enumeration value="Authority Having Jurisdiction"/>
    <xs:enumeration value="Utility"/>
    <xs:enumeration value="Power plant"/>
    <xs:enumeration value="Electric Distribution Utility (EDU)"/>
    <xs:enumeration value="ESCO"/>
    <xs:enumeration value="Facilitator"/>
    <xs:enumeration value="Facility Manager"/>
    <xs:enumeration value="Trainer"/>
    <xs:enumeration value="Electrical Engineer"/>
    <xs:enumeration value="Controls Engineer"/>
    <xs:enumeration value="Lender"/>
    <xs:enumeration value="Servicer"/>
    <xs:enumeration value="Originator"/>
    <xs:enumeration value="Other"/>
```

## Justification

A contact should be able to have multiple roles.


## Implementation

There are two changes that are proposed. 

1. ContactRole under ContactType `//element(*,auc:ContactType)/auc:ContactRole` will be moved under a new container objective called ContactRoles and made unbounded.

2. A new enumeration will be added to support the role of an audit submitter. This is a non-breaking change.
```xml
	<xs:enumeration value="Submitter"/>
```

## References

N/A

