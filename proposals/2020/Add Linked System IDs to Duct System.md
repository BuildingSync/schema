# Add LinkedSystemIDs to DuctSystem

## Overview

This proposal is to add the `auc:LinkedSystemIDs` child element to the `auc:DuctSystem` element.

## Justification

Currently, ducts only have `auc:LinkedPremises`, but Ducts should be linkable directly to a delivery system. This is how `auc:FanSystem` works as well.

## Implementation

Copy `auc:LinkedSystemIDs` into `DuctSystemType`.
