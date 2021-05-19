# Refactor MeasureName minOccurs maxOccurs

## Overview

This proposal is to refactor the `minOccurs` and `maxOccurs` bounds for `MeasureName` element under each measure category, if it's restricted with enumerated options.  

## Justification

For a measure category (`TechnologyCategory`) that a specific `Measure` element falls into, there should be one and only one `MeasureName` corresponding to it (or at least using `Other` indicating not covered by enumerated options).
`MeasureName` under `HealthAndSafety` category should not have bounds as there is no enumeration, which means it could be left unspecified.

## Implementation

```xml
                  <xs:element name="TechnologyCategoryName" minOccurs="0">
                    ...
                    <xs:complexType>
                      <xs:sequence>
                        <xs:element name="MeasureName" minOccurs="1" maxOccurs="1">
                          ...
                        </xs:element>
```

## References