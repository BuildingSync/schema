# Primary Systems Updates

## Overview

The current method for defining HVAC Systems in a Level 1 audit consists of utilizing the `PrimaryHVACSystem` as part of an `HVACSystem`, and there is currently no simple method for defining a `PrimaryLightingSystem` without going through and defining a specific `LampType`.  Both of these are lacking in the context of having standardized enumerations, and the HVAC aspect is lacking in that it lumps all characteristics of an HVAC system into a single field.

## Justification
For Level 1 energy audits, auditors are required to specify (for individual space functions), the Principal HVAC Type and Principal Lighting Type.

### Justification for `PrimaryLightingSystem`
There is currently no good way to implement the Principal Lighting Type in BuildingSync without defining additional details (`LampType`, etc.).

### Justification for Adding HVAC Details
Defining a ‘Principal HVAC Type’ is lacking in that it doesn’t break out system specific information, such as heating, cooling, ventilation, fan control, or terminal type (it lumps all characterisitics of an HVAC system into one field, which is problematic).  Additionally, 211 does not provide standardized enumerations, making it difficult to know what will end up being in that field.

## Implementation

This proposal seeks to:

1. Add additional elements to the `HVACSystemType` complex element, including:
    1. `PrimaryCoolingType`
    1. `PrimaryHeatingType`
    1. `PrimaryVentilationType`
    1. `PrimaryFanControlType`
    1. `PrimaryTerminalUnitType`
    These will utilize enumerations, allowing them to be expanded.
    
