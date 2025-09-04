# Add Enums to ballastType

## Overview

<auc:BallastType> enumeration does not distinguish between “Standard Electronic” and “Premium Electronic” values (both are mapped to “Electronic”).

## Justification

There exists a need for certain users to differentiate between Standard Electronic and Premium Electronic for ballast type. THIS IS A BREAKING CHANGE.

## Implementation

This proposal is to:

Remove 'Electronic'
Add 'Standard Electronic'
Add 'Premium Electronic'

enums to:
BuildingSync/Facilities/Facility/Systems/LightingSystems/LightingSystem/BallastType

## References

N/A
