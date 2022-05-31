# Energy Auditing with BuildingSync

Follow the instructions in the [README.md](../README.md) file to run in Jupyter Lab/Notebook.

## Introduction
So you've been tasked with performing an energy audit that requires submission of a BuildingSync document? What does that even mean? This notebook is intended to provide an interactive and informational introduction to what BuildingSync is and how it relates to buildings, building systems, and energy audit reporting. This will be done by performing an example energy audit on the DOE Small Office Prototype building.

## Who This is For
While this notebook is setup in Python, this introduction is not reserved only for software developers. The code is more of a supplement, but doesn't need to be run. Energy auditors, mechanical engineers, AHJ's procuring audits, and software developers all have something to gain from walking through this notebook.

## Learning Objectives
By the end of this notebook, you should:
- Have a practical understanding of some XML features, namely: elements, attributes, and xpaths
- Know the main elements of the BuildingSync schema: Buildings, Systems, Reports, Scenarios, TimeSeriesData
- Be able to relate these concepts back to an ASHRAE Standard 211 energy audit
- Create a minimum viable Level 1 BuildingSync document and verify it validates using the [BuildingSync Use Case Validator](https://buildingsync.net/validator)

## For Reference: Core Concepts and Notation Used
- We will be using BuildingSync version 2.3.0. [Documentation](https://buildingsync.net/documentation/2.3.0). [Github release](https://github.com/BuildingSync/schema/releases/tag/v2.3.0).
- BuildingSync is an XML Schema Document (XSD). It defines intended structure. Referring to something as a BuildingSync document typically means the document is intended to conform to the BuildingSync schema.
- An XSD defines a hierarchical or tree-based schema, where elements are 'nested' within other elements. An XML document then looks like nested elements within one another. Similar to HTML, it uses angle brackets `<` and `>` to open and close an element tag. The example below provides a very simple example of an XML document:
```xml
<a-root-node>
    <first-child>This child element captures information in a string (text), whereas the second-child captures a numeric datatype.</first-child>
    <second-child>2</second-child>
</a-root-node>
```
- `auc:` is often used as the namespace prefix for elements in a BuildingSync document. If a document declares the BuildingSync namespace prefix to be `auc:`, an element would look like `auc:Facility`. The same element in a BuildingSync document without a namespace prefix would look like `Facility`. Going forward, we will not prefix elements with `auc` - the remaining XML content should only refer to things defined by the BuildingSync schema.
- XPath: xpath is basically a syntax for 'walking' an xml tree, mainly used for 'querying' information out of an XML document. In the simple example xml document above, to get the `<first-child>` element, we would notate this in XPath as `/a-root-node/first-child`. XPath will be used throughout this document to concisely convey where elements can be found in a BuildingSync document.

## Caveats
- These cells are meant to be run 1x through sequentially. Running a single cell multiple times may give you bad results


```python
# Import the main bsync module
from bsyncpy import bsync
from lxml import etree
from datetime import datetime, date
import eeweather

def pretty_print(element):
    """Simple printing of an xml element from the bsync library"""
    print(etree.tostring(element.toxml(), pretty_print=True).decode('utf-8'))
    
def bsync_dump(root_element, file="example1.xml"):
    """Write the element to the specified file"""
    doctype = '<?xml version="1.0" encoding="UTF-8"?>'
    as_etree = root_element.toxml()
    as_etree.set("xmlns", "http://buildingsync.net/schemas/bedes-auc/2019")
    #as_etree.set("xmlns:xsi", "http://www.w3.org/2001/XMLSchema-instance")
    #as_etree.set("xsi:schemaLocation", "http://buildingsync.net/schemas/bedes-auc/2019 https://raw.githubusercontent.com/BuildingSync/schema/v2.4.0/BuildingSync.xsd")
    # Have to manually set the version right now. Align release of bsyncpy to this version.
    as_etree.set("version", "2.4.0")  
    output = etree.tostring(as_etree, doctype=doctype, pretty_print=True)
    with open(file, 'wb+') as f:
        f.write(output)
        return True
```

# Starting the Audit

## Small Office Prototype Building
The small office prototype is a single story rectangular building. We will show some love to Missoula and assume this building is located at 4055 Brooks St. Missoula, MT 59804.
![](./img/b1-bldg.png)

We can summarize the high level features as:
- Total Floor Area: 5500sf
- WWR: Southern Wall ~25%, Other Walls ~20%
- Climate Zone 6B
- Assume built year: 2006
- Let's assume this is on the 90.1-2004 code cycle

## "I have a building...where do I start"
Relevant Standard 211 Sections:
- 6.1.1 Facility Description

Let's start by defining a building. In this exercise, we will learn about some BuildingSync design patterns that will continue to propagate. In xpath terms, buildings live here: `/BuildingSync/Facilities/Facility/Sites/Site/Buildings/Building`. A few things to notice:
- The root node of a BuildingSync document is the `BuildingSync` element
- Plurals (Facilities, Sites, Buildings) are often used to indicate parents that can contain 1 <= n < infinite child elements having a non-pluralized name (Facility, Site, Building). For example:
```xml
<BuildingSync>
    <Facilities>
        <Facility ID="F-1">
            ...children stuff here...
        </Facility>
        <Facility ID="F-2">
            ...children stuff here...
        </Facility>
    </Facilities>
</BuildingSync>
```
- While the above can be done, it is __most common__ to find a single Facility, Site, and Building in a BuildingSync document. In general:
    - Facility refers to a grouping of Sites, but a Facility is still geographically proximate. Its boundary might include not building specific things (streets, sidewalks, etc.)
    - A Site is everything in and around a group of Buildings. This might be two Buildings that are connected via a tunnel, etc.
    - ** Most common is just to have a single Building

### Primary BuildingSync Structural Elements
We start by creating the primary structure of a BuildingSync document. We introduced `Facilities`, `Sites`, and `Buildings`, but there are a few additional:
- `Sections` are subportions of a `Building`. Think of a mixed-use commercial building with retail and office space, each of these would become a section. For those familiar with the ASHRAE 211 Normative Spreadsheet, a `Section` is analagous to a column in the `All - Space Functions` sheet.
- `Systems` are defined under a `Facility` and capture the energy consuming / producing assets. Each can be linked back to an individual `Facility`, `Site`, `Building`, or `Section`.
- `Reports` are defined under a `Facility` and each `Report` would contain information about reporting type requirements. Most importantly, a `Report` contains a set of `Scenario` elements, where each `Scenario` would convey building performance for one of: current / historical data, target performance, benchmark performance, baseline modeled performance, or expected performance with measure(s) implemented.


```python
# just take this for what it is at the moment. the bsync package makes
# it easier to work with xml content. All of this is mainly syntactic
# sugar around the lxml package, with some type checking, attribute 
# assignment, etc.
root = bsync.BuildingSync()
facs = bsync.Facilities()
f1 = bsync.Facilities.Facility(ID="Facility-1")
sites = bsync.Sites()
s1 = bsync.Sites.Site(ID="Site-1")
bldgs = bsync.Buildings()
b1 = bsync.Buildings.Building(ID="Building-Small-Office-Prototype")
sections = bsync.Sections()
systems = bsync.Systems()
contacts = bsync.Contacts()
reports = bsync.Reports()
measures = bsync.Measures()
schedules = bsync.Schedules()
utilities = bsync.Utilities()

# We link the entire report to the building
r1 = bsync.Report(
    bsync.LinkedPremisesOrSystem(
        bsync.LinkedPremisesOrSystem.Building(
            bsync.LinkedBuildingID(IDref=b1["ID"])
        )
    ),
    ID='Report-L2-Audit')
scenarios = bsync.Scenarios()

# We now combine these and pretty print the result for easy viewing of what we just made
root += facs
facs += f1

# Direct children of a facility
f1 += sites
f1 += systems
f1 += schedules
f1 += measures
f1 += reports
f1 += contacts

# Specific to a site
sites += s1
s1 += bldgs
bldgs += b1

# Direct children of a building
b1 += sections

# Specific to a report
reports += r1
r1 += scenarios
r1 += utilities

pretty_print(root)
```

    <BuildingSync>
      <Facilities>
        <Facility ID="Facility-1">
          <Sites>
            <Site ID="Site-1">
              <Buildings>
                <Building ID="Building-Small-Office-Prototype">
                  <Sections/>
                </Building>
              </Buildings>
            </Site>
          </Sites>
          <Systems/>
          <Schedules/>
          <Measures/>
          <Reports>
            <Report ID="Report-L2-Audit">
              <Scenarios/>
              <Utilities/>
              <LinkedPremisesOrSystem>
                <Building>
                  <LinkedBuildingID IDref="Building-Small-Office-Prototype"/>
                </Building>
              </LinkedPremisesOrSystem>
            </Report>
          </Reports>
          <Contacts/>
        </Facility>
      </Facilities>
    </BuildingSync>
    
    

#### 6.2.1.1 Building information

This section of Standard 211 asks for lots of detail. We walk through the components of this that get added _as child elements of the building_, and then discuss other information.


```python
# 6.2.1.1.a - name
b1 += bsync.PremisesName('Small Office Prototype')

# 6.1.1.1.m 
b1 += bsync.PremisesNotes("Here we record general problems / issues identified in a walkthrough survey.")

# 6.1.1.1.d - address
b1 += bsync.Address(
    bsync.StreetAddressDetail(
        bsync.Simplified(
            bsync.StreetAddress("4055 Brooks Street")
        )
    ),
    bsync.Address.State("MT"),
    bsync.City("Missoula"),
    bsync.PostalCode("59804")
)

# 6.2.1.1.b - gross and conditioned floor area
b1 += bsync.FloorAreas(
    bsync.FloorArea(
        bsync.FloorAreaType("Gross"),
        bsync.FloorAreaValue(5500.0),
        bsync.ExcludedSectionIDs(
            bsync.ExcludedSectionID(IDref="Section-excluded")
        )
    ),
    bsync.FloorArea(
        bsync.FloorAreaType("Conditioned"),
        bsync.FloorAreaValue(5500.0),
        bsync.ExcludedSectionIDs(
            bsync.ExcludedSectionID(IDref="Section-excluded")
        )
    )
)

# 6.2.1.2.b - gross wall area
b1 += bsync.TotalExteriorAboveGradeWallArea(6500.)
b1 += bsync.TotalExteriorBelowGradeWallArea(0.)

# 6.2.1.2.c - fenestration-wall ratio
b1 += bsync.OverallWindowToWallRatio(0.2133)
b1 += bsync.OverallDoorToWallRatio(0.05)

# 6.1.1.1.f - classification of the uses
b1 += bsync.BuildingClassification("Commercial")
b1 += bsync.OccupancyClassification("Office")
b1 += bsync.BuildingAutomationSystem(True)
b1 += bsync.HistoricalLandmark(False)

# 6.1.1.1.h - for completeness, we spell this out explicitly
b1 += bsync.FloorsAboveGrade(1)
b1 += bsync.FloorsBelowGrade(0)
b1 += bsync.ConditionedFloorsAboveGrade(1)
b1 += bsync.ConditionedFloorsBelowGrade(0)

# 6.1.1.1.i - again, to be explicit, we define the latest remodel / retrofit year
# to be the same as the original build year to indicate nothing has happened since original construction
b1 += bsync.YearOfConstruction(2000)
b1 += bsync.YearOccupied(2000)
b1 += bsync.RetrocommissioningDate(date(2020,3,1))
b1 += bsync.YearOfLastMajorRemodel(2000)
b1 += bsync.YearOfLastEnergyAudit(2010)

#pretty_print(root)
```

Continuing with the information required by 6.1.1.1, we define additional content that doesn't sit as direct child elements of the Building. This includes:
- Contacts. Key contacts (1 auditor and 1 owner) __must be linked__ back to the building, even though they are not in the Building subtree:
    - Contacts live: /BuildingSync/Facilities/Facility/Contacts/Contact
    - An auditor is linked to a building at a Report level (i.e. who performed the audit)
    - Reports live: /BuildingSync/Facilities/Facility/Reports/Report
    - An audit report, with the correct links to a Building, Measures, etc. should be sufficient to meet the Standard 211 requirements spelled out in Section 6. More on this later.
- Space function breakdown by space type
- Occupied hours and number of occupants

#### Contacts


```python
# 6.1.1.1.b - Owner and auditor contact info
c1 = bsync.Contact(
    bsync.ContactName('The dude'),
    bsync.ContactCompany("Some big company"),
    bsync.ContactRoles(
        bsync.ContactRole('Owner')
    ),
    bsync.ContactTelephoneNumbers(
        bsync.ContactTelephoneNumber(
            bsync.TelephoneNumber("123-456-7890")
        )
    ),
    bsync.ContactEmailAddresses(
        bsync.ContactEmailAddress(
            bsync.EmailAddress("the.dude@somebigco.net")
        )
    ),
    ID='Contact-Owner'
)
c2 = bsync.Contact(
    bsync.ContactName('The lady'),
    bsync.ContactCompany("Auditeers"),
    bsync.ContactRoles(
        bsync.ContactRole('Energy Auditor')
    ),
    bsync.ContactTelephoneNumbers(
        bsync.ContactTelephoneNumber(
            bsync.TelephoneNumber("123-456-7890")
        )
    ),
    bsync.ContactEmailAddresses(
        bsync.ContactEmailAddress(
            bsync.EmailAddress("the.lady@the-three-auditeers.com")
        )
    ),
    ID='Contact-Auditor'
)
# We add the two contacts to the correct parent
contacts += c1
contacts += c2

# We 'assign' (link) the owner as the primary contact for the building, though this
# could be an owners rep or some other contact type.
b1 += bsync.PrimaryContactID(IDref=c1['ID'])

# We link the auditor contact to the report
r1 += bsync.AuditorContactID(IDref=c2['ID'])
```

### Space Function Analysis
Relevant Standard 211 Sections:
- 5.3.4 Space Function Analysis

Space functions are used to define sections of a building used for different purposes. The classic example of this is a mixed use commercial real estate, with retail space on the bottom floor and offices in the remainder of the building. We do this in BuildingSync via the following:
- Each space functions gets its own `Section` element
- Each `Section` element should specify the `Section/SectionType` as "Space function"

The Small Office, as its name suggests, is just an office space, and therefore we will only create one section for it.


```python
# create a new section
section = bsync.Sections.Section(
    bsync.SectionType("Space function"),
    bsync.OccupancyClassification("Office"),
    bsync.OriginalOccupancyClassification("Office"),
    bsync.ThermalZoneLayout("Single zone"),
    ID=f"Section-office"
)
section_wb = bsync.Sections.Section(ID="Section-Whole-building")
section_wb += bsync.SectionType("Whole building")
section_ex = bsync.Sections.Section(ID="Section-excluded")
sections += section
sections += section_wb
sections += section_ex
```

Section 5.3.4 lays out specific requirements to convey for each space function. These include:
- floor area requirements
- typical occupant usages
- systems information (plugs, lighting, hvac)


```python
# 5.3.4.a Gross floor area for the section (we also add conditioned for 5.3.4.f)
section_fa = bsync.FloorAreas(
    bsync.FloorArea(
        bsync.FloorAreaType("Gross"),
        bsync.FloorAreaValue(5500.0)
    ),
    bsync.FloorArea(
        bsync.FloorAreaType("Conditioned"),
        bsync.FloorAreaValue(5500.0)
    )
)

# 5.3.4.b and 5.3.4.c are asking for typical operating hours for the section
tous = bsync.TypicalOccupantUsages()
tou_hpw = bsync.TypicalOccupantUsage(
    bsync.TypicalOccupantUsageUnits("Hours per week"),
    bsync.TypicalOccupantUsageValue(40.0)
)
tou_wpy = bsync.TypicalOccupantUsage(
    bsync.TypicalOccupantUsageUnits("Weeks per year"),
    bsync.TypicalOccupantUsageValue(50.)
)
tous += tou_hpw
tous += tou_wpy

# 5.3.4.d looks for normal / design or peak occupancy.
occ_levels = bsync.OccupancyLevels()
occ_design = bsync.OccupancyLevel(
    bsync.OccupantQuantityType("Peak total occupants"),
    bsync.OccupantQuantity(31.)
)
occ_levels += occ_design

```


```python
# finally, we add these to the actual section element
section += section_fa
section += tous
section += occ_levels
#pretty_print(sections)
```

6.2.1.1.e Schedules


```python
schedule_occ = bsync.Schedule(ID="Schedule-Occupancy")
schedule_light = bsync.Schedule(ID="Schedule-Lighting")
schedule_pl = bsync.Schedule(ID="Schedule-PlugLoad")
schedule_hvac = bsync.Schedule(ID="Schedule-HVAC")
schedule_hvac_new = bsync.Schedule(ID="Schedule-HVAC-new")

# occupancy schedule
schedule_occ += bsync.ScheduleDetails(
    bsync.ScheduleDetail(
        bsync.DayType("Weekday"),
        bsync.ScheduleCategory("Occupied"),
        bsync.DayStartTime(datetime.strptime("06:00:00", "%H:%M:%S").time()),
        bsync.DayEndTime(datetime.strptime("07:00:00", "%H:%M:%S").time()),
        bsync.PartialOperationPercentage(11.)
    ),
    bsync.ScheduleDetail(
        bsync.DayType("Weekday"),
        bsync.ScheduleCategory("Occupied"),
        bsync.DayStartTime(datetime.strptime("07:00:00", "%H:%M:%S").time()),
        bsync.DayEndTime(datetime.strptime("08:00:00", "%H:%M:%S").time()),
        bsync.PartialOperationPercentage(21.)
    ),
    bsync.ScheduleDetail(
        bsync.DayType("Weekday"),
        bsync.ScheduleCategory("Occupied"),
        bsync.DayStartTime(datetime.strptime("08:00:00", "%H:%M:%S").time()),
        bsync.DayEndTime(datetime.strptime("12:00:00", "%H:%M:%S").time()),
        bsync.PartialOperationPercentage(100.)
    ),
    bsync.ScheduleDetail(
        bsync.DayType("Weekday"),
        bsync.ScheduleCategory("Occupied"),
        bsync.DayStartTime(datetime.strptime("12:00:00", "%H:%M:%S").time()),
        bsync.DayEndTime(datetime.strptime("13:00:00", "%H:%M:%S").time()),
        bsync.PartialOperationPercentage(53.)
    ),
    bsync.ScheduleDetail(
        bsync.DayType("Weekday"),
        bsync.ScheduleCategory("Occupied"),
        bsync.DayStartTime(datetime.strptime("13:00:00", "%H:%M:%S").time()),
        bsync.DayEndTime(datetime.strptime("17:00:00", "%H:%M:%S").time()),
        bsync.PartialOperationPercentage(100.)
    ),
    bsync.ScheduleDetail(
        bsync.DayType("Weekday"),
        bsync.ScheduleCategory("Occupied"),
        bsync.DayStartTime(datetime.strptime("17:00:00", "%H:%M:%S").time()),
        bsync.DayEndTime(datetime.strptime("18:00:00", "%H:%M:%S").time()),
        bsync.PartialOperationPercentage(32.)
    ),
    bsync.ScheduleDetail(
        bsync.DayType("Weekday"),
        bsync.ScheduleCategory("Occupied"),
        bsync.DayStartTime(datetime.strptime("18:00:00", "%H:%M:%S").time()),
        bsync.DayEndTime(datetime.strptime("22:00:00", "%H:%M:%S").time()),
        bsync.PartialOperationPercentage(11.)
    ),
    bsync.ScheduleDetail(
        bsync.DayType("Weekday"),
        bsync.ScheduleCategory("Occupied"),
        bsync.DayStartTime(datetime.strptime("22:00:00", "%H:%M:%S").time()),
        bsync.DayEndTime(datetime.strptime("23:00:00", "%H:%M:%S").time()),
        bsync.PartialOperationPercentage(5.)
    ),
    bsync.ScheduleDetail(
        bsync.DayType("Weekend"),
        bsync.ScheduleCategory("Occupied"),
        bsync.DayStartTime(datetime.strptime("00:00:00", "%H:%M:%S").time()),
        bsync.DayEndTime(datetime.strptime("23:59:59", "%H:%M:%S").time()),
        bsync.PartialOperationPercentage(0.)
    ),
    bsync.ScheduleDetail(
        bsync.DayType("Holiday"),
        bsync.ScheduleCategory("Occupied"),
        bsync.DayStartTime(datetime.strptime("00:00:00", "%H:%M:%S").time()),
        bsync.DayEndTime(datetime.strptime("23:59:59", "%H:%M:%S").time()),
        bsync.PartialOperationPercentage(0.)
    )
)
schedule_occ += bsync.LinkedPremises(
    bsync.LinkedPremises.Building(
        bsync.LinkedBuildingID(IDref=b1['ID'])
    ),
    bsync.LinkedPremises.Section(
        bsync.LinkedSectionID(IDref=section['ID'])
    )
)
# lighting schedule
schedule_light += bsync.ScheduleDetails(
    bsync.ScheduleDetail(
        bsync.DayType("Weekday"),
        bsync.ScheduleCategory("Lighting"),
        bsync.DayStartTime(datetime.strptime("00:00:00", "%H:%M:%S").time()),
        bsync.DayEndTime(datetime.strptime("05:00:00", "%H:%M:%S").time()),
        bsync.PartialOperationPercentage(18.)
    ),
    bsync.ScheduleDetail(
        bsync.DayType("Weekday"),
        bsync.ScheduleCategory("Lighting"),
        bsync.DayStartTime(datetime.strptime("05:00:00", "%H:%M:%S").time()),
        bsync.DayEndTime(datetime.strptime("07:00:00", "%H:%M:%S").time()),
        bsync.PartialOperationPercentage(23.)
    ),
    bsync.ScheduleDetail(
        bsync.DayType("Weekday"),
        bsync.ScheduleCategory("Lighting"),
        bsync.DayStartTime(datetime.strptime("07:00:00", "%H:%M:%S").time()),
        bsync.DayEndTime(datetime.strptime("08:00:00", "%H:%M:%S").time()),
        bsync.PartialOperationPercentage(42.)
    ),
    bsync.ScheduleDetail(
        bsync.DayType("Weekday"),
        bsync.ScheduleCategory("Lighting"),
        bsync.DayStartTime(datetime.strptime("08:00:00", "%H:%M:%S").time()),
        bsync.DayEndTime(datetime.strptime("17:00:00", "%H:%M:%S").time()),
        bsync.PartialOperationPercentage(90.)
    ),
    bsync.ScheduleDetail(
        bsync.DayType("Weekday"),
        bsync.ScheduleCategory("Lighting"),
        bsync.DayStartTime(datetime.strptime("17:00:00", "%H:%M:%S").time()),
        bsync.DayEndTime(datetime.strptime("18:00:00", "%H:%M:%S").time()),
        bsync.PartialOperationPercentage(61.)
    ),
    bsync.ScheduleDetail(
        bsync.DayType("Weekday"),
        bsync.ScheduleCategory("Lighting"),
        bsync.DayStartTime(datetime.strptime("18:00:00", "%H:%M:%S").time()),
        bsync.DayEndTime(datetime.strptime("20:00:00", "%H:%M:%S").time()),
        bsync.PartialOperationPercentage(42.)
    ),
    bsync.ScheduleDetail(
        bsync.DayType("Weekday"),
        bsync.ScheduleCategory("Lighting"),
        bsync.DayStartTime(datetime.strptime("20:00:00", "%H:%M:%S").time()),
        bsync.DayEndTime(datetime.strptime("22:00:00", "%H:%M:%S").time()),
        bsync.PartialOperationPercentage(32.)
    ),
    bsync.ScheduleDetail(
        bsync.DayType("Weekday"),
        bsync.ScheduleCategory("Lighting"),
        bsync.DayStartTime(datetime.strptime("22:00:00", "%H:%M:%S").time()),
        bsync.DayEndTime(datetime.strptime("23:00:00", "%H:%M:%S").time()),
        bsync.PartialOperationPercentage(23.)
    ),
    bsync.ScheduleDetail(
        bsync.DayType("Weekday"),
        bsync.ScheduleCategory("Lighting"),
        bsync.DayStartTime(datetime.strptime("23:00:00", "%H:%M:%S").time()),
        bsync.DayEndTime(datetime.strptime("23:59:59", "%H:%M:%S").time()),
        bsync.PartialOperationPercentage(18.)
    ),
    bsync.ScheduleDetail(
        bsync.DayType("Weekend"),
        bsync.ScheduleCategory("Lighting"),
        bsync.DayStartTime(datetime.strptime("00:00:00", "%H:%M:%S").time()),
        bsync.DayEndTime(datetime.strptime("23:59:59", "%H:%M:%S").time()),
        bsync.PartialOperationPercentage(18.)
    ),
    bsync.ScheduleDetail(
        bsync.DayType("Holiday"),
        bsync.ScheduleCategory("Lighting"),
        bsync.DayStartTime(datetime.strptime("00:00:00", "%H:%M:%S").time()),
        bsync.DayEndTime(datetime.strptime("23:59:59", "%H:%M:%S").time()),
        bsync.PartialOperationPercentage(18.)
    )
)
schedule_light += bsync.LinkedPremises(
    bsync.LinkedPremises.Building(
        bsync.LinkedBuildingID(IDref=b1['ID'])
    )
)
# plug load schedule
schedule_pl += bsync.ScheduleDetails(
    bsync.ScheduleDetail(
        bsync.DayType("Weekday"),
        bsync.ScheduleCategory("Miscellaneous equipment"),
        bsync.DayStartTime(datetime.strptime("00:00:00", "%H:%M:%S").time()),
        bsync.DayEndTime(datetime.strptime("05:00:00", "%H:%M:%S").time()),
        bsync.PartialOperationPercentage(50.)
    ),
    bsync.ScheduleDetail(
        bsync.DayType("Weekday"),
        bsync.ScheduleCategory("Miscellaneous equipment"),
        bsync.DayStartTime(datetime.strptime("05:00:00", "%H:%M:%S").time()),
        bsync.DayEndTime(datetime.strptime("12:00:00", "%H:%M:%S").time()),
        bsync.PartialOperationPercentage(100.)
    ),
    bsync.ScheduleDetail(
        bsync.DayType("Weekday"),
        bsync.ScheduleCategory("Miscellaneous equipment"),
        bsync.DayStartTime(datetime.strptime("12:00:00", "%H:%M:%S").time()),
        bsync.DayEndTime(datetime.strptime("13:00:00", "%H:%M:%S").time()),
        bsync.PartialOperationPercentage(94.)
    ),
    bsync.ScheduleDetail(
        bsync.DayType("Weekday"),
        bsync.ScheduleCategory("Miscellaneous equipment"),
        bsync.DayStartTime(datetime.strptime("13:00:00", "%H:%M:%S").time()),
        bsync.DayEndTime(datetime.strptime("17:00:00", "%H:%M:%S").time()),
        bsync.PartialOperationPercentage(100.)
    ),
    bsync.ScheduleDetail(
        bsync.DayType("Weekday"),
        bsync.ScheduleCategory("Miscellaneous equipment"),
        bsync.DayStartTime(datetime.strptime("17:00:00", "%H:%M:%S").time()),
        bsync.DayEndTime(datetime.strptime("18:00:00", "%H:%M:%S").time()),
        bsync.PartialOperationPercentage(50.)
    ),
    bsync.ScheduleDetail(
        bsync.DayType("Weekday"),
        bsync.ScheduleCategory("Miscellaneous equipment"),
        bsync.DayStartTime(datetime.strptime("18:00:00", "%H:%M:%S").time()),
        bsync.DayEndTime(datetime.strptime("23:59:59", "%H:%M:%S").time()),
        bsync.PartialOperationPercentage(20.)
    ),
    bsync.ScheduleDetail(
        bsync.DayType("Weekend"),
        bsync.ScheduleCategory("Miscellaneous equipment"),
        bsync.DayStartTime(datetime.strptime("00:00:00", "%H:%M:%S").time()),
        bsync.DayEndTime(datetime.strptime("23:59:59", "%H:%M:%S").time()),
        bsync.PartialOperationPercentage(20.)
    ),
    bsync.ScheduleDetail(
        bsync.DayType("Holiday"),
        bsync.ScheduleCategory("Miscellaneous equipment"),
        bsync.DayStartTime(datetime.strptime("00:00:00", "%H:%M:%S").time()),
        bsync.DayEndTime(datetime.strptime("23:59:59", "%H:%M:%S").time()),
        bsync.PartialOperationPercentage(20.)
    )
)
schedule_pl += bsync.LinkedPremises(
    bsync.LinkedPremises.Building(
        bsync.LinkedBuildingID(IDref=b1['ID'])
    )
)
# HVAC schedule
schedule_hvac += bsync.ScheduleDetails(
    bsync.ScheduleDetail(
        bsync.DayType("Weekday"),
        bsync.ScheduleCategory("HVAC equipment"),
        bsync.DayStartTime(datetime.strptime("07:00:00", "%H:%M:%S").time()),
        bsync.DayEndTime(datetime.strptime("20:00:00", "%H:%M:%S").time()),
        bsync.PartialOperationPercentage(100.)
    ),
    bsync.ScheduleDetail(
        bsync.DayType("Weekend"),
        bsync.ScheduleCategory("HVAC equipment"),
        bsync.DayStartTime(datetime.strptime("07:00:00", "%H:%M:%S").time()),
        bsync.DayEndTime(datetime.strptime("20:00:00", "%H:%M:%S").time()),
        bsync.PartialOperationPercentage(100.)
    ),
    bsync.ScheduleDetail(
        bsync.DayType("Holiday"),
        bsync.ScheduleCategory("HVAC equipment"),
        bsync.DayStartTime(datetime.strptime("07:00:00", "%H:%M:%S").time()),
        bsync.DayEndTime(datetime.strptime("20:00:00", "%H:%M:%S").time()),
        bsync.PartialOperationPercentage(100.)
    )
)
schedule_hvac += bsync.LinkedPremises(
    bsync.LinkedPremises.Building(
        bsync.LinkedBuildingID(IDref=b1['ID'])
    )
)
# upgraded HVAC schedule (for EEM)
schedule_hvac_new += bsync.ScheduleDetails(
    bsync.ScheduleDetail(
        bsync.DayType("Weekday"),
        bsync.ScheduleCategory("HVAC equipment"),
        bsync.DayStartTime(datetime.strptime("06:00:00", "%H:%M:%S").time()),
        bsync.DayEndTime(datetime.strptime("07:00:00", "%H:%M:%S").time()),
        bsync.PartialOperationPercentage(60.)
    ),
    bsync.ScheduleDetail(
        bsync.DayType("Weekday"),
        bsync.ScheduleCategory("HVAC equipment"),
        bsync.DayStartTime(datetime.strptime("07:00:00", "%H:%M:%S").time()),
        bsync.DayEndTime(datetime.strptime("12:00:00", "%H:%M:%S").time()),
        bsync.PartialOperationPercentage(100.)
    ),
    bsync.ScheduleDetail(
        bsync.DayType("Weekday"),
        bsync.ScheduleCategory("HVAC equipment"),
        bsync.DayStartTime(datetime.strptime("12:00:00", "%H:%M:%S").time()),
        bsync.DayEndTime(datetime.strptime("13:00:00", "%H:%M:%S").time()),
        bsync.PartialOperationPercentage(80.)
    ),
    bsync.ScheduleDetail(
        bsync.DayType("Weekday"),
        bsync.ScheduleCategory("HVAC equipment"),
        bsync.DayStartTime(datetime.strptime("13:00:00", "%H:%M:%S").time()),
        bsync.DayEndTime(datetime.strptime("18:00:00", "%H:%M:%S").time()),
        bsync.PartialOperationPercentage(100.)
    ),
    bsync.ScheduleDetail(
        bsync.DayType("Weekday"),
        bsync.ScheduleCategory("HVAC equipment"),
        bsync.DayStartTime(datetime.strptime("18:00:00", "%H:%M:%S").time()),
        bsync.DayEndTime(datetime.strptime("20:00:00", "%H:%M:%S").time()),
        bsync.PartialOperationPercentage(60.)
    ),
    bsync.ScheduleDetail(
        bsync.DayType("Weekend"),
        bsync.ScheduleCategory("HVAC equipment"),
        bsync.DayStartTime(datetime.strptime("07:00:00", "%H:%M:%S").time()),
        bsync.DayEndTime(datetime.strptime("20:00:00", "%H:%M:%S").time()),
        bsync.PartialOperationPercentage(30.)
    ),
    bsync.ScheduleDetail(
        bsync.DayType("Holiday"),
        bsync.ScheduleCategory("HVAC equipment"),
        bsync.DayStartTime(datetime.strptime("07:00:00", "%H:%M:%S").time()),
        bsync.DayEndTime(datetime.strptime("20:00:00", "%H:%M:%S").time()),
        bsync.PartialOperationPercentage(20.)
    )
)
schedule_hvac_new += bsync.LinkedPremises(
    bsync.LinkedPremises.Building(
        bsync.LinkedBuildingID(IDref=b1['ID'])
    )
)

schedules += schedule_occ
schedules += schedule_light
schedules += schedule_pl
schedules += schedule_hvac
schedules += schedule_hvac_new
#pretty_print(schedules)
```

#### 6.2.1.2 Envelope

Level 2 energy audits require information about the building envelop, including roof, wall, floor and fenestration. BuildingSync defines these components (construction, thermal properties, etc.) under the `Systems` element, and links corresponding elements back to the envelope specified under the `Section` elements. A few other information (e.g. gross areas) are added under the `Building` element above.
In addition, 6.2.1.2.e requires information of the building overall tightness, and this is covered under the `AirInfiltrationSystems` element.



```python
# 6.2.1.2.a roof
roofsys = bsync.RoofSystems()
roof = bsync.RoofSystem(
    bsync.RoofConstruction("Wood frame"),
    bsync.RoofRValue(1.),
    ID=f"Roof-1"
)
roofsys += roof

# 6.2.1.2.b wall
wallsys = bsync.WallSystems()
wall = bsync.WallSystem(
    bsync.ExteriorWallConstruction("Wood frame"),
    bsync.WallRValue(1.),
    ID=f"Wall-1"
)
wallsys += wall

# 6.2.1.2.c fenestration
fenestsys = bsync.FenestrationSystems()
win1_orig = bsync.FenestrationSystem(
    bsync.FenestrationType(
        bsync.Window()
    ),
    bsync.FenestrationFrameMaterial("Vinyl"),
    bsync.GlassType("Clear uncoated"),
    bsync.FenestrationGlassLayers("Single pane"),
    bsync.FenestrationUFactor(1.25),
    bsync.SolarHeatGainCoefficient(0.5),
    bsync.VisibleTransmittance(0.8),
    ID=f"Window-1-Original"
)
win1 = bsync.FenestrationSystem(
    bsync.FenestrationType(
        bsync.Window()
    ),
    bsync.FenestrationFrameMaterial("Vinyl"),
    bsync.GlassType("Low e"),
    bsync.FenestrationGlassLayers("Triple pane"),
    bsync.FenestrationUFactor(0.25),
    bsync.SolarHeatGainCoefficient(0.5),
    bsync.VisibleTransmittance(0.7),
    ID=f"Window-1"
)
door = bsync.FenestrationSystem(
    bsync.FenestrationType(
        bsync.Door(
            bsync.ExteriorDoorType("Insulated metal"),
            bsync.DoorGlazedAreaFraction(0.5)
        )
    ),
    bsync.FenestrationFrameMaterial("Steel"),
    bsync.FenestrationRValue(0.5),
    ID=f"Door-1"
)
fenestsys += win1_orig
fenestsys += win1
fenestsys += door

# 6.2.1.2.d floor
foundsys = bsync.FoundationSystems()
found = bsync.FoundationSystem(
    bsync.GroundCouplings(
        bsync.GroundCoupling(
            bsync.SlabOnGrade(
                bsync.SlabUFactor(0.5)
            )
        )
    ),
    bsync.FloorConstructionType("Concrete poured"),
    ID=f"Foundation-1"
)
foundsys += found

# 6.2.1.2.e tightness
infiltsys = bsync.AirInfiltrationSystems()
infilt = bsync.AirInfiltrationSystem(
    bsync.AirInfiltrationNotes("Notes on test"),
    bsync.AirInfiltrationSystem.Tightness("Very Tight"),
    bsync.AirInfiltrationValue(123.),
    bsync.AirInfiltrationValueUnits("CFM25"),
    bsync.AirInfiltrationTest("Blower door"),
    bsync.LinkedPremises(
        bsync.LinkedPremises.Section(
            bsync.LinkedSectionID(IDref=section_wb["ID"])
        )
    ),
    ID=f"Infiltration-1"
)
infiltsys += infilt

waterinfiltsys = bsync.WaterInfiltrationSystems()
waterinfilt = bsync.WaterInfiltrationSystem(
    bsync.WaterInfiltrationNotes("Notes on test"),
    bsync.LinkedPremises(
        bsync.LinkedPremises.Section(
            bsync.LinkedSectionID(IDref=section_wb["ID"])
        )
    )
)
waterinfiltsys += waterinfilt
```


```python
# now we add these components to System element
systems += roofsys
systems += wallsys
systems += fenestsys
systems += foundsys
systems += infiltsys
systems += waterinfiltsys
#pretty_print(systems)
```


```python
# then we link these components to the envelope elements under Section/Sides
section_wb += bsync.FootprintShape("Rectangular")

section_sides = bsync.Sides()
for sidenumber in ["A1", "B1", "C1", "D1"]:
    section_sides += bsync.Side(
        bsync.SideNumber(sidenumber),
        bsync.WallIDs(
            bsync.WallID(
                bsync.WallArea(123.),
                IDref=wall["ID"]
            )
        ),
        bsync.WindowIDs(
            bsync.WindowID(
                bsync.FenestrationArea(123.),
                IDref=win1_orig["ID"]
            )
        ),
        bsync.DoorIDs(
            bsync.DoorID(
                bsync.FenestrationArea(123.),
                IDref=door["ID"]
            )
        )
    )

section_roofs = bsync.Roofs(
    bsync.Roof(
        bsync.RoofID(
            bsync.RoofArea(123.),
            bsync.RoofCondition("Good"),
            IDref=roof["ID"]
        )
    )
)
section_founds = bsync.Foundations(
    bsync.Foundation(
        bsync.FoundationID(
            bsync.FoundationArea(123.),
            IDref=found["ID"]
        )
    )
)

section_wb += section_sides
section_wb += section_roofs
section_wb += section_founds
#pretty_print(sections)
```

#### HVAC, SHW/DHW, Lighting, Plugs 

Level 2 energy audits require information about the primary systems serving a specific section, with details such as types, capacities and conditions


```python
# 6.2.1.3 HVAC
# Here we specify HVAC system details
# and link them back to the Section of interest.
# According to prototype small office spec in ASHRAE901_OfficeSmall_STD2004
# the heating source is Air-source heat pump with gas furnace as back up
# and cooling source is Air-source heat pump
# and air distribution unit is Single zone, constant air volume air distribution, one unit per occupied thermal zone

hvac_systems = bsync.HVACSystems()
hvac_system = bsync.HVACSystem(ID="HVACSystem-1")
hvac_systems += hvac_system
# link hvac to section
hvac_system += bsync.LinkedPremises(
    bsync.LinkedPremises.Section(
        bsync.LinkedSectionID(
            bsync.LinkedScheduleIDs(
                bsync.LinkedScheduleID(IDref=schedule_hvac['ID'])
            ),
            IDref=section["ID"]
        )
    )
)

# heating and cooling system
hc_systems = bsync.HeatingAndCoolingSystems()
hc_systems += bsync.ZoningSystemType("Single zone")
# cooling system
css = bsync.CoolingSources()
cs = bsync.CoolingSource(
    bsync.CoolingSourceType(
        bsync.DX(
            bsync.DXSystemType("Packaged/unitary heat pump"),
            bsync.CompressorType("Reciprocating"),
            bsync.CompressorStaging("Single stage")
        )
    ),
    bsync.AnnualCoolingEfficiencyValue(123.),
    bsync.AnnualCoolingEfficiencyUnits('COP'),
    bsync.Capacity(123.),
    bsync.CapacityUnits('gpm'),
    bsync.CoolingSourceCondition('Good'),
    bsync.CoolingSource.Controls(
        bsync.CoolingSource.Controls.Control(
            bsync.CoolingSource.Controls.Control.OtherControlTechnology(
                bsync.ControlSystemType(
                    bsync.Digital()
                )
            )
        )
    ),
    bsync.YearInstalled(2020),
    ID=f"CoolingSource-1"
)
css += cs
hc_systems += css
# heating system
hss = bsync.HeatingSources()
hs1 = bsync.HeatingSource(
    bsync.HeatingSourceType(
        bsync.HeatingSourceType.HeatPump(
            bsync.HeatPumpType("Packaged Unitary"),
            bsync.HeatPumpBackupSystemFuel("Natural gas"),
            bsync.HeatPumpBackupAFUE(0.123),
            bsync.CoolingSourceID(IDref=cs['ID'])
        )
    ),
    bsync.AnnualHeatingEfficiencyValue(123.),
    bsync.AnnualHeatingEfficiencyUnits('COP'),
    bsync.InputCapacity(123.),
    bsync.HeatingSource.Capacity(123.),
    bsync.CapacityUnits('gpm'),
    bsync.HeatingSourceCondition('Good'),
    bsync.HeatingSource.Controls(
        bsync.HeatingSource.Controls.Control(
            bsync.HeatingSource.Controls.Control.OtherControlTechnology(
                bsync.ControlSystemType(
                    bsync.Digital()
                )
            )
        )
    ),
    bsync.YearInstalled(2020),
    ID=f"HeatingSource-1"
)
hs2 = bsync.HeatingSource(
    bsync.HeatingSourceType(
        bsync.Furnace(
            bsync.FurnaceType('Warm air')
        )
    ),
    bsync.AnnualHeatingEfficiencyValue(123.),
    bsync.AnnualHeatingEfficiencyUnits('COP'),
    bsync.InputCapacity(123.),
    bsync.HeatingSource.Capacity(123.),
    bsync.CapacityUnits('gpm'),
    bsync.HeatingSourceCondition('Good'),
    bsync.HeatingSource.Controls(
        bsync.HeatingSource.Controls.Control(
            bsync.HeatingSource.Controls.Control.OtherControlTechnology(
                bsync.ControlSystemType(
                    bsync.Digital()
                )
            )
        )
    ),
    bsync.YearInstalled(2020),
    ID=f"HeatingSource-2"
)
hss += hs1
hss += hs2
hc_systems += hss
# delivery system
delivers = bsync.Deliveries()
deliver = bsync.Delivery(
    bsync.DeliveryType(
        bsync.CentralAirDistribution(
            bsync.AirDeliveryType("Central fan"),
            bsync.TerminalUnit("CAV terminal box no reheat"),
            bsync.ReheatSource("None"),
            bsync.FanBased(
                bsync.AirSideEconomizer(
                    bsync.AirSideEconomizerType("None"),
                    bsync.EconomizerControl("Fixed"),
                    ID=f"AirSideEconomizer-1"
                )
            )
        )
    ),
    bsync.HeatingSourceID(IDref=hs1["ID"]),
    bsync.CoolingSourceID(IDref=cs["ID"]),
    bsync.Delivery.Controls(
        bsync.Delivery.Controls.Control(
            bsync.Delivery.Controls.Control.OtherControlTechnology(
                bsync.ControlSystemType(
                    bsync.Digital()
                )
            )
        )
    ),
    bsync.YearInstalled(2020),
    bsync.Quantity(5),
    bsync.DeliveryCondition("Good"),
    ID=f"Delivery-1"
)
delivers += deliver
hc_systems += delivers
# duct
duct_systems = bsync.DuctSystems()
duct = bsync.DuctSystem(
    bsync.DuctConfiguration("Single"),
    bsync.DuctInsulationCondition("Good"),
    bsync.HeatingDeliveryID(IDref=deliver['ID']),
    bsync.CoolingDeliveryID(IDref=deliver['ID']),
    ID=f"DuctSystem-1"
)
duct_systems += duct
# HVAC control
hvacctl = bsync.HVACControlSystemTypes(
    bsync.HVACControlSystemType("Digital")
)

hvac_system += hc_systems
hvac_system += duct_systems
hvac_system += hvacctl
#pretty_print(hvac_systems)

# fan
fan_systems = bsync.FanSystems()
fan = bsync.FanSystem(
    bsync.FanEfficiency(123.),
    bsync.FanSize(123.),
    bsync.InstalledFlowRate(123.),
    bsync.FanControlType("Constant Volume"),
    bsync.LinkedSystemIDs(
        bsync.LinkedSystemID(IDref=deliver['ID'])
    ),
    ID=f"FanSystem-1"
)
fan_new = bsync.FanSystem(
    bsync.FanEfficiency(123.),
    bsync.FanSize(123.),
    bsync.InstalledFlowRate(123.),
    bsync.FanControlType("Variable Volume"),
    bsync.LinkedSystemIDs(
        bsync.LinkedSystemID(IDref=deliver['ID'])
    ),
    ID=f"FanSystem-new"
)
fan_systems += fan
fan_systems += fan_new
```


```python
# 6.2.1.4 SHW/DHW
# Required information are types, ratings, operating and general conditions,
# According to prototype small office spec in ASHRAE901_OfficeSmall_STD2004
# SHW type is electric Storage tank

shw_systems = bsync.DomesticHotWaterSystems()
shw = bsync.DomesticHotWaterSystem(
    bsync.DomesticHotWaterType(
        bsync.StorageTank(
            bsync.TankHeatingType(
                bsync.Direct(
                    bsync.DirectTankHeatingSource(
                        bsync.ElectricResistance()
                    )
                )
            ),
            bsync.TankVolume(40.),
            bsync.StorageTankInsulationRValue(123.)
        )
    ),
    bsync.DomesticHotWaterSystemNotes("Notes"),
    bsync.PrimaryFuel("Electricity"),
    bsync.Recirculation(
        bsync.RecirculationLoopCount(1),
        bsync.RecirculationFlowRate(123.),
        bsync.RecirculationControlType("Continuous"),
        bsync.PipeInsulationThickness(123.),
        bsync.RecirculationEnergyLossRate(123.)
    ),
    bsync.HotWaterDistributionType("Looped"),
    bsync.HotWaterSetpointTemperature(140.),
    bsync.WaterHeaterEfficiency(123.),
    bsync.WaterHeaterEfficiencyType("COP"),
    bsync.DailyHotWaterDraw(123.),
    bsync.ParasiticFuelConsumptionRate(123.),
    bsync.Capacity(123.),
    bsync.CapacityUnits("gpm"),
    bsync.YearInstalled(2020),
    bsync.DomesticHotWaterSystemCondition("Good"),
    bsync.DomesticHotWaterSystem.Controls(
        bsync.DomesticHotWaterSystem.Controls.Control(
            bsync.DomesticHotWaterSystem.Controls.Control.Manual(
                bsync.ControlSystemType(
                    bsync.ControlSystemType.Other()
                )
            )
        )
    ),
    bsync.LinkedPremises(
        bsync.LinkedPremises.Building(
            bsync.LinkedBuildingID(IDref=b1['ID'])
        ),
        bsync.LinkedPremises.Section(
            bsync.LinkedSectionID(IDref=section["ID"])
        )
    ),
    bsync.Quantity(1),
    ID=f"SHW-1"
)
shw_systems += shw
```


```python
# 6.2.1.5
# For the lighting systems, this is a bit different. When 
# performing an audit, it is atypical to know the LPD of a space / zone
# as you would in 'Energy Modeling' world / design world.
# Assuming drawings are unavailable and we go in to check,
# based on the vintage it's likely we will find T8 linear
# fluorescents (thanks Jay Wratten!). So we add that information
light_systems = bsync.LightingSystems()
ls1 = bsync.LightingSystem(
    bsync.OutsideLighting(False),
    bsync.LampType(
        bsync.LinearFluorescent(
            bsync.LinearFluorescent.LampLabel("T8")
        )
    ),
    bsync.BallastType("Standard Electronic"),
    bsync.DimmingCapability(
        bsync.MinimumDimmingLightFraction(0.2)
    ),
    bsync.InstalledPower(123.),
    bsync.LampPower(123.),
    bsync.NumberOfLampsPerBallast(1),
    bsync.NumberOfBallastsPerLuminaire(1.),
    bsync.NumberOfLuminaires(10),
    bsync.PercentPremisesServed(100.),
    bsync.LightingAutomationSystem(False),
    bsync.LightingSystem.Controls(
        bsync.LightingSystem.Controls.Control(
            bsync.LightingSystem.Controls.Control.OtherControlTechnology(
                bsync.ControlSystemType(
                    bsync.Digital()
                ),
                bsync.LightingSystem.Controls.Control.OtherControlTechnology.ControlStrategy("Programmable")
            )
        )
    ),
    bsync.LinkedPremises(
        bsync.LinkedPremises.Section(
            bsync.LinkedSectionID(
                bsync.LinkedScheduleIDs(
                    bsync.LinkedScheduleID(IDref=schedule_light['ID'])
                ),
                IDref=section["ID"])
        )
    ),
    ID="LightingSystem-1"
)
# there is no specific information related to exterior lighting (but it exists)
ls2 = bsync.LightingSystem(
    bsync.OutsideLighting(True),
    bsync.LampType(
        bsync.LinearFluorescent(
            bsync.LinearFluorescent.LampLabel("T12")
        )
    ),
    bsync.BallastType("Standard Electronic"),
    bsync.InstalledPower(123.),
    bsync.LampPower(123.),
    bsync.NumberOfLampsPerBallast(1),
    bsync.NumberOfBallastsPerLuminaire(1.),
    bsync.NumberOfLuminaires(1),
    bsync.PercentPremisesServed(100.),
    bsync.LightingAutomationSystem(False),
    bsync.LightingSystem.Controls(
        bsync.LightingSystem.Controls.Control(
            bsync.LightingSystem.Controls.Control.OtherControlTechnology(
                bsync.ControlSystemType(
                    bsync.Digital()
                ),
                bsync.LightingSystem.Controls.Control.OtherControlTechnology.ControlStrategy("Programmable")
            )
        )
    ),
    bsync.LinkedPremises(
        bsync.LinkedPremises.Section(
            bsync.LinkedSectionID(
                bsync.LinkedScheduleIDs(
                    bsync.LinkedScheduleID(IDref=schedule_light['ID'])
                ),
                IDref=section_wb["ID"])
        )
    ),
    ID="LightingSystem-2"
)
# new lighting system for measure
ls_new = bsync.LightingSystem(
    bsync.OutsideLighting(False),
    bsync.LampType(
        bsync.SolidStateLighting(
            bsync.SolidStateLighting.LampLabel("LED")
        )
    ),
    bsync.BallastType("Standard Electronic"),
    bsync.DimmingCapability(
        bsync.MinimumDimmingLightFraction(0.1)
    ),
    bsync.InstalledPower(123.),
    bsync.LampPower(123.),
    bsync.NumberOfLampsPerBallast(1),
    bsync.NumberOfBallastsPerLuminaire(1.),
    bsync.NumberOfLuminaires(10),
    bsync.PercentPremisesServed(100.),
    bsync.LightingAutomationSystem(False),
    bsync.LightingSystem.Controls(
        bsync.LightingSystem.Controls.Control(
            bsync.Daylighting(
                bsync.ControlSystemType(
                    bsync.Digital()
                ),
                bsync.Daylighting.ControlSensor("Photocell"),
                bsync.Daylighting.ControlStrategy("Continuous")
            )
        )
    ),
    bsync.LinkedPremises(
        bsync.LinkedPremises.Section(
            bsync.LinkedSectionID(
                bsync.LinkedScheduleIDs(
                    bsync.LinkedScheduleID(IDref=schedule_light['ID'])
                ),
                IDref=section["ID"])
        )
    ),
    ID="LightingSystem-new"
)

light_systems += ls1
light_systems += ls2
light_systems += ls_new
```


```python
# 6.2.1.6 Process, plug and conveyance loads
# There are no process and conveyance loads identified for prototype small office
# The plug loads are pretty straightforwad
# Based on the Small Office 90.1-2004 prototype model,
# each zone has an EPD of 0.63 W/ft2
# Since all zones are part of the same section, we can
# just assign this EPD to the Section as a whole
plug_systems = bsync.PlugLoads()
psys = bsync.PlugLoad(
    bsync.PlugLoadType("Miscellaneous Electric Load"),
    bsync.WeightedAverageLoad(0.63),
    bsync.LinkedPremises(
        bsync.LinkedPremises.Section(
            bsync.LinkedSectionID(
                bsync.LinkedScheduleIDs(
                    bsync.LinkedScheduleID(IDref=schedule_pl['ID'])
                ),
                IDref=section["ID"])
        )
    ),
    ID="PlugLoad-1"
)
plug_systems += psys
```


```python
systems += hvac_systems
systems += fan_systems
systems += shw_systems
systems += light_systems
systems += plug_systems
#pretty_print(systems)
```

### Current Building Measured Scenario
Relevant Standard 211 Sections:
- 6.1.2

Now that we have a quick sense of the building, let's start off by looking at the requirements for an ASHRAE 211 Level 1 audit. This leads us to the concept of a [Scenario](https://buildingsync.net/schema/v2.3.0/documentation/BuildingSync_xsd.html#ScenarioType). A Scenario in BuildingSync is used to refer to energy and timeseries data associated with a particular, well, scenario. Specifically, there are 5 primary Scenarios used in BuildingSync, all which relate back to Standard 211:

![Scenario Types](./img/b1-sc-docs.png)

We will repeatedly come back to the concept of a Scenario, as they are core to organizing information in a BuildingSync document. 

The current building measured scenario is intended to capture true measured historical data. Typically this refers to utility bill data, but AMI type data can also be captured (later).  We start off by creating a new scenario element and defining its type as follows:
- `Scenario[ScenarioType/CurrentBuilding/CalculationMethod/Measured]`. This is an XPath expression that can be interpreted as "A Scenario that has the child elements ScenarioType/CurrentBuilding/CalculationMethod/Measured".  The XML for this would look like:
```xml
<Scenario>
    <ScenarioType>
        <CurrentBuilding>
            <CalculationMethod>
                <Measured/>
            </CalculationMethod>
        </CurrentBuilding>
    </ScenarioType>
</Scenario>
```

We build this scenario up programatically as follows:


```python
# define the current building measured scenario (cbms)
cbms = bsync.Scenario(
    bsync.Scenario.ScenarioType(
        bsync.CurrentBuilding(
            bsync.CalculationMethod(
                bsync.Measured()
            )
        )
    )
)
cbms['ID'] = 'Scenario-measured'

# add the scenario to the audit report and scenarios parent grouping
scenarios += cbms
```

#### Utilities
Relevant Standard 211 Sections: 6.1.2
In the next section, we will create resource use elements to define energy data. First, we need to get add utility information. Utility information gets added at the report level. Specific information required includes:
- Rate schedules (you can get very expressive in BuildingSync with Rate Schedules - we keep it pretty minimal here)
- Utility account numbers


```python
elec_ut = bsync.Utility(
    bsync.RateSchedules(
        bsync.RateSchedule(
            bsync.TypeOfRateStructure(
                bsync.FlatRate(
                    bsync.FlatRate.RatePeriods(
                        bsync.FlatRate.RatePeriods.RatePeriod(
                            bsync.ApplicableStartDateForEnergyRate(date(2019,1,1)),
                            bsync.ApplicableEndDateForEnergyRate(date(2020,1,1)),
                            bsync.EnergyCostRate(0.0725), # $0.0725/kWh
                            bsync.ApplicableStartDateForDemandRate(date(2019,1,1)),
                            bsync.ApplicableEndDateForDemandRate(date(2020,1,1)),
                            bsync.ElectricDemandRate(0.0) # no demand charge per https://missoulaelectric.com/member-care/billing-payment/rates/
                        )
                    )
                )
            ),
            bsync.ReferenceForRateStructure("https://missoulaelectric.com/member-care/billing-payment/rates/"),
            bsync.FixedMonthlyCharge(28.),
            ID="RateSchedule-Electricity"
        )
    ),
    bsync.UtilityMeterNumbers(
        bsync.UtilityMeterNumber("Some-meter-ID")
    ),
    bsync.EIAUtilityID(12692),
    bsync.UtilityName("Missoula Electric Cooperative"),
    bsync.UtilityAccountNumber("some-account-number"),
    bsync.UtilityBillpayer("Building Owner"),
    ID="Utility-Electric"
)
ng_ut = bsync.Utility(
    bsync.RateSchedules(
        bsync.RateSchedule(
            bsync.TypeOfRateStructure(
                bsync.FlatRate(
                    bsync.FlatRate.RatePeriods(
                        bsync.FlatRate.RatePeriods.RatePeriod(
                            bsync.ApplicableStartDateForEnergyRate(date(2019,1,1)),
                            bsync.ApplicableEndDateForEnergyRate(date(2020,1,1)),
                            bsync.EnergyCostRate(5.5) # $/MMBtu
                        )
                    )
                )
            ),
            bsync.ReferenceForRateStructure("https://naturalgaslocal.com/states/montana/missoula/"),
            ID="RateSchedule-Natural-Gas"
        )
    ),
    bsync.UtilityMeterNumbers(
        bsync.UtilityMeterNumber("Some-meter-ID")
    ),
    bsync.UtilityName("NorthWestern Energy"),
    bsync.UtilityAccountNumber("some-other-account-number"),
    bsync.UtilityBillpayer("Building Owner"),
    ID="Utility-Natural-Gas"
)
```


```python
utilities += elec_ut
utilities += ng_ut
```

#### ResourceUses and TimeSeries Data
Now that we have a current building measured scenario, we want to declare energy and monthly billing data. Per Std 211 6.1.2.1, a minimum of 12 months (preferably up to 3 years) of energy use data is required. The mechanical system of the small office prototype is a heatpump air handler with natural gas backup. We know that Missoula is cold, so likely it will use natural gas backup at some point during its operation. We run an example simulation to get estimates for this, which come out as follows:

| Resource Type | Jan | Feb | Mar | Apr | May | Jun | Jul | Aug | Sep | Oct | Nov | Dec |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Electricity (kWh) | 6792.89 | 5841.75 | 6025.19 | 4985.3 | 5184.04 | 5358.55 | 5755.67 | 5981.78 | 5401.94 | 5225.84 | 5672.15 | 6291.63 |
| Natural Gas (MMBtu) | 5.7 | 4.01 | 0.58 | 0.4 | 0.02 | 0 | 0 | 0 | 0 | 0.01 | 0.36 | 6.08 | 17.16 |
| GHG Emissions (MtCO2e) | 250.0 | 240.0 | 260.0 | 250.0 | 260.0 | 230.0 | 280.0 | 270.0 | 260.0 | 250.0 | 240.0 | 250.0 |

In BuildingSync land, we need to declare an resource use for each resource type. Standard, allowable enumerations exist for this already. We do this as follows:


```python
all_ru = bsync.ResourceUses()

# create a resource use for electricity, units of kWh, all end uses
# we also add info about the 'peak' units
# we also connect it up to a utility
elec_ru = bsync.ResourceUse(
    bsync.EnergyResource('Electricity'),
    bsync.ResourceUseNotes("This is required for L1 to document irregularities in monthly energy patterns (Std 211 6.1.2.1.j). No irregularities found."),
    bsync.ResourceUnits('kWh'),
    bsync.PeakResourceUnits('kW'),
    bsync.EndUse('All end uses'),
    bsync.UtilityIDs(
        bsync.UtilityID(IDref=elec_ut['ID'])
    ),
    ID=f"ResourceUse-Electricity"
)
# given the above, we add the annual totals
elec_ru += bsync.AnnualFuelUseNativeUnits(68516.73)
elec_ru += bsync.AnnualFuelUseConsistentUnits(234.) #convert to MMBTU
elec_ru += bsync.AnnualPeakNativeUnits(21.12) # kW as specified above
elec_ru += bsync.AnnualPeakConsistentUnits(21.12) # already in kW, same as above
elec_ru += bsync.AnnualFuelCost(5304.) # $28 monthly + $0.0725/kwh per https://missoulaelectric.com/member-care/billing-payment/rates/

# create a resource use for natural gas, units of MMBtu, all end uses
# additional connect it up to the utility
ng_ru = bsync.ResourceUse(
    bsync.EnergyResource('Natural gas'),
    bsync.ResourceUseNotes("No irregularities in monthly energy consumption found."),
    bsync.ResourceUnits('MMBtu'),
    bsync.EndUse('All end uses'),
    bsync.UtilityIDs(
        bsync.UtilityID(IDref=ng_ut['ID'])
    ),
    ID=f"ResourceUse-Natural-gas"
)
# given the above, we add the annual totals
ng_ru += bsync.AnnualFuelUseNativeUnits(17.16)
ng_ru += bsync.AnnualFuelUseConsistentUnits(17.16) # already in MMBTU
ng_ru += bsync.AnnualFuelCost(91.63) # ~ $5.50/1000ft3 NG per https://naturalgaslocal.com/states/montana/missoula/
251.16
# create resource uses for submetering of lighting, heating and cooling
lighting_ru = bsync.ResourceUse(
    bsync.EnergyResource('Electricity'),
    bsync.ResourceUnits('kWh'),
    bsync.EndUse('Total lighting'),
    bsync.AnnualFuelUseNativeUnits(18384.912),
    bsync.AnnualFuelUseConsistentUnits(62.79),
    bsync.PercentEndUse(25.),
    bsync.ParentResourceUseID(IDref=elec_ru['ID']),
    ID=f"ResourceUse-Electricity-Lighting-Submeter"
)
heating_ru = bsync.ResourceUse(
    bsync.EnergyResource('Electricity'),
    bsync.ResourceUnits('kWh'),
    bsync.EndUse('Heating'),
    bsync.AnnualFuelUseNativeUnits(22061.8944),
    bsync.AnnualFuelUseConsistentUnits(75.348),
    bsync.PercentEndUse(30.),
    bsync.ParentResourceUseID(IDref=elec_ru['ID']),
    ID=f"ResourceUse-Electricity-Heating-Submeter"
)
cooling_ru = bsync.ResourceUse(
    bsync.EnergyResource('Electricity'),
    bsync.ResourceUnits('kWh'),
    bsync.EndUse('Cooling'),
    bsync.AnnualFuelUseNativeUnits(18384.912),
    bsync.AnnualFuelUseConsistentUnits(62.79),
    bsync.PercentEndUse(25.),
    bsync.ParentResourceUseID(IDref=elec_ru['ID']),
    ID=f"ResourceUse-Electricity-Cooling-Submeter"
)
shw_ru = bsync.ResourceUse(
    bsync.EnergyResource('Electricity'),
    bsync.ResourceUnits('kWh'),
    bsync.EndUse('Domestic hot water'),
    bsync.AnnualFuelUseNativeUnits(7353.9648),
    bsync.AnnualFuelUseConsistentUnits(25.116),
    bsync.PercentEndUse(10.),
    bsync.ParentResourceUseID(IDref=elec_ru['ID']),
    ID=f"ResourceUse-Electricity-SHW-Submeter"
)
pl_ru = bsync.ResourceUse(
    bsync.EnergyResource('Electricity'),
    bsync.ResourceUnits('kWh'),
    bsync.EndUse('Plug load'),
    bsync.AnnualFuelUseNativeUnits(3676.9824),
    bsync.AnnualFuelUseConsistentUnits(12.558),
    bsync.PercentEndUse(5.),
    bsync.ParentResourceUseID(IDref=elec_ru['ID']),
    ID=f"ResourceUse-Electricity-Plugload-Submeter"
)

# add these to the ResourceUses parent element
all_ru += elec_ru
all_ru += ng_ru
all_ru += lighting_ru
all_ru += heating_ru
all_ru += cooling_ru
all_ru += shw_ru
all_ru += pl_ru
# ResourceUses are child elements of a specific scenario:
cbms += all_ru
```

#### All TimeSeries Data
The following cell simply performs the following:
1. Create a simple function to generate monthly timeseries elements for each resource use
1. Add it to a `TimeSeriesData` parent element
1. Add this back to the previously defined current building measured scenario (i.e. Scenario-1)


```python
full_ts_data = bsync.TimeSeriesData()

# usage and peak data
monthly_elec = [6792.89, 5841.75, 6025.19, 4985.3, 5184.04, 5358.55, 5755.67, 5981.78, 5401.94, 5225.84, 5672.15, 6291.63]
monthly_ng = [5.7, 4.01, 0.58, 0.4, 0.02, 0, 0, 0, 0, 0.01, 0.36, 6.08]
monthly_elec_peak = [15.42, 15.5, 16.25, 16.65, 18.56, 20.01, 20.82, 21.12, 20.42, 20.08, 17.4, 16.3]
monthly_elec_lf = [0.373, 0.394, 0.390, 0.358, 0.374, 0.386, 0.369, 0.372, 0.373, 0.354, 0.380, 0.362]

# costs data
monthly_elec_cost = [520.48, 451.53, 464.83, 389.43, 403.84, 416.49, 445.29, 461.68, 419.64, 406.87, 439.23, 484.14]
monthly_ng_cost = [30.44, 21.41, 3.10, 2.14, 0.11, 0.00, 0.00, 0.00, 0.00, 0.05, 1.92, 32.47]

elec_ids = []
ng_ids = []
daysinmonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
def create_monthly(values, resource_use_id, start_year, tsrq='Energy', rt='Total'):
    """
    tsrq: One of Energy, Power, Cost
    rt: One of Total, Peak, Cost, Load factor
    """
    monthly = []
    end_year = start_year
    for i, val in enumerate(values, start=1):
        if i % 12 == 0:
            start_month = 12
            end_month = 1
            end_year += 1
        else:
            start_month = i % 12
            end_month = start_month + 1
        start_dt = datetime(start_year, start_month, 1)
        end_dt = datetime(end_year, end_month, 1)

        if rt == 'Load factor':
            my_id = f"TS-{resource_use_id}-Loadfactor-{start_month}"
        else:
            my_id = f"TS-{resource_use_id}-{rt}-{start_month}"
        
        if rt == 'Peak':
            ts = bsync.TimeSeries(
                bsync.ReadingType(rt),
                bsync.PeakType("On-peak"),
                bsync.TimeSeriesReadingQuantity(tsrq),
                bsync.StartTimestamp(start_dt),
                bsync.EndTimestamp(end_dt),
                bsync.IntervalDuration(daysinmonth[i-1]),
                bsync.IntervalDurationUnits("Day"),
                bsync.IntervalFrequency("Month"),
                bsync.IntervalReading(float(val)),
                bsync.ResourceUseID(IDref=resource_use_id),
                ID=my_id
            )
        else:
            ts = bsync.TimeSeries(
                bsync.ReadingType(rt),
                bsync.TimeSeriesReadingQuantity(tsrq),
                bsync.StartTimestamp(start_dt),
                bsync.EndTimestamp(end_dt),
                bsync.IntervalDuration(daysinmonth[i-1]),
                bsync.IntervalDurationUnits("Day"),
                bsync.IntervalFrequency("Month"),
                bsync.IntervalReading(float(val)),
                bsync.ResourceUseID(IDref=resource_use_id),
                ID=my_id
            )
        
        monthly.append(ts)
        
        if tsrq == 'Energy':
            if 'Electricity' in resource_use_id:
                elec_ids.append(my_id)
            else:
                ng_ids.append(my_id)
    return monthly
    
elec_ts = create_monthly(monthly_elec, elec_ru['ID'], 2019)
ng_ts = create_monthly(monthly_ng, ng_ru['ID'], 2019)
elec_peak_ts = create_monthly(monthly_elec_peak, elec_ru['ID'], 2019, 'Power', 'Peak')
elec_lf_ts = create_monthly(monthly_elec_lf, elec_ru['ID'], 2019, 'Power', 'Load factor')

elec_cost_ts = create_monthly(monthly_elec_cost, elec_ru['ID'], 2019, 'Cost', 'Cost')
ng_cost_ts = create_monthly(monthly_ng_cost, ng_ru['ID'], 2019, 'Cost', 'Cost')
 
def add_to_full(months, full):
    for month in months:
        full += month

add_to_full(elec_ts, full_ts_data)
add_to_full(ng_ts, full_ts_data)
add_to_full(elec_peak_ts, full_ts_data)
add_to_full(elec_lf_ts, full_ts_data)
add_to_full(elec_cost_ts, full_ts_data)
add_to_full(ng_cost_ts, full_ts_data)

cbms += full_ts_data
```

#### Linked TimeSeriesIDs
Due to the fact that annual data reporting is dependent on which months / utility bill periods were used to calculate the annual total, the `AnnualFuelUseLinkedTimeSeriesIDs` element was introduced. It is required to specify exactly which months for each resource use were used in the calculation of the `AnnualFuelUseNativeUnits` and `AnnualFuelUseConsistentUnits` elements. We add this element below.


```python
elec_linked_ids = bsync.AnnualFuelUseLinkedTimeSeriesIDs()
for each_id in elec_ids:
    elec_linked_ids += bsync.LinkedTimeSeriesID(IDref=each_id)
    

ng_linked_ids = bsync.AnnualFuelUseLinkedTimeSeriesIDs()
for each_id in ng_ids:
    ng_linked_ids += bsync.LinkedTimeSeriesID(IDref=each_id)
    
elec_ru += elec_linked_ids
ng_ru += ng_linked_ids
```

#### All Resource Totals

We have defined monthly electricity (energy, power, cost) and natural gas (energy, cost) usage as timeseries elements. Now we basically just need to summarize these into site and source energy use totals. We use the `Scenario/AllResourceTotals/AllResourceTotal` element to achieve this. The Level 1 use case requires annual energy reporting to follow Standard 105s methodology including:

- `SiteEnergyUse`: Corresponds to $E_{site}$
- `BuildingEnergyUse`: Corresponds to $E_{bld}$
- `ImportedEnergyConsistentUnits`: Corresponds to $E_{imp}$
- `OnsiteEnergyProductionConsistentUnits`: Corresponds to $E_{g}$
- `ExportedEnergyConsistentUnits`: Corresponds to $E_{exp}$
- `NetIncreaseInStoredEnergyConsistentUnits`: Corresponds to $E_{s}$


```python
art = bsync.AllResourceTotals(
    bsync.AllResourceTotal(
        bsync.AllResourceTotal.SiteEnergyUse(250953.5), # reported in kBtu
        bsync.SiteEnergyUseIntensity(45.6), # reported in kbtu/ft2
        
        # Since there is no energy generated onsite, there is no difference btw site and building energy usage / intensity
        bsync.BuildingEnergyUse(250953.5), 
        bsync.BuildingEnergyUseIntensity(45.6),
        
        bsync.ImportedEnergyConsistentUnits(250.9535),  # in this case, same as building and site energy, but in MMBTU
        bsync.OnsiteEnergyProductionConsistentUnits(0.), # no energy produced onsite, MMBtu
        bsync.ExportedEnergyConsistentUnits(0.), # no energy exported, MMBtu
        bsync.NetIncreaseInStoredEnergyConsistentUnits(0.),  # no energy stored, MMBtu
        
        bsync.AllResourceTotal.SourceEnergyUse(759011.9), # reported in kBtu. Assume site -> source: elec = 3.167, ng = 1.084
        bsync.SourceEnergyUseIntensity(138.0), # kbtu/ft2
        bsync.EnergyCost(5395.),
        bsync.EnergyCostIndex(0.98), # $/ft2
        ID="AllResourceTotal-1"
    )
)
```


```python
cbms += art
cbms += bsync.LinkedPremises(
    bsync.LinkedPremises.Building(
        bsync.LinkedBuildingID(IDref=b1['ID'])
    )
)
```

### Benchmark Scenario
Relevant Standard 211 Sections:
- 6.1.3

We inserted the above information (electricity, natural gas, square footage, etc.) into the Energy Star Portfolio Manager and got a score of 56. We can add this information into BuildingSync with our benchmark scenario.
TODO: Figure this out:
1. Entered info into ESPM. Got the following:

![ESPM](./img/ESPM-Target.png)

1. So, the ES score for the _current building measured_ should be 56? And then 50 is used as the benchmark value here...? And 274,825 kBtu as the SiteEnergyUse...? Confused.


```python
# define the benchmark scenario
bench_sc = bsync.Scenario(
    bsync.AllResourceTotals(
        bsync.AllResourceTotal(
            bsync.AllResourceTotal.SiteEnergyUse(274825.),  
            bsync.SiteEnergyUseIntensity(50.),
            ID="AllResourceTotal-Benchmark"
        )
    ),
    bsync.LinkedPremises(
        bsync.LinkedPremises.Building(
            bsync.LinkedBuildingID(IDref=b1['ID'])
        )
    ),
    ID="Scenario-Benchmark"
)
bench_st = bsync.Scenario.ScenarioType()
bench = bsync.Benchmark(
    bsync.BenchmarkType(
        bsync.PortfolioManager(
            bsync.PMBenchmarkDate(date(2021, 3, 24))
        )
    ),
    bsync.BenchmarkTool("Portfolio Manager"),
    bsync.BenchmarkYear(2019),
    bsync.BenchmarkValue(56.)
)

# 
scenarios += bench_sc
bench_sc += bench_st
bench_st += bench
```

### Target Scenario
Relevant Standard 211 Sections:
- 6.1.4

Since we used a PM score in the baseline, we will also use that for our target. Let's say we are shooting for a target score of 70.


```python
# define the target scenario in reference to the benchmark scenario
target_sc = bsync.Scenario(
    bsync.AllResourceTotals(
        bsync.AllResourceTotal(
            bsync.AllResourceTotal.SiteEnergyUse(207643.5),  
            bsync.SiteEnergyUseIntensity(37.8),
            bsync.EnergyCost(4451.51),
            bsync.EnergyCostIndex(0.81),
            ID="AllResourceTotal-Target"
        )
    ),
    bsync.LinkedPremises(
        bsync.LinkedPremises.Building(
            bsync.LinkedBuildingID(IDref=b1['ID'])
        )
    ),
    ID="Scenario-Target"
)
target_st = bsync.Scenario.ScenarioType()
target = bsync.Target(
    bsync.ReferenceCase(IDref=bench_sc["ID"]),
    bsync.AnnualSavingsSiteEnergy(67181.5),
    bsync.AnnualSavingsCost(931),
    bsync.ENERGYSTARScore(70.),
)

# 
scenarios += target_sc
target_sc += target_st
target_st += target
```

### Current Building Modeled Scenario
Relevant Standard 211 Sections:
- 6.1.5 & 6.1.6

Although not explicitly called out in Standard 211, the current building modeled scenario is mostly implied as part of a Level 2 energy audit when doing more detailed savings estimates / calculations for potential measure(s) implementation. This is because when an energy / cost savings claim is made for a package of measures scenario, it needs to be _in reference_ to something, i.e. a current building modeled scenario (also often referred to as a baseline modeled scenario). The baseline modeled scenario should be interpreted as the expected performance of your building on an average or typical year. This is assuming the baseline modeled scenario is performed with TMY3 data, although they are likely first calibrated with AMY data.

Since we are already using an energy model for this example and providing details for implementing a Standard 211 Level 1 energy audit, we will not go into this too much at this point. It should be addressed in future examples.

### Package of Measures Scenario
Relevant Standard 211 Sections:
- 6.1.5 & 6.1.6

Standard 211 breaks out recommendations into low / no-cost (6.1.5) or capital (6.1.6). On the BuildingSync side, we don't change the data modeling between these two situations significantly, we simply change the value of the `Scenario/ScenarioType/PackageOfMeasures/CostCategory` element, while the majority of other features remain the same.
- Low / no-cost scenario: `CostCategory>Low-Cost or No-Cost</CostCategory>`
- Capital scenario: `CostCategory>Capital</CostCategory>`

For Level 1 audits, since the reporting only requires estimated costs, savings, and ROI, we don't specifically need a current building modeled scenario to be our reference case.

#### Measures

Packages of measures first require measures to be instantiated inside the BuildingSync document in order to correctly 'incorporate' them into the scenario. BuildingSync provides a significant number of already enumerated measures that can easily be used. We will first add some of these to our doc.

The scope of an individual measure is primarily conveyed by a few elements:
- `SystemCategoryAffected`: select one of an enumerated set of strings representing the general scope of system, i.e. Refrigeration, Fan, Lighting, etc.
- `TechnologyCategories/TechnologyCategory/*/MeasureName`: Select a very specific measure to implement


```python
# A measure to modify HVAC schedules (low-cost EEM)
hvac_schedule_measure = bsync.Measure(
    bsync.TypeOfMeasure(
        bsync.ModificationRetrocommissions(
            bsync.ModificationRetrocommissioning(
                bsync.ExistingScheduleAffected(IDref=schedule_hvac['ID']),
                bsync.ModifiedSchedule(IDref=schedule_hvac_new['ID'])
            )
        )
    ),
    bsync.SystemCategoryAffected("Air Distribution"),
    bsync.TechnologyCategories(
        bsync.TechnologyCategory(
            bsync.OtherHVAC(
                bsync.OtherHVAC.MeasureName("Other distribution")
            )
        )
    ),
    bsync.CustomMeasureName("Update HVAC schedule"),
    bsync.LongDescription("The current HVAC schedule is set to be at 100'%' fan operation during weekday from 7am - 8pm. This measure would implement a modified schedule to enable pre-cooling/pre-heating from 6am - 7am, and reduce output to 80'%' during peak time 12pm - 1pm. "),
    bsync.MeasureScaleOfApplication("Individual system"),
    bsync.UsefulLife(1.),
    bsync.MeasureInstallationCost(0.),
    bsync.MeasureMaterialCost(0.),
    bsync.StartDate(date(2021,1,1)),
    bsync.EndDate(date(2021,12,30)),
    bsync.Recommended(True),
    ID="Measure-HVAC-schedule-lowcost"
)

# A measure to upgrade the lighting system to LEDs
led_measure = bsync.Measure(
    bsync.TypeOfMeasure(
        bsync.Replacements(
            bsync.Replacement(
                bsync.ExistingSystemReplaced(IDref=ls1['ID']),
                bsync.AlternativeSystemReplacement(IDref=ls_new['ID'])
            )
        )
    ),
    bsync.SystemCategoryAffected("Lighting"),
    bsync.TechnologyCategories(
        bsync.TechnologyCategory(
            bsync.LightingImprovements(
                bsync.LightingImprovements.MeasureName("Retrofit with light emitting diode technologies")
            )
        )
    ),
    bsync.LongDescription("This measure is designed to replace all fluorescent bulbs with LEDs"),
    bsync.MeasureScaleOfApplication("Individual system"),
    bsync.UsefulLife(1.),
    bsync.MeasureInstallationCost(123.),
    bsync.MeasureMaterialCost(123.),
    bsync.StartDate(date(2021,1,1)),
    bsync.EndDate(date(2021,12,30)),
    bsync.Recommended(True),
    ID="Measure-LEDs"
)

# A measure to upgrade the fans in the RTUs to use VFDs
# instead of simple on/off fans.
# The CFMs for each of the RTUs are around ~ 700-800cfm,
# so there is no obvious choice of fans to upgrade to vfds.
# Here, we just recommend upgrading all of them.
vsd_measure = bsync.Measure(
    bsync.TypeOfMeasure(
        bsync.ModificationRetrocommissions(
            bsync.ModificationRetrocommissioning(
                bsync.ExistingSystemAffected(IDref=fan['ID']),
                bsync.ModifiedSystem(IDref=fan_new['ID'])
            )
        )
    ),
    # could have also used Air Distribution or Motor, this seemed ok too.
    bsync.SystemCategoryAffected("Fan"),
    bsync.TechnologyCategories(
        bsync.TechnologyCategory(
            bsync.OtherElectricMotorsAndDrives(
                bsync.OtherElectricMotorsAndDrives.MeasureName("Add VSD motor controller")
            )
        )
    ),
    bsync.LongDescription("This measure is designed to retrofit all RTU fans with a VSD"),
    bsync.MeasureScaleOfApplication("Individual system"),
    bsync.UsefulLife(1.),
    bsync.MeasureInstallationCost(123.),
    bsync.MeasureMaterialCost(123.),
    bsync.StartDate(date(2021,1,1)),
    bsync.EndDate(date(2021,12,30)),
    bsync.Recommended(True),
    ID="Measure-VSDs"
)
```


```python
measures += hvac_schedule_measure
measures += led_measure
measures += vsd_measure
```

#### POM Scenarios
Now that the measures have been added, we create three potential POM scenarios, and add the necessary attributes per Standard 211 6.1.5 and 6.1.6
1. LEDs only
1. VSDs only
1. HVAC schedule only


```python
pom_sc_1 = bsync.Scenario(
    bsync.Scenario.ScenarioType(
        bsync.PackageOfMeasures(
            bsync.ReferenceCase(IDref=cbms['ID']),
            bsync.MeasureIDs(
                bsync.MeasureID(IDref=led_measure['ID'])
            ),
            bsync.CostCategory("Capital"),
            bsync.AnnualSavingsSiteEnergy(123.),
            bsync.AnnualSavingsCost(123),
            bsync.AnnualSavingsByFuels(
                bsync.AnnualSavingsByFuel(
                    bsync.EnergyResource("Electricity"),
                    bsync.ResourceUnits("kWh"),
                    bsync.AnnualSavingsNativeUnits(123.)
                ),
                bsync.AnnualSavingsByFuel(
                    bsync.EnergyResource("Natural gas"),
                    bsync.ResourceUnits("MMBtu"),
                    bsync.AnnualSavingsNativeUnits(0.)
                )
            ),
            bsync.AnnualPeakElectricityReduction(123.),
            bsync.AnnualDemandSavingsCost(123),
            bsync.AnnualWaterSavings(0.),
            bsync.AnnualWaterCostSavings(0.),
            bsync.ImplementationPeriod(1),
            bsync.ImplementationPeriodCostSavings(0.),
            bsync.PackageFirstCost(0.),
            bsync.MVCost(0.),
            bsync.OMCostAnnualSavings(123.),
            bsync.EquipmentDisposalAndSalvageCosts(0.),
            bsync.ProjectMarkup(123.),
            bsync.FundingFromIncentives(123.),
            bsync.FundingFromTaxCredits(123.),
            bsync.OtherFinancialIncentives(123),
            bsync.RecurringIncentives(123),
            bsync.InternalRateOfReturn(1.),
            bsync.SimplePayback(123.),
            ID="POM-LEDs"
        )
    ),
    bsync.LinkedPremises(
        bsync.LinkedPremises.Building(
            bsync.LinkedBuildingID(IDref=b1['ID'])
        )
    ),
    ID="Scenario-POM-LEDs"
)

pom_sc_2 = bsync.Scenario(
    bsync.Scenario.ScenarioType(
        bsync.PackageOfMeasures(
            bsync.ReferenceCase(IDref=cbms['ID']),
            bsync.MeasureIDs(
                bsync.MeasureID(IDref=vsd_measure['ID'])
            ),
            bsync.CostCategory("Capital"),
            bsync.AnnualSavingsSiteEnergy(123.),
            bsync.AnnualSavingsCost(123),
            bsync.AnnualSavingsByFuels(
                bsync.AnnualSavingsByFuel(
                    bsync.EnergyResource("Electricity"),
                    bsync.ResourceUnits("kWh"),
                    bsync.AnnualSavingsNativeUnits(123.)
                ),
                bsync.AnnualSavingsByFuel(
                    bsync.EnergyResource("Natural gas"),
                    bsync.ResourceUnits("MMBtu"),
                    bsync.AnnualSavingsNativeUnits(12.)
                )
            ),
            bsync.AnnualPeakElectricityReduction(123.),
            bsync.AnnualDemandSavingsCost(123),
            bsync.AnnualWaterSavings(0.),
            bsync.AnnualWaterCostSavings(0.),
            bsync.ImplementationPeriod(1),
            bsync.ImplementationPeriodCostSavings(0.),
            bsync.PackageFirstCost(0.),
            bsync.MVCost(0.),
            bsync.OMCostAnnualSavings(123.),
            bsync.EquipmentDisposalAndSalvageCosts(0.),
            bsync.ProjectMarkup(123.),
            bsync.FundingFromIncentives(123.),
            bsync.FundingFromTaxCredits(123.),
            bsync.OtherFinancialIncentives(123),
            bsync.RecurringIncentives(123),
            bsync.InternalRateOfReturn(1.),
            bsync.SimplePayback(123.),
            ID="POM-VSDs"
        )
    ),
    bsync.LinkedPremises(
        bsync.LinkedPremises.Building(
            bsync.LinkedBuildingID(IDref=b1['ID'])
        )
    ),
    ID="Scenario-POM-VSDs"
)

pom_sc_3 = bsync.Scenario(
    bsync.Scenario.ScenarioType(
        bsync.PackageOfMeasures(
            bsync.ReferenceCase(IDref=cbms['ID']),
            bsync.MeasureIDs(
                bsync.MeasureID(IDref=hvac_schedule_measure['ID']),
            ),
            bsync.CostCategory("Low-Cost or No-Cost"),
            bsync.AnnualSavingsSiteEnergy(123.),
            bsync.AnnualSavingsCost(123),
            bsync.AnnualSavingsByFuels(
                bsync.AnnualSavingsByFuel(
                    bsync.EnergyResource("Electricity"),
                    bsync.ResourceUnits("kWh"),
                    bsync.AnnualSavingsNativeUnits(123.)
                ),
                bsync.AnnualSavingsByFuel(
                    bsync.EnergyResource("Natural gas"),
                    bsync.ResourceUnits("MMBtu"),
                    bsync.AnnualSavingsNativeUnits(0.)
                )
            ),
            bsync.AnnualPeakElectricityReduction(123.),
            bsync.AnnualDemandSavingsCost(123),
            bsync.AnnualWaterSavings(0.),
            bsync.AnnualWaterCostSavings(0.),
            bsync.ImplementationPeriod(1),
            bsync.ImplementationPeriodCostSavings(0.),
            bsync.PackageFirstCost(0.),
            bsync.MVCost(0.),
            bsync.OMCostAnnualSavings(123.),
            bsync.EquipmentDisposalAndSalvageCosts(0.),
            bsync.ProjectMarkup(123.),
            bsync.FundingFromIncentives(123.),
            bsync.FundingFromTaxCredits(123.),
            bsync.OtherFinancialIncentives(123),
            bsync.RecurringIncentives(123),
            bsync.InternalRateOfReturn(1.),
            bsync.SimplePayback(123.),
            ID="POM-HVAC-Schedule"
        )
    ),
    bsync.LinkedPremises(
        bsync.LinkedPremises.Building(
            bsync.LinkedBuildingID(IDref=b1['ID'])
        )
    ),
    ID="Scenario-POM-HVAC-Schedule"
)
```


```python
scenarios += pom_sc_1
scenarios += pom_sc_2
scenarios += pom_sc_3
```

# Validation

So did what we just went through actually work? Do we have the required information for a Level 1 Audit? Head over to the [use case validator](https://buildingsync.net/validator) to find out!

![Selection Tool](./img/UC-Selection.png)

Use the line below to write the file to disk


```python
bsync_dump(root, file="example-level2.xml")
```




    True



    True



You should see a green check mark for the L100 AUDIT use case!

![Valid](./img/valid_level2.png)


```python

```
