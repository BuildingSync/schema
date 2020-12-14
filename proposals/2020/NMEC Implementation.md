# NMEC Implementation

## Overview

This proposal is to provide a mechanism for storing the results of an NMEC (normalized metered energy consumption) calculation within the BuildingSync schema.  Specifically, how can model inputs, outputs, and metrics for the models be stored.

## Justification
To prove out the usefulness of BSync in capturing post-retrofit savings calculated via NMEC.  This could prove useful for both cities and utility program administrators needing to verify implementation and effectiveness of retrofit measures.

## Definition and Concept Clarification
__Note: italicized words after a reference identify the name of the concept used in the reference__

- Baseline period:
    - period of time selected as representative of facility operations before retrofit.  CPUC defines this specifically as 12-months [1] __baseline period__
    - The baseline period is the 12-month period leading up to the energy efficiency intervention or retrofit. [2] __baseline period__
- Reporting period / performance period:
    - period of time following implementation of an energy conservation measure when savings reports adhere to the guideline. This period may be as short as the time for an instantaneous measurement of a constant quantity, long enough to reflect all normal operating modes of a system or facility with variable operations, the length of the financial payback period for an investment, the duration of a perfor- mance measurement period under an energy performance contract, or indefinite. [1] __reporting period__
    - The Reporting Period is the period of time over which the savings from energy efficiency interventions
      and retrofits are measured. The reporting period immediately follows the implementation period. [2] __reporting period__ / __post-implementation performance monitoring__ / __performance period__
- Baseline period actual energy use (BAE) [1] __baseline energy__
- Reporting period actual energy use (RAE)
- Reporting period calculated energy use (RCE)
- Baseline period calculated energy use at standard conditions (BCESC)
- Reporting period calculated energy use at standard conditions (RCESC)
- Avoided energy use:
    - Equation: RCE - RAE
    - Avoided Energy Use is the amount of energy (or peak demand) that was not consumed or realized as a
      result of the energy efficiency project or program intervention. Avoided energy use is the difference
      between actual energy consumption in the “reporting period” and the consumption that is forecast for
      the same period using the “baseline energy consumption model,” and where the baseline energy
      consumption model use is adjusted to reflect reporting period conditions. The Avoided Energy Use
      approach is used as the basis of customer incentive calculations and embedded M&V reporting of
      savings [2] __avoided energy use__
    - reduction in energy use during the reporting period relative to what would have occurred if the facility had been equipped and operated as it was in the base- line period but under reporting period operating conditions. Cost avoidance is the monetary equivalent of avoided energy use. Both are commonly called “savings.” See also, energy savings and normalized savings. [1] __avoided energy use__
- Normalized savings:
    - Equation: RCESC - BCESC
    - Normalized energy savings is the reduction in energy consumption or demand that occurs in the
      reporting period, relative to the baseline period, after both have been adjusted to a common set of
      normal operating conditions. Normalized Savings are used for the final reporting of energy and demand
      savings claims that are filed with the CPUC. [2] __normalized energy savings__
    - Standard condition normalization results in two adjustment models: one of baseline period
      energy consumption and one for reporting period energy consumption. Standard conditions are
      applied to each of the models to calculate adjusted energy consumption values. The adjusted energy consumption for each period is the estimated energy consumption that would have been expected at a standard set of conditions (relevant variable values) in both the baseline and reporting periods. [3] __standard condition normalization__
- Normal operating conditions:
    - Normal operating conditions should reflect expected operating conditions and occupancy. This includes
      long-term average weather conditions for the climate zone corresponding to the building location.
      Normal production and occupancy should be based on observed pre and post-treatment values [2]

## Implementation

Models to support:
- Simple linear regression model (2p model)
- 3p heating CPM
- 3p cooling CPM
- 4p CPM
- 5p CPM
- Future implementation #TODO:
    - Time of week & temperature
    - Time only
    - HDD only ?
    - CDD only ?
    - HDD and CDD ?

Metrics to be able to capture:
- r-squared
- Adjusted r-squared
- RMSE
- CVRMSE
- Net determination bias error (NDBE)
- MBE
- NMBE

Model inputs to capture:
- Baseline period start datetime
- Baseline period end datetime
- Reporting period start datetime
- Reporting period end datetime
- Data interval: [Hourly, daily, monthly]
- Confidence interval?
- Model Type: One of above models
- Dependent variable:
    - ResourceUse (electricity, natural gas, etc.)
    - Units (kWh, therms, etc.)
Independent variables:
    - For CPMs and SLR model, temperature is only independent variable
    - Units
    
Model outputs to capture:
- BAE
- RAE
- RCE
- BCESC
- RCESC
- Avoided energy use
- Normalized savings
- Number of parameters (p)
- Number of data points or periods in the baseline period (n)
- Number of data points or periods in the reporting period (m)
- Degrees of freedom (n - p)
- Savings percentage: Believe this is just `Avoided energy use / RCE` #TODO
- Savings uncertainty: Is this what is defined by equations 4-6 and 4-7 in [1]? Is this the same across CalTrack methods / CPUC NMEC rulebook? #TODO

Potentially?
- Cutoff thresholds (for CVRMSE or NDBE)
- 

