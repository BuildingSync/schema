# Justification of IDREF Updates
 
## Definition of "IDREFs" 

These letters, whether lower or uppercase, only appear in three ways within the BuildingSync.xsd schema file. They are either the value of an attribute's name, the value of an attribute's type, or the value of an extension's base:
    
```xml
<xs:attribute name="IDref" type="xs:IDREF" use="required"/>
```
	
In this case, the marked "IDref" refers to the value of the attribute's name. The W3C has no standard specifications for whether an attribute's name should contain lowercase or uppercase letters. As long as this name contains alphanumeric characters and it does not start with a number, it is up to standard. Therefore, "IDref" is an acceptable string to use as the value of an attribute's name according to W3C standards.

```xml
<xs:attribute name="IDref" type="xs:IDREF" use="required"/>
```

In this case, the marked "xs:IDREF" refers to the value of the attribute's type (data type). According to W3C standard specifications, the "xs:" portion of an attribute's type value must be stated in lowercase letters and the "IDREF" portion must contain only uppercase letters. Therefore, "xs:IDREF" is the correct string to use as the value of an attribute's type according to W3C standards.

```xml
<xs:extension base="xs:IDREF">
```

In this case, the marked "xs:IDREF" refers to the value of the extension's base. The value of this base can be the name of a built-in data type, a simpleType element, or a complexType element; in this case, the base value is a data type. According to W3C standard specifications, the "xs:" portion of an extension's data type value must be stated in lowercase letters and the "IDREF" portion must contain only uppercase letters. Therefore, "xs:IDREF" is the correct string to use as the value of an extension's data type according to W3C standards.

## Recommendation

The BuildingSync schema is already complete without the need for a Proposal and its related work.

## Justification

All IDREF instances-either as `name="IDref"`, `type="xs:IDREF"`, or `base="xs:IDREF"`-are consistent throughout the whole BuildingSync.xsd document as it stands before any work is performed on it by PSD. All instances are cased consistently, following W3C standards; therefore, there is no work needed in order to make the schema compliant. Furthermore, since no modifications to the BuildingSync schema are required, there is no need for a proposal to be submitted for this task. 
