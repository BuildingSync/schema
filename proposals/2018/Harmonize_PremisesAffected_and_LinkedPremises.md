# Harmonize Definitions of `PremisesAffected` and `LinkedPremises` Elements

## Overview

The BuildingSync XML (BSXML) schema provides more than one way to relate a concept to other elements, including `Site`, `Facility` and `Subsection` elements: the `PremisesAffected` and `LinkedPremises` elements.

The duplication of functionality is confusing for end-users and downstream software developers.

## Justification

An example of the usage of the `PremisesAffected` element (within the context of a `Measure` element) is:

```xml
<Measure>
  <!-- ... before ... -->
  <PremisesAffected>
    <PremiseAffected IDref="Site1">
      <MeasureCoverage>10</MeasureCoverage>
    </PremiseAffected>
    <PremiseAffected IDref="Facility1">
      <MeasureCoverage>20</MeasureCoverage>
    </PremiseAffected>
    <PremiseAffected IDref="Subsection1">
      <MeasureCoverage>40</MeasureCoverage>
    </PremiseAffected>
  </PremisesAffected>
  <!-- ... after ... -->
</Measure>
```

A corresponding example of the usage of the `LinkedPremises` element is:

```xml
<LinkedPremises>
  <Site>
    <LinkedSiteID IDref="Site1"/>
  </Site>
  <Facility>
    <LinkedFacilityID IDref="Facility1"/>
  </Facility>
  <Subsection>
    <LinkedSubsectionID IDref="Subsection1"/>
  </Subsection>
</LinkedPremises>
```

Note that:

* The `PremisesAffected` element is a child of the `Measure` element. Within each `PremiseAffected` element, there may be a child `MeasureCoverage` element.
* Unlike the `LinkedPremises` element and its child elements, the `PremiseAffected` element does not indicate the type of the referenced element (the target of the `IDref` attribute).

## Implementation

This proposal is:
1. To remove the `PremisesAffected` element and to replace its use with that of the `LinkedPremises` element.
2. To remove the `MeasureCoverage` element and to replace its use with that of the `FloorAreas` element.

For example:

```xml
<Measure>
  <!-- ... before ... -->
  <LinkedPremises>
    <Site>
      <LinkedSiteID IDref="Site1">
        <FloorAreas>
          <FloorArea>
            <FloorAreaType>Tenant</FloorAreaType>
            <FloorAreaPercentage>10</FloorAreaPercentage>
          </FloorArea>
        </FloorAreas>
      </LinkedSiteID>
    </Site>
    <Facility>
      <LinkedFacilityID IDref="Facility1">
        <FloorAreas>
          <FloorArea>
            <FloorAreaType>Tenant</FloorAreaType>
            <FloorAreaPercentage>20</FloorAreaPercentage>
          </FloorArea>
        </FloorAreas>
      </LinkedFacilityID>
    </Facility>
    <Subsection>
      <LinkedSubsectionID IDref="Subsection1">
        <FloorAreas>
          <FloorArea>
            <FloorAreaType>Tenant</FloorAreaType>
            <FloorAreaPercentage>40</FloorAreaPercentage>
          </FloorArea>
        </FloorAreas>
      </LinkedSubsectionID>
    </Subsection>
  </LinkedPremises>
  <!-- ... after ... -->
</Measure>
```

Note that:
* Using XSD, the `LinkedPremises` element can be defined as a child element of the `Measure` element (with optional `MeasureCoverage` elements).
* The `LinkedPremises` structure indicates the type of the referenced element.
* The `FloorAreaType` element indicates the floor area type ("Tenant" in the above example).

## References

n/a
