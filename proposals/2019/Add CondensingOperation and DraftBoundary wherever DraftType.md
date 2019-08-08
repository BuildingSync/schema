# CondensingOperation and DraftBoundary - Add Wherever DraftType is Present

## Overview

The `auc:CondensingOperation` and `auc:DraftBoundary` elements are very useful for disambiguating the vent type that is specified by a given `auc:DraftType` element.

## Justification

Currently, the `auc:CondensingOperation` and `auc:DraftBoundary` elements are not available in all locations where the `auc:DraftType` is present.

## Implementation

This proposal is to:
1. Promote `auc:CondensingOperation` to a top-level enumeration (so that it can be reused).
2. Add `auc:DraftBoundary` element to `auc:Furnace` and `auc:Boiler` elements.
3. Add `auc:CondensingOperation` and/or `auc:DraftBoundary` elements to `auc:Combustion` elements.

## References

n/a
