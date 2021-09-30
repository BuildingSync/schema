# Add MaximumOutsideAirFlowRate

## Overview

This proposal is to create the element `auc:MaximumOutsideAirFlowRate` as alternative choice to `auc:MaximumOAFlowRate`.

## Justification

All other elements use `OutsideAir`. To keep consistent naming, we will substitute `auc:MaximumOAFlowRate` under `auc:DuctSystem` with `auc:MaximumOutsideAirFlowRate` (by adding it as a choice element to make it non-breaking change) and deprecate `auc:MaximumOAFlowRate` in version 3.0.

## Implementation

As a non-breaking change for 2.4, we will move `auc:MaximumOAFlowRate` into a choice, and provide `auc:MaximumOutsideAirFlowRate` as the alternative. Annotate `auc:MaximumOAFlowRate` with a deprecation warning.
As a breaking change for 3.0, we will replace `auc:MaximumOAFlowRate` with `auc:MaximumOutsideAirFlowRate`.

## References
