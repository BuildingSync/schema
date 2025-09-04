# Versioning

Having consistent meanings of versions is helpful to users. By the version alone, a user can determine whether or not an implementation of BuildingSync supports their existing documents or not.

Since version 2.0.0 (post 2016 version reset), BuildingSync attempts to follow [semantic versioning](https://semver.org/). Since semantic versioning (semver) is more directed towards APIs, it can be helpful to translate the meaning of breaking changes, non-breaking features, and patches. When thinking about the API of an xml schema, consider XPaths, when and how they break, as well as document validation, when and how historical documents are no longer valid, as these are the use cases of XML documents.

Note that BuildingSync reset the numbering of the schema in 2016.

## Breaking changes

These are the changes that require a new MAJOR version. Generally this would be any time where there could exist a historical document that would not validate against the new schema. This would include:

- adding a required element/attribute that was not previously required
- moving the location of an existing element or changing its name (e.g. moving order in sequence or to different parent)
- changing to an incompatible type (e.g. decimal to integer)
- changing the restrictions for a simple type to something which is not the superset of the previous restriction

## Non-breaking features

These are the changes that require a new MINOR version. This would include any changes which are meaningful changes to the schema, but do not break the validation of historical documents. For example:

- adding a new non-required element/attribute
- changing a simple type to a compatible type (e.g. decimal to string)
- adding a new enum option for a simple type

## Patches

These are the changes that require a new PATCH version. This would include changes which do not meaningfully change the schema. For example:

- updating the documentation
- restructuring the XSD without changing the schema (e.g. turning an inline element definition into a reference or creating a new type)
