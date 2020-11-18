# Limit MeasureName to one

## Overview

This proposal is limit the occurrence of MeasureName to 1 for all TechnologyCategories. This is a breaking change.

## Justification

Measures should represent singular energy conservation change ([BEDES](https://bedes.lbl.gov/bedes-online/reporting-level)). For a collection of changes one should use `PackageOfMeasures`.

## Implementation

Change `maxOccurs="1"` for every `auc:MeasureName`.
