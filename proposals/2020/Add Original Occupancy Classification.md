# BuildingSync Feature Proposals

## Overview

Add an OriginalOccupancyClassification element in the Schema under the auc:Section element.

## Justification
Per the 211 spreadsheet (All - Space Functions sheet), this is a field with same enumerations as an OccupancyClassification element.  It is necessary for all Audit Levels, and is a current UDF to be added

## Implementation

New element:
```xml
  <xs:element name="OriginalOccupancyClassification" type="auc:OccupancyClassifications">
    <xs:annotation>
      <xs:documentation>Original classification of the space (complex, whole building, or section) tasks by building occupants.</xs:documentation>
    </xs:annotation>
  </xs:element>
```

Declare OccupancyClassification as:
```xml
  <xs:element name="OccupancyClassification" type="auc:OccupancyClassifications">
    <xs:annotation>
      <xs:documentation>Classification of the space (complex, whole building, or section) tasks by building occupants.</xs:documentation>
    </xs:annotation>
  </xs:element>
```


Change original OccupancyClassification element to a simplyType called OccupancyClassifications to enable typing from other element declarations (as above):
```xml
  <xs:simpleType name="OccupancyClassifications">
    <xs:restriction base="xs:string">
      <xs:enumeration value="Manufactured home"/>
      <xs:enumeration value="Single family"/>
      <xs:enumeration value="Multifamily"/>
      <xs:enumeration value="Multifamily with commercial"/>
      <xs:enumeration value="Multifamily individual unit"/>
      <xs:enumeration value="Public housing"/>
      <xs:enumeration value="Residential"/>
      <xs:enumeration value="Health care-Pharmacy"/>
      <xs:enumeration value="Health care-Skilled nursing facility"/>
      <xs:enumeration value="Health care-Residential treatment center"/>
      <xs:enumeration value="Health care-Inpatient hospital"/>
      <xs:enumeration value="Health care-Outpatient rehabilitation"/>
      <xs:enumeration value="Health care-Diagnostic center"/>
      <xs:enumeration value="Health care-Outpatient facility"/>
      <xs:enumeration value="Health care-Outpatient non-diagnostic"/>
      <xs:enumeration value="Health care-Outpatient surgical"/>
      <xs:enumeration value="Health care-Veterinary"/>
      <xs:enumeration value="Health care-Morgue or mortuary"/>
      <xs:enumeration value="Health care"/>
      <xs:enumeration value="Gas station"/>
      <xs:enumeration value="Convenience store"/>
      <xs:enumeration value="Food sales-Grocery store"/>
      <xs:enumeration value="Food sales"/>
      <xs:enumeration value="Laboratory-Testing"/>
      <xs:enumeration value="Laboratory-Medical"/>
      <xs:enumeration value="Laboratory"/>
      <xs:enumeration value="Vivarium"/>
      <xs:enumeration value="Zoo"/>
      <xs:enumeration value="Office-Financial"/>
      <xs:enumeration value="Office"/>
      <xs:enumeration value="Bank"/>
      <xs:enumeration value="Courthouse"/>
      <xs:enumeration value="Public safety station-Fire"/>
      <xs:enumeration value="Public safety station-Police"/>
      <xs:enumeration value="Public safety station"/>
      <xs:enumeration value="Public safety-Detention center"/>
      <xs:enumeration value="Public safety-Correctional facility"/>
      <xs:enumeration value="Public safety"/>
      <xs:enumeration value="Warehouse-Refrigerated"/>
      <xs:enumeration value="Warehouse-Unrefrigerated"/>
      <xs:enumeration value="Warehouse-Self-storage"/>
      <xs:enumeration value="Warehouse"/>
      <xs:enumeration value="Assembly-Religious"/>
      <xs:enumeration value="Assembly-Cultural entertainment"/>
      <xs:enumeration value="Assembly-Social entertainment"/>
      <xs:enumeration value="Assembly-Arcade or casino without lodging"/>
      <xs:enumeration value="Assembly-Convention center"/>
      <xs:enumeration value="Assembly-Indoor arena"/>
      <xs:enumeration value="Assembly-Race track"/>
      <xs:enumeration value="Assembly-Stadium"/>
      <xs:enumeration value="Assembly-Stadium (closed)"/>
      <xs:enumeration value="Assembly-Stadium (open)"/>
      <xs:enumeration value="Assembly-Public"/>
      <xs:enumeration value="Recreation-Pool"/>
      <xs:enumeration value="Recreation-Bowling alley"/>
      <xs:enumeration value="Recreation-Fitness center"/>
      <xs:enumeration value="Recreation-Ice rink"/>
      <xs:enumeration value="Recreation-Roller rink"/>
      <xs:enumeration value="Recreation-Indoor sport"/>
      <xs:enumeration value="Recreation"/>
      <xs:enumeration value="Education-Adult"/>
      <xs:enumeration value="Education-Higher"/>
      <xs:enumeration value="Education-Secondary"/>
      <xs:enumeration value="Education-Primary"/>
      <xs:enumeration value="Education-Preschool or daycare"/>
      <xs:enumeration value="Education-Vocational"/>
      <xs:enumeration value="Education"/>
      <xs:enumeration value="Food service-Fast"/>
      <xs:enumeration value="Food service-Full"/>
      <xs:enumeration value="Food service-Limited"/>
      <xs:enumeration value="Food service-Institutional"/>
      <xs:enumeration value="Food service"/>
      <xs:enumeration value="Lodging-Barracks"/>
      <xs:enumeration value="Lodging-Institutional"/>
      <xs:enumeration value="Lodging with extended amenities"/>
      <xs:enumeration value="Lodging with limited amenities"/>
      <xs:enumeration value="Lodging"/>
      <xs:enumeration value="Retail-Automobile dealership"/>
      <xs:enumeration value="Retail-Mall"/>
      <xs:enumeration value="Retail-Strip mall"/>
      <xs:enumeration value="Retail-Enclosed mall"/>
      <xs:enumeration value="Retail-Dry goods retail"/>
      <xs:enumeration value="Retail-Hypermarket"/>
      <xs:enumeration value="Retail"/>
      <xs:enumeration value="Service-Postal"/>
      <xs:enumeration value="Service-Repair"/>
      <xs:enumeration value="Service-Laundry or dry cleaning"/>
      <xs:enumeration value="Service-Studio"/>
      <xs:enumeration value="Service-Beauty and health"/>
      <xs:enumeration value="Service-Production and assembly"/>
      <xs:enumeration value="Service"/>
      <xs:enumeration value="Transportation terminal"/>
      <xs:enumeration value="Central Plant"/>
      <xs:enumeration value="Water treatment-Wastewater"/>
      <xs:enumeration value="Water treatment-Drinking water and distribution"/>
      <xs:enumeration value="Water treatment"/>
      <xs:enumeration value="Energy generation plant"/>
      <xs:enumeration value="Industrial manufacturing plant"/>
      <xs:enumeration value="Utility"/>
      <xs:enumeration value="Industrial"/>
      <xs:enumeration value="Agricultural estate"/>
      <xs:enumeration value="Mixed-use commercial"/>
      <xs:enumeration value="Parking"/>
      <xs:enumeration value="Attic"/>
      <xs:enumeration value="Basement"/>
      <xs:enumeration value="Dining area"/>
      <xs:enumeration value="Living area"/>
      <xs:enumeration value="Sleeping area"/>
      <xs:enumeration value="Laundry area"/>
      <xs:enumeration value="Lodging area"/>
      <xs:enumeration value="Dressing area"/>
      <xs:enumeration value="Restroom"/>
      <xs:enumeration value="Auditorium"/>
      <xs:enumeration value="Classroom"/>
      <xs:enumeration value="Day room"/>
      <xs:enumeration value="Sport play area"/>
      <xs:enumeration value="Stage"/>
      <xs:enumeration value="Spectator area"/>
      <xs:enumeration value="Office work area"/>
      <xs:enumeration value="Non-office work area"/>
      <xs:enumeration value="Common area"/>
      <xs:enumeration value="Reception area"/>
      <xs:enumeration value="Waiting area"/>
      <xs:enumeration value="Transportation waiting area"/>
      <xs:enumeration value="Lobby"/>
      <xs:enumeration value="Conference room"/>
      <xs:enumeration value="Computer lab"/>
      <xs:enumeration value="Data center"/>
      <xs:enumeration value="Printing room"/>
      <xs:enumeration value="Media center"/>
      <xs:enumeration value="Telephone data entry"/>
      <xs:enumeration value="Darkroom"/>
      <xs:enumeration value="Courtroom"/>
      <xs:enumeration value="Kitchen"/>
      <xs:enumeration value="Kitchenette"/>
      <xs:enumeration value="Refrigerated storage"/>
      <xs:enumeration value="Bar-Nightclub"/>
      <xs:enumeration value="Bar"/>
      <xs:enumeration value="Dance floor"/>
      <xs:enumeration value="Trading floor"/>
      <xs:enumeration value="TV studio"/>
      <xs:enumeration value="Security room"/>
      <xs:enumeration value="Shipping and receiving"/>
      <xs:enumeration value="Mechanical room"/>
      <xs:enumeration value="Chemical storage room"/>
      <xs:enumeration value="Non-chemical storage room"/>
      <xs:enumeration value="Janitorial closet"/>
      <xs:enumeration value="Vault"/>
      <xs:enumeration value="Corridor"/>
      <xs:enumeration value="Deck"/>
      <xs:enumeration value="Courtyard"/>
      <xs:enumeration value="Atrium"/>
      <xs:enumeration value="Science park"/>
      <xs:enumeration value="Other"/>
      <xs:enumeration value="Unknown"/>
    </xs:restriction>
  </xs:simpleType>
  ```