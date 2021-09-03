# BuildingSync Project Haystack Example

The files in this directory contain an example implementation of connecting a BuildingSync model (.xml) to a [Project Haystack](https://project-haystack.org/) model (.json). The files are _not_ valid schema representations and are shortened to highlight the relevant common elements and entities.

## BuildingSync

The BuildingSync XML file contains three _new_ high-level elements under the `<Building>` element, listed below, that describe details of the metadata ontology or schema. These elements are placed here to accomodate multiple buildings on a single site that may use different metadata schemas, e.g. Brick, Haystack, and ASHRAE 223.

```xml
            ...
            <NEWExternalMetaDataID>860d52bd-9f0e-4986-8644-866bcb24d480</NEWExternalMetaDataID>
            <NEWExternalMetaDataType>Project Haystack</NEWExternalMetaDataType>
            <NEWExternalMetaDataTypeVersion>3.0</NEWExternalMetaDataTypeVersion>
            ...
```
 
The file also contains one _new_ low-level element `<NEWExternalMetaDataEntityID>` showing an example connection to a Haystack entity, shown below.
 
```xml
        <HVACSystem ID="HVACSystem-1">
          <PrincipalHVACSystemType>BuildingSync Packaged Rooftop Heat Pump</PrincipalHVACSystemType>
          <NEWExternalMetaDataEntityID>9d7b67cb-e07d-4f07-98b2-08f3c6df0400</NEWExternalMetaDataEntityID>
```
 
## Project Haystack
 
The Project Haystack JSON file shows an example entity with a common ID to connect to the `<NEWExternalMetaDataEntityID>` BuildingSync element.
 
```json
     {
    "id": "9d7b67cb-e07d-4f07-98b2-08f3c6df0400",
    "dis": "Project Haystack Packaged Rooftop Heat Pump",
    "ahu": "m",
    "equip": "m",
    },
```
