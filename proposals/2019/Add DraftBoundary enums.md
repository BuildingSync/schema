# DraftBoundary - Add Enumerations

## Overview

The current definition `auc:DomesticHotWaterType` element and its child elements is not sufficient to distinguish between direct- and indirect-fired, instantaneous water heaters.

## Justification

In both cases, the BuildingSync XML is:

```
<auc:DomesticHotWaterType>
  <auc:Instantaneous>
    <auc:InstantaneousWaterHeatingSource>
      <auc:Combustion/>
    </auc:InstantaneousWaterHeatingSource>
  </auc:Instantaneous>
</auc:DomesticHotWaterType>
```

## Implementation

This proposal is to add a `<auc:DraftBoundary>` element with the following enumerations:
* "Direct"
* "Direct indirect"
* "Indirect"
* "Other"

With this proposal, direct- and indirect-fired, instantaneous water heaters are asserted as follows:

**Direct-fired, instantaneous:**

```
<auc:DomesticHotWaterType>
  <auc:Instantaneous>
    <auc:InstantaneousWaterHeatingSource>
      <auc:Combustion>
        <auc:DraftBoundary>Direct</auc:DraftBoundary>
      </auc:Combustion>
    </auc:InstantaneousWaterHeatingSource>
  </auc:Instantaneous>
</auc:DomesticHotWaterType>
```

**Indirect-fired, instantaneous:**

```
<auc:DomesticHotWaterType>
  <auc:Instantaneous>
    <auc:InstantaneousWaterHeatingSource>
      <auc:Combustion>
        <auc:DraftBoundary>Indirect</auc:DraftBoundary>
      </auc:Combustion>
    </auc:InstantaneousWaterHeatingSource>
  </auc:Instantaneous>
</auc:DomesticHotWaterType>
```

## References

n/a
