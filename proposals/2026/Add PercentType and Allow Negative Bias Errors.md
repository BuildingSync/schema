# Add PercentType and Allow Negative Bias Errors

## Overview

Addresses [#297](https://github.com/BuildingSync/schema/issues/297). Adds reusable named types for percentages on a 0-100 scale and fixes the lower bound of the `NDBE` and `NMBE` model fit metrics, which are signed quantities but are currently restricted to 0-100.

## Justification

- Many elements are documented as percentages (e.g. `PercentOccupiedByOwner`, `PercentPremisesServed`, `PercentOfWindowAreaShaded`) but are plain `xs:decimal`, and examples mix 0-1 fractions and 0-100 percents. A shared `PercentType` gives new and future elements a single, documented definition, analogous to the existing `BoundedDecimalZeroToOne`.
- `NDBE` (Net Determination Bias Error) and `NMBE` (Normalized Mean Bias Error) are signed by definition (ASHRAE Guideline 14); a model can over- or under-predict. The current `minInclusive value="0"` rejects valid negative results.

## Implementation

Non-breaking change (MINOR).

- Add global `xs:simpleType` `PercentType`: `xs:decimal` restricted to `[0, 100]`.
- Add global `xs:complexType` `PercentWithSourceAttribute`: `simpleContent` extension of `auc:PercentType` with `auc:Source` attribute.
- `.../DerivedModelPerformance/CVRMSE`: replace the inline 0-100 restriction with `type="auc:PercentType"` (identical value space; patch-level).
- `.../DerivedModelPerformance/NDBE` and `.../DerivedModelPerformance/NMBE`: change `minInclusive` from `0` to `-100` (widening; non-breaking). Documentation notes the value may be negative.

Out of scope (would be breaking, since it narrows existing `xs:decimal` elements): migrating existing percentage elements to `PercentType`. That requires first resolving fraction-vs-percent values in examples and producer data (e.g. Audit Template) and is deferred to a major version.

No element names, paths, or enumerations change, so downstream repos (use-cases, BOSS, asset-extractor) are unaffected; bsyncpy gains two new types on regeneration.

## References

- [#297](https://github.com/BuildingSync/schema/issues/297)
- ASHRAE Guideline 14-2014, Measurement of Energy, Demand, and Water Savings
