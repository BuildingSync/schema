# Allow Multiple Doors for Side

## Overview

This proposal is to modify the `auc:Side` to allow an unbounded number of `auc:DoorID`s to be referenced

## Justification

Currently you can only reference one door ID for each `auc:Side`. This is an issue if a side of a building has multiple door types.

## Implementation

This proposal suggests the schema creates a choice between a single `auc:DoorID` (how things currently are), or `auc:DoorIDs` which contains an unbounded number of door IDs. This is non-breaking and the former choice could be dropped in the next major release.
