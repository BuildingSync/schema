# Add WCM Categories

## Overview

This proposal is to add new measure enumerations for existing categories under `auc:Measure/auc:TechnologyCategories/auc:TechnologyCategory/auc:BuildingEnvelopeModifications`.

## Justification

Responding to the request of adding new measures into BuildingSync related to window/shading retrofit, by PNNL/LBNL collaborative Commercial Building and Window Assessment projects, BuildingSync proposed to add two new measures (enumerations) to the existing measure category `BuildingEnvelopeModifications`, which covers measures implemented on fenestration (window/shading) systems. The proposed measures are:

- Add secondary window systems/attachments
- Install shading automation system

## Implementation
The enumerations will be added as in this structure: 
`auc:Measure`
    `auc:TechnologyCategories`
        `auc:TechnologyCategory`
            `auc:<BuildingEnvelopeModifications>`
                `auc:MeasureName`
                    `[enumerations]`.
