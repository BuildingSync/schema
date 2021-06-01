# Update various integer simple types for correctness

## Overview

This proposal is to update  a number of integer simple type requirements on elements that are incorrect or potentially misleading. The mapping for  their updated counterpart where applicable is as follows:
 - `xs:integer` -> `xs:nonNegativeInteger`
## Justification

In many cases the `xs:integer` simple type is used on elements where allowing a negative value would be nonsensical.  

## Implementation

Change all simple types to the appropriate type where necessary in the schema.  One example of this would be to change the `simpleContent` type on the `FloorsAboveGrade` element.  
```xml
 <xs:element name="FloorsAboveGrade" minOccurs="0">
        <xs:annotation>
          <xs:documentation>Nominal number of floors which are fully above ground.</xs:documentation>
        </xs:annotation>
        <xs:complexType>
          <xs:simpleContent>
            <xs:extension base="xs:nonNegativeinteger">
              <xs:attribute ref="auc:Source"/>
            </xs:extension>
          </xs:simpleContent>
        </xs:complexType>
      </xs:element>
```
