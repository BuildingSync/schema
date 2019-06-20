# Add Footprint to Building Element

## Overview

The current structure is to have the footprint shape defined at the subsection level. The purpose of the proposal is to allow the footprint shape to also be defined at the building level.

## Justification

The footprint can be defined at both levels, that is, the building and subsection level. For example a building can have an overall rectangular footprint, but the underlying subsections can have L-shape footprints.

## Implementation

Copy the `auc:FootprintShape` element to the auc:BuildingType.

## References

N/A
