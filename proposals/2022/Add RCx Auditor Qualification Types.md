# Add RCx Auditor Qualification Types

## Overview

This proposal is to add new enumerations to the `<auc:AuditorQualificationType>` element for retrocommissioning (RCx) auditor qualification types and then to sort the enumerations in alphabetical order.

## Justification

The current definition of the `<auc:AuditorQualificationType>` element does not define enumerations for RCx.

Sorting in alphabetical order will make it easier to add new enumerations in future.

## Implementation

This proposal is to:
1. Add the following enumerations to the `<auc:AuditorQualificationType>` element:
  * AABC Commissioning Group (ACG) Commissioning Authority (CxA)
  * Building Commissioning Association (BCA) Certified Commissioning Professional (CCP)
  * Building Commissioning Certification Board (BCCB) Certified Commissioning Professional (CCP)
  * MEP Professional Engineer
  * National Environmental Balancing Bureau (NEBB) Building Systems Commissioning (BSC)
  * University of Wisconsin Accredited Commissioning Process Authority Professional (CxAP or CAP)
  * University of Wisconsin Accredited Commissioning Process Manager (CxM)
  * University of Wisconsin Accredited Green Commissioning Process Provider (GCxP or GCP)
2. Sort the enumerations in the `<auc:AuditorQualificationType>` element in alphabetical order.
