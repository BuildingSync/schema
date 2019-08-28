# BuildingSync®

[![Build Status](https://travis-ci.org/BuildingSync/schema.svg?branch=develop)](https://travis-ci.org/BuildingSync/schema)

BuildingSync® is a common schema for energy audit data that can be 
utilized by different software and databases involved in the energy 
audit process. It allows data to be more easily aggregated, compared 
and exchanged between different databases and software tools. This 
streamlines the energy audit process, improving the value of the data
and facilitating achievement of greater energy efficiency.

The schema is developed by a National Renewable Energy Laboratory 
(NREL) led working group. Working group participants included industry 
partners, national laboratories, and industry organizations.


### GBXML Schema Referencing

This version of BuildingSync references the GBXML schema to allow GBXML-valid geometry data to be present in a BuildingSync instance file.  For proper functioning, there must be a local copy of the GBXML schema present and pointed to by the BuildingSync schema.  The current GBXML schema can be found [here](http://www.gbxml.org/Schema_Current_GreenBuildingXML_gbXML).  Save it in the directory you want, and then edit the 'schemaLocation' attribute of the `<xs:import>` element near the top of BuildingSync.xsd with a path to the proper directory and the correct file name.

In the /examples folder, there are two new files: 

`Single_building_gmxml_externalreference_geometry.xml`

`Multi_building_gmxml_externalreference_geometry.xml  `

These are very basic mockups of BuildingSync files with GBXML geometry data added to them, showcasing the formatting of an end-case XML file and that they validate against the schema while containing foreign GBXML data.  The BSync schema can be referenced for what GBXML elements are allowed and where (just search 'gbxml:' to find any gbxml references).  Essentially, there are a number of geometry-specific elements that are children of GBXML's `<Space>` element which can now be placed inside of a BuildingSync `<Space>` element.  One thing to note is that any existing IdRef-type attributes in the GBXML data may cause validation errors (depending on how strict of an XML validator is used), as they are referencing id's of elements that are from the original GBXML instance file, which will not be present in the BSync instance file.  These can be removed a variety of ways; here's a simple XSLT transformation which can be applied to the document:

<pre><code>
&lt;xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"&gt;
    &lt;xsl:template match="@***name of attribute to remove***" /&gt;
    &lt;xsl:template match="@*|node()"&gt;
        &lt;xsl:copy&gt;
            &lt;xsl:apply-templates select="@*|node()"/&gt;
        &lt;/xsl:copy&gt;
    &lt;/xsl:template&gt;
&lt;/xsl:stylesheet&gt;
</code>
</pre>