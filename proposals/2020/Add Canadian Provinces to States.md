# Add Canadian Provinces to States

## Overview

Add Canadian province abbreviations to acceptable `auc:State` enumeration restrictions.

## Justification

To enable Canadian province and territory serialization. There are no conflicts with current enums.

## Implementation

```xml
  <xs:simpleType name="State">
    <xs:restriction base="xs:string">
    ...
      <!-- ADDITIONAL CANADIAN PROVINCES / TERRITORIES -->
      <xs:enumaration value="AB">
      <xs:enumaration value="BC">
      <xs:enumaration value="MB">
      <xs:enumaration value="NB">
      <xs:enumaration value="NL">
      <xs:enumaration value="NS">
      <xs:enumaration value="ON">
      <xs:enumaration value="PE">
      <xs:enumaration value="QC">
      <xs:enumaration value="SK">
      <xs:enumaration value="NT">
      <xs:enumaration value="NU">
      <xs:enumaration value="YT">
    </xs:restriction>
  </xs:simpleType>
```

## References

https://en.wikipedia.org/wiki/ISO_3166-2:CA
