# BuildingSync Feature Proposal - External File Reference Support #

## Overview ##
The following document is a feature proposal for supporting (multiple) external file references in BuildingSync, e.g. importing timeseries data from Green Button Data, and/or building geometry via gbXML, into BuildingSync. This FP will present the use case of a user wishing to import gbXML data into BuildingSync.

## Justification ##
As a standardized language for exchanging commercial building data between audit tools, BuildingSync needs to also support building energy modeling tools and data exchange formats thereof (i.e., gbXML), as well as simulation-level data from either simulations or real building audits. BuildingSync must be capable of referencing and validating against multiple schemas simultaneously.

## Implementation ##
###Mapping gbXML-to-BldgSync

| Building Sync | gbXML |
| :---: | :---: |
|Site | Campus |
|Facility | Building |

###Schema Details

* `Campus` (Building Sync `Site`)
	* `Building` (Buulding Sync `Facility`)
		* `BuildingStorey`
		* `PlanarGeometry`
			* `Space` (has a ZoneID)
				* `SpaceBoundary` - this field seems to define the bounding box(?)
	* Surface - `Surface` entries have `AdjacentSpaceId` (single), but no "SpaceId" or ZoneId". **Unclear how surface geometry is associated with spaces.**


###TODO
1. Add suppot for other gbXML elements (do we want to support non-geometry elements? e.g. Schedules)
2. Define mapping for low-level building elements

## References ##

**gbXML**

* [About gbXML](http://www.gbxml.org/About_GreenBuildingXML_gbXML)
* [Sample gbXML files](https://github.com/GreenBuildingXML/Sample-gbXML-Files)
* [Test Cases](http://www.gbxml.org/TestCases_for_GreenBuildingXML_gbXML)

**Green Button**

* [Green Button Data Developers](http://www.greenbuttondata.org/developers.html)
* [Green Button Developers Repo](https://green-button.github.io/build/)
* [Green Button Schema (XML)](https://github.com/energyos/OpenESPI-Common-java/blob/master/etc/espiDerived.xsd)
* [Green Button Data Parser (Ruby)](https://github.com/cew821/greenbutton)

**JSON**

* [JSON Schema](https://cswr.github.io/JsonSchema/)
* [JSON - auxiliary schema](https://cswr.github.io/JsonSchema/spec/definitions_references/)
* [JSON Schema - combining schemas](https://json-schema.org/understanding-json-schema/reference/combining.html)
* [allOf: usage](https://stackoverflow.com/questions/29781040/json-schema-possible-to-reference-multiple-schemas-from-one-object)

