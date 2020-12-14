# NMEC Implementation

## Overview

This proposal is to provide a mechanism for storing the results of an NMEC (normalized metered energy consumption) calculation (or similar regression based analyses) within the BuildingSync schema.  Specifically, how can model inputs, outputs, and metrics for the models be stored in a standardized fashion.

## Justification
Using BuildingSync to represent data inputs and outputs for Advanced Measurement & Verification analyses can be highly useful for people needing to streamline reporting of energy efficiency savings.  BuildingSync will not _implement_ any methodology in particular, but will provide support for serializing the analysis from different methodologies in a standardized way.  
# Implementation

To tackle this, we introduce the `DerivedModelType` as follows:

![img](./img/DerivedModelType.png)

- An `auc:DerivedModelType` can store multiple individual `auc:Model`s, where each model would be a different analysis method (i.e. a 2p SLR or 5p CPM).
- An `auc:DerivedModel` can be declared in the following places:
    - `auc:Scenario/auc:ScenarioType/auc:CurrentBuilding/auc:DerivedModel`:  A derived model placed here represents a model created for analysis of a Baseline Period
    - `auc:Scenario/auc:ScenarioType/auc:PackageOfMeasures/auc:DerivedModel`: A derived model placed here represents a model created for a Reporting / Performance Period
- Every `auc:DerivedModel` should make use of storing measured data using the existing 'Current Building Measured' Scenario, which is an `auc:Scenario` typed as: `auc:Scenario[auc:ScenarioType/auc:CurrentBuilding/auc:CalculationMethod/auc:Measured]`. The model should refer back to a 'Current Building Measured' Scenario for which the analysis was performed using the `auc:MeasuredScenarioID` element.  The `auc:Model/auc:StartTimestamp` and `auc:Model/auc:EndTimestamp` refers to data from the 'Current Building Measured` scenario which is used to generate the model in this analysis.

## Model Details
The majority of the details concerning the implemented analysis are stored as part of an individual `auc:DerivedModel/auc:Models/auc:Model`.  This includes:
- `auc:Model/auc:DerivedModelCoefficients`: Calculated coefficients for the model.  Currently, only `auc:DerivedModelCoefficients/auc:Guideline14Model` coefficients have been explicitly defined (in reference to ASHRAE Guideline 14-2014 Figure D-1), although support for `auc:TimeOfWeekTemperatureModel` may be added.
- `auc:Model/auc:DerivedModelInputs`: Whereas `auc:Model/auc:DerivedModelCoefficients` represent actual parameters calculated for the model, this element captures more generic information about the model inputs.
    - `auc:Model/auc:DerivedModelInputs/auc:IntervalFrequency`: Frequency of data used for analysis (monthly, daily, hourly, etc.)
    - `auc:Model/auc:DerivedModelInputs/auc:ResonseVariable`: Store general information about what the response variable is (i.e Electricity), its end use, and the units used in the model (i.e. kWh).
    - `auc:Model/auc:DerivedModelInputs/auc:ExplanatoryVariables`: Store general information about the variables used in the regression / model.
- `auc:Model/auc:DerivedModelPerformance`: Store values associated with the characterized performance of the model, including `RSquared`, `RMSE`, etc.
- `auc:Model/auc:TrainingPredictions`: Predictions of the response variable (yhat) using the model information defined withinfor the time intervals analyzed can be stored here.

# Example - Forecast Method

