# Deprecate DoorID as direct child under Side

## Overview

This proposal is to deprecate the choice of single `auc:DoorID` reference as direct child under `auc:Side`.

## Justification

`DoorIDs` was added as an `xsd:choice` element in [#231](https://github.com/BuildingSync/schema/pull/231) to allow multiple `auc:DoorID`s referenced for a `auc:Side` element (unbounded). This made the single `auc:DoorID` reference choice redundant, so we propose to remove it.
On the other hand, to avoid breaking change for Audit Template, the `xsd:choice` element will remain.

## Implementation

```xml
                        <xs:element name="Side" maxOccurs="unbounded">
                          <xs:complexType>
                            <xs:sequence>
                              ...
                              <xs:element name="DoorIDs" minOccurs="0" maxOccurs="1">
                                <xs:complexType>
                                  <xs:sequence>
                                    <xs:element ref="auc:DoorID" minOccurs="0" maxOccurs="unbounded"/>
                                  </xs:sequence>
                                </xs:complexType>
                              </xs:element>
                              ...
                        </xs:element>
```

## References
