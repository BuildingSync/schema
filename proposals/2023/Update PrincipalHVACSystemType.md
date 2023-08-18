# Update PrincipalHVACSystemType

## Overview

This proposal is to update the usage of element `auc:PrincipalHVACSystemType` to be defined under the `auc:Building` and `auc:Section` elements.

## Justification

The Audit Template Tool requires this element living directly under building and section level instead of being referred through `auc:LinkedPremises` with `auc:HVACSystem/auc:PrincipalHVACSystemType`.

## Implementation
Change the definition of element `auc:PrincipalLightingSystemType` globally, and refer it under `auc:Building` and `auc:Section`, as well as `auc:HVACSystem` (where we have the element currently).

## Decision
We add this element to avoid the usage of UDF for a commonly used element in AT and improve the data transferability between AT and BuildingSync. However we don't recommend the usage of this element under `auc:Building` and `auc:Section` other than the use case of input/output to/from Audit Template.

## References
