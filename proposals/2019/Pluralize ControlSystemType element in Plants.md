# ControlSystemType - Pluralize

## Overview

Pluralize the `auc:ControlSystemType` element for `auc:HeatingPlant`, `auc:CoolingPlant` and `auc:CondenserPlant` elements.

## Justification

In Audit Template, it is possible for plant equipment to have multiple control strategies, e.g., heating plant equipment may have either/both digital and/or pneumatic-based control strategies.

## Implementation

This proposal is to:

1. Add the `auc:ControlSystemTypes` element to the `auc:HeatingPlant`, `auc:CoolingPlant` and `auc:CondenserPlant` elements.

2. Move the singular `auc:ControlSystemType` element to the new `auc:ControlSystemTypes` elements.

## References

n/a
