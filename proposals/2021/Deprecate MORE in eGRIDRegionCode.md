# Deprecate MORE in eGRIDRegionCode

## Overview

This proposal is to deprecate the enumeration `MORE` under `eGRIDRegionCode` element.

## Justification

`MORE` should be `MROE`. This typo bug was raised in issue [#276](https://github.com/BuildingSync/schema/issues/276) and partially addressed in PR [#279](https://github.com/BuildingSync/schema/pull/279) by adding the correct enumeration. Removing `MORE` will fix the last piece of the problem.

## References
