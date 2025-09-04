# Add PrincipalLightingSystemType

## Overview

This proposal is to add the element `auc:PrincipalLightingSystemType` element under the `auc:Building` and `auc:Section` element.

## Justification

The Audit Template Tool requires this element living directly under building and section level. Due to the hierarchy structural difference between AT and BS, AT can not map `auc:LampType` to their Principal Lighting System Type field under Building or Section, so previously a UDF was used for this. However adding this element does not align with the current structure of BuildingSync, which separates `auc:Facilities` and `auc:Systems` and applies relationship via linking elements - it introduces a "system" element into the `auc:Facilities`.

## Implementation

Add the element `auc:PrincipalLightingSystemType` globally, and refer it under `auc:Building` and `auc:Section`.
The enumerations of the added elements are combined by sources from Audit Template library and the child elements of `auc:LampType`.
From Audit Template:

- Compact Fluorescent
- Halogen
- Incandescent
- LED
- Mercury Vapor
- Metal Halide
- Sodium Vapor High Pressure
- T5
- T5HO
- T8
- Super T8
- T12
- T12HO
  From `auc:LampType`:
- Incandescent
- Linear Fluorescent
- Compact Fluorescent
- Halogen
- High Intensity Discharge
- Solid State Lighting
- Induction
- Neon
- Plasma
- Photoluminescent
- SelfLuminous
- Other
- Unknown
  The combined options might have overlaps (e.g. LED and Solid State Lighting).

## Decision

We add this element to avoid the usage of UDF for a commonly used element in AT and improve the data transferability between AT and BuildingSync. However we don't recommend the usage of this element other than the use case of input/output to/from Audit Template.

## References
