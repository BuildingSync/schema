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

  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Reference elements -->
  <!-- 1. `AlternativeSystemAdded` -> `AlternativeSystemIDAdded` -->
  <xsl:template match="auc:AlternativeSystemAdded">
    <auc:AlternativeSystemIDAdded>
      <xsl:apply-templates/>
    </auc:AlternativeSystemIDAdded>
  </xsl:template>
  <!-- 2. `AlternativeSystemReplacement` -> `AlternativeSystemIDReplacement` -->
  <xsl:template match="auc:AlternativeSystemReplacement">
    <auc:AlternativeSystemIDReplacement>
      <xsl:apply-templates/>
    </auc:AlternativeSystemIDReplacement>
  </xsl:template>
  <!-- 3. `ExistingScheduleAffected` -> `ExistingScheduleIDAffected` -->
  <xsl:template match="auc:ExistingScheduleAffected">
    <xsl:element name="auc:ExistingScheduleIDAffected">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <!-- 4. `ExistingSystemAffected` -> `ExistingSystemIDAffected` -->
  <xsl:template match="auc:ExistingSystemAffected">
    <xsl:element name="auc:ExistingSystemIDAffected">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <!-- 5. `ExistingSystemRemoved` -> `ExistingSystemIDRemoved` -->
  <xsl:template match="auc:ExistingSystemRemoved">
    <xsl:element name="auc:ExistingSystemIDRemoved">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <!-- 6. `ExistingSystemReplaced` -> `ExistingSystemIDReplaced` -->
  <xsl:template match="auc:ExistingSystemReplaced">
    <xsl:element name="auc:ExistingSystemIDReplaced">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <!-- 7. `SourceHeatingPlantID` -> `HeatingPlantID` -->
  <xsl:template match="auc:SourceHeatingPlantID">
    <auc:HeatingPlantID>
      <xsl:apply-templates select="@*|node()"/>
    </auc:HeatingPlantID>
  </xsl:template>
  <!-- 8. `LinkedHeatingPlantID` -> `HeatingPlantID` -->
  <xsl:template match="auc:LinkedHeatingPlantID">
    <xsl:element name="auc:HeatingPlantID">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <!-- 9. `DeliveryID` -> `LinkedDeliveryID` -->
  <xsl:template match="auc:DeliveryID">
    <xsl:element name="auc:LinkedDeliveryID">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <!-- 10. `MakeupAirSourceID` -> `MakeupAirSpaceID` -->
  <xsl:template match="auc:MakeupAirSourceID">
    <xsl:element name="auc:MakeupAirSpaceID">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <!-- 11. `ModifiedSchedule` -> `ModifiedScheduleID` -->
  <xsl:template match="auc:ModifiedSchedule">
    <xsl:element name="auc:ModifiedScheduleID">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <!-- 12. `ModifiedSystem` -> `ModifiedSystemID` -->
  <xsl:template match="auc:ModifiedSystem">
    <xsl:element name="auc:ModifiedSystemID">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <!-- 13. `ReferenceCase` -> `ReferenceScenarioID` -->
  <xsl:template match="auc:ReferenceCase">
    <xsl:element name="auc:ReferenceScenarioID">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
