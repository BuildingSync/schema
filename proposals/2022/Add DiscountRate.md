# Add Discount Rate

## Overview

This proposal is support the assertion of discount rates in BuildingSync XML schema.

## Justification

### Present Value Calculation

The equation for net present value is:

$$ NPV\left({i,N}\right) = \sum*{t=0}^{N}{\frac{R*{t}}{\left({1+i}\right)^t}} $$

where

- $i$ is the discount rate (percentage).
- $N$ is the total number of periods (non-negative integer).
- $t$ is the time of the cash flow (non-negative integer).
- $R_{t}$ is the cash flow at time $t$ (decimal).

Currently, BuildingSync XML schema supports the assertion of discount factors via the `<auc:DiscountFactor>` element, where the discount factor $v$ is related to the discount rate $i$ by the following equation:

$$ v = \frac{1}{1 + i} $$

### Service Life

BuildingSync XML schema supports the assertion of the service life in years via the `<auc:UsefulLife>` element.
Currently, the datatype is `xsd:decimal`, which allows for fractional and negative years.
However, ASHRAE [reports](http://weblegacy.ashrae.org/publicdatabase/) median life in non-negative integer years.

## Implementation

The proposed implementation consists of 3 tasks:

1. Add `<auc:DiscountRate>` element (non-breaking change).
2. Add documentation to definitions of `<auc:DiscountFactor>` and `<auc:DiscountRate>` elements to clarify their mathematical relationship (non-breaking change).
3. Constrain datatype of `<auc:UsefulLife>` element to `xsd:nonNegativeInteger` (breaking change).
