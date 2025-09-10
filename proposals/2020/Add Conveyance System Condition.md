# Add Conveyance System Condition

## Overview

This proposal is to add `auc:ConveyanceSystemCondition` to `auc:ConveyanceSystem`.

## Justification

SPC 211 Standard for Commercial Building Energy Audits section 6.2.1.6.c states

> Conveyance equipment (elevators, escalators, and automated people movers) shall be identified, including their condition (excellent, good, average, poor).

## Implementation

Add an optional element `auc:ConveyanceSystemCondition` of type `auc:EquipmentCondition` to `auc:ConveyanceSystem`.
