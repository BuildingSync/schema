# Add eGRIDSubregionCodes

## Overview

This proposal is to create the element `auc:eGRIDSubregionCodes`, which has one or more `auc:eGRIDSubregionCode` elements, to substitute the function of `auc:eGRIDRegionCode` and allow multiple eGRID Subregion Codes with the `auc:Site` and/or `auc:Building`.

## Justification

Given an eGRID-assigned zip code, the power profiler zip code tool (see reference) returns between 1 and 3 eGRID subregion codes, referred to as "eGRID Subregion 1", "eGRID Subregion 2" and "eGRID Subregion 3", respectively.
Currently, in BuildingSync XML schema, Only 1 eGRID subregion code can be asserted for a given `auc:Site` and `auc:Building` element.
We decide that BuildingSync should handle multiple eGRID Subregion Codes. The main motivation for allowing multiple codes is that users should use the average of coefficients for multiple region codes.
We are currently reaching out to determine if/how we should add these codes to `auc:Utility`.

## Implementation

We will create an element `auc:eGRIDSubregionCodes`, which has one or more `auc:eGRIDSubregionCode` elements.
As a non-breaking change for 2.4, we will move `auc:eGRIDRegionCode` into a choice, and provide `auc:eGRIDSubregionCodes` as the other option. Annotate `auc:eGRIDRegionCode` with a deprecation warning.
As a breaking change for 3.0, we will replace `auc:eGRIDRegionCode` with `auc:eGRIDSubregionCodes`.

## References
The EPA's online [Power Profiler Tool](https://www.epa.gov/egrid/power-profiler#/CAMX)
The Excel version of the [Power Profiler Zipcode Tool](https://epa.gov/sites/production/files/2020-03/power_profiler_zipcode_tool_2018_3_09_20._v9.xlsx) which has ~8% of the zip codes with a second eGRID subregion and ~0.3% with a third subregion
