# Allow Multiple Windows for Side

## Overview

This proposal is to modify the `auc:Side` to allow an unbounded number of `auc:WindowID`s to be referenced

## Justification

Currently you can only reference one window ID for each `auc:Side`. This is an issue if a side of a building has multiple window types.

## Implementation

This proposal suggests the schema creates a choice between a single `auc:WindowID` (how things currently are), or `auc:WindowIDs` which contains an unbounded number of window IDs. This is non-breaking and the former choice could be dropped in the next major release.
