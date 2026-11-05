# Add RECS to BenchmarkType

## Overview

Add a `RECS` option to `Report/.../Benchmark/BenchmarkType` so that residential (in particular multifamily) buildings can record that they were benchmarked against the U.S. EIA Residential Energy Consumption Survey (RECS), and add `EPMI`, `ASHRAE Building EQ`, and `CIBSE` to `BenchmarkTool`, consistent with ASHRAE Standard 211 Section 6.1.3. Addresses [#535](https://github.com/BuildingSync/schema/issues/535).

## Justification

ASHRAE Standard 211 Section 6.1.3 requires the annual normalized EUI to be compared to at least one of: (a) Standard 100, (b) CBECS 2012, (c) 2003 CBECS data in the ASHRAE Handbook, (d) for multifamily, RECS 2009 or EPMI 2016, (e) ENERGY STAR score, (f) ASHRAE Building EQ, (g) DOE Building Performance Database, (h) CIBSE benchmarking, (i) other. `BenchmarkType` covers (b), (c), (e) and (i) via `CBECS`, `PortfolioManager` and `Other`, and `BenchmarkTool` covers (g). RECS, EPMI, Building EQ and CIBSE can only be recorded as `Other` with free text, which is not machine-readable.

## Implementation

Non-breaking (MINOR): adds a new optional choice, a new named type, and new enumeration values; existing documents remain valid.

- In `auc:Benchmark/auc:BenchmarkType` (`xs:choice`), add after `CBECS`:
  - `RECS` (`type="auc:RECSType"`, `minOccurs="0"`), documentation: "Benchmark against the U.S. Energy Information Administration Residential Energy Consumption Survey (RECS), typically used for multifamily and other residential buildings."
- Add empty named `xs:complexType` `RECSType` (same pattern as other empty marker types), leaving room for future children.
- In `auc:Benchmark/auc:BenchmarkTool`, add enumerations before `Other`: `EPMI` (Energy Performance of Multifamily Index), `ASHRAE Building EQ` (same spelling as `AssessmentProgram`), `CIBSE`.

The RECS dataset year (e.g., 2009, 2020) is recorded in the existing `Benchmark/BenchmarkYear`. No climate zone is added under `RECS`: RECS peer groups (Building America climate region, census region/division, housing unit type, year built, size) are already described by building-level `ClimateZoneType` (the `DOE` option uses Building America zones), `Address`, `OccupancyClassification`, `YearOfConstruction` and `FloorAreas`.

Downstream impact: additive only. use-cases Schematron rules and BuildingSync-asset-extractor that enumerate `BenchmarkType` children may optionally recognize `RECS`; no existing XPaths change.

## References

- ASHRAE/ACCA/ANSI Standard 211, Section 6.1.3 (Benchmarking)
- U.S. EIA Residential Energy Consumption Survey: https://www.eia.gov/consumption/residential/
