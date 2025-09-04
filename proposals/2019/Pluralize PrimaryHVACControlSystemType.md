# PrimaryHVACControlSystemType - Pluralize

## Overview

Pluralize the `auc:PrimaryHVACControlSystemType` element.

## Justification

In Audit Template, it is possible for HVAC equipment to have multiple control strategies.

## Implementation

This proposal is to:

1. Rename the `auc:PrimaryHVACControlSystemType` element to `auc:HVACControlSystemType`.

2. Add the `auc:HVACControlSystemTypes` element to the `auc:HVACSystemType` element.

3. Move the renamed `auc:HVACControlSystemType` to the new `auc:HVACControlSystemTypes` element.

## References

n/a
