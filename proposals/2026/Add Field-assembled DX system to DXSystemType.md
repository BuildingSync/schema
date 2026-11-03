# Add Field-assembled DX system to DXSystemType

## Overview

This proposal is to add the enumeration `Field-assembled DX system` to `auc:DXSystemType` (under `auc:CoolingSource/auc:CoolingSourceType/auc:DX`).

As a side product, the `xs:documentation` of two elements is corrected:

- `auc:DXSystemType`: "General type of heat pump used for space heating." is changed to "General type of DX system used for space cooling."
- `auc:HeatPumpType`: "General type of heat pump used for space heating." is changed to "General type of heat pump used for space conditioning (heating and/or cooling)."

## Justification

Issue [#167](https://github.com/BuildingSync/schema/issues/167) reported that the documentation of `DXSystemType` was copied from `HeatPumpType` and describes a heat pump used for space heating, which is not what the element represents. A heat pump can also provide cooling, so the `HeatPumpType` text is also reworded.

A comment on the issue also requested a way to represent DX systems whose components (e.g. compressor/condensing unit and evaporator coil) are selected and installed separately on site, as opposed to factory-packaged or factory-matched split systems. None of the current enumerations (`Split DX air conditioner`, `Packaged/unitary direct expansion/RTU`, `Variable refrigerant flow`, etc.) describe this configuration accurately; today such systems must be reported as `Other`, which loses information.

## Implementation

Under `auc:DXSystemType`, add the enumeration before `Other`:

```xml
<xs:element name="DXSystemType" minOccurs="0">
  <xs:annotation>
    <xs:documentation>General type of DX system used for space cooling.</xs:documentation>
  </xs:annotation>
  <xs:simpleType>
    <xs:restriction base="xs:string">
      <xs:enumeration value="Split DX air conditioner"/>
      <xs:enumeration value="Packaged terminal air conditioner (PTAC)"/>
      <xs:enumeration value="Split heat pump"/>
      <xs:enumeration value="Packaged terminal heat pump (PTHP)"/>
      <xs:enumeration value="Variable refrigerant flow"/>
      <xs:enumeration value="Packaged/unitary direct expansion/RTU"/>
      <xs:enumeration value="Packaged/unitary heat pump"/>
      <xs:enumeration value="Single package vertical air conditioner"/>
      <xs:enumeration value="Single package vertical heat pump"/>
      <xs:enumeration value="Field-assembled DX system"/>
      <xs:enumeration value="Other"/>
      <xs:enumeration value="Unknown"/>
    </xs:restriction>
  </xs:simpleType>
</xs:element>
```

Under `auc:HeatPumpType`, update the documentation only (enumerations are unchanged):

```xml
<xs:documentation>General type of heat pump used for space conditioning (heating and/or cooling).</xs:documentation>
```

### Breaking changes

None. Adding an enumeration value and changing documentation text is non-breaking: all existing instance documents remain valid.
