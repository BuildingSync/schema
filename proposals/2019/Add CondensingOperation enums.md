# CondensingOperation - Add Enumerations

## Overview

The `auc:CondensingOperation` element should be an enumeration.

## Justification

Currently, the `auc:CondensingOperation` element is Boolean-valued, asserting that a furnace or boiler is either condensing or non-condensing.
As such, it is not possible to assert that a furnace or boiler is near-condensing.

## Implementation

This proposal is to replace the definition of the `auc:CondensingOperation` element with an enumeration of the following values:

- "Condensing"
- "Near-Condensing"
- "Non-Condensing"
- "Other"
- "Unknown"

## References

n/a
