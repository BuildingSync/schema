# Add DaylightingIlluminanceSetpointUnits Element

## Overview

The `auc:DaylightingIlluminanceSetpoint` element should have a corresponding "units" element.

## Justification

Currently, the units of measure for the `auc:DaylightingIlluminanceSetpoint` element is given in lux.
Other units of measure are defined in the literature, e.g., foot-candle [1].

## Implementation

This proposal is to add a new `auc:DaylightingIlluminanceSetpointUnits` element as an enumeration with the following values:
* "fc" (Foot-candle)
* "lux" (Lumens per square meter)
* "phot" (Lumens per square centimeter)
* "Other"
* "Unknown"

## References

1. https://www.noao.edu/education/QLTkit/ACTIVITY_Documents/Safety/LightLevels_outdoor+indoor.pdf
