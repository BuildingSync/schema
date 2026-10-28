# Define TimeOfWeekTemperatureModel Parameters

## Overview

This proposal defines the child elements of `auc:DerivedModelCoefficients/auc:TimeOfWeekTemperatureModel` so that a fitted Time-of-Week and Temperature (TOWT) model can be serialized in BuildingSync, in the same way that `auc:Guideline14Model` already supports ASHRAE Guideline 14 change point models.

Addresses [#285](https://github.com/BuildingSync/schema/issues/285).

## Justification

- `auc:TimeOfWeekTemperatureModel` was added in 2.2.0 as part of the [NMEC Implementation](../2020/NMEC%20Implementation.md) proposal as an empty placeholder (`<xs:complexType/>`), noting that it "needs work". It is still empty, so a TOWT model can only be identified, not described.
- TOWT (Mathieu et al. 2011) is the hourly/daily baseline model used by CalTRACK, LBNL RMV2.0, and nmecr, and is widely used in NMEC and pay-for-performance programs. Tools that serialize NMEC results to BuildingSync (e.g. [bsyncr](https://github.com/BuildingSync/bsyncr)) can currently store only Guideline 14 coefficients.
- Storing the fitted parameters (not just the predictions in `auc:ModeledTimeSeriesData`) lets a reviewer reproduce predictions for any period, for example to compute avoided energy use in a reporting period.

## Implementation

Classification: **Non-breaking** (MINOR). All new elements are optional, so existing documents that contain an empty `<auc:TimeOfWeekTemperatureModel/>` remain valid. No elements are moved, renamed or removed.

### Model summary

A TOWT model predicts the response variable for interval $t$ as

$$\hat{y}_t = \alpha_{m,\,b(t)} + \sum_{k=1}^{K+1} \beta_{m,k}\, T_{k,t}$$

where:

- $b(t)$ is the time-of-week bin of interval $t$ (e.g. 1 to 168 for hourly bins starting Monday 00:00).
- $m$ is the occupancy mode of bin $b(t)$ (occupied or unoccupied). Bins are classified by the share of intervals with residuals above zero from an initial fit; CalTRACK uses a threshold of 0.65.
- $T_{k,t}$ is the portion of the outdoor air temperature falling in temperature segment $k$, where segments are bounded by $K$ temperature knots (CalTRACK default knots: 30, 45, 55, 65, 75, 90 F).
- $\alpha_{m,b}$ is the time-of-week coefficient and $\beta_{m,k}$ is the temperature slope for segment $k$.

### Proposed XSD changes

Replace the empty type of `auc:TimeOfWeekTemperatureModel` (inside `auc:DerivedModel/auc:Models/auc:Model/auc:DerivedModelCoefficients`) with:

| Element path (relative to `auc:TimeOfWeekTemperatureModel`)                                 | Type                                                                                                         | Occurs     | Documentation                                                                                                                                                                      |
| ------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------ | ---------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `TimeOfWeekBinCount`                                                                        | `xs:positiveInteger`                                                                                         | 0..1       | Number of time-of-week bins used by the model (e.g. 168 for hourly bins, 7 for daily bins). Bin 1 starts Monday 00:00 local time.                                                  |
| `OccupancyThreshold`                                                                        | `auc:BoundedDecimalZeroToOne`                                                                                | 0..1       | Fraction of positive residuals from the initial fit above which a time-of-week bin is classified as occupied (CalTRACK: 0.65).                                                     |
| `TemperatureKnots`                                                                          | sequence                                                                                                     | 0..1       | Temperature knots that bound the temperature segments, in ascending order.                                                                                                         |
| `TemperatureKnots/TemperatureKnot`                                                          | `xs:decimal`                                                                                                 | 1..unbound | A temperature knot, in the units of the temperature `auc:ExplanatoryVariableUnits`.                                                                                                |
| `OccupancyModes`                                                                            | sequence                                                                                                     | 0..1       | Coefficients for each occupancy mode.                                                                                                                                              |
| `OccupancyModes/OccupancyMode`                                                              | sequence                                                                                                     | 1..2       | Coefficients for a single occupancy mode.                                                                                                                                          |
| `OccupancyModes/OccupancyMode/OccupancyModeType`                                            | enum: `Occupied`, `Unoccupied`, `Single mode`                                                                | 0..1       | Occupancy mode the coefficients apply to. `Single mode` is used when the model does not separate occupied and unoccupied periods.                                                  |
| `OccupancyModes/OccupancyMode/TimeOfWeekCoefficients`                                       | sequence                                                                                                     | 0..1       | Time-of-week coefficients. The bins listed under a mode are the bins classified as that mode.                                                                                      |
| `OccupancyModes/OccupancyMode/TimeOfWeekCoefficients/TimeOfWeekCoefficient`                 | `xs:simpleContent` extension of `xs:decimal`, required attribute `TimeOfWeekBin` (`xs:positiveInteger`)      | 1..unbound | Fitted coefficient (alpha) for one time-of-week bin, in the units of `auc:ResponseVariableUnits`.                                                                                  |
| `OccupancyModes/OccupancyMode/TemperatureSegmentCoefficients`                               | sequence                                                                                                     | 0..1       | Temperature slope coefficients.                                                                                                                                                    |
| `OccupancyModes/OccupancyMode/TemperatureSegmentCoefficients/TemperatureSegmentCoefficient` | `xs:simpleContent` extension of `xs:decimal`, required attribute `TemperatureSegment` (`xs:positiveInteger`) | 1..unbound | Fitted slope (beta) for one temperature segment. Segment 1 is below the first knot and segment K+1 is above the last knot. Units are response variable units per temperature unit. |

Annotation for `auc:TimeOfWeekTemperatureModel`:

> Defined parameters are based on the Time-of-Week and Temperature model (Mathieu et al. 2011) as implemented in the CalTRACK hourly methods, LBNL RMV2.0 and nmecr. Fitted coefficients are stored per occupancy mode.

Notes:

- All elements are local to `auc:TimeOfWeekTemperatureModel`, and none of the new names exist elsewhere in the schema, so no names are added to the duplicate list in `spec/validation_spec.rb`. `xs:complexContent` is not used.
- The coefficients use attributes (`TimeOfWeekBin`, `TemperatureSegment`) rather than child elements to keep documents with 168+ values compact. The current BuildingSync website schema viewer does not show `xs:simpleContent` attributes; this is a viewer limitation (see [#474](https://github.com/BuildingSync/schema/issues/474)) and is documented in the element annotations.
- Out of scope: CalTRACK 3-month weighted segmentation (which produces one TOWT model per month-group) can be represented with multiple `auc:Model` elements and is not addressed here.

### Example

[TOWT-Example.xml](Define%20TimeOfWeekTemperatureModel%20Parameters/TOWT-Example.xml) shows a `auc:DerivedModel` scenario with an hourly TOWT model (shortened to a few bins per mode). It validates only once this proposal is implemented in `BuildingSync.xsd`.

### Downstream impact

Additive only. Possible follow-up consumers: [bsyncr](https://github.com/BuildingSync/bsyncr) (could serialize nmecr TOWT fits) and [bsyncpy](https://github.com/BuildingSync/bsyncpy) (regenerated classes). No use-cases Schematron, BOSS, or asset-extractor rules reference `auc:TimeOfWeekTemperatureModel`.

## References

- Mathieu, J. L., Price, P. N., Kiliccote, S., and Piette, M. A. (2011). Quantifying Changes in Building Electricity Use, With Application to Demand Response. IEEE Transactions on Smart Grid, 2(3), 507-518.
- CalTRACK Methods, hourly methods: <https://www.caltrack.org/>
- nmecr: <https://github.com/kW-Labs/nmecr>
- ASHRAE Guideline 14-2014, Measurement of Energy, Demand, and Water Savings.
- [NMEC Implementation proposal (2020)](../2020/NMEC%20Implementation.md)
