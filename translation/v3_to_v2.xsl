<?xml version="1.0" encoding="UTF-8"?>

<!--

XML Stylesheet Language Transformation (XSLT) to transform BuildingSync from v3 to v2

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
    <xsl:comment>This BuildingSync v2.3 document was generated from a BuildingSync v3.X document via an XML Stylesheet Language Transformation (XSLT).</xsl:comment>
    <!--xsl:text>&#10;</xsl:text-->
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

  <xsl:template match="@version">
    <xsl:attribute name="version">2.3.0</xsl:attribute>
  </xsl:template>

  <!-- Measures -->

  <!-- 1. Map "Repair leaks in ducts" to "Repair leaks / seal ducts" -->
  <xsl:template match="auc:MeasureName[. = 'Repair leaks in ducts']">
    <xsl:copy>Repair leaks / seal ducts</xsl:copy>
  </xsl:template>
  <!-- 2. Map "Insulate attic hatch" to "Insulate attic hatch / stair box" -->
  <xsl:template match="auc:MeasureName[. = 'Insulate attic hatch']">
    <xsl:copy>Insulate attic hatch / stair box</xsl:copy>
  </xsl:template>
  <!-- 3. Map enumeration "MROE" to "MORE" under auc:eGRIDRegionCode -->
  <xsl:template match="auc:eGRIDRegionCode/auc:MeasureName[. = 'MROE']">
    <xsl:copy>MORE</xsl:copy>
  </xsl:template>
  <!-- 4. Map enumeration "Convert to cleaner fuels" to "Convert to Cleaner Fuels" under auc:BoilerPlantImprovements -->
  <xsl:template match="auc:BoilerPlantImprovements/auc:MeasureName[. = 'Convert to cleaner fuels']">
    <xsl:copy>Convert to Cleaner Fuels</xsl:copy>
  </xsl:template>

  <!-- Systems and other components -->

  <!-- 1. Map auc:PrincipalHVACSystemType to auc:PrimaryHVACSystemType -->
  <xsl:template match="auc:PrincipalHVACSystemType">
    <xsl:element name="auc:PrimaryHVACSystemType">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <!-- 2. Map auc:FanInstallFlowRate to auc:InstalledFlowRate under auc:FanSystem -->
  <xsl:template match="auc:FanSystem/auc:FanInstalledFlowRate">
    <xsl:element name="auc:InstalledFlowRate">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <!-- 3. Map auc:Capacity to auc:OutputCapacity for auc:HeatingSource and HeatingPlant types -->
  <xsl:template match="auc:HeatingSource/auc:Capacity">
    <xsl:element name="auc:OutputCapacity">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="auc:Boiler/auc:Capacity">
    <xsl:element name="auc:OutputCapacity">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="auc:DistrictHeating/auc:Capacity">
    <xsl:element name="auc:OutputCapacity">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="auc:SolarThermal/auc:Capacity">
    <xsl:element name="auc:OutputCapacity">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <!-- 4. Transform auc:WallIDs/auc:WallID, auc:WindowIDs/auc:WindowID, auc:DoorIDs/auc:DoorID elements under auc:Side to auc:WallID, auc:WindowID, auc:DoorID elements -->
  <xsl:template match="auc:WallIDs">
    <xsl:copy-of select="auc:WallID"/>
  </xsl:template>
  <xsl:template match="auc:WindowIDs">
    <xsl:copy-of select="auc:WindowID"/>
  </xsl:template>
  <xsl:template match="auc:DoorIDs">
    <xsl:copy-of select="auc:DoorID"/>
  </xsl:template>

</xsl:stylesheet>
