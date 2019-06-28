# BRICR Support

## Overview

Add fields to CalculationMethod, Measure, and ResourceUses to support the BRICR Use Case.

## Justification

There exists a need to have additional fields added to the schema to support BRICR:

1. Adding WeatherDataType and SimulationCompletionStatus to CalculationMethod, which is referenced in multipled places in the schema (i.e., BuildingSync/Facilities/Facility/Reports/Report/Scenarios/Scenario/ScenarioType/PackageOfMeasures/CalculationMethod)

1. Adding CustomMeasureName to Measure element, in order to capture the OpenStudioMeasureName.

1. Add AnnualPeakNativeUnits and AnnualPeakConsistentUnits under ResourceUses.  ConsistentUnits are set at: kW.

## Implementation

This proposal is to:

1. Add WeatherDataType (with enums: 'Typical Meteorological Year' and 'Weather Station') to the CalculationMethod element.

1. Add SimulationCompletionStatus (with enums: 'Not Started', 'Started', 'Queued', 'Finished', 'Other', 'Unknown') to the CalculationMethod element.

1. Add CustomMeasureName element under Measure path: BuildingSync/Facilities/Facility/Measures/Measure.  

1. Add AnnualPeakNativeUnits and AnnualPeakConsistentUnits under BuildingSync/Facilities/Facility/Reports/Report/Scenarios/Scenario/ResourceUses.				


## References

N/A
