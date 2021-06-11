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

  <xsl:template match="@auc:version">
    <xsl:attribute name="auc:version">3.0.0</xsl:attribute>
  </xsl:template>

  <!-- Measures -->

  <!-- 1. Map "Repair leaks / seal ducts" to "Repair leaks in ducts" -->
  <xsl:template match="auc:MeasureName[. = 'Repair leaks / seal ducts']">
    <xsl:copy>Repair leaks in ducts</xsl:copy>
  </xsl:template>
  <!-- 2. Map "Insulate attic hatch / stair box" to "Insulate attic hatch" -->
  <xsl:template match="auc:MeasureName[. = 'Insulate attic hatch / stair box']">
    <xsl:copy>Insulate attic hatch</xsl:copy>
  </xsl:template>
  <!-- 3. Map enumeration "MORE" to "MROE" under auc:eGRIDRegionCode -->
  <xsl:template match="auc:eGRIDRegionCode/auc:MeasureName[. = 'MORE']">
    <xsl:copy>MROE</xsl:copy>
  </xsl:template>
  <!-- 4. Map enumeration "Convert to Cleaner Fuels" to "Convert to cleaner fuels" under auc:BoilerPlantImprovements -->
  <xsl:template match="auc:BoilerPlantImprovements/auc:MeasureName[. = 'Convert to Cleaner Fuels']">
    <xsl:copy>Convert to cleaner fuels</xsl:copy>
  </xsl:template>
  <!-- 5. Map enumeration "Energy cost reduction through rate adjustments - uncategorized" to "Other" under auc:EnergyCostReductionThroughRateAdjustments/auc:MeasureName -->
  <xsl:template match="auc:EnergyCostReductionThroughRateAdjustments/auc:MeasureName[. = 'Energy cost reduction through rate adjustments - uncategorized']">
    <xsl:copy>Other</xsl:copy>
  </xsl:template>
  <!-- 6. Map auc:FutureOtherECMs to auc:Uncategorized -->
  <xsl:template match="auc:FutureOtherECMs">
    <xsl:element name="auc:Uncategorized">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <!-- 7. Limit auc:MeasureName to exactly one by commenting out all other auc:MeasureNames -->
  <xsl:template match="auc:MeasureName[not(position() = 1)]">
    <xsl:message>WARNING: commenting out auc:MeasureName <xsl:value-of select="current()"/></xsl:message>
    <xsl:comment>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:comment>
  </xsl:template>
  <!-- 8. Move enumeration "Add or replace cooling tower" from auc:OtherHVAC/auc:MeasureName to auc:ChillerPlantImprovements/auc:MeasureName -->
  <xsl:template match="auc:OtherHVAC[auc:MeasureName = 'Add or replace cooling tower']">
    <xsl:element name="auc:ChillerPlantImprovements">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <!-- 9. Move enumeration "Install or upgrade master venting" from auc:OtherHVAC/auc:MeasureName to auc:ChilledWaterHotWaterAndSteamDistributionSystems/auc:MeasureName -->
  <xsl:template match="auc:OtherHVAC[auc:MeasureName = 'Install or upgrade master venting']">
    <xsl:element name="auc:ChilledWaterHotWaterAndSteamDistributionSystems">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <!-- 10. Move enumeration "Separate SHW from heating" from auc:ChilledWaterHotWaterAndSteamDistributionSystems/auc:MeasureName to auc:ServiceHotWaterSystems/auc:MeasureName -->
  <xsl:template match="auc:ChilledWaterHotWaterAndSteamDistributionSystems[auc:MeasureName = 'Separate SHW from heating']">
    <xsl:element name="auc:ServiceHotWaterSystems">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <!-- 11. Map enumeration "Add heat recovery" from auc:BuildingAutomationSystems/auc:MeasureName to "Add energy recovery" under auc:OtherHVAC/auc:MeasureName-->
  <xsl:template match="auc:BuildingAutomationSystems[auc:MeasureName = 'Add heat recovery']">
    <xsl:element name="auc:OtherHVAC">
      <auc:MeasureName>Add energy recovery</auc:MeasureName>
    </xsl:element>
  </xsl:template>

  <!-- Systems and other components -->

  <!-- 1. Deprecate auc:Capacity and auc:CapacityUnits under auc:Delivery -->
  <xsl:template match="auc:Delivery/auc:Capacity">
    <xsl:comment>auc:Delivery/auc:Capacity is deprecated in version 3.0.</xsl:comment>
  </xsl:template>
  <xsl:template match="auc:Delivery/auc:CapacityUnits">
    <xsl:comment>auc:Delivery/auc:CapacityUnits is deprecated in version 3.0.</xsl:comment>
  </xsl:template>
  <!-- 2. Map auc:PrimaryHVACSystemType to auc:PrincipalHVACSystemType -->
  <xsl:template match="auc:PrimaryHVACSystemType">
    <xsl:element name="auc:PrincipalHVACSystemType">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <!-- 3. Map auc:InstalledFlowRate to auc:FanInstallFlowRate under auc:FanSystem -->
  <xsl:template match="auc:FanSystem/auc:InstalledFlowRate">
    <xsl:element name="auc:FanInstallFlowRate">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <!-- 4. Map auc:OutputCapacity to auc:Capacity for auc:HeatingSource and HeatingPlant types -->
  <xsl:template match="auc:HeatingSource/auc:OutputCapacity">
    <xsl:element name="auc:Capacity">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="auc:Boiler/auc:OutputCapacity">
    <xsl:element name="auc:Capacity">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="auc:DistrictHeating/auc:OutputCapacity">
    <xsl:element name="auc:Capacity">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="auc:SolarThermal/auc:OutputCapacity">
    <xsl:element name="auc:Capacity">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <!-- 5. Transform auc:WallID, auc:WindowID, auc:DoorID elements under auc:Side to auc:WallIDs/auc:WallID, auc:WindowIDs/auc:WindowID, auc:DoorIDs/auc:DoorID elements -->
  <xsl:template match="auc:WallID">
    <xsl:element name="auc:WallIDs">
      <xsl:copy-of select="."/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="auc:WindowID">
    <xsl:element name="auc:WindowIDs">
      <xsl:copy-of select="."/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="auc:DoorID">
    <xsl:element name="auc:DoorIDs">
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
