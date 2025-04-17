# Add Files elements

## Overview

This proposal is to add new elements to enable file attachment feature in BuildingSync XML files. 
There are three outstanding potential use cases requesting this feature:
* An old request of this feature brought by Audit Template Tool in this [issue](https://github.com/BuildingSync/schema/issues/391), revealing compatibility needs with some building assessment standards that require data file attachments along with the report/submission. 
* This is also inferred in outreaching effort, where a few contacts indicated that pictures are essential data generated during audit process.
* As we are broadening the capability of mapping BuildingSync with different data tools or schema, file attachment feature could be a strong candidate solution for mapping with complex schemas, which might potentially introduce significant changes, bias, duplication, redundancy, or even subversive structure changes to the current BuildingSync schema. For example, mapping with ASHRAE STD 229 would bring in a lot of BEM related elements that might be irrelavent to auditing, or even requires refactor of the whole schema structure. That being said, enabling file attachment function allows BuildingSync to carry information from another data source, while keeping the consistency/purity of the main BuildingSync structure.

## Justification

The main questions to justify here are 
### How do we want to structure file attachments within a BuildingSync report?
* Distribute `Files` under applicable elements, or
* Use a universal `Files` element under `Facility` to store all file attachments, and utilize linking element mechanism to point to the files under applicable elements (e.g. adding `LinkedFiles`).

### Where / what element should we allow file attachments with?
* `Building`
  * Picture ofthe building
* `WeatherStations`
  * Weather data
* `System`
  * Picture of the system/label
  * System manual
* `Report`/`Scenario`
  
### What details should a `File` element carry?
Per suggestion in the Audit Template Tool request, these elements are necessary information to describe a file attachment
* The file name and description;
* The file MIME type;
* The file size and checksum; and
* The file URL and/or encoded blob data.

### What should we be careful with?
* File attachment might lose the capability of direct translation and data transferability for anything that lives in the attached file, especially for the purpose / use case of mapping with another schema.
* Do we and how do we constrain the usage of file attachment?
* The file has to live in an existing URL - it can not go with the BuildingSync XML file but the element simply provides a link/reference to the existing resource.

## Implementation
Proposed implementation goes with the universal `Files` element pathway:
Under `Facility`, in parallel to `Sites`, `Systems` and so on:
```xml
  <xs:element name="Files" minOccurs="0">
    <xs:complexType>
      <xs:sequence>
        <xs:element name="File" type="auc:FileType" maxOccurs="unbounded"/>
      </xs:sequence>
    </xs:complexType>
  </xs:element>
```
Universally, define `FileType`:
```xml
  <xs:complexType name="FileType">
    <xs:annotation>
      <xs:documentation>File attachment associated with the audit report for supplemental information other than the general XML fields</xs:documentation>
    </xs:annotation>
    <xs:sequence>
      <xs:element name="FileName" type="xs:string" minOccurs="0">
        <xs:annotation>
          <xs:documentation>Name identifying the file other than the ID</xs:documentation>
        </xs:annotation>
      </xs:element>
      <xs:element name="FileDescription" type="xs:string" minOccurs="0">
        <xs:annotation>
          <xs:documentation>Details about the file</xs:documentation>
        </xs:annotation>
      </xs:element>
      <xs:element name="FileContentType" type="auc:ContentType" minOccurs="0">
        <xs:annotation>
          <xs:documentation>MIME type of the file</xs:documentation>
        </xs:annotation>
      </xs:element>
      <xs:element name="FileSize" type="xs:integer" minOccurs="0">
        <xs:annotation>
          <xs:documentation>Size of file in Megabyte (MB)</xs:documentation>
        </xs:annotation>
      </xs:element>
      <xs:element name="FileChecksum" type="xs:string" minOccurs="0">
        <xs:annotation>
          <xs:documentation>The digital fingerprint for file integrity and authenticity verification, if applicable, such as SHA-1, MD5, etc.</xs:documentation>
        </xs:annotation>
      </xs:element>
      <xs:element name="FileURL" type="xs:string">
        <xs:annotation>
          <xs:documentation>The address (permanent link peferred) to the intenet location where the file is stored</xs:documentation>
        </xs:annotation>
      </xs:element>
      <xs:element ref="auc:UserDefinedFields" minOccurs="0"/>
    </xs:sequence>
    <xs:attribute name="ID" type="xs:ID" use="required"/>
  </xs:complexType>
```
Additionally to support the `FileContentType`, we may define a universal element `ContentType` with applicable file format enumerations:
```xml
  <xs:simpleType name="ContentType">
    <xs:restriction base="xs:string">
      <xs:enumeration value="text/plain"/>
      <xs:enumeration value="text/csv"/>
      <xs:enumeration value="text/html"/>
      <xs:enumeration value="image/jpeg"/>
      <xs:enumeration value="image/png"/>
      <xs:enumeration value="image/tiff"/>
      <xs:enumeration value="image/gif"/>
      <xs:enumeration value="image/bmp"/>
      <xs:enumeration value="audio/mpeg"/>
      <xs:enumeration value="audio/ogg"/>
      <xs:enumeration value="audio/wav"/>
      <xs:enumeration value="video/mp4"/>
      <xs:enumeration value="video/webm"/>
      <xs:enumeration value="video/mpeg"/>
      <!--.avi-->
      <xs:enumeration value="video/x-msvideo"/>
      <xs:enumeration value="application/json"/>
      <xs:enumeration value="application/xml"/>
      <xs:enumeration value="application/pdf"/>
      <xs:enumeration value="application/zip"/>
      <!--.rar-->
      <xs:enumeration value="application/vnd.rar"/>
      <!--.tar-->
      <xs:enumeration value="application/x-tar"/>
      <!--.7z-->
      <xs:enumeration value="application/x-7z-compressed"/>
      <!--.doc-->
      <xs:enumeration value="application/msword"/>
      <!--.docx-->
      <xs:enumeration value="application/vnd.openxmlformats-officedocument.wordprocessingml.document"/>
      <!--.xls-->
      <xs:enumeration value="application/vnd.ms-excel"/>
      <!--.xlsx-->
      <xs:enumeration value="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"/>
      <!--.ppt-->
      <xs:enumeration value="application/vnd.ms-powerpoint"/>
      <!--.pptx-->
      <xs:enumeration value="application/vnd.openxmlformats-officedocument.presentationml.presentation"/>
      <xs:enumeration value="application/dwg"/>
      <xs:enumeration value="application/dxf"/>
      <!--.rvt-->
      <xs:enumeration value="application/octet-stream"/>
      <xs:enumeration value="application/ifc"/>
      <xs:enumeration value="application/vnd.sketchup.skp"/>
      <xs:enumeration value="Other"/>
      <xs:enumeration value="Unknown"/>
    </xs:restriction>
  </xs:simpleType>
```
