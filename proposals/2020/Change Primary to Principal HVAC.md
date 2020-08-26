# Change Primary HVAC to Principal HVAC

## Overview

This proposal is to change the element `auc:PrimaryHVACSystemType` element to the `auc:PrincipalHVACSystemType` element.

## Justification

In Standard 211, the term "Principal HVAC" is used rather than "Primary HVAC", see section 5.3.4.

## Implementation
Change the element name to `auc:PrincipalHVACSystemType`, and update annotation documentation to say principal.


## Decision
We will allow users to use _either_ `auc:PrimaryHVACSystemType` or `auc:PrincipalHVACSystemType` for now, and add a warning that `PrimaryHVACSystemType` is being deprecated. It should be fully removed in the next major version.

## References

Standard 211 5.3.4
