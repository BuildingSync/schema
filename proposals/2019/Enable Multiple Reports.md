# Enable Multiple Reports in a Single BuildingSync XML Data

## Overview
At present, BuildingSync allows only a single report in valid XML data. This proposal will expand the schema to allow for multiple reports and will make the necessary additions to the Report type to facilitate this change. The changes are breaking.

## Justification
A single report per file limits the extent to which reports can be associated with different parts of buildings or systems. This is particularly an issue when data has been collected for part of a building, but the report implicitly applies to all buildings in the file. Furthermore, BuildingSync should be able to track changes over time, and allowing multiple reports means that this will be easier to do. Users can simply add a new report if another audit is done rather than add to previous data. While this isn't strictly necessary, it is a slightly more natural representation and should be easier on users.

## Implementation
Three steps will be taken to make this change:

  1. The report element will be changed into a containerized list: `<Reports><Report/></Reports>`.
  2. Building off of the `LinkedPremises` type, create a linkage type that allows users to specify that the report applies to a premises or a system. It is possible that a union type will accomplish this.
  3. Modify the example files to use the containerized lists of reporting.

Step 2 is not breaking changes, but step 1 is. If we are rigidly following semantic versioning, at the completion of this modification the version number of the schema will need to be bumped to 2.0.
