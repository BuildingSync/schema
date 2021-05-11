# Deprecate WallID as direct child under Side

## Overview

This proposal is to deprecate the choice of single `auc:WallID` reference as direct child under `auc:Side`.

## Justification

`WallIDs` was added as an `xsd:choice` element in [#223](https://github.com/BuildingSync/schema/pull/223) to allow multiple `auc:WallID`s referenced for a `auc:Side` element (unbounded). This made the single `auc:WallID` reference choice redundant, so we propose to remove it.
On the other hand, to avoid breaking change for Audit Template, the `xsd:choice` element will remain.

## Implementation

```xml
                        <xs:element name="Side" maxOccurs="unbounded">
                          <xs:complexType>
                            <xs:sequence>
                              ...
                              <xs:choice>
                                <xs:element name="WallIDs">
                                  <xs:complexType>
                                    <xs:sequence>
                                      <xs:element ref="auc:WallID" minOccurs="0" maxOccurs="unbounded"/>
                                    </xs:sequence>
                                  </xs:complexType>
                                </xs:element>
                              </xs:choice>
                              ...
                        </xs:element>
```

## References