```xml
      <xs:element name="PrimaryCoolingType" minOccurs="0">
        <xs:annotation>
          <xs:documentation>The primary cooling type utilized by the HVAC system.</xs:documentation>
        </xs:annotation>
        <xs:simpleType>
          <xs:restriction base="xs:string">
            <xs:enumeration value="Air Cooled Chiller"/>
            <xs:enumeration value="Water Cooled Chiller with Cooling Towers"/>
            <xs:enumeration value="Cooling Towers"/>
            <xs:enumeration value="Direct Expansion"/>
            <xs:enumeration value="District Chilled Water"/>
            <xs:enumeration value="Evaporative Coolers"/>
            <xs:enumeration value="Heat Pump"/>
            <xs:enumeration value="Other"/>
            <xs:enumeration value="None"/>
          </xs:restriction>
        </xs:simpleType>
      </xs:element>
      <xs:element name="PrimaryHeatingType" minOccurs="0">
        <xs:annotation>
          <xs:documentation>The primary heating type utilized by the HVAC system.</xs:documentation>
        </xs:annotation>
        <xs:simpleType>
          <xs:restriction base="xs:string">
            <xs:enumeration value="Fossil Fuel Furnace"/>
            <xs:enumeration value="Fossil Fuel Hot Water Boiler"/>
            <xs:enumeration value="Electric Resistance"/>
            <xs:enumeration value="District Steam"/>
            <xs:enumeration value="District Hot Water"/>
            <xs:enumeration value="Heat Pump"/>
            <xs:enumeration value="Other"/>
            <xs:enumeration value="None"/>
          </xs:restriction>
        </xs:simpleType>
      </xs:element>
      <xs:element name="PrimaryVentilationType" minOccurs="0">
        <xs:annotation>
          <xs:documentation>The primary ventilation type utilized by the HVAC system.</xs:documentation>
        </xs:annotation>
        <xs:simpleType>
          <xs:restriction base="xs:string">
            <xs:enumeration value="Exhaust Only"/>
            <xs:enumeration value="Supply Only"/>
            <xs:enumeration value="Infiltration Only"/>
            <xs:enumeration value="Exhaust and Supply"/>
            <xs:enumeration value="Exhaust and Infiltration"/>
            <xs:enumeration value="Supply, Exhaust, and Infiltration"/>
            <xs:enumeration value="Local Heat Recovery Ventilator"/>
            <xs:enumeration value="Local Energy Recovery Ventilator"/>
            <xs:enumeration value="Centralized Heat Recovery Ventilator"/>
            <xs:enumeration value="Centralized Energy Recovery Ventilator"/>
            <xs:enumeration value="Other"/>
            <xs:enumeration value="None"/>
          </xs:restriction>
        </xs:simpleType>
      </xs:element>
      <xs:element name="PrimaryFanControlType" minOccurs="0">
        <xs:annotation>
          <xs:documentation>The primary fan control type used for air distribution</xs:documentation>
        </xs:annotation>
        <xs:simpleType>
          <xs:restriction base="xs:string">
            <xs:enumeration value="Constant Volume"/>
            <xs:enumeration value="Stepped"/>
            <xs:enumeration value="Variable Volume"/>
            <xs:enumeration value="Other"/>
            <xs:enumeration value="None"/>
          </xs:restriction>
        </xs:simpleType>
      </xs:element>
      <xs:element name="PrimaryTerminalUnitType" minOccurs="0">
        <xs:annotation>
          <xs:documentation>The primary terminal unit used for local heating, cooling, and air distribution</xs:documentation>
        </xs:annotation>
        <xs:simpleType>
          <xs:restriction base="xs:string">
            <xs:enumeration value="Four Pipe Fan Coil Unit"/>
            <xs:enumeration value="Heating Two Pipe Fan Coil Unit"/>
            <xs:enumeration value="Cooling Two Pipe Fan Coil Unit"/>
            <xs:enumeration value="VAV Boxes"/>
            <xs:enumeration value="VAV Boxes with Hot Water Reheat"/>
            <xs:enumeration value="VAV Boxes with Electric Reheat"/>
            <xs:enumeration value="VAV with Parallel Fan-Powered Boxes"/>
            <xs:enumeration value="VAV with Parallel Fan-Powered Boxes and Electric Reheat"/>
            <xs:enumeration value="VAV with Parallel Fan-Powered Boxes and Hot Water Reheat"/>
            <xs:enumeration value="Cooling Only Active Chilled Beams"/>
            <xs:enumeration value="Cooling Only Passive Chilled Beams"/>
            <xs:enumeration value="Heating Only Active Chilled Beams"/>
            <xs:enumeration value="Heating Only Passive Chilled Beams"/>
            <xs:enumeration value="Heating and Cooling Active Chilled Beams"/>
            <xs:enumeration value="Heating and Cooling Passive Chilled Beams"/>
          </xs:restriction>
        </xs:simpleType>
      </xs:element>
```

1. Add the `PrimaryLightingSystemType` element to the `LightingSystemType` complex type:

```xml
      <xs:element name="PrimaryLightingSystemType" minOccurs="0">
        <xs:annotation>
          <xs:documentation>The primary lighting system type is a generic, simple lighting type definition to accompany a Level 1 audit.</xs:documentation>
        </xs:annotation>
        <xs:simpleType>
          <xs:restriction base="xs:string">
            <xs:enumeration value="Compact Fluorescent"/>
            <xs:enumeration value="Fluorescent T5"/>
            <xs:enumeration value="Fluorescent T5 - High Output"/>
            <xs:enumeration value="Fluorescent T8"/>
            <xs:enumeration value="Fluorescent T8 - Super T8"/>
            <xs:enumeration value="Fluorescent T12"/>
            <xs:enumeration value="Fluorescent T12 - High Output"/>
            <xs:enumeration value="High Pressure Sodium"/>
            <xs:enumeration value="Incandescent"/>
            <xs:enumeration value="Halogen"/>
            <xs:enumeration value="LED"/>
            <xs:enumeration value="Mercury Vapor"/>
            <xs:enumeration value="Metal Halide"/>
            <xs:enumeration value="Other"/>
          </xs:restriction>
        </xs:simpleType>
      </xs:element>
```