# Deprecate eGRIDRegionCode

## Overview

This proposal is to remove the element `auc:eGRIDRegionCode` and deprecate the choice of `auc:eGRIDRegionCode` reference under `auc:Site` and `auc:Building`.

## Justification

The element `auc:eGRIDSubregionCodes` was added in [#387](https://github.com/BuildingSync/schema/pull/387) to replace the function of `auc:eGRIDRegionCode` and allow multiple eGRID Subregion Codes with the `auc:Site` and/or `auc:Building`. `auc:eGRIDSubregionCodes` and `auc:eGRIDRegionCode` are currently options of the `auc:choice` element under both `auc:Site` and `auc:Building`. In version 3.0, we will deprecate `auc:eGRIDRegionCode`.

## Implementation

 We will remove the element and choice of `auc:eGRIDRegionCode`, and make `auc:eGRIDSubregionCodes` direct child under `auc:Site` and `auc:Building`.

## References
