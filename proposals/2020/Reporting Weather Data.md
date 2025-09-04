# Reporting Weather Data

## Overview

This proposal is to improve the reporting of weather data by making a weather station an "entity" which is referencable from a time series element.

## Justification

BuildingSync is used with tools which require or report weather data. BuildingSync needs a way to report time series data for temperature (and other weather qualities) and link that to a weather station. Currently you can report time series weather data using `TimeSeriesReadingQuantity`, but you can't link it to weather station. It would be valuable (and consistent) to be able to link a `auc:TimeSeries` to a weather station.

## Implementation

The set of elements

- auc:WeatherDataStationID
- auc:WeatherStationName
- auc:WeatherStationCategory

are currently available under Site and Building, so that's where we will put the new weather station element. Note that we will **not** remove the existing set of elements, but they will become _mutually exclusive_ with the new `auc:WeatherStations` element until they are deprecated in the next major version (3.0).

Schema:

```xml
<!-- Weather station schema -->
<xs:element name="WeatherStations" minOccurs="0">
    <xs:complexType>
        <xs:sequence>
            <xs:element name="WeatherStation" maxOccurs="unbounded">
                <xs:complexType>
                    <xs:sequence>
                        <xs:element ref="auc:WeatherDataStationID" minOccurs="0"/>
                        <xs:element ref="auc:WeatherStationName" minOccurs="0"/>
                        <xs:element ref="auc:WeatherStationCategory" minOccurs="0"/>
                    </xs:sequence>
                    <xs:attribute name="ID" type="xs:ID" use="required"/>
                </xs:complexType>
            </xs:element>
        </xs:sequence>
    </xs:complexType>
</xs:element>

<!-- TimeSeries schema -->
<xs:complexType name="TimeSeriesType">
    <xs:sequence>
        <!-- ... other sub elements ... -->
        <xs:element name="WeatherStationID" minOccurs="0">
            <xs:annotation>
                <xs:documentation>ID number of weather station this time series contributes to.</xs:documentation>
            </xs:annotation>
            <xs:complexType>
                <xs:attribute name="IDref" type="xs:IDREF" use="required"/>
            </xs:complexType>
        </xs:element>
    </xs:sequence>
</xs:complexType>
```

Example instance:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<auc:BuildingSync xmlns:auc="http://buildingsync.net/schemas/bedes-auc/2019"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://buildingsync.net/schemas/bedes-auc/2019 ./BuildingSync.xsd" version="2.3.0">
    <auc:Facilities>
        <auc:Facility ID="FacilityA">
            <auc:Sites>
                <auc:Site ID="SiteA">
                    <auc:WeatherStations>
                        <auc:WeatherStation ID="StationA">
                            <auc:WeatherDataStationID>12345</auc:WeatherDataStationID>
                            <auc:WeatherStationName>Some Name</auc:WeatherStationName>
                            <auc:WeatherStationCategory>FAA</auc:WeatherStationCategory>
                        </auc:WeatherStation>
                    </auc:WeatherStations>
                </auc:Site>
            </auc:Sites>
            <auc:Reports>
                <auc:Report ID="ReportA">
                    <auc:Scenarios>
                        <auc:Scenario ID="ScenarioA">
                            <auc:TimeSeriesData>
                                <auc:TimeSeries ID="TS1">
                                    <auc:ReadingType>Average</auc:ReadingType>
                                    <auc:TimeSeriesReadingQuantity>Dry Bulb Temperature</auc:TimeSeriesReadingQuantity>
                                    <auc:StartTimestamp>2020-01-01T00:00:00+00:00</auc:StartTimestamp>
                                    <auc:EndTimestamp>2020-02-01T00:00:00+00:00</auc:EndTimestamp>
                                    <auc:IntervalReading>65</auc:IntervalReading>
                                    <auc:WeatherStationID IDref="StationA"/>
                                </auc:TimeSeries>
                                <auc:TimeSeries ID="TS2">
                                    <auc:ReadingType>Average</auc:ReadingType>
                                    <auc:TimeSeriesReadingQuantity>Dry Bulb Temperature</auc:TimeSeriesReadingQuantity>
                                    <auc:StartTimestamp>2020-02-01T00:00:00+00:00</auc:StartTimestamp>
                                    <auc:EndTimestamp>2020-03-01T00:00:00+00:00</auc:EndTimestamp>
                                    <auc:IntervalReading>70</auc:IntervalReading>
                                    <auc:WeatherStationID IDref="StationA"/>
                                </auc:TimeSeries>
                            </auc:TimeSeriesData>
                        </auc:Scenario>
                    </auc:Scenarios>
                </auc:Report>
            </auc:Reports>
        </auc:Facility>
    </auc:Facilities>
</auc:BuildingSync>
```
