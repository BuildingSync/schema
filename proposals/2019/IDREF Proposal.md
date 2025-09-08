# Ensure all "IDREF" are consistent and W3C compliant

## Overview

The BuildingSync.xsd document includes several instances of values with the "IDREF" string. It is hereby proposed these instances be checked to ensure they are:

- Compliant with the W3C Recommendation pertaining to XML Schemas, i.e., "W3C compliant."
- Consistent throughout the schema document.

## Justification

The BuildingSync XML schema must be W3C compliant to provide satisfactory performance and portability across systems. It must also be consistent to ensure proper code execution and facilitate future code review and possible modifications.

## Implementation

The following non-breaking changes must take place in the BuildingSync.xsd document:

1. Find all occurrences of the string "IDREF." Include occurrences where some/all letters are lowercase.
2. Group occurrences based on their code statement’s tag type (e.g., element, attribute, extension, etc.) and tag attribute type (e.g., type, base, name, etc.).
3. Research the W3C standards that apply to each occurrence "group."
4. If any occurrence is not W3C compliant, rename it according to W3C XML standards.
5. If any occurrence is not consistent with other occurrences of the same type, rename it to ensure consistency. Maintain W3C compliance.

## References

More information on W3C XML schema standards can be found here: https://www.w3schools.com/xml/
