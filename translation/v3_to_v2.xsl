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
  <!-- 5. Transform auc:eGRIDSubregionCodes/auc:eGRIDSubregionCode element to auc:eGRIDRegionCode element -->
  <xsl:template match="auc:eGRIDSubregionCodes">
    <xsl:copy-of select="auc:eGRIDRegionCode"/>
  </xsl:template>
  <!-- 7. Map auc:MaximumOutsideAirFlowRate to auc:MaximumOAFlowRate under auc:DuctSystem -->
  <xsl:template match="auc:DuctSystem/auc:MaximumOutsideAirFlowRate">
    <xsl:element name="auc:MaximumOAFlowRate">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <!-- Reference elements -->
  <!-- 1. `AlternativeSystemIDAdded` -> `AlternativeSystemAdded` -->
  <xsl:template match="auc:AlternativeSystemIDAdded">
    <xsl:element name="auc:AlternativeSystemAdded">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>
  <!-- 2. `AlternativeSystemIDReplacement` -> `AlternativeSystemReplacement` -->
  <xsl:template match="auc:AlternativeSystemIDReplacement">
    <xsl:element name="auc:AlternativeSystemReplacement">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>
  <!-- 3. `ExistingScheduleIDAffected` -> `ExistingScheduleAffected` -->
  <xsl:template match="auc:ExistingScheduleIDAffected">
    <xsl:element name="auc:ExistingScheduleAffected">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>
  <!-- 4. `ExistingSystemIDAffected` -> `ExistingSystemAffected` -->
  <xsl:template match="auc:ExistingSystemIDAffected">
    <xsl:element name="auc:ExistingSystemAffected">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>
  <!-- 5. `ExistingSystemIDRemoved` -> `ExistingSystemRemoved` -->
  <xsl:template match="auc:ExistingSystemIDRemoved">
    <xsl:element name="auc:ExistingSystemRemoved">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>
  <!-- 6. `ExistingSystemIDReplaced` -> `ExistingSystemReplaced` -->
  <xsl:template match="auc:ExistingSystemIDReplaced">
    <xsl:element name="auc:ExistingSystemReplaced">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>
  <!-- 7. `HeatingPlantID` -> `SourceHeatingPlantID` under auc:HeatingSourceType -->
  <xsl:template match="auc:HeatingSourceType/auc:HeatingPlantID">
    <xsl:element name="auc:SourceHeatingPlantID">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>
  <!-- 8. `HeatingPlantID` -> `LinkedHeatingPlantID` under auc:HeatPump -->
  <xsl:template match="auc:HeatPump/auc:HeatingPlantID">
    <xsl:element name="auc:LinkedHeatingPlantID">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>
  <!-- 9. `DeliveryIDs` -> `LinkedDeliveryIDs` and `DeliveryID` -> `LinkedDeliveryID` under auc:OtherHVACSystem -->
  <xsl:template match="auc:OtherHVACSystem/auc:DeliveryIDs">
    <xsl:element name="auc:LinkedDeliveryIDs">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="auc:LinkedDeliveryIDs/auc:DeliveryID">
    <xsl:element name="auc:LinkedDeliveryID">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>
  <!-- 10. `MakeupAirSpaceID` -> `MakeupAirSourceID` -->
  <xsl:template match="auc:MakeupAirSpaceID">
    <xsl:element name="auc:MakeupAirSourceID">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>
  <!-- 11. `ModifiedScheduleID` -> `ModifiedSchedule` -->
  <xsl:template match="auc:ModifiedScheduleID">
    <xsl:element name="auc:ModifiedSchedule">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>
  <!-- 12. `ModifiedSystemID` -> `ModifiedSystem` -->
  <xsl:template match="auc:ModifiedSystemID">
    <xsl:element name="auc:ModifiedSystem">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>
  <!-- 13. `ReferenceScenarioID` -> `ReferenceCase` -->
  <xsl:template match="auc:ReferenceScenarioID">
    <xsl:element name="auc:ReferenceCase">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
