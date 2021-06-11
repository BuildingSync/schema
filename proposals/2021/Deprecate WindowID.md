# Deprecate WindowID as direct child under Side

## Overview

This proposal is to deprecate the choice of single `auc:WindowID` reference as direct child under `auc:Side`.

## Justification

`WindowIDs` was added as an `xsd:choice` element in [#232](https://github.com/BuildingSync/schema/pull/232) to allow multiple `auc:WindowID`s referenced for a `auc:Side` element (unbounded). This made the single `auc:WindowID` reference choice redundant, so we propose to remove it.
On the other hand, to avoid breaking change for Audit Template, the `xsd:choice` element will remain.

## Implementation

```xml
                        <xs:element name="Side" maxOccurs="unbounded">
                          <xs:complexType>
                            <xs:sequence>
                              ...
                              <xs:element name="WindowIDs" minOccurs="0" maxOccurs="1">
                                <xs:complexType>
                                  <xs:sequence>
                                    <xs:element ref="auc:WindowID" minOccurs="0" maxOccurs="unbounded"/>
                                  </xs:sequence>
                                </xs:complexType>
                              </xs:element>
                              ...
                        </xs:element>
```

## References
