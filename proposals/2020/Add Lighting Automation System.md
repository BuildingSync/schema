# Add Lighting Automation System

## Overview

This proposal is to add `auc:LightingAutomationSystem` element at the `auc:Building` and `auc:LightingSystem` levels.

## Justification

In reference to lighting systems, SPC 211 Standard for Commercial Building Energy Audits requires

> A listing of lighting control system types (manual switching, step switching, dimmers, photosensors, occupancy sensors, timers)

BuildingSync is capable of handling the controls mentioned, however there's no notion of lighting automation systems in the schema, which is relevant to lighting controls.

## Implementation

Add an optional, boolean element `auc:LightingAutomationSystem` at the `auc:Building` and `auc:LightingSystem`.
