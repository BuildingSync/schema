# Changes to Support Other Project Types

## Overview

The BuildingSync schema can be useful and leveraged for more types of project than just audits, and the current schema uses an audit element that can be confusing. After changing the root element to not be Audit, this proposal will add information to help identify the BuildingSync instance.

## Justification

A few relatively small changes are proposed to better support other cases. The proposed BuildingSync element names have been reviewed by LBNL BEDES team so that they use BEDES compliant terms and structure.

## Implementation

The proposed implementation is to add the elements marked with a '_' to the BuildingSync.xsd code: >BuildingSync/
oPrograms/_
-Program/_
+ProgramDate_
+ProgramFundingSource*
+ProgramClassification*
oFacilities/Facility/
Note that this root element sequence refers to the one explained in Proposal #64.

Steps:
a)Create an element named 'Programs' as a sibling of 'Facility.'
b)Create an element named 'Program' as a child of 'Programs.'
c)Create the elements 'ProgramDate,' 'ProgramFundingSource,' and 'Program Classification' as children of 'Program.'
d)Add the BEDES definition of each BEDES term used as a description of the mentioned elements.

## References

Site used to research BEDES terms: https://bedes.lbl.gov/bedes-online
