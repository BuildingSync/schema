# Deprecate WallID as direct child under Side

## Overview

This proposal is to deprecate the choice of single `auc:WallID` reference as direct child under `auc:Side`.

## Justification

`auc:WallIDs` was added as an `xsd:choice` element in [#223](https://github.com/BuildingSync/schema/pull/223) to allow multiple `auc:WallID`s referenced for a `auc:Side` element (unbounded). This made the single `auc:WallID` reference choice redundant, so we propose to remove it.
In addition, as `auc:WallIDs` becomes the only choice, the `xsd:choice` element is no longer needed, so we propose to remove this layer and make `auc:WallIDs` direct child under `auc:Side`.

## Implementation

```xml
                        <xs:element name="Side" maxOccurs="unbounded">
                          <xs:complexType>
                            <xs:sequence>
                              ...
                              <xs:element name="WallIDs">
                                <xs:complexType>
                                  <xs:sequence>
                                    <xs:element ref="auc:WallID" minOccurs="0" maxOccurs="unbounded"/>
                                  </xs:sequence>
                                </xs:complexType>
                              </xs:element>
                              ...
                        </xs:element>
```

## References
