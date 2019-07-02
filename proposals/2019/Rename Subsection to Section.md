# Rename Subsection to Section

## Overview

This proposal renames the Subsections/Subsection child element of Building to Sections/Section and adds an enumeration to clarify what the section represents.

## Justification

Presently, the schema uses "subsection" terminology that users have found confusing. With no "section" in the schema, it is unclear what is meant.
This change will clarify the meaning of section and allow users to express the intent of the section. 

## Implementation

The Subsections/Subsection child element of Building will be renamed to Sections/Section, and a new enumeration called SectionType will be added with the following values:

* Whole Building:  the section describes the whole building
* Space Function: the section describes a space function (see ASHRAE standard 211)
* Component: the section describes a subspace of a primary premises. Examples of components are: HVAC zones, retail shops in a mall, floors in a multi-story building, etc. (BEDES)
* Virtual: the section is loosely defined and may overlap with others
* Other: the section is not well-described by any of the other types

The original idea included a "Custom" value, but that has been dropped in favor of adding more values.

The Section elements do not have to be mutually exclusive, for example, there can be a Section describing the whole building and another Section describing the Space Function of a portion of the building. For example, this change allows for geometry (FloorShape) to be described for a whole building section and for a space function.

## References

* https://bedes.lbl.gov/bedes-online/premises-level
* https://bedes.lbl.gov/bedes-online/spatial-unit-type
