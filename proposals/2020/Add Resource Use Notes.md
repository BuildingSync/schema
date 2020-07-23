# Add ResourceUseNotes element

## Overview

This proposal is to add the `auc:ResourceUseNotes` child element to the `auc:ResourceUse` element.

## Justification

Standard 211 sections 6.1.2.1.d and 6.1.2.1.j specify
> ... If meter sampling is used by the qualified energy auditor, [the report must include] the sampling methodology used for each fuel
> ... Identification of irregularities in monthly energy use patterns and suggestions about their possible causes

This proposal suggests that having an element freeform text notes within `auc:ResourceUse` would best address these requirements.

## Implementation

```xml
<xs:complexType name="ResourceUseType">
    <xs:sequence>
        ...
        <xs:element name="ResourceUseNotes" type="xs:string">
          <xs:annotation>
            <xs:documentation>Notes about the resource use; for example, meter sampling methodology</xs:documentation>
          </xs:annotation>
        </xs:element>
    </xs:sequence>
```

## References

Standard 211 6.1.2.1.d and 6.1.2.1.j