### Approach
- Two `auc:Scenario`s will be used, one to represent the baseline period and one to represent the reporting period.  For situations where multiple reporting periods are considered (i.e. in the case where an energy simulation is used to produce synthetic data for different potential retrofit scenarios), additional reporting period scenarios can be defined.
- The concept of an `auc:DerivedModel` is introduced.  It represents the generic concept of either a baseline or reporting model (referred to as an adjustment model in [3]).
- The `auc:DerivedModel` complex type will be able to be instantiated as a child of the following elements:
    - `auc:Scenario/auc:ScenarioType/auc:CurrentBuilding`
        - It is expected that models for baseline periods would be embedded here (regardless if modeled or measured)
        - `auc:DerivedModelPerformance` and child elements should be captured here
        - All elements starting with `auc:BaselinePeriod` should be captured here
    - `auc:Scenario/auc:ScenarioType/auc:PackageOfMeasures`
        - It is expected that models for reporting periods would be embedded here (regardless if modeled or measured)
        - All elements starting with `auc:ReportingPeriod` should be captured here
- Multiple `auc:DerivedModels` should be able to be captured, as users may want to test different `auc:ModelType`s
- The `auc:DerivedModel` will be a complex type that would look something like:
```xml
  <auc:DerivedModels>
    <auc:DerivedModel ID="Model1">
      <auc:DerivedModelPeriod>[Baseline, Reporting]</auc:DerivedModelPeriod>
      <auc:DerivedModelBaselineID/>
      <auc:DerivedModelInputs>
        <auc:ModelType>[2P SLR, 3P heating CPM, 3P cooling CPM, 4P CPM, 5P CPM]</auc:ModelType>
        <auc:NormalizationMethod>[Forecast, Backcast, Standard Conditions]</auc:NormalizationMethod>
        <auc:BaselinePeriodStartDate>2016-12-01</auc:BaselinePeriodStartDate>
        <auc:BaselinePeriodEndDate>2017-12-01</auc:BaselinePeriodEndDate>
        <auc:ReportingPeriodStartDate/>
        <auc:ReportingPeriodEndDate/>
        <auc:IntervalFrequency>Monthly</auc:IntervalFrequency>
        <auc:ResponseVariable>
          <auc:EnergyResource>Electricity</auc:EnergyResource>
          <auc:EnergyResourceUnits>kWh</auc:EnergyResourceUnits>
          <auc:EndUse>All end uses</auc:EndUse>
        </auc:ResponseVariable>
        <auc:ExplanatoryVariables>
          <auc:ExplanatoryVariable>
            <auc:ExplanatoryVariableName>[Temperature, Relative Humidity, GHI, DHI, DNI, Time-of-week, Time-of-day,...]</auc:ExplanatoryVariableName>
            <auc:ExplanatoryVariableUnits>[Fahrenheit, Percent, W/m2, Hour of week, Hour of day, ...]</auc:ExplanatoryVariableUnits>
            <auc:StandardConditionDataSource>[TMY3, ...]</auc:StandardConditionDataSource>
          </auc:ExplanatoryVariable>
        </auc:ExplanatoryVariables>
      </auc:DerivedModelInputs>
      <auc:DerivedModelParameters>
        <auc:BetaCooling>1.11</auc:BetaCooling>
        <auc:BetaHeating>2.51</auc:BetaHeating>
        <auc:BalancePointCooling>68</auc:BalancePointCooling>
        <auc:BalancePointHeating>53</auc:BalancePointHeating>
        <auc:Intercept>13.7</auc:Intercept>
      </auc:DerivedModelParameters>
      <auc:DerivedModelPerformance>
        <auc:NDBE/>
        <auc:RSquaredAdjusted/>
        <auc:RSquared/>
        <auc:RMSE/>
        <auc:CVRMSE/>
        <auc:MBE/>
        <auc:NMBE/>
      </auc:DerivedModelPerformance>
      <auc:DerivedModelOutputs>
        <auc:BaselinePeriodActualEnergyUse/>
        <auc:ReportingPeriodActualEnergyUse/>
        <auc:ReportingPeriodCalculatedEnergyUse/>
        <auc:BaselinePeriodCalculatedEnergyUseStandardConditions/>
        <auc:ReportingPeriodCalculatedEnergyUseStandardConditions/>
        <auc:AvoidedEnergyUse/>
        <auc:NormalizedEnergySavings/>
        <auc:NumberOfParameters/>
        <auc:NumberOfBaselinePeriodDataPoints/>
        <auc:NumberOfReportingPeriodDataPoints/>
        <auc:DegreesOfFreedom/>
        <auc:UncertaintyOutputs>
          <auc:SavingsPercentage/>
          <auc:SavingsUncertainty/>
        </auc:UncertaintyOutputs>
        <auc:CalTrackOutputs>
          <auc:Status>[Qualified, Unqualified, ...]</auc:Status>
          <auc:Warnings>
            <auc:Warning>This a warning</auc:Warning>
            <auc:Warning>This another warning</auc:Warning>
          </auc:Warnings>
        </auc:CalTrackOutputs>
      </auc:DerivedModelOutputs>
    </auc:DerivedModel>
  </auc:DerivedModels>
```

## References
[1] ASHRAE Guideline 14-2014
[2] CPUC NMEC Rulebook, v2.0, 07 Jan. 2020
[3] California Industrial SEM M&V Guide, v1.0, 08 Feb. 2017
