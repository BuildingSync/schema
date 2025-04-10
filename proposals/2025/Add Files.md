# Add Files elements

## Overview

This proposal is to add new elements to enable file attachment feature in BuildingSync XML files. 
There are three outstanding potential use cases requesting this feature:
* An old request of this feature brought by Audit Template Tool in this [issue](https://github.com/BuildingSync/schema/issues/391), revealing compatibility needs with some building assessment standards that require data file attachments along with the report/submission. 
* This is also inferred in outreaching effort, where a few contacts indicated that pictures are essential data generated during audit process.
* As we are broadening the capability of mapping BuildingSync with different data tools or schema, file attachment feature could be a strong candidate solution for mapping with complex schemas, which might potentially introduce significant changes, bias, duplication, redundancy, or even subversive structure changes to the current BuildingSync schema. For example, mapping with ASHRAE STD 229 would bring in a lot of BEM related elements that might be irrelavent to auditing, or even requires refactor of the whole schema structure. That being said, enabling file attachment function allows BuildingSync to carry information from another data source, while keeping the consistency/purity of the main BuildingSync structure.

## Justification

The main questions to justify here are 
### How do we want to structure file attachments within a BuildingSync report?
* Distribute `Files` under applicable elements, or
* Use a universal `Files` element under `Facility` to store all file attachments, and utilize linking element mechanism to point to the files under applicable elements (e.g. adding `LinkedFiles`).
### Where / what element should we allow file attachments with?
* `Building`
  * Picture ofthe building
* `WeatherStations`
  * Weather data
* `System`
  * Picture of the system/label
  * System manual
* `Report`/`Scenario`
  
### What details should a `File` element carry?
Per suggestion in the Audit Template Tool request, these elements are necessary information to describe a file attachment
* The file name and description;
* The file MIME type;
* The file size and checksum; and
* The file URL and/or encoded blob data.

### Cons
File attachment might lose the capability of direct translation and data transferability for anything that lives in the attached file, especially for the purpose / use case of mapping with another schema.

## Implementation

