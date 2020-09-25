# Green Building XML (gbXML) Schema Referencing

BuildingSync can reference the gbXML schema to allow gbXML-valid geometry data to be present in a BuildingSync file. The current gbXML schema can be found [here](http://www.gbxml.org/Schema_Current_GreenBuildingXML_gbXML). The current gbXML version referenced is [6.01](http://www.gbxml.org/schema/6-01/GreenBuildingXML_Ver6.01.xsd).

There are two examples in the examples folder:

* `Single_building_gmxml_externalreference_geometry.xml`
* `Multi_building_gmxml_externalreference_geometry.xml`

The examples are basic mockups of BuildingSync files with gbXML geometry data, showcasing the formatting of an end-case XML file and which validate against the both BuildingSync and gbXML schema while containing foreign gbXML data. The gbXML elements allowed are prefixed with (namespaced) with `gbXML`.

The elements are primarily geometry-specific elements that are children of gbXML's `<Space>` element and can be placed inside of a BuildingSync `<Space>` element.  Note that any existing IDref-type attributes in the gbXML data may cause validation errors (depending the XML validator strictness), as they are referencing ID's of elements that are from the original gbXML instance file, which will not be present in the BuildingSync instance file.  These can be removed a variety of ways; here's a simple XSLT transformation which can be applied to the document:

<pre><code>
&lt;xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"&gt;
    &lt;xsl:template match="@nameOfAttributeToRemove" /&gt;
    &lt;xsl:template match="@*|node()"&gt;
        &lt;xsl:copy&gt;
            &lt;xsl:apply-templates select="@*|node()"/&gt;
        &lt;/xsl:copy&gt;
    &lt;/xsl:template&gt;
&lt;/xsl:stylesheet&gt;
</code>
</pre>

