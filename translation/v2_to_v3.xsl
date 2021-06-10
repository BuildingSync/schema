<?xml version="1.0" encoding="UTF-8"?>

<!--

XML Stylesheet Language Transformation (XSLT) to transform BuildingSync from v2 to v3

Version: 0.1.0

-->

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:auc="http://buildingsync.net/schemas/bedes-auc/2019"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	exclude-result-prefixes="xs">

  <xsl:output method="xml" version="1.0" encoding="UTF-8" omit-xml-declaration="no" indent="yes"/>

  <xsl:template match="/">
    <xsl:comment>This BuildingSync v3.0 document was generated from a BuildingSync v2.X document via an XML Stylesheet Language Transformation (XSLT).</xsl:comment>
    <xsl:text>&#10;</xsl:text>
    <xsl:copy>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <!--xsl:template match="@xsi:schemaLocation">
    <xsl:attribute name="xsi:schemaLocation">http://buildingsync.net/schemas/bedes-auc/2019 https://raw.githubusercontent.com/BuildingSync/schema/v3.0.0/BuildingSync.xsd</xsl:attribute>
  </xsl:template-->

  <xsl:template match="@auc:version">
    <xsl:attribute name="auc:version">3.0.0</xsl:attribute>
  </xsl:template>

  <!-- Map "Repair leaks / seal ducts" to "Repair leaks in ducts" -->
  <xsl:template match="auc:MeasureName[. = 'Repair leaks / seal ducts']">
    <xsl:copy>Repair leaks in ducts</xsl:copy>
  </xsl:template>

  <!-- Limit auc:MeasureName to exactly one by commenting out all other auc:MeasureNames -->
  <xsl:template match="auc:MeasureName[not(position() = 1)]">
    <xsl:message>WARNING: commenting out auc:MeasureName <xsl:value-of select="current()"/></xsl:message>
    <xsl:comment>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:comment>
  </xsl:template>

  <!-- Transform auc:WallID element under auc:Side to auc:WallIDs/auc:WallID element -->
  <xsl:template match="auc:WallID">
    <xsl:element name="auc:WallIDs">
      <xsl:copy-of select="."/>
    </xsl:element>
  </xsl:template>
  
  <!-- Transform auc:WindowID element under auc:Side to auc:WindowIDs/auc:WindowID element -->
  <xsl:template match="auc:WindowID">
    <xsl:element name="auc:WindowIDs">
      <xsl:copy-of select="."/>
    </xsl:element>
  </xsl:template>

  <!-- Transform auc:DoorID element under auc:Side to auc:DoorIDs/auc:DoorID element -->
  <xsl:template match="auc:DoorID">
    <xsl:element name="auc:DoorIDs">
      <xsl:copy-of select="."/>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
