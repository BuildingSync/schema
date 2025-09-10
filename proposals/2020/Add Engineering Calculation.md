# Add EngineeringCalculation element

## Overview

This proposal is to add the `auc:EngineeringCalculation` element as a calculation method.

## Justification

The `auc:CalculationMethodType` element is used as a child element of the `auc:ScenarioType` to help further refine how information in the scenario was derived. This might include energy consumption information, costs, savings, etc.

The current sequence of items that can be used to define an `auc:CalculationMethodType` are as follows:

- `auc:Modeled` - used to represent when a whole building energy modeling application is used.
- `auc:Measured` - used to represent when actual measurements (utility, AMI, HOBO devices, etc.) are used to capture real data from the building
- `auc:Estimated` - used to represent a 'guess' or 'judgment call'
- `auc:Other` - anything else

There is currently no good way to represent information that, although may not be modeled in a BEM application, was derived with some knowledge of the building and a spreadsheet, for example. The following complex type is introduced as a placeholder to represent that situation. There currently is no way to specify **how** the calculation was made - pending the use of this element, this may be added in the future.

## Implementation

```xml
  <xs:complexType name="CalculationMethodType">
    <xs:choice>
      <xs:element name="Modeled" minOccurs="0">
        ...
      </xs:element>
      <xs:element name="Measured" minOccurs="0">
        ...
      </xs:element>
      <xs:element name="Estimated" type="auc:EstimatedType" minOccurs="0"/>
      <xs:element name="EngineeringCalculation" type="auc:EngineeringCalculationType" minOccurs="0"/>
      <xs:element name="Other" type="auc:OtherType" minOccurs="0"/>
    </xs:choice>
  </xs:complexType>
  ...

<xs:complexType name="EngineeringCalculationType"/>
```
