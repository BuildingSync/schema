# Replicate Site Elements in Building Element

## Overview

Replicate certain child elements of the `auc:SiteType` element in the `auc:BuildingType` element.

## Justification

In Audit Template, users may submit audits for individual buildings and/or multi-building, New York City (NYC) properties.
To make them available to users in both cases, specific metadata elements, e.g., latitude and longitude coordinates, are persisted in the Audit Template database at the building level, i.e., individual buildings may have their own latitude and longitude coordinates.
Currently, it is not possible to represent this building level information as BuildingSync.

## Implementation

This proposal is to:

1. Reify the following child elements of the `auc:SiteType` element and then add them to the `auc:BuildingType` element:
   - `auc:ClimateZoneType`
   - `auc:eGRIDRegionCode`
   - `auc:WeatherDataStationID`
   - `auc:WeatherStationName`
   - `auc:WeatherStationCategory`
   - `auc:Longitude`
   - `auc:Latitude`

## References

n/a
