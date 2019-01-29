# Rename the Root Element

## Overview

Presently, the root element of the BuildingSync schema is Audit. Having the root element as Audit limits the scope of
BuildingSync to 'projects' that are audits, assuming the user does not want to confuse the consumer for 'projects' that 
are non-audits. In addition, the existing schema is designed to allow multiple audits in a single instance.

There exist several use cases where BuildingSync should be used even though the overall 'project' was not a ASHRAE
Standard 211-type audit. For example: 

1) exporting building from Asset Score 
2) generating a hypothetical building for use in advanced workflows (e.g. simulations)
3) no touch audits which may not be classified as an ASHRAE Standard 211 audit
4) transferring building data for use in M&V IPMVP Option C/D type analysis
5) exporting a benchmarking building from SEED.

Prior root sequence for BuildingSync are:

```bash
Audits/Audit/Sites/Site/Facilities
```

## Justification

As described in the Overview, the use cases of BuildingSync is easily extended past the commonly defined audit-based schema.
Traditionally, the root element of an XML schema is a term used to define the data that will be described in detail. With this in
mind, the existing root element of Audits means that the schema is defining an Audit (which is partly true); however, this schema is 
more reallistically defining a Building (or Facility). Also, based on other commonly used schemas, the root element is often 
named the same as the schema (e.g. HPXML root element is HPXML, gbXML root element is gbXML); therefore, the root element in 
this implementation could/should be `BuildingSync`.


## Implementation

The proposed implementation is to rename the root element sequence from `Audits/Audit/Sites/Site/Facilities/Facility` to 

    * `BuildingSync/Facilities/Facility/Sites/Site/Buildings/Building`  
 
## References

https://bedes.lbl.gov/bedes-online/building-1