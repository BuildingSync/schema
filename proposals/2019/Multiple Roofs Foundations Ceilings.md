# Allow Multiple Roofs, Foundations, and Ceilings on Section

## Overview

A section is allowed to only have a single reference of RoofID, CeilingID, and FoundationID. This causes issues when there may be more than one roof/ceiling/foundation in a section.

## Justification

Audit Template Tool allows for a list of roofs, ceilings, and foundations, however, there is no easy way to reference these multiple constructions in the Sites/Building path.

## Implementation

Create containers for Roofs, Ceilings, and Foundations similar to the Sides element at `//BuildingSync/Facilities/Facility/Sites/Site/Buildings/Building/Sections/Section/Sides`.

* Move `//element(*:BuildingType)/Sections/Section/RoofID` under `//element(*:BuildingType)/Sections/Section/Roofs/Roof`. Make `Roof` unbounded.
* Move `//element(*:BuildingType)/Sections/Section/CeilingID` under `//element(*:BuildingType)/Sections/Section/Ceilings/Ceiling`. Make `Ceiling` unbounded.
* Move `//element(*:BuildingType)/Sections/Section/FoundationID` under `//element(*:BuildingType)/Sections/Section/Foundations/Foundation`. Make `Foundation` unbounded.

## References

N/A
