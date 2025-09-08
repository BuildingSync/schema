# Resource Use Submetering

## Overview

This proposal is to modify `auc:ResourceUse` to allow modeling of submeters.

## Justification

SPC 211 Standard for Commercial Building Energy Audits section 6.2.2.1.d states the following regarding historical utility data.

> A description of the submetering installed in the building (if present), including a listing of the systems metered, the frequency of data recording, and a description of the data acquisition system (fixed, portable, or integrated with the BAS), shall be provided.

## Implementation

### Option 1

Use ResourceUses to model submetering by adding the elements `auc:MeterID` and `auc:ParentResourceUseID`. `auc:MeterID` should contain the ID of the meter as seen by the facility manager. `auc:ParentResourceUseID` links to another `auc:ResourceUse` to signify that it's a submeter of the parent resource use.

#### Pros

- simple, no breaking changes

#### Cons

- Not great data modeling

### Option 2

Implement a new metering modeling system. This would incur a breaking change most likely, and the implementation is currently uncertain.

#### Pros

- better data modeling

#### Cons

- breaking change

## Decision

We've decided to go with Option 1 for now, and push the refactoring of meter modeling to BuildingSync v3
