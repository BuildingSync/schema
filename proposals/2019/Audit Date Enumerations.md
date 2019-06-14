# Add List of Audit Dates and Enumerations

## Overview

There are several dates that are of interest during an audit such as the site visit, the completion of the audit, and perhaps others. The current path to the Audit Date is BuildingSync/Facilities/Facility/Reports/Report/AuditDate. This field is defined as just the date the audit was conducted.


## Justification

The schema needs to be extended to store several dates related to audits. 

## Implementation

Add a new paired element container to store multiple dates for any report. 

New container will be `BuildingSync/Facilities/Facility/Reports/Report/AuditDates/AuditDate`.

The existing enumerations being proposed are:

```xml
	<xs:enumeration value="Site Visit"/>
	<xs:enumeration value="Conducted"/>
	<xs:enumeration value="Completion"/>
```

## References

N/A

