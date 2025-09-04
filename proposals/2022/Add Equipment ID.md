# Add Equipment ID

## Overview

This proposal is to add an "Equipment ID" element to the schema.

## Justification

The schema has an "ID" attribute for each top-level plant/system type; however, the IDs themselves are opaque (i.e., their values can be tested for equality, but otherwise, convey no information) and are locally-unique to the XML document (i.e., their values are only unique within the scope of the XML document). Hence, the "ID" attribute can be used to _identify_ and _reference_ an element, but not to _name_ said element.

The schema has elements to describe the equipment manufacturer, the year of manufacture, and the model number; however, there is no element for the equipment ID (e.g., "AHU-1", "PTAC-Room-42", or "ABC123").

## Implementation

This proposal is implemented by adding a new element:

```xml
<xs:element name="EquipmentID" type="xs:string">
  <xs:annotation>
    <xs:documentation>Identifier for the equipment.</xs:documentation>
  </xs:annotation>
</xs:element>
```

The new element is added to the `<xs:sequence>` for the following types:

- `<auc:AntiSweatHeaters>`
- `<auc:ConveyanceSystemType>`
- `<auc:CookingSystemType>`
- `<auc:CoolingSource>`
- `<auc:CriticalITSystemType>`
- `<auc:Delivery>`
- `<auc:DishwasherSystemType>`
- `<auc:DomesticHotWaterSystemType>`
- `<auc:DuctSystemType>`
- `<auc:FanSystemType>`
- `<auc:FenestrationSystemType>`
- `<auc:HeatRecoverySystemType>`
- `<auc:HeatingSource>`
- `<auc:LaundrySystemType>`
- `<auc:LightingSystemType>`
- `<auc:MotorSystemType>`
- `<auc:OnsiteStorageTransmissionGenerationSystemType>`
- `<auc:OtherHVACSystemType>`
- `<auc:PlugElectricLoadType>`
- `<auc:PoolType>`
- `<auc:ProcessGasElectricLoadType>`
- `<auc:PumpSystemType>`
- `<auc:RefrigerationSystemType>`
- `<auc:Solar>`
- `<auc:WaterUseType>`

The types, above, were identified programmatically using the following XPath: `//xs:complexType[xs:sequence/xs:element[@ref = "auc:Manufacturer"]]`.
