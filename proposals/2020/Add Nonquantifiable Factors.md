# Update Annual Fuel Use Native Units

## Overview

This proposal is to add the `auc:NonquantifiableFactors` element to `auc:PackageOfMeasures`.

## Justification

SPC 211 Standard for Commercial Building Energy Audits section 6.2.6.1 states
>For each practical measure, report ... Include a description of the nonquantifiable factors...

Nonquantifiable factors should really be interpreted as 'factors that are highly difficult to quantify, or unquantifiable given the existing infrastructure or budget'. This might include aspects such as:

- Improve indoor air quality
- Improve occupant comfort
- Improve occupant satisfaction
- Reduce glare
- Improve access to daylight
etc.

## Implementation

Add `auc:NonquantifiableFactors` to `auc:PackageOfMeasures` as a free-form text field.
