# Add PercentType and Allow Negative Bias Errors

## Overview

Addresses [#297](https://github.com/BuildingSync/schema/issues/297). Adds reusable named types for percentages on a 0-100 scale and fixes the lower bound of the `NDBE` and `NMBE` model fit metrics, which are signed quantities but are currently restricted to 0-100.

## Justification

- Many elements are documented as percentages (e.g. `PercentOccupiedByOwner`, `PercentPremisesServed`, `PercentOfWindowAreaShaded`) but are plain `xs:decimal`, and examples mix 0-1 fractions and 0-100 percents. A shared `PercentType` gives new and future elements a single, documented definition, analogous to the existing `BoundedDecimalZeroToOne`.
- `PercentWithSourceAttribute` is needed because most existing percentage elements already carry the optional `auc:Source` attribute (data provenance such as `Estimate`, `Auditor`, `Direct measurement`), for example:

  ```xml
  <auc:PercentOccupiedByOwner Source="Estimate">40</auc:PercentOccupiedByOwner>
  ```

  A plain `xs:simpleType` such as `PercentType` cannot have attributes, so moving these elements to `PercentType` would drop `Source` and invalidate such documents. `PercentWithSourceAttribute` has the same 0-100 value space plus the optional `Source` attribute. This mirrors the existing pair `BoundedDecimalZeroToOne` (used directly by elements without `Source`, e.g. `ConfidenceLevel`) and `BoundedDecimalZeroToOneWithSourceAttribute` (a `simpleContent` extension adding `auc:Source`, used by e.g. `OverallWindowToWallRatio`, `SupplyFractionOfDuctLeakage`, `MinimumDimmingLightFraction`, `WaterFixtureFractionHotWater`).

- `NDBE` (Net Determination Bias Error) and `NMBE` (Normalized Mean Bias Error) are signed by definition (ASHRAE Guideline 14); a model can over- or under-predict. The current `minInclusive value="0"` rejects valid negative results.

## Implementation

Non-breaking change (MINOR).

- Add global `xs:simpleType` `PercentType`: `xs:decimal` restricted to `[0, 100]`.
- Add global `xs:complexType` `PercentWithSourceAttribute`: `simpleContent` extension of `auc:PercentType` with `auc:Source` attribute.
- `.../DerivedModelPerformance/CVRMSE`: replace the inline 0-100 restriction with `type="auc:PercentType"` (identical value space; patch-level).
- `.../DerivedModelPerformance/NDBE` and `.../DerivedModelPerformance/NMBE`: change `minInclusive` from `0` to `-100` (widening; non-breaking). Documentation notes the value may be negative.

Out of scope (would be breaking, since it narrows existing `xs:decimal` elements): migrating existing percentage elements to `PercentType`. That requires first resolving fraction-vs-percent values in examples and producer data (e.g. Audit Template) and is deferred to a major version.

Candidate share-of-whole elements for a future (breaking) migration. Each is documented as a percentage of a bounded whole (area, floor area, length, time, consumption, savings), so values outside 0-100 are not meaningful. Example statistics are from all valid `examples/*.xml`; "Fractions" counts values strictly between 0 and 1.

| Element                                              | Current type     | Target type                  | Uses in examples | Example range | Fractions | Fraction-to-percent fix needed?                 |
| ---------------------------------------------------- | ---------------- | ---------------------------- | ---------------- | ------------- | --------- | ----------------------------------------------- |
| `PartialOperationPercentage`                         | decimal + Source | `PercentWithSourceAttribute` | 714              | 0 to 1        | 484       | Yes: all values are fractions                   |
| `PercentPremisesServed`                              | decimal + Source | `PercentWithSourceAttribute` | 38               | 0.05 to 1     | 6         | Yes                                             |
| `PercentSkylightArea`                                | decimal + Source | `PercentWithSourceAttribute` | 50               | 0 to 0.0375   | 2         | Yes                                             |
| `PercentResource`                                    | decimal          | `PercentType`                | 13               | 1             | 0         | Ambiguous: 1 probably means 100%                |
| `PercentEndUse`                                      | decimal          | `PercentType`                | 13               | 1             | 0         | Ambiguous: 1 probably means 100%                |
| `PipeLocation`                                       | decimal + Source | `PercentWithSourceAttribute` | 4                | 1             | 0         | Ambiguous                                       |
| `PercentOccupiedByOwner`                             | decimal + Source | `PercentWithSourceAttribute` | 6                | 20 to 78      | 0         | No                                              |
| `PercentLeasedByOwner`                               | decimal + Source | `PercentWithSourceAttribute` | 6                | 15 to 80      | 0         | No                                              |
| `SpatialUnitOccupiedPercentage`                      | decimal          | `PercentType`                | 1                | 90            | 0         | No                                              |
| `PercentOfWindowAreaShaded`                          | decimal + Source | `PercentWithSourceAttribute` | 200              | 0             | 0         | No                                              |
| `FloorAreaPercentage`                                | float [0, 100]   | `PercentType`                | 88               | 0 to 100      | 0         | No; already bounded, change is float to decimal |
| `PercentageOfCommonSpace`                            | decimal + Source | `PercentWithSourceAttribute` | 0                | -             | -         | Not used in examples                            |
| `BoilerPercentCondensateReturn`                      | decimal + Source | `PercentWithSourceAttribute` | 0                | -             | -         | Not used in examples                            |
| `DuctPressureTestLeakagePercentage`                  | decimal + Source | `PercentWithSourceAttribute` | 0                | -             | -         | Not used in examples                            |
| `SupplyDuctPercentConditionedSpace`                  | decimal + Source | `PercentWithSourceAttribute` | 0                | -             | -         | Not used in examples                            |
| `ReturnDuctPercentConditionedSpace`                  | decimal + Source | `PercentWithSourceAttribute` | 0                | -             | -         | Not used in examples                            |
| `DutyCycle`                                          | decimal + Source | `PercentWithSourceAttribute` | 0                | -             | -         | Not used in examples                            |
| `PumpDutyCycle`                                      | decimal + Source | `PercentWithSourceAttribute` | 0                | -             | -         | Not used in examples                            |
| `MinimumOutsideAirPercentage`                        | decimal + Source | `PercentWithSourceAttribute` | 0                | -             | -         | Not used in examples                            |
| `HumidityControlMinimum`                             | decimal + Source | `PercentWithSourceAttribute` | 0                | -             | -         | Not used in examples                            |
| `HumidityControlMaximum`                             | decimal + Source | `PercentWithSourceAttribute` | 0                | -             | -         | Not used in examples                            |
| `PercentGuaranteedSavings`                           | decimal + Source | `PercentWithSourceAttribute` | 0                | -             | -         | Not used in examples                            |
| `FederalSustainabilityChecklistCompletionPercentage` | decimal + Source | `PercentWithSourceAttribute` | 0                | -             | -         | Not used in examples                            |

Rates and ratios that can be negative or exceed 100 (`EscalationRate` and the price escalation rates, `InflationRate`, `DiscountRate`, `DiscountFactor`, `InternalRateOfReturn`, `ProjectMarkup`, `DemandRatchetPercentage`) are excluded.

No element names, paths, or enumerations change, so downstream repos (use-cases, BOSS, asset-extractor) are unaffected; bsyncpy gains two new types on regeneration.

## References

- [#297](https://github.com/BuildingSync/schema/issues/297)
- ASHRAE Guideline 14-2014, Measurement of Energy, Demand, and Water Savings
