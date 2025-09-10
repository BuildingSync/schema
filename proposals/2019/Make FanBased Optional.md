# Make FanBased ZoneEquipment Optional

## Overview

The fan based zone equipment object was set to be required. If a building has only radiant panels, then this requirement is not necessary.

## Justification

A user needs to be able to specify a radiant system without a fan based system

## Implementation

Add `minOccurs="0"` to FanBasedType

This is a non-breaking change.

## References

N/A
