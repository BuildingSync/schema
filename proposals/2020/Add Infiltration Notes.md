# Add Infiltration Notes

## Overview

This proposal is to add `auc:AirInfiltrationNotes` and `auc:WaterInfiltrationNotes` elements to meet STD 211 requirements.

## Justification

STD 211 6.2.1.2.e states
> Results of assessment of the enclosure’s overall tightness against air infiltration/exfiltration, coordinated with the assessment of building ventilation per Section 5.4.5.2(n), including a statement of the auditor’s methods used, criteria, evidence, and basis of evaluation (Assessment shall include an overall condition rating on a scale of 1 [poor = high infiltration/exfiltration] to 3 [excellent = tight, low infiltration/exfiltration].)

Currently there's no way for users to specify methods/criteria/evidence etc of the infiltration assessment. This new element addresses this need.

## Implementation

Add optional elements `auc:AirInfiltrationNotes` and `auc:WaterInfiltrationNotes` to `auc:AirInfiltrationSystem` and `auc:WaterInfiltrationSystem`, respectively.
