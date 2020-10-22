# Add Peak Type

## Overview

This proposal is to add the `auc:PeakType` element in order to specify what type of peak a given reading is.

## Justification

SPC 211 Standard for Commercial Building Energy Audits section 6.2.2.1.a.8 requires "Actual or billed (or both if reported) peak electric demand (kW), identified as on-peak, mid-peak, and off-peak" for Historical Monthly Utility Data.

## Implementation

Inside of auc:TimeSeries, create a new element `auc:PeakType` as a child element of the TimeSeriesType with options of on-peak, mid-peak, and off-peak.