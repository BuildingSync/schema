# ControlTechnology - Add Gas Engine to Chiller Compressor Driver

## Overview

The `BuildingSync/Facilities/Facility/Systems/HVACSystems/HVACSystem/Plants/CoolingPlants/CoolingPlant/Chiller/ChillerCompressorDriver` enumeration does not have a gas engine.

## Justification

Chillers can be driven by a gas engine.

## Implementation

This proposal is to:

Add the following enumerations to `<auc:ChillerCompressorDriver>`:
* Gas Engine

After complete, the full list of enums will be:

```
<xs:enumeration value="Electric Motor"/>
<xs:enumeration value="Steam"/>
<xs:enumeration value="Gas Turbine"/>
<xs:enumeration value="Gas Engine"/>
<xs:enumeration value="Other"/>
<xs:enumeration value="Unknown"/>
```

## References

n/a
