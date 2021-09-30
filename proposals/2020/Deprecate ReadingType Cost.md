# Deprecate ReadingType Cost

## Overview

This proposal is to deprecate the enum "Cost" within `auc:ReadingType` of `auc:TimeSeries`.

## Justification

`auc:ReadingType` should describe how a value was calculated, not its "units" or the quantity being measured. In addition `TimeSeriesReadingQuantity` already has Currency.

This proposal suggests that we deprecate Cost, and change `TimeSeriesReadingQuantity`'s Currency to Cost.