We provide an example snippet based on analysis performed in the [nmecr overview](https://github.com/kW-Labs/nmecr/blob/master/inst/vignettes/nmecr_overview.pdf).  Or example is performed using the SLR model instead of a TOWT model.

| Model | Start Time | End Time |
|:--- |:---|:---|
| Baseline Period | 2012-03-01 | 2013-02-28 | 
| Reporting Period | 2014-03-01 | 2015-02-28 |

We assume the workflow will look as follows

![img](./img/DerivedModelIO.png)

We will create two scenarios:
1. Scenario to store current building measured data (energy and temperature) (`ID=Scenario-Measured`) (included in both input and output file)
1. Scenario to store a derived model associated with the baseline period (`ID=Scenario-DM-Baseline`) (included in output file)

## Current Building Measured Scenario 

- For NMEC analysis, we expect the 'Current Building Measured' Scenario to capture time series data for __both__ the Baseline Period and the Reporting Period.  Additional data for the Implementation Period may also be included, but isn't necessary nor considered in the analysis.
- For the dependent variable of interest (i.e. electricity), we expect an `auc:ResourceUse` to be declared and the timeseries data to point back to it
- For independent variables, these can also be captured as timeseries elements.

```xml
            <auc:Scenario ID="Scenario-Measured">
              <auc:ScenarioType>
                <auc:CurrentBuilding>
                  <auc:CalculationMethod>
                    <auc:Measured/>
                  </auc:CalculationMethod>
                </auc:CurrentBuilding>
              </auc:ScenarioType>
              <auc:ResourceUses>
                <auc:ResourceUse ID="Elec">
                  <auc:EnergyResource>Electricity</auc:EnergyResource>
                  <auc:ResourceUnits>kWh</auc:ResourceUnits>
                  <auc:EndUse>All end uses</auc:EndUse>
                </auc:ResourceUse>
              </auc:ResourceUses>
              <auc:TimeSeriesData>
                <!-- ...repeat for 12 months for baseline period until endtime of 2013-02-28 -->
                <auc:TimeSeries ID="TS-Daily-BP1">
                  <auc:ReadingType>Total</auc:ReadingType>
                  <auc:StartTimestamp>2012-03-01T00:00:00</auc:StartTimestamp>
                  <auc:IntervalFrequency>Day</auc:IntervalFrequency>
                  <auc:IntervalReading>21505.44</auc:IntervalReading>
                  <auc:ResourceUseID IDref="Elec"/>
                </auc:TimeSeries>
                <auc:TimeSeries ID="TS-Daily-BP2">
                  <auc:ReadingType>Total</auc:ReadingType>
                  <auc:StartTimestamp>2012-03-02T00:00:00</auc:StartTimestamp>
                  <auc:IntervalFrequency>Day</auc:IntervalFrequency>
                  <auc:IntervalReading>20892.24</auc:IntervalReading>
                  <auc:ResourceUseID IDref="Elec"/>
                </auc:TimeSeries>
                <!-- ...repeat for 12 months for reporting period until endtime of 2015-02-28 -->
                <auc:TimeSeries ID="TS-Daily-RP1">
                  <auc:ReadingType>Total</auc:ReadingType>
                  <auc:StartTimestamp>2014-03-01T00:00:00</auc:StartTimestamp>
                  <auc:IntervalFrequency>Day</auc:IntervalFrequency>
                  <auc:IntervalReading>15988.56</auc:IntervalReading>
                  <auc:ResourceUseID IDref="Elec"/>
                </auc:TimeSeries>
                  <!-- ...repeat for every month required for the above -->
                <auc:TimeSeries ID="TimeSeries-1">
                  <auc:ReadingType>Average</auc:ReadingType>
                  <auc:TimeSeriesReadingQuantity>Dry Bulb Temperature</auc:TimeSeriesReadingQuantity>
                  <auc:StartTimestamp>2012-03-01T00:00:00</auc:StartTimestamp>
                  <auc:IntervalFrequency>Day</auc:IntervalFrequency>
                  <auc:IntervalReading>38.42</auc:IntervalReading>
                </auc:TimeSeries>
              </auc:TimeSeriesData>
            </auc:Scenario>
```

## Derived Model - Baseline Period

We perform a simple linear regression model using data from the Baseline Period. In our output, we capture:
- Characteristics of the model
- Coefficients for the model
- Model performance (result of the `nmecr::calculate_summary_statistics` from nmecr)
- Model fit data for the baseline period
- Savings summary data for the reporting period (Result of the `nmecr::calculate_savings_and_uncertainty` function)

```xml
            <auc:Scenario ID="Scenario-DM-Baseline">
              <auc:ScenarioType>
                <auc:CurrentBuilding>
                  <auc:DerivedModel ID="DerivedModel-Baseline">
                    <auc:DerivedModelName>This is my name</auc:DerivedModelName>
                    <auc:MeasuredScenarioID IDref="Scenario-Measured"/>
                    <auc:Models>
                      <auc:Model ID="Scenario-Baseline-DM-SLR">
                        <auc:StartTimestamp>2012-03-01T00:00:00</auc:StartTimestamp>
                        <auc:EndTimestamp>2013-01-01T00:00:00</auc:EndTimestamp>
                        <auc:DerivedModelInputs>
                          <auc:IntervalFrequency>Day</auc:IntervalFrequency>
                          <auc:ResponseVariable>
                            <auc:ResponseVariableName>Electricity</auc:ResponseVariableName>
                            <auc:ResponseVariableUnits>kWh</auc:ResponseVariableUnits>
                            <auc:ResponseVariableEndUse>All end uses</auc:ResponseVariableEndUse>
                          </auc:ResponseVariable>
                          <auc:ExplanatoryVariables>
                            <auc:ExplanatoryVariable>
                              <auc:ExplanatoryVariableName>Drybulb Temperature</auc:ExplanatoryVariableName>
                              <auc:ExplanatoryVariableUnits>Fahrenheit, F</auc:ExplanatoryVariableUnits>
                            </auc:ExplanatoryVariable>
                          </auc:ExplanatoryVariables>
                        </auc:DerivedModelInputs>
                        <auc:DerivedModelCoefficients>
                          <auc:Guideline14Model>
                            <auc:ModelType>2 parameter simple linear regression</auc:ModelType>
                            <auc:Intercept>31433.86</auc:Intercept>
                            <auc:Beta1>-288.1071</auc:Beta1>
                          </auc:Guideline14Model>
                        </auc:DerivedModelCoefficients>
                        <auc:DerivedModelPerformance>
                          <auc:RSquared>0.43</auc:RSquared>
                          <auc:CVRMSE>17.89</auc:CVRMSE>
                          <auc:NDBE>0.00</auc:NDBE>
                          <auc:NMBE>0.00</auc:NMBE>
                        </auc:DerivedModelPerformance>
                        <auc:SummaryInformation>
                          <auc:NumberOfDataPoints>365</auc:NumberOfDataPoints>
                          <auc:NumberOfParameters>2</auc:NumberOfParameters>
                        </auc:SummaryInformation>
                        <!-- The model fit data, i.e. the yhat values of the model -->
                        <auc:TrainingPredictions>
                          <auc:TimeSeries ID="TS-ModelFit-1">
                            <auc:ReadingType>Total</auc:ReadingType>
                            <auc:StartTimestamp>2012-03-01T00:00:00</auc:StartTimestamp>
                            <auc:IntervalFrequency>Day</auc:IntervalFrequency>
                            <auc:IntervalReading>20365.587</auc:IntervalReading>
                          </auc:TimeSeries>
                          <auc:TimeSeries ID="TS-ModelFit-2">
                            <auc:ReadingType>Total</auc:ReadingType>
                            <auc:StartTimestamp>2012-03-02T00:00:00</auc:StartTimestamp>
                            <auc:IntervalFrequency>Day</auc:IntervalFrequency>
                            <auc:IntervalReading>19950.433</auc:IntervalReading>
                          </auc:TimeSeries>
                          <!-- ... repeat for 12 months -->
                        </auc:TrainingPredictions>
                      </auc:Model>
                    </auc:Models>
                    <auc:SavingsSummaries>
                      <auc:SavingsSummary ID="SavingsSummary-SLR">
                        <auc:ReportingPeriodStartTimestamp>2014-03-01T00:00:00</auc:ReportingPeriodStartTimestamp>
                        <auc:ReportingPeriodEndTimestamp>2015-02-28T23:59:00</auc:ReportingPeriodEndTimestamp>
                        <auc:NormalizationMethod>Forecast</auc:NormalizationMethod>
                        <auc:ReportingPeriodActualEnergyUse>5103905</auc:ReportingPeriodActualEnergyUse>
                        <auc:ReportingPeriodCalculatedEnergyUse>5456928</auc:ReportingPeriodCalculatedEnergyUse>
                        <auc:AvoidedEnergyUse>353022.9</auc:AvoidedEnergyUse>
                        <auc:SavingsUncertainty>0.405</auc:SavingsUncertainty>
                        <auc:ConvidenceLevel>0.90</auc:ConfidenceLevel>
                        <auc:BaselineModelID IDref="Scenario-Baseline-DM-SLR"/>
                        <auc:ReportingPeriodPredictions>
                          <auc:TimeSeries ID="TS-Prediction-1">
                            <auc:StartTimestamp>2014-03-01T00:00:00</auc:StartTimestamp>
                            <auc:IntervalFrequency>Day</auc:IntervalFrequency>
                            <auc:IntervalReading>17017</auc:IntervalReading>
                          </auc:TimeSeries>
                        </auc:ReportingPeriodPredictions>
                      </auc:SavingsSummary>
                    </auc:SavingsSummaries>
                  </auc:DerivedModel>
                </auc:CurrentBuilding>
              </auc:ScenarioType>
            </auc:Scenario>
```


# Definitions and Concept Clarification
__Note: italicized words after a reference identify the name of the concept used in the reference__

- Baseline period:
    - period of time selected as representative of facility operations before retrofit.  CPUC defines this specifically as 12-months [1] __baseline period__
    - The baseline period is the 12-month period leading up to the energy efficiency intervention or retrofit. [2] __baseline period__
- Implementation period:
    - period of time during which the energy conservation measures are being installed.
- Reporting period / performance period:
    - period of time following implementation of an energy conservation measure when savings reports adhere to the guideline. This period may be as short as the time for an instantaneous measurement of a constant quantity, long enough to reflect all normal operating modes of a system or facility with variable operations, the length of the financial payback period for an investment, the duration of a perfor- mance measurement period under an energy performance contract, or indefinite. [1] __reporting period__
    - The Reporting Period is the period of time over which the savings from energy efficiency interventions
      and retrofits are measured. The reporting period immediately follows the implementation period. [2] __reporting period__ / __post-implementation performance monitoring__ / __performance period__
- Baseline period actual energy use (BAE) [1] __baseline energy__
- Reporting period actual energy use (RAE)
- Reporting period calculated energy use (RCE), also referred to as the Adjusted Baseline Energy Use [4]
- Baseline period calculated energy use at standard conditions (BCESC)
- Reporting period calculated energy use at standard conditions (RCESC)
- Avoided Energy Use (AEU):
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

# References
[1] ASHRAE Guideline 14-2014
[2] CPUC NMEC Rulebook, v2.0, 07 Jan. 2020
[3] California Industrial SEM M&V Guide, v1.0, 08 Feb. 2017
[4] https://github.com/kW-Labs/nmecr/blob/master/inst/vignettes/nmecr_overview.pdf
