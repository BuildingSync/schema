# Allow Multiple Walls for Side

## Overview

This proposal is to modify the `auc:Side` to allow an unbounded number of `auc:Wall` IDs to be referenced

## Justification

Currently you can only reference one wall ID for each `auc:Side`. This is an issue if a side of a building is composed of more than one wall type.

## Implementation

This proposal suggests the schema creates a choice between a single `auc:WallID` (how things currently are), or `auc:WallIDs` which contains an unbounded number of wall IDs. This is non-breaking and the former choice could be dropped in the next major release.
