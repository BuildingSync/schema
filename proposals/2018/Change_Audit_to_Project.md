# Changes to Support Other Project Types #

## Overview ##
The BuildingSync schema can be useful and leveraged for more types of project than just audits, and the current schema uses an audit element that can be confusing. After changing the root element to not be Audit, this proposal will add information to help identify the BuildingSync instance.

## Justification ##
A few relatively small changes are proposed to better support other cases. The proposed BuildingSync element names have been reviewed by LBNL BEDES team so that they use BEDES compliant terms and structure.

## Implementation ##
~~Three~~ Two changes are proposed to better support non-audit projects: 

~~* Change the name of the "Audit" element to "Project". This is a breaking change, but as an element renaming it is a fairly minimal change.~~
* Add a new element called "ProgramIdentifier" as a child of BuildingSync This change is non-breaking.
* For the Program Identifier add new elements "ProgramDate", "ProgramFundingSource", "ProgramClassification". This change is non-breaking.

## References ##
NA