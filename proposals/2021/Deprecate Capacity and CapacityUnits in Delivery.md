# Deprecate Capacity and CapacityUnits in Delivery

## Overview

This proposal is to deprecate the `Capacity` and `CapacityUnits` elements under `Delivery` element.

## Justification

The linked systems of `Delivery` element (`HeatingSource` and `CoolingSource`) have their own capacities defined individually, so it does not make sense to declare `Capacity` under `Delivery`. This will be deprecated in version 3.0.

## References
