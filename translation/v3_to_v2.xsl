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

  <xsl:template match="@auc:version">
    <xsl:attribute name="auc:version">2.3.0</xsl:attribute>
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
  <!-- 5. Map enumeration "Energy cost reduction through rate adjustments - uncategorized" to "Other" under auc:EnergyCostReductionThroughRateAdjustments/auc:MeasureName -->
  <!--xsl:template match="auc:EnergyCostReductionThroughRateAdjustments/auc:MeasureName[. = 'Energy cost reduction through rate adjustments - uncategorized']">
    <xsl:copy>Other</xsl:copy>
  </xsl:template-->
  <!-- 6. Map auc:FutureOtherECMs to auc:Uncategorized -->
  <!--xsl:template match="auc:FutureOtherECMs">
    <xsl:element name="auc:Uncategorized">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template-->
  <!-- 7. Limit auc:MeasureName to exactly one by commenting out all other auc:MeasureNames -->
  <!--xsl:template match="auc:MeasureName[not(position() = 1)]">
    <xsl:message>WARNING: commenting out auc:MeasureName <xsl:value-of select="current()"/></xsl:message>
    <xsl:comment>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:comment>
  </xsl:template-->
  <!-- 8. Move enumeration "Add or replace cooling tower" from auc:ChillerPlantImprovements/auc:MeasureName to auc:OtherHVAC/auc:MeasureName -->
  <!--xsl:template match="auc:ChillerPlantImprovements[auc:MeasureName = 'Add or replace cooling tower']">
    <xsl:element name="auc:OtherHVAC">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template-->
  <!-- 9. Map enumeration "Install or upgrade master venting" from auc:ChilledWaterHotWaterAndSteamDistributionSystems/auc:MeasureName to "Install or Upgrade Master Venting" under auc:OtherHVAC/auc:MeasureName -->
  <!--xsl:template match="auc:ChilledWaterHotWaterAndSteamDistributionSystems[auc:MeasureName = 'Install or upgrade master venting']">
    <xsl:element name="auc:OtherHVAC">
      <auc:MeasureName>Install or Upgrade Master Venting</auc:MeasureName>
    </xsl:element>
  </xsl:template-->
  <!-- 10. Move enumeration "Separate SHW from heating" from auc:ServiceHotWaterSystems/auc:MeasureName to auc:ChilledWaterHotWaterAndSteamDistributionSystems/auc:MeasureName -->
  <!--xsl:template match="auc:ServiceHotWaterSystems[auc:MeasureName = 'Separate SHW from heating']">
    <xsl:element name="auc:ChilledWaterHotWaterAndSteamDistributionSystems">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template-->
  <!-- 11. Map enumeration "Add heat recovery" from auc:BuildingAutomationSystems/auc:MeasureName to "Add energy recovery" under auc:OtherHVAC/auc:MeasureName-->
  <!--xsl:template match="auc:BuildingAutomationSystems[auc:MeasureName = 'Add heat recovery']">
    <xsl:element name="auc:OtherHVAC">
      <auc:MeasureName>Add energy recovery</auc:MeasureName>
    </xsl:element>
  </xsl:template-->

  <!-- Systems and other components -->

  <!-- 1. Deprecate auc:Capacity and auc:CapacityUnits under auc:Delivery -->
  <!--xsl:template match="auc:Delivery/auc:Capacity">
    <xsl:comment>auc:Delivery/auc:Capacity is deprecated in version 3.0.</xsl:comment>
  </xsl:template>
  <xsl:template match="auc:Delivery/auc:CapacityUnits">
    <xsl:comment>auc:Delivery/auc:CapacityUnits is deprecated in version 3.0.</xsl:comment>
  </xsl:template-->
  <!-- 2. Map auc:PrincipalHVACSystemType to auc:PrimaryHVACSystemType -->
  <xsl:template match="auc:PrincipalHVACSystemType">
    <xsl:element name="auc:PrimaryHVACSystemType">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <!-- 3. Map auc:FanInstallFlowRate to auc:InstalledFlowRate under auc:FanSystem -->
  <xsl:template match="auc:FanSystem/auc:FanInstalledFlowRate">
    <xsl:element name="auc:InstalledFlowRate">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <!-- 4. Map auc:Capacity to auc:OutputCapacity for auc:HeatingSource and HeatingPlant types -->
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
  <!-- 5. Transform auc:WallIDs/auc:WallID, auc:WindowIDs/auc:WindowID, auc:DoorIDs/auc:DoorID elements under auc:Side to auc:WallID, auc:WindowID, auc:DoorID elements -->
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
