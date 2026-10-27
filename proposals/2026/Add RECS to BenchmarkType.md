# Add RECS to BenchmarkType

## Overview

Add a `RECS` option to `Report/.../Benchmark/BenchmarkType` so that residential (in particular multifamily) buildings can record that they were benchmarked against the U.S. EIA Residential Energy Consumption Survey (RECS), consistent with ASHRAE Standard 211 Section 6.1.3. Addresses [#535](https://github.com/BuildingSync/schema/issues/535).

## Justification

ASHRAE Standard 211 Section 6.1.3 requires the building's energy performance to be benchmarked against ENERGY STAR Portfolio Manager where available, or otherwise against national survey data such as CBECS (commercial) or RECS (residential). `BenchmarkType` currently offers `PortfolioManager`, `CBECS`, `CodeMinimum`, `StandardPractice`, and `Other`, so a RECS benchmark for a multifamily building can only be recorded as `Other` with a free-text description, which is not machine-readable.

## Implementation

Non-breaking (MINOR): adds a new optional choice and a new named type; existing documents remain valid.

- In `auc:Benchmark/auc:BenchmarkType` (`xs:choice`), add after `CBECS`:
  - `RECS` (`type="auc:RECSType"`, `minOccurs="0"`), documentation: "Benchmark against the U.S. Energy Information Administration Residential Energy Consumption Survey (RECS), typically used for multifamily and other residential buildings."
- Add named `xs:complexType` `RECSType` with one optional element:
  - `RECSSurveyYear` (`xs:gYear`): "Year of the RECS survey data release used for benchmarking (e.g., 2020). (CCYY)"

Climate zone is not repeated inside `RECSType`; it is already captured by `auc:ClimateZoneType` on the building.

Downstream impact: additive only. use-cases Schematron rules and BuildingSync-asset-extractor that enumerate `BenchmarkType` children may optionally recognize `RECS`; no existing XPaths change.

## References

- ASHRAE/ACCA/ANSI Standard 211, Section 6.1.3 (Benchmarking)
- U.S. EIA Residential Energy Consumption Survey: https://www.eia.gov/consumption/residential/
