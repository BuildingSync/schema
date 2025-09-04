# FuelTypes - Add Enumerations

## Overview

The `auc:FuelTypes` element is missing enumerations.

## Justification

The assertion of "delivered", "exported", "metered" and "onsite generated" characteristics for fuel types is a required input for ASHRAE Standard 211 [1].

The assertion of specific fuel types, e.g., "Biofuel B5" and not "Biofuel", is a required input for ASHRAE Standard 211 [1].

## Implementation

This proposal is to add the following enumerations to the `auc:FuelTypes` element:

- "Electricity-Exported"
- "Electricity-Onsite generated"
- "Biofuel B5"
- "Biofuel B10"
- "Biofuel B20"
- "Dual fuel"
- "Gasoline"
- "Other delivered-Exported"
- "Other delivered-Onsite generated"
- "Other metered-Exported"
- "Other metered-Onsite generated"
- "Thermal-Exported"
- "Thermal-Onsite generated"

## References

1. https://www.ashrae.org/technical-resources/bookstore/standards-180-and-211
