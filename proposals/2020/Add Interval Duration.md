# Add Interval Duration

## Overview

This proposal is to add `auc:IntervalDuration` and `auc:IntervalDurationUnits` elements in order to better validate and specify time series durations.

## Justification

SPC 211 Standard for Commercial Building Energy Audits section 6.2.2.1.a.6 requires "Number of days in month or period" for Historical Utility Data.

## Implementation

Add `auc:IntervalDuration` and `auc:IntervalDurationUnits` to `auc:TimeSeries`. Interval duration will be an integer, and duration units will have the same enums as `auc:IntervalFrequency`