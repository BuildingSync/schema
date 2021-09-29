# Deprecate MaximumOAFlowRate under DuctSystem

## Overview

This proposal is to deprecate `auc:MaximumOAFlowRate` under `auc:DuctSystem` element.

## Justification

`auc:MaximumOAFlowRate` should be renamed to `auc:MaximumOutsideAirFlowRate` to keep naming consistency. `auc:MaximumOutsideAirFlowRate` was added in PR [#395](https://github.com/BuildingSync/schema/pull/395) as a choice element in parallel with `auc:MaximumOAFlowRate` to avoid breaking change in version 2.4. Now we propose to deprecate `auc:MaximumOAFlowRate` in version 3.0.

## References
