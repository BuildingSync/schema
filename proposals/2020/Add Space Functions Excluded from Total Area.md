# Document space functions excluded from floor area calculations

## Overview

This proposal is to modify the schema to allow specifying which sections (specifically space functions) are not included in a building's gross and conditioned floor area values.

## Justification

Standard 211 section 6.2.1.1.a.4 specifies
> A listing of energy uses associated with space types that are not included in the gross floor area in Section 6.2.1.1(b) (parking garages, surface parking)

In other words, BuildingSync must be able to specify which `Space function`s are included (or excluded) in calculating:
- `auc:Building/auc:FloorAreas/auc:FloorArea[auc:FloorAreaType/text() = "Gross"]/auc:FloorAreaValue`
- `auc:Building/auc:FloorAreas/auc:FloorArea[auc:FloorAreaType/text() = "Conditioned"]/auc:FloorAreaValue`

## Implementation

There are multiple ways to implement this.

### Option 1

```xml
...
<auc:Building>
  <auc:FloorAreas>
    <auc:FloorArea>
      <auc:FloorAreaType>Gross</auc:FloorAreaType>
      <auc:FloorAreaValue>123</auc:FloorAreaValue>
      <!-- add this element -->
      <auc:ExcludedSectionIDs>
        <auc:ExcludedSectionID IDref="SpaceFunction-A" />
      </auc:ExcludedSectionIDs>
    </auc:FloorArea>
    <auc:FloorArea>
      <auc:FloorAreaType>Conditioned</auc:FloorAreaType>
      <auc:FloorAreaValue>123</auc:FloorAreaValue>
      <!-- add this element -->
      <auc:ExcludedSectionIDs>
        <auc:ExcludedSectionID IDref="SpaceFunction-A" />
      </auc:ExcludedSectionIDs>
    </auc:FloorArea>
  </auc:FloorAreas>
  ...
  <auc:Sections>
    <auc:Section ID="SpaceFunction-A">
      <auc:SectionType>Space function</auc:SectionType>
      ...
    </auc:Section>
  </auc:Sections>
</auc:Building>
...
```

#### Pros
- non-breaking
- more flexible b/c allows specifying spaces on a per-floor-area basis (though this could be a con (tedious) if that's not useful)

#### Cons
- using ID references makes xpathing more difficult. E.g. user wants to find all spaces included in gross floor area calculation

#### Variations
- move `auc:ExcludedSectionIDs` under `auc:FloorAreas`, then it applies to _all_ floor area types

### Option 2

```xml
...
<auc:Building>
  <auc:FloorAreas>
    <auc:FloorArea>
      <auc:FloorAreaType>Gross</auc:FloorAreaType>
      <auc:FloorAreaValue>123</auc:FloorAreaValue>
    </auc:FloorArea>
    <auc:FloorArea>
      <auc:FloorAreaType>Conditioned</auc:FloorAreaType>
      <auc:FloorAreaValue>123</auc:FloorAreaValue>
    </auc:FloorArea>
  </auc:FloorAreas>
  ...
  <auc:Sections>
    <auc:Section ID="SpaceFunction-A">
      <auc:SectionType>Space function</auc:SectionType>
      <!-- add this element -->
      <auc:ExcludedFromBuildingFloorAreas>true</auc:ExcludedFromBuildingFloorAreas>
      ...
    </auc:Section>
  </auc:Sections>
</auc:Building>
...
```

#### Pros
- non-breaking
- xpaths don't require references, ie easier to xpath

#### Cons
- less flexible b/c requires exclusion from _all_ floor area calculations (though could be a pro if that's the common use case)
- (opinion) feels awkward to have a child element specify how a parent element's value was calculated

#### Variations
- add an element for every floor area type, e.g. `ExcludedFromBuildingGrossFloorAreas` and `ExcludedFromBuildingConditionedFloorAreas`

### Option 3

```xml
...
<auc:Building>
  <auc:FloorAreas>
    <auc:FloorArea>
      <auc:FloorAreaType>Gross</auc:FloorAreaType>
      <auc:FloorAreaValue>123</auc:FloorAreaValue>
    </auc:FloorArea>
    <auc:FloorArea>
      <auc:FloorAreaType>Conditioned</auc:FloorAreaType>
      <auc:FloorAreaValue>123</auc:FloorAreaValue>
    </auc:FloorArea>
  </auc:FloorAreas>
  ...
  <auc:Sections>
    <auc:Section ID="SpaceFunction-A">
      <!-- add this enum type -->
      <auc:SectionType>Space function - excluded from building floor area</auc:SectionType>
      ...
    </auc:Section>
  </auc:Sections>
</auc:Building>
...
```

#### Pros
- non-breaking
- xpaths don't require references, ie easier to xpath

#### Cons
- less flexible b/c requires exclusion from _all_ floor area calculations (though could be a pro if that's the common use case)
- takes special consideration when xpathing space functions (this is technically still a space function but now it has a different auc:Section type)
- (opinion) feels awkward to have a child element specify how a parent element's value was calculated

#### Variations
- add a type for every floor area type, e.g. `Space function - excluded from building gross floor area`, etc

## Decision
We decided to implement Option 1.

## References

Standard 211 6.2.1.1.a.4
