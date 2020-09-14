# Update Annual Fuel Use Native Units

## Overview

This proposal is to add `auc:NumberOfSides` element to `auc:Section` to allow validation for number of sides provided in `auc:Sides` when `auc:FootprintShape` is Other.

## Justification

If a document has `auc:FootprintShape` of Other, we cannot validate the number of provided `auc:Side`s, which we plan on doing for the 211 Level 2 use case. Adding this element will allow us to validate the number of sides.

## Implementation

Add an optional simple type element `auc:NumberOfSides` in `auc:Section` which accepts a positive integer.
