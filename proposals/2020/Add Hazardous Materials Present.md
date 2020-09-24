# Add Hazardous Materials Present

## Overview

This proposal is to add the `auc:HazardousMaterialsPresent` element.

## Justification

SPC 211 Standard for Commercial Building Energy Audits section 6.2.5.2 states
>Hazardous Materials. If the possible presence of hazardous materials at the site is apparent, either through observation or as reported by others, the possible presence of the hazardous material shall be identified in the report as potentially having a significant impact on the measure cost estimates

## Implementation

Add boolean element `auc:HazardousMaterialsPresent` to `auc:Measure` to indicate if there are any hazardous materials present.
