# Change Audit to Support Other Projects #

## Overview ##
The BuildingSync schema can be useful and leveraged for more types of project than just audits, and the current schema uses an audit element that can be confusing.

## Justification ##
BuildingSync can be useful and leveraged for programs that require representation of different project types. The current schema uses an "Audit" tag that is confusing for non-audit projects and does not include a standard way to input program-related information.

A few relatively small changes are proposed to better support other cases. The proposed BuildingSync element names have been reviewed by LBNL BEDES team so that they use BEDES compliant terms and structure.

## Implementation ##
Three changes are proposed to better support non-audit projects: 

* Change the name of the "Audit" element to "Project". This is a breaking change, but as an element renaming it is a fairly minimal change.
* Add a new element called "ProgramIdentifier" (location of Program could be either in Audit/Project or a parent of Audit/Project). This change is non-breaking.
* For the Program Identifier add new elements "ProgramDate", "ProgramFundingSource", "ProgramClassification". This change is non-breaking.

## References ##
NA
