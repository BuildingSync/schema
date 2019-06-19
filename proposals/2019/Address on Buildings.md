# Add the Address Element to a Building

## Overview

The release of Version 1.0 added the concept of a building to the schema; however, the building element does not have the concept of an address. The parent element, Site, does contain an address element

## Justification

The need to have two addresses is logical when dealing with campuses. In the campus use case, a Site can have an address (the contact/mailing address) and each building in the campus can have another address.

If there is only one site and one building, then it is at the user discretion to select which address to fill out. It is encouraged to verify with the Use Case Selection Tool which fields are required based on the BuildingSync use case. It is also recommended to use the higher level address over the building level address element.


## Implementation

This proposal is to:
1. Add BuildingSync/Facilities/Facility/Sites/Site/Buildings/Building/Address element.
2. The address element references the global Address element.

## References

N/A
