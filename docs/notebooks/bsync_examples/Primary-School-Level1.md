# Level 1-3 Audits of the DOE Primary School Prototype Building

This notebook will walk you through the creation of a BuildingSync file using bsyncpy. We are going to prepare a Level 1, Level 2 and Level 3 audit for the DOE Primary School Prototype building.

Follow the instructions in the [README.md](../README.md) file to run this in Jupyter Lab/Notebook.

## 1. Pre-requisites

This notebook assumes that you have installed bsyncpy and all of its dependencies.

## 2. Useful information

This notebook uses resources from:

- the [DOE Commercial Prorotype buildings](https://www.energycodes.gov/prototype-building-models) repository
- ASHRAE [Standard 211](https://www.ashrae.org/technical-resources/bookstore/standards-180-and-211) for formal guidelines on energy audits
- the [BuildingSync schema documentation](https://buildingsync.net/dictionary/2.4.0/)
- the [notebook included in the bsync examples folder](./Small-Office-Level-1.md) for a comprehensive explanation on basic BuildingSync and bsyncpy concepts

## 3. Overview

This notebook is broken down into the following sections:
1) Setting up the root, or the base, of your BuildingSync file
2) Adding the information required for a Level 1 energy audit
3) Adding the information required for a Level 2 energy audit
4) Adding the information required for a Level 3 energy audit
5) Generating a BuildingSync file and verifying it against version 2.4.0 of the BuildingSync schema


But first, let us import the required libraries and set up some useful functions:



```python

```


```python
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
    # Have to manually set the version right now. Align release of bsyncpy to this version.
    as_etree.set("version", "2.4.0")  
    output = etree.tostring(as_etree, doctype=doctype, pretty_print=True)
    with open(file, 'wb+') as f:
        f.write(output)
        return True
```

## 4. Setting up the root of the BuildingSync file

We are going to define the basic building blocks (ha!) of our representation of the primary school prototype building. For that, we need to define a buiding, which belongs to a site, which belongs to a facility, which belongs to the highest-level of our BuildingSync file: the BuildingSync root. It will look like this:
<BuildingSync>
  <Facilities>
    <Facility ID="My-Nice-Facility">
      <Sites>
        <Site ID="My-Beautiful-Site">
          <Buildings>
            <Building ID="My-Awesome-Building">
            </Building>
          </Buildings>
        </Site>
      </Sites>
    </Facility>
  </Facilities>
</BuildingSync>
For that, we will:
- define the BuildingSync root
- add a Facilities entity to it - as BuildingSync lets us define several facilities at once, should we need to
- add a Facility to our Facilities
- define a Sites entity for our Facility - because a Facility might have several sites
- define a Site within our Sites
- define a Buildings entity for our site - again, we might have several buildings
- finally, define the Primary School building


```python
# Defining the root is as easy as that
root = bsync.BuildingSync()
# We add facilities
facs = bsync.Facilities()
# We add a single facility within our facilities. Here, we need to define an ID for the facility
f1 = bsync.Facilities.Facility(ID="Facility-1")
# We do the same for the Sites that contain a Site which contains Buildings which include our Primary School building.
sites = bsync.Sites()
s1 = bsync.Sites.Site(ID="Site-1")
bldgs = bsync.Buildings()
b1 = bsync.Buildings.Building(ID="Building-Primary-School-Prototype")
```

We now have several entities, but we have not yet defined the relationship between them. How does BuildingSync know that "Facilities" belongs to the root? How does it know that the building belongs to the buildings which belong to... I am going to stop there, you now get the idea.

Well, bsyncpy just lets us "add" an element to another, quite literally:


```python
# we add the facilities (facs) to the root
root += facs
# and then we add Facility-1 (f1) to the facilities (facs)
facs += f1
# and we continue adding children to the parent elements, following the tree's branches all the way down to our building
f1 += sites
sites += s1
s1 += bldgs
bldgs += b1
```

And we verify the output of what we just did:


```python
pretty_print(root)
```

    <BuildingSync>
      <Facilities>
        <Facility ID="Facility-1">
          <Sites>
            <Site ID="Site-1">
              <Buildings>
                <Building ID="Building-Primary-School-Prototype"/>
              </Buildings>
            </Site>
          </Sites>
        </Facility>
      </Facilities>
    </BuildingSync>
    


This looks exactly like it was supposed to look. If you needed to add a different site, you would just need to add a child to the appropriate parent, in that case a Site to a group of Sites.
Now, let us carry on and start the Level 1 audit.

## 5. Level 1 audit

We refer to ASHRAE Standard 211, section 5.3, relevant to the Level 1 energy audit procedures.
For this audit, we will need to report:
1) a facility description (section 6.1.1.1)
2) the historical energy use (section 6.1.1.2)
3) a benchmark of the site EUI (section 6.1.1.3)
4) the target and estimate savings (section 6.1.1.4)
5) low-cost and no-cost energy efficiency measure recommendations (section 6.1.1.5)
6) potential capital energy efficiency measure recommendations (section 6.1.1.6)

In order to compile all this information, we will start by defining a Report entity for our Level 1 audit.


```python
reports = bsync.Reports()

# we create a linked building ID for our building (b1) which we will use in our Level 1 report
linkedbldgid = bsync.LinkedBuildingID(IDref=b1["ID"])

# we link this ID to a Building
linkedbldg = bsync.LinkedPremisesOrSystem.Building(linkedbldgid)

# and we link this building to a premise
premise = bsync.LinkedPremisesOrSystem(linkedbldg)

# and finally, we create a report linked to this premise
r1 = bsync.Report(premise, ID='Report-L1-Audit')

# Now, we link the report (r1) to the reports, and link those to the facility (f1)
f1 += reports
reports += r1


```

Now, we link the report to the facility, and the remaining elements where they belong according to the BuildingSync schema.


```python

```

### 5.1 Site description (Section 6.1.1)

ASHRAE Standard 211 requires that we describe the site in detail, so let us walk through section 6.1.1 and add the relevant elements.
First, we include elements that are direct children of the Building entity:


```python
# 6.1.1.1.a - name
b1 += bsync.PremisesName('Primary School Prototype')

# 6.1.1.1.m 
b1 += bsync.PremisesNotes("Here we record general problems / issues identified in a walkthrough survey.")

# 6.1.1.1.d - address
b1 += bsync.Address(
    bsync.StreetAddressDetail(
        bsync.Simplified(
            bsync.StreetAddress("15013 Denver West Parkway")
        )
    ),
    bsync.Address.State("CO"),
    bsync.City("Golden"),
    bsync.PostalCode("80401")
)

# 6.1.1.1.e - gross and conditioned floor area
b1 += bsync.FloorAreas(
    bsync.FloorArea(
        bsync.FloorAreaType("Gross"),
        bsync.FloorAreaValue(73960.0)
    ),
    bsync.FloorArea(
        bsync.FloorAreaType("Conditioned"),
        bsync.FloorAreaValue(73960.0)
    )
)

# 6.1.1.1.f - classification of the uses
b1 += bsync.BuildingClassification("Commercial")
b1 += bsync.OccupancyClassification("Education-Primary")
b1 += bsync.HistoricalLandmark(False)

# 6.1.1.1.h - for completeness, we spell this out explicitly
b1 += bsync.FloorsAboveGrade(1)
b1 += bsync.FloorsBelowGrade(0)
b1 += bsync.ConditionedFloorsAboveGrade(1)
b1 += bsync.ConditionedFloorsBelowGrade(0)

# 6.1.1.1.i - again, to be explicit, we define the latest remodel / retrofit year
# to be the same as the original build year to indicate nothing has happened since original construction
b1 += bsync.YearOfConstruction(2018)
b1 += bsync.YearOccupied(2018)
b1 += bsync.YearOfLastMajorRemodel(2018)

pretty_print(root)
```

    <BuildingSync>
      <Facilities>
        <Facility ID="Facility-1">
          <Sites>
            <Site ID="Site-1">
              <Buildings>
                <Building ID="Building-Primary-School-Prototype">
                  <PremisesName>Primary School Prototype</PremisesName>
                  <PremisesNotes>Here we record general problems / issues identified in a walkthrough survey.</PremisesNotes>
                  <Address>
                    <StreetAddressDetail>
                      <Simplified>
                        <StreetAddress>15013 Denver West Parkway</StreetAddress>
                      </Simplified>
                    </StreetAddressDetail>
                    <City>Golden</City>
                    <State>CO</State>
                    <PostalCode>80401</PostalCode>
                  </Address>
                  <BuildingClassification>Commercial</BuildingClassification>
                  <OccupancyClassification>Education-Primary</OccupancyClassification>
                  <FloorsAboveGrade>1</FloorsAboveGrade>
                  <FloorsBelowGrade>0</FloorsBelowGrade>
                  <ConditionedFloorsAboveGrade>1</ConditionedFloorsAboveGrade>
                  <ConditionedFloorsBelowGrade>0</ConditionedFloorsBelowGrade>
                  <HistoricalLandmark>false</HistoricalLandmark>
                  <FloorAreas>
                    <FloorArea>
                      <FloorAreaType>Gross</FloorAreaType>
                      <FloorAreaValue>73960.000000</FloorAreaValue>
                    </FloorArea>
                    <FloorArea>
                      <FloorAreaType>Conditioned</FloorAreaType>
                      <FloorAreaValue>73960.000000</FloorAreaValue>
                    </FloorArea>
                  </FloorAreas>
                  <YearOfConstruction>2018</YearOfConstruction>
                  <YearOccupied>2018</YearOccupied>
                  <YearOfLastMajorRemodel>2018</YearOfLastMajorRemodel>
                </Building>
              </Buildings>
            </Site>
          </Sites>
          <Reports>
            <Report ID="Report-L1-Audit">
              <LinkedPremisesOrSystem>
                <Building>
                  <LinkedBuildingID IDref="Building-Primary-School-Prototype"/>
                </Building>
              </LinkedPremisesOrSystem>
            </Report>
          </Reports>
        </Facility>
      </Facilities>
    </BuildingSync>
    


Now, let us add the contact information. Standard 211 requires that we define a building owner and an auditor. Contacts are created as "Contact" entities, then linked to the building (for the owner) or the report (for the auditor). 


```python
# we create a "Contacts" entity and link it to the facility
contacts = bsync.Contacts()
f1 += contacts

# 6.1.1.1.b - Owner and auditor contact info
c1 = bsync.Contact(
    bsync.ContactName("Bill Dean O'Nerr"),
    bsync.ContactCompany("ACME"),
    bsync.ContactRoles(
        bsync.ContactRole('Owner')
    ),
    bsync.ContactEmailAddresses(
        bsync.ContactEmailAddress(
            bsync.EmailAddress("bd.onerr@acme.net")
        )
    ),
    ID='Contact-Owner'
)
c2 = bsync.Contact(
    bsync.ContactName('Odette Or'),
    bsync.ContactCompany("La Audit Compagnie"),
    bsync.ContactRoles(
        bsync.ContactRole('Energy Auditor')
    ),
    bsync.ContactEmailAddresses(
        bsync.ContactEmailAddress(
            bsync.EmailAddress("odette.orr@la-audit-co.fr")
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
pretty_print(root)
```

    <BuildingSync>
      <Facilities>
        <Facility ID="Facility-1">
          <Sites>
            <Site ID="Site-1">
              <Buildings>
                <Building ID="Building-Primary-School-Prototype">
                  <PremisesName>Primary School Prototype</PremisesName>
                  <PremisesNotes>Here we record general problems / issues identified in a walkthrough survey.</PremisesNotes>
                  <Address>
                    <StreetAddressDetail>
                      <Simplified>
                        <StreetAddress>15013 Denver West Parkway</StreetAddress>
                      </Simplified>
                    </StreetAddressDetail>
                    <City>Golden</City>
                    <State>CO</State>
                    <PostalCode>80401</PostalCode>
                  </Address>
                  <BuildingClassification>Commercial</BuildingClassification>
                  <OccupancyClassification>Education-Primary</OccupancyClassification>
                  <PrimaryContactID IDref="Contact-Owner"/>
                  <FloorsAboveGrade>1</FloorsAboveGrade>
                  <FloorsBelowGrade>0</FloorsBelowGrade>
                  <ConditionedFloorsAboveGrade>1</ConditionedFloorsAboveGrade>
                  <ConditionedFloorsBelowGrade>0</ConditionedFloorsBelowGrade>
                  <HistoricalLandmark>false</HistoricalLandmark>
                  <FloorAreas>
                    <FloorArea>
                      <FloorAreaType>Gross</FloorAreaType>
                      <FloorAreaValue>73960.000000</FloorAreaValue>
                    </FloorArea>
                    <FloorArea>
                      <FloorAreaType>Conditioned</FloorAreaType>
                      <FloorAreaValue>73960.000000</FloorAreaValue>
                    </FloorArea>
                  </FloorAreas>
                  <YearOfConstruction>2018</YearOfConstruction>
                  <YearOccupied>2018</YearOccupied>
                  <YearOfLastMajorRemodel>2018</YearOfLastMajorRemodel>
                </Building>
              </Buildings>
            </Site>
          </Sites>
          <Reports>
            <Report ID="Report-L1-Audit">
              <AuditorContactID IDref="Contact-Auditor"/>
              <LinkedPremisesOrSystem>
                <Building>
                  <LinkedBuildingID IDref="Building-Primary-School-Prototype"/>
                </Building>
              </LinkedPremisesOrSystem>
            </Report>
          </Reports>
          <Contacts>
            <Contact ID="Contact-Owner">
              <ContactRoles>
                <ContactRole>Owner</ContactRole>
              </ContactRoles>
              <ContactName>Bill Dean O'Nerr</ContactName>
              <ContactCompany>ACME</ContactCompany>
              <ContactEmailAddresses>
                <ContactEmailAddress>
                  <EmailAddress>bd.onerr@acme.net</EmailAddress>
                </ContactEmailAddress>
              </ContactEmailAddresses>
            </Contact>
            <Contact ID="Contact-Auditor">
              <ContactRoles>
                <ContactRole>Energy Auditor</ContactRole>
              </ContactRoles>
              <ContactName>Odette Or</ContactName>
              <ContactCompany>La Audit Compagnie</ContactCompany>
              <ContactEmailAddresses>
                <ContactEmailAddress>
                  <EmailAddress>odette.orr@la-audit-co.fr</EmailAddress>
                </ContactEmailAddress>
              </ContactEmailAddresses>
            </Contact>
          </Contacts>
        </Facility>
      </Facilities>
    </BuildingSync>
    


### 5.2 Space Function Analysis
Relevant Standard 211 Sections:
- 5.3.4 Space Function Analysis

Space functions are used to define sections of a building used for different purposes. The classic example of this is a mixed use commercial real estate, with retail space on the bottom floor and offices in the remainder of the building. We do this in BuildingSync via the following:
- Each space functions gets its own `Section` element
- Each `Section` element should specify the `Section/SectionType` as "Space function"


```python
# We create a "Sections" entity that belongs to our building (b1)
sections = bsync.Sections()
b1 += sections
```

Let us break down the school into sections. We have:
- 12 classrooms
- one computer lab
- one bathroom
- one cafeteria
- one gym
- one kitchen
- one library
- one mechanical room
- one office
- 4 corridors

We need to create a definition for each of these sections. We will aggregate the classrooms together (TK check that).

#### 5.2.1 Office space


```python
# create a new section
office_sec = bsync.Sections.Section(ID="Offices")
office_sec += bsync.SectionType('Space function')
office_sec += bsync.OccupancyClassification("Office work area")
office_sec += bsync.OriginalOccupancyClassification("Education-Primary")
sections += office_sec

# add the floor area

# 5.3.4.a Gross floor area for the section (we also add conditioned for 5.3.4.f)
office_fas = bsync.FloorAreas(
    bsync.FloorArea(
        bsync.FloorAreaType("Gross"),
        bsync.FloorAreaValue(4746.88)
    ),
    bsync.FloorArea(
        bsync.FloorAreaType("Conditioned"),
        bsync.FloorAreaValue(4746.88)
    )
)

# 5.3.4.b and 5.3.4.c are asking for typical operating hours for the section
office_tous = bsync.TypicalOccupantUsages()
office_tou_hpw = bsync.TypicalOccupantUsage(
    bsync.TypicalOccupantUsageUnits("Hours per week"),
    bsync.TypicalOccupantUsageValue(45.0)
)
office_tou_wpy = bsync.TypicalOccupantUsage(
    bsync.TypicalOccupantUsageUnits("Weeks per year"),
    bsync.TypicalOccupantUsageValue(50.)
)
office_tous += office_tou_hpw
office_tous += office_tou_wpy

# 5.3.4.d looks for normal / design or peak occupancy.
office_occ_levels = bsync.OccupancyLevels()
office_occ_design = bsync.OccupancyLevel(
    bsync.OccupantQuantityType("Peak total occupants"),
    bsync.OccupantQuantity(23.73)
)
office_occ_levels += office_occ_design

# finally, we add these to the actual section element
office_sec += office_fas
office_sec += office_tous
office_sec += office_occ_levels
```

#### 5.2.2 Mechanical Room


```python
# create a new section
mech_sec = bsync.Sections.Section(ID="Mechanical room")
mech_sec += bsync.SectionType('Space function')
mech_sec += bsync.OccupancyClassification("Mechanical room")
mech_sec += bsync.OriginalOccupancyClassification("Education-Primary")
sections += mech_sec

# add the floor area

# 5.3.4.a Gross floor area for the section (we also add conditioned for 5.3.4.f)
mech_fas = bsync.FloorAreas(
    bsync.FloorArea(
        bsync.FloorAreaType("Gross"),
        bsync.FloorAreaValue(2712.51)
    ),
    bsync.FloorArea(
        bsync.FloorAreaType("Conditioned"),
        bsync.FloorAreaValue(2712.51)
    )
)

# 5.3.4.b and 5.3.4.c are asking for typical operating hours for the section
mech_tous = bsync.TypicalOccupantUsages()
mech_tou_hpw = bsync.TypicalOccupantUsage(
    bsync.TypicalOccupantUsageUnits("Hours per week"),
    bsync.TypicalOccupantUsageValue(30.0)
)
mech_tou_wpy = bsync.TypicalOccupantUsage(
    bsync.TypicalOccupantUsageUnits("Weeks per year"),
    bsync.TypicalOccupantUsageValue(50.)
)
mech_tous += mech_tou_hpw
mech_tous += mech_tou_wpy

# 5.3.4.d looks for normal / design or peak occupancy.
# Here, we take values from the IDF as the building has been modelled: with no occupants in the mech room, bathroom or corridors.
mech_occ_levels = bsync.OccupancyLevels()
mech_occ_design = bsync.OccupancyLevel(
    bsync.OccupantQuantityType("Peak total occupants"),
    bsync.OccupantQuantity(0.)
)
mech_occ_levels += mech_occ_design

# finally, we add these to the actual section element
mech_sec += mech_fas
mech_sec += mech_tous
mech_sec += mech_occ_levels
```

#### 5.2.3 Library


```python
# create a new section
lib_sec = bsync.Sections.Section(ID="Library")
lib_sec += bsync.SectionType('Space function')
lib_sec += bsync.OccupancyClassification("Media center")
lib_sec += bsync.OriginalOccupancyClassification("Education-Primary")
sections += lib_sec

# add the floor area

# 5.3.4.a Gross floor area for the section (we also add conditioned for 5.3.4.f)
lib_fas = bsync.FloorAreas(
    bsync.FloorArea(
        bsync.FloorAreaType("Gross"),
        bsync.FloorAreaValue(4294.80)
    ),
    bsync.FloorArea(
        bsync.FloorAreaType("Conditioned"),
        bsync.FloorAreaValue(4294.80)
    )
)

# 5.3.4.b and 5.3.4.c are asking for typical operating hours for the section
lib_tous = bsync.TypicalOccupantUsages()
lib_tou_hpw = bsync.TypicalOccupantUsage(
    bsync.TypicalOccupantUsageUnits("Hours per week"),
    bsync.TypicalOccupantUsageValue(45.0)
)
lib_tou_wpy = bsync.TypicalOccupantUsage(
    bsync.TypicalOccupantUsageUnits("Weeks per year"),
    bsync.TypicalOccupantUsageValue(50.)
)
lib_tous += lib_tou_hpw
lib_tous += lib_tou_wpy

# 5.3.4.d looks for normal / design or peak occupancy.
# Here, we take values from the IDF as the building has been modelled: with no occupants in the mech room, bathroom or corridors.
lib_occ_levels = bsync.OccupancyLevels()
lib_occ_design = bsync.OccupancyLevel(
    bsync.OccupantQuantityType("Peak total occupants"),
    bsync.OccupantQuantity(42.9)
)
lib_occ_levels += lib_occ_design

# finally, we add these to the actual section element
lib_sec += lib_fas
lib_sec += lib_tous
lib_sec += lib_occ_levels
```

#### 5.2.4 Kitchen


```python
# create a new section
kitchen_sec = bsync.Sections.Section(ID="Kitchen")
kitchen_sec += bsync.SectionType('Space function')
kitchen_sec += bsync.OccupancyClassification("Kitchen")
kitchen_sec += bsync.OriginalOccupancyClassification("Education-Primary")
sections += kitchen_sec

# add the floor area

# 5.3.4.a Gross floor area for the section (we also add conditioned for 5.3.4.f)
kitchen_fas = bsync.FloorAreas(
    bsync.FloorArea(
        bsync.FloorAreaType("Gross"),
        bsync.FloorAreaValue(1808.33)
    ),
    bsync.FloorArea(
        bsync.FloorAreaType("Conditioned"),
        bsync.FloorAreaValue(1808.33)
    )
)

# 5.3.4.b and 5.3.4.c are asking for typical operating hours for the section
kitchen_tous = bsync.TypicalOccupantUsages()
kitchen_tou_hpw = bsync.TypicalOccupantUsage(
    bsync.TypicalOccupantUsageUnits("Hours per week"),
    bsync.TypicalOccupantUsageValue(45.0)
)
kitchen_tou_wpy = bsync.TypicalOccupantUsage(
    bsync.TypicalOccupantUsageUnits("Weeks per year"),
    bsync.TypicalOccupantUsageValue(50.)
)
kitchen_tous += kitchen_tou_hpw
kitchen_tous += kitchen_tou_wpy

# 5.3.4.d looks for normal / design or peak occupancy.
# Here, we take values from the IDF as the building has been modelled: with no occupants in the mech room, bathroom or corridors.
kitchen_occ_levels = bsync.OccupancyLevels()
kitchen_occ_design = bsync.OccupancyLevel(
    bsync.OccupantQuantityType("Peak total occupants"),
    bsync.OccupantQuantity(27.)
)
kitchen_occ_levels += kitchen_occ_design

# finally, we add these to the actual section element
kitchen_sec += kitchen_fas
kitchen_sec += kitchen_tous
kitchen_sec += kitchen_occ_levels
```

#### 5.2.5 Gym


```python
# create a new section
gym_sec = bsync.Sections.Section(ID="Gym")
gym_sec += bsync.SectionType('Space function')
gym_sec += bsync.OccupancyClassification("Sport play area")
gym_sec += bsync.OriginalOccupancyClassification("Education-Primary")
sections += gym_sec

# add the floor area

# 5.3.4.a Gross floor area for the section (we also add conditioned for 5.3.4.f)
gym_fas = bsync.FloorAreas(
    bsync.FloorArea(
        bsync.FloorAreaType("Gross"),
        bsync.FloorAreaValue(3842.71)
    ),
    bsync.FloorArea(
        bsync.FloorAreaType("Conditioned"),
        bsync.FloorAreaValue(3842.71)
    )
)

# 5.3.4.b and 5.3.4.c are asking for typical operating hours for the section
gym_tous = bsync.TypicalOccupantUsages()
gym_tou_hpw = bsync.TypicalOccupantUsage(
    bsync.TypicalOccupantUsageUnits("Hours per week"),
    bsync.TypicalOccupantUsageValue(25.0)
)
gym_tou_wpy = bsync.TypicalOccupantUsage(
    bsync.TypicalOccupantUsageUnits("Weeks per year"),
    bsync.TypicalOccupantUsageValue(50.)
)
gym_tous += gym_tou_hpw
gym_tous += gym_tou_wpy

# 5.3.4.d looks for normal / design or peak occupancy.
# Here, we take values from the IDF as the building has been modelled: with no occupants in the mech room, bathroom or corridors.
gym_occ_levels = bsync.OccupancyLevels()
gym_occ_design = bsync.OccupancyLevel(
    bsync.OccupantQuantityType("Peak total occupants"),
    bsync.OccupantQuantity(115.16)
)
gym_occ_levels += gym_occ_design

# finally, we add these to the actual section element
gym_sec += gym_fas
gym_sec += gym_tous
gym_sec += gym_occ_levels
```

##### 5.2.6 Cafeteria


```python
# create a new section
cafeteria_sec = bsync.Sections.Section(ID="Cafeteria")
cafeteria_sec += bsync.SectionType('Space function')
cafeteria_sec += bsync.OccupancyClassification("Dining area")
cafeteria_sec += bsync.OriginalOccupancyClassification("Education-Primary")
sections += cafeteria_sec

# add the floor area

# 5.3.4.a Gross floor area for the section (we also add conditioned for 5.3.4.f)
cafeteria_fas = bsync.FloorAreas(
    bsync.FloorArea(
        bsync.FloorAreaType("Gross"),
        bsync.FloorAreaValue(3390.63)
    ),
    bsync.FloorArea(
        bsync.FloorAreaType("Conditioned"),
        bsync.FloorAreaValue(3390.63)
    )
)

# 5.3.4.b and 5.3.4.c are asking for typical operating hours for the section
cafeteria_tous = bsync.TypicalOccupantUsages()
cafeteria_tou_hpw = bsync.TypicalOccupantUsage(
    bsync.TypicalOccupantUsageUnits("Hours per week"),
    bsync.TypicalOccupantUsageValue(30.0)
)
cafeteria_tou_wpy = bsync.TypicalOccupantUsage(
    bsync.TypicalOccupantUsageUnits("Weeks per year"),
    bsync.TypicalOccupantUsageValue(50.)
)
cafeteria_tous += cafeteria_tou_hpw
cafeteria_tous += cafeteria_tou_wpy

# 5.3.4.d looks for normal / design or peak occupancy.
# Here, we take values from the IDF as the building has been modelled: with no occupants in the mech room, bathroom or corridors.
cafeteria_occ_levels = bsync.OccupancyLevels()
cafeteria_occ_design = bsync.OccupancyLevel(
    bsync.OccupantQuantityType("Peak total occupants"),
    bsync.OccupantQuantity(338.7)
)
cafeteria_occ_levels += cafeteria_occ_design

# finally, we add these to the actual section element
cafeteria_sec += cafeteria_fas
cafeteria_sec += cafeteria_tous
cafeteria_sec += cafeteria_occ_levels
```

#### 5.2.7 Bathroom


```python
# create a new section
bath_sec = bsync.Sections.Section(ID="Bathroom")
bath_sec += bsync.SectionType('Space function')
bath_sec += bsync.OccupancyClassification("Restroom")
bath_sec += bsync.OriginalOccupancyClassification("Education-Primary")
sections += bath_sec

# add the floor area

# 5.3.4.a Gross floor area for the section (we also add conditioned for 5.3.4.f)
bath_fas = bsync.FloorAreas(
    bsync.FloorArea(
        bsync.FloorAreaType("Gross"),
        bsync.FloorAreaValue(2045.14)
    ),
    bsync.FloorArea(
        bsync.FloorAreaType("Conditioned"),
        bsync.FloorAreaValue(2045.14)
    )
)

# 5.3.4.b and 5.3.4.c are asking for typical operating hours for the section
bath_tous = bsync.TypicalOccupantUsages()
bath_tou_hpw = bsync.TypicalOccupantUsage(
    bsync.TypicalOccupantUsageUnits("Hours per week"),
    bsync.TypicalOccupantUsageValue(45.0)
)
bath_tou_wpy = bsync.TypicalOccupantUsage(
    bsync.TypicalOccupantUsageUnits("Weeks per year"),
    bsync.TypicalOccupantUsageValue(50.)
)
bath_tous += bath_tou_hpw
bath_tous += bath_tou_wpy

# 5.3.4.d looks for normal / design or peak occupancy.
# Here, we take values from the IDF as the building has been modelled: with no occupants in the mech room, bathroom or corridors.
bath_occ_levels = bsync.OccupancyLevels()
bath_occ_design = bsync.OccupancyLevel(
    bsync.OccupantQuantityType("Peak total occupants"),
    bsync.OccupantQuantity(0.)
)
bath_occ_levels += bath_occ_design

# finally, we add these to the actual section element
bath_sec += bath_fas
bath_sec += bath_tous
bath_sec += bath_occ_levels
```

#### 5.2.8 Computer Lab


```python
# create a new section
computerlab_sec = bsync.Sections.Section(ID="Computer-Lab")
computerlab_sec += bsync.SectionType('Space function')
computerlab_sec += bsync.OccupancyClassification("Computer lab")
computerlab_sec += bsync.OriginalOccupancyClassification("Education-Primary")
sections += computerlab_sec

# add the floor area

# 5.3.4.a Gross floor area for the section (we also add conditioned for 5.3.4.f)
computerlab_fas = bsync.FloorAreas(
    bsync.FloorArea(
        bsync.FloorAreaType("Gross"),
        bsync.FloorAreaValue(1743.75)
    ),
    bsync.FloorArea(
        bsync.FloorAreaType("Conditioned"),
        bsync.FloorAreaValue(1743.75)
    )
)

# 5.3.4.b and 5.3.4.c are asking for typical operating hours for the section
computerlab_tous = bsync.TypicalOccupantUsages()
computerlab_tou_hpw = bsync.TypicalOccupantUsage(
    bsync.TypicalOccupantUsageUnits("Hours per week"),
    bsync.TypicalOccupantUsageValue(65.0)
)
computerlab_tou_wpy = bsync.TypicalOccupantUsage(
    bsync.TypicalOccupantUsageUnits("Weeks per year"),
    bsync.TypicalOccupantUsageValue(50.)
)
computerlab_tous += computerlab_tou_hpw
computerlab_tous += computerlab_tou_wpy

# 5.3.4.d looks for normal / design or peak occupancy.
# Here, we take values from the IDF as the building has been modelled: with no occupants in the mech room, bathroom or corridors.
computerlab_occ_levels = bsync.OccupancyLevels()
computerlab_occ_design = bsync.OccupancyLevel(
    bsync.OccupantQuantityType("Peak total occupants"),
    bsync.OccupantQuantity(43.64)
)
computerlab_occ_levels += computerlab_occ_design

# finally, we add these to the actual section element
computerlab_sec += computerlab_fas
computerlab_sec += computerlab_tous
computerlab_sec += computerlab_occ_levels
```

#### 5.2.9 Classrooms

Here, we need to group the classrooms depending on which HVAC unit serves them. There are 3 "pods" defined in the Primary School prototype building, so we create them here.


```python
# create a new section
classroom1_sec = bsync.Sections.Section(ID="Classroom-Pod1")
classroom1_sec += bsync.SectionType('Space function')
classroom1_sec += bsync.OccupancyClassification("Classroom")
classroom1_sec += bsync.OriginalOccupancyClassification("Education-Primary")
sections += classroom1_sec

# add the floor area

# 5.3.4.a Gross floor area for the section (we also add conditioned for 5.3.4.f)
classroom1_fas = bsync.FloorAreas(
    bsync.FloorArea(
        bsync.FloorAreaType("Gross"),
        bsync.FloorAreaValue(12400.02)
    ),
    bsync.FloorArea(
        bsync.FloorAreaType("Conditioned"),
        bsync.FloorAreaValue(12400.02)
    )
)

# 5.3.4.b and 5.3.4.c are asking for typical operating hours for the section
classroom1_tous = bsync.TypicalOccupantUsages()
classroom1_tou_hpw = bsync.TypicalOccupantUsage(
    bsync.TypicalOccupantUsageUnits("Hours per week"),
    bsync.TypicalOccupantUsageValue(45.0)
)
classroom1_tou_wpy = bsync.TypicalOccupantUsage(
    bsync.TypicalOccupantUsageUnits("Weeks per year"),
    bsync.TypicalOccupantUsageValue(50.)
)
classroom1_tous += classroom1_tou_hpw
classroom1_tous += classroom1_tou_wpy

# 5.3.4.d looks for normal / design or peak occupancy.
# Here, we take values from the IDF as the building has been modelled: with no occupants in the mech room, bathroom or corridors.
classroom1_occ_levels = bsync.OccupancyLevels()
classroom1_occ_design = bsync.OccupancyLevel(
    bsync.OccupantQuantityType("Peak total occupants"),
    bsync.OccupantQuantity(309.7)
)
classroom1_occ_levels += classroom1_occ_design

# finally, we add these to the actual section element
classroom1_sec += classroom1_fas
classroom1_sec += classroom1_tous
classroom1_sec += classroom1_occ_levels
```


```python
# create a new section
classroom2_sec = bsync.Sections.Section(ID="Classroom-Pod2")
classroom2_sec += bsync.SectionType('Space function')
classroom2_sec += bsync.OccupancyClassification("Classroom")
classroom2_sec += bsync.OriginalOccupancyClassification("Education-Primary")
sections += classroom2_sec

# add the floor area

# 5.3.4.a Gross floor area for the section (we also add conditioned for 5.3.4.f)
classroom2_fas = bsync.FloorAreas(
    bsync.FloorArea(
        bsync.FloorAreaType("Gross"),
        bsync.FloorAreaValue(12400.02)
    ),
    bsync.FloorArea(
        bsync.FloorAreaType("Conditioned"),
        bsync.FloorAreaValue(12400.02)
    )
)

# 5.3.4.b and 5.3.4.c are asking for typical operating hours for the section
classroom2_tous = bsync.TypicalOccupantUsages()
classroom2_tou_hpw = bsync.TypicalOccupantUsage(
    bsync.TypicalOccupantUsageUnits("Hours per week"),
    bsync.TypicalOccupantUsageValue(45.0)
)
classroom2_tou_wpy = bsync.TypicalOccupantUsage(
    bsync.TypicalOccupantUsageUnits("Weeks per year"),
    bsync.TypicalOccupantUsageValue(50.)
)
classroom2_tous += classroom2_tou_hpw
classroom2_tous += classroom2_tou_wpy

# 5.3.4.d looks for normal / design or peak occupancy.
# Here, we take values from the IDF as the building has been modelled: with no occupants in the mech room, bathroom or corridors.
classroom2_occ_levels = bsync.OccupancyLevels()
classroom2_occ_design = bsync.OccupancyLevel(
    bsync.OccupantQuantityType("Peak total occupants"),
    bsync.OccupantQuantity(309.7)
)
classroom2_occ_levels += classroom2_occ_design

# finally, we add these to the actual section element
classroom2_sec += classroom2_fas
classroom2_sec += classroom2_tous
classroom2_sec += classroom2_occ_levels
```


```python
# create a new section
classroom3_sec = bsync.Sections.Section(ID="Classroom-Pod3")
classroom3_sec += bsync.SectionType('Space function')
classroom3_sec += bsync.OccupancyClassification("Classroom")
classroom3_sec += bsync.OriginalOccupancyClassification("Education-Primary")
sections += classroom3_sec

# add the floor area

# 5.3.4.a Gross floor area for the section (we also add conditioned for 5.3.4.f)
classroom3_fas = bsync.FloorAreas(
    bsync.FloorArea(
        bsync.FloorAreaType("Gross"),
        bsync.FloorAreaValue(10656.27)
    ),
    bsync.FloorArea(
        bsync.FloorAreaType("Conditioned"),
        bsync.FloorAreaValue(10656.27)
    )
)

# 5.3.4.b and 5.3.4.c are asking for typical operating hours for the section
classroom3_tous = bsync.TypicalOccupantUsages()
classroom3_tou_hpw = bsync.TypicalOccupantUsage(
    bsync.TypicalOccupantUsageUnits("Hours per week"),
    bsync.TypicalOccupantUsageValue(45.0)
)
classroom3_tou_wpy = bsync.TypicalOccupantUsage(
    bsync.TypicalOccupantUsageUnits("Weeks per year"),
    bsync.TypicalOccupantUsageValue(50.)
)
classroom3_tous += classroom3_tou_hpw
classroom3_tous += classroom3_tou_wpy

# 5.3.4.d looks for normal / design or peak occupancy.
# Here, we take values from the IDF as the building has been modelled: with no occupants in the mech room, bathroom or corridors.
classroom3_occ_levels = bsync.OccupancyLevels()
classroom3_occ_design = bsync.OccupancyLevel(
    bsync.OccupantQuantityType("Peak total occupants"),
    bsync.OccupantQuantity(266.12)
)
classroom3_occ_levels += classroom3_occ_design

# finally, we add these to the actual section element
classroom3_sec += classroom3_fas
classroom3_sec += classroom3_tous
classroom3_sec += classroom3_occ_levels
```

#### 5.2.10 Corridors

We need to do the same for the 4 corridor spaces, as each is serviced by a different VAV.


```python
# create a new section
corridor1_sec = bsync.Sections.Section(ID="Corridor-Pod1")
corridor1_sec += bsync.SectionType('Space function')
corridor1_sec += bsync.OccupancyClassification("Corridor")
corridor1_sec += bsync.OriginalOccupancyClassification("Education-Primary")
sections += corridor1_sec

# add the floor area

# 5.3.4.a Gross floor area for the section (we also add conditioned for 5.3.4.f)
corridor1_fas = bsync.FloorAreas(
    bsync.FloorArea(
        bsync.FloorAreaType("Gross"),
        bsync.FloorAreaValue(2066.67)
    ),
    bsync.FloorArea(
        bsync.FloorAreaType("Conditioned"),
        bsync.FloorAreaValue(2066.67)
    )
)

# 5.3.4.b and 5.3.4.c are asking for typical operating hours for the section
corridor1_tous = bsync.TypicalOccupantUsages()
corridor1_tou_hpw = bsync.TypicalOccupantUsage(
    bsync.TypicalOccupantUsageUnits("Hours per week"),
    bsync.TypicalOccupantUsageValue(45.0)
)
corridor1_tou_wpy = bsync.TypicalOccupantUsage(
    bsync.TypicalOccupantUsageUnits("Weeks per year"),
    bsync.TypicalOccupantUsageValue(50.)
)
corridor1_tous += corridor1_tou_hpw
corridor1_tous += corridor1_tou_wpy

# 5.3.4.d looks for normal / design or peak occupancy.
# Here, we take values from the IDF as the building has been modelled: with no occupants in the mech room, bathroom or corridors.
corridor1_occ_levels = bsync.OccupancyLevels()
corridor1_occ_design = bsync.OccupancyLevel(
    bsync.OccupantQuantityType("Peak total occupants"),
    bsync.OccupantQuantity(0.)
)
corridor1_occ_levels += corridor1_occ_design

# finally, we add these to the actual section element
corridor1_sec += corridor1_fas
corridor1_sec += corridor1_tous
corridor1_sec += corridor1_occ_levels
```


```python
# create a new section
corridor2_sec = bsync.Sections.Section(ID="Corridor-Pod1")
corridor2_sec += bsync.SectionType('Space function')
corridor2_sec += bsync.OccupancyClassification("Corridor")
corridor2_sec += bsync.OriginalOccupancyClassification("Education-Primary")
sections += corridor2_sec

# add the floor area

# 5.3.4.a Gross floor area for the section (we also add conditioned for 5.3.4.f)
corridor2_fas = bsync.FloorAreas(
    bsync.FloorArea(
        bsync.FloorAreaType("Gross"),
        bsync.FloorAreaValue(2066.67)
    ),
    bsync.FloorArea(
        bsync.FloorAreaType("Conditioned"),
        bsync.FloorAreaValue(2066.67)
    )
)

# 5.3.4.b and 5.3.4.c are asking for typical operating hours for the section
corridor2_tous = bsync.TypicalOccupantUsages()
corridor2_tou_hpw = bsync.TypicalOccupantUsage(
    bsync.TypicalOccupantUsageUnits("Hours per week"),
    bsync.TypicalOccupantUsageValue(45.0)
)
corridor2_tou_wpy = bsync.TypicalOccupantUsage(
    bsync.TypicalOccupantUsageUnits("Weeks per year"),
    bsync.TypicalOccupantUsageValue(50.)
)
corridor2_tous += corridor2_tou_hpw
corridor2_tous += corridor2_tou_wpy

# 5.3.4.d looks for normal / design or peak occupancy.
# Here, we take values from the IDF as the building has been modelled: with no occupants in the mech room, bathroom or corridors.
corridor2_occ_levels = bsync.OccupancyLevels()
corridor2_occ_design = bsync.OccupancyLevel(
    bsync.OccupantQuantityType("Peak total occupants"),
    bsync.OccupantQuantity(0.)
)
corridor2_occ_levels += corridor2_occ_design

# finally, we add these to the actual section element
corridor2_sec += corridor2_fas
corridor2_sec += corridor2_tous
corridor2_sec += corridor2_occ_levels
```


```python
# create a new section
corridor3_sec = bsync.Sections.Section(ID="Corridor-Pod1")
corridor3_sec += bsync.SectionType('Space function')
corridor3_sec += bsync.OccupancyClassification("Corridor")
corridor3_sec += bsync.OriginalOccupancyClassification("Education-Primary")
sections += corridor3_sec

# add the floor area

# 5.3.4.a Gross floor area for the section (we also add conditioned for 5.3.4.f)
corridor3_fas = bsync.FloorAreas(
    bsync.FloorArea(
        bsync.FloorAreaType("Gross"),
        bsync.FloorAreaValue(2066.67)
    ),
    bsync.FloorArea(
        bsync.FloorAreaType("Conditioned"),
        bsync.FloorAreaValue(2066.67)
    )
)

# 5.3.4.b and 5.3.4.c are asking for typical operating hours for the section
corridor3_tous = bsync.TypicalOccupantUsages()
corridor3_tou_hpw = bsync.TypicalOccupantUsage(
    bsync.TypicalOccupantUsageUnits("Hours per week"),
    bsync.TypicalOccupantUsageValue(45.0)
)
corridor3_tou_wpy = bsync.TypicalOccupantUsage(
    bsync.TypicalOccupantUsageUnits("Weeks per year"),
    bsync.TypicalOccupantUsageValue(50.)
)
corridor3_tous += corridor3_tou_hpw
corridor3_tous += corridor3_tou_wpy

# 5.3.4.d looks for normal / design or peak occupancy.
# Here, we take values from the IDF as the building has been modelled: with no occupants in the mech room, bathroom or corridors.
corridor3_occ_levels = bsync.OccupancyLevels()
corridor3_occ_design = bsync.OccupancyLevel(
    bsync.OccupantQuantityType("Peak total occupants"),
    bsync.OccupantQuantity(0.)
)
corridor3_occ_levels += corridor3_occ_design

# finally, we add these to the actual section element
corridor3_sec += corridor3_fas
corridor3_sec += corridor3_tous
corridor3_sec += corridor3_occ_levels
```


```python
# create a new section
corridormain_sec = bsync.Sections.Section(ID="Corridor-Pod1")
corridormain_sec += bsync.SectionType('Space function')
corridormain_sec += bsync.OccupancyClassification("Corridor")
corridormain_sec += bsync.OriginalOccupancyClassification("Education-Primary")
sections += corridormain_sec

# add the floor area

# 5.3.4.a Gross floor area for the section (we also add conditioned for 5.3.4.f)
corridormain_fas = bsync.FloorAreas(
    bsync.FloorArea(
        bsync.FloorAreaType("Gross"),
        bsync.FloorAreaValue(2066.67)
    ),
    bsync.FloorArea(
        bsync.FloorAreaType("Conditioned"),
        bsync.FloorAreaValue(2066.67)
    )
)

# 5.3.4.b and 5.3.4.c are asking for typical operating hours for the section
corridormain_tous = bsync.TypicalOccupantUsages()
corridormain_tou_hpw = bsync.TypicalOccupantUsage(
    bsync.TypicalOccupantUsageUnits("Hours per week"),
    bsync.TypicalOccupantUsageValue(45.0)
)
corridormain_tou_wpy = bsync.TypicalOccupantUsage(
    bsync.TypicalOccupantUsageUnits("Weeks per year"),
    bsync.TypicalOccupantUsageValue(50.)
)
corridormain_tous += corridormain_tou_hpw
corridormain_tous += corridormain_tou_wpy

# 5.3.4.d looks for normal / design or peak occupancy.
# Here, we take values from the IDF as the building has been modelled: with no occupants in the mech room, bathroom or corridors.
corridormain_occ_levels = bsync.OccupancyLevels()
corridormain_occ_design = bsync.OccupancyLevel(
    bsync.OccupantQuantityType("Peak total occupants"),
    bsync.OccupantQuantity(0.)
)
corridormain_occ_levels += corridormain_occ_design

# finally, we add these to the actual section element
corridormain_sec += corridormain_fas
corridormain_sec += corridormain_tous
corridormain_sec += corridormain_occ_levels
```

#### 5.2.11 Lobby


```python
# create a new section
lobby_sec = bsync.Sections.Section(ID="Lobby")
lobby_sec += bsync.SectionType('Space function')
lobby_sec += bsync.OccupancyClassification("Lobby")
lobby_sec += bsync.OriginalOccupancyClassification("Education-Primary")
sections += lobby_sec

# add the floor area

# 5.3.4.a Gross floor area for the section (we also add conditioned for 5.3.4.f)
lobby_fas = bsync.FloorAreas(
    bsync.FloorArea(
        bsync.FloorAreaType("Gross"),
        bsync.FloorAreaValue(1840.62)
    ),
    bsync.FloorArea(
        bsync.FloorAreaType("Conditioned"),
        bsync.FloorAreaValue(1840.62)
    )
)

# 5.3.4.b and 5.3.4.c are asking for typical operating hours for the section
lobby_tous = bsync.TypicalOccupantUsages()
lobby_tou_hpw = bsync.TypicalOccupantUsage(
    bsync.TypicalOccupantUsageUnits("Hours per week"),
    bsync.TypicalOccupantUsageValue(45.0)
)
lobby_tou_wpy = bsync.TypicalOccupantUsage(
    bsync.TypicalOccupantUsageUnits("Weeks per year"),
    bsync.TypicalOccupantUsageValue(50.)
)
lobby_tous += lobby_tou_hpw
lobby_tous += lobby_tou_wpy

# 5.3.4.d looks for normal / design or peak occupancy.
# Here, we take values from the IDF as the building has been modelled: with no occupants in the mech room, bathroom, lobby or corridors.
lobby_occ_levels = bsync.OccupancyLevels()
lobby_occ_design = bsync.OccupancyLevel(
    bsync.OccupantQuantityType("Peak total occupants"),
    bsync.OccupantQuantity(0.)
)
lobby_occ_levels += lobby_occ_design

# finally, we add these to the actual section element
lobby_sec += lobby_fas
lobby_sec += lobby_tous
lobby_sec += lobby_occ_levels
```

### 5.3 Plugs, lighting and HVAC

Level 1 and Level 2 energy audits require information about the primary systems serving a specific section, but with very different degrees of specificity. Taking guidance from the 211 Normative spreadsheet:
- A Level 1 audit just requires high level information
- A Level 2 audit requires doing some more detailed modeling of the actual system of interest (mainly for HVAC).



```python
systems = bsync.Systems()
# Systems, measures, reports and contacts belong to our facility (f1)
f1 += systems

# Let us automate the task this time
# We first create a list of dictionaries that contains information on space IDs and the appropriate plug load. The plug load is taken from the Primary School Prototype ASHRAE Standard 90.1-2016 model
# We take the IDs from the sections we created earlier
plugloads = [{'spaceid' : lobby_sec["ID"], 'plugload' : 4.0},
             {'spaceid' : corridor1_sec["ID"], 'plugload' : 4.0},
             {'spaceid' : corridor2_sec["ID"], 'plugload' : 4.0},
             {'spaceid' : corridor3_sec["ID"], 'plugload' : 4.0},
             {'spaceid' : corridormain_sec["ID"], 'plugload' : 4.0},
             {'spaceid' : classroom1_sec["ID"], 'plugload' : 15.0},
             {'spaceid' : classroom2_sec["ID"], 'plugload' : 15.0},
             {'spaceid' : classroom3_sec["ID"], 'plugload' : 15.0},
             {'spaceid' : computerlab_sec["ID"], 'plugload' : 20.0},
             {'spaceid' : bath_sec["ID"], 'plugload' : 4.0},
             {'spaceid' : cafeteria_sec["ID"], 'plugload' : 25.39},
             {'spaceid' : gym_sec["ID"], 'plugload' : 5.0},
             {'spaceid' : kitchen_sec["ID"], 'plugload' : 1630.3893},
             {'spaceid' : lib_sec["ID"], 'plugload' : 15.0},
             {'spaceid' : mech_sec["ID"], 'plugload' : 10.0},
             {'spaceid' : office_sec["ID"], 'plugload' : 10.8},
]

# Now we create a loop to assign the corresponding plug and process load to the appropriate section

plug_systems = bsync.PlugLoads()
systems += plug_systems

for section in plugloads:
    psys = bsync.PlugLoad(
        bsync.WeightedAverageLoad(section['plugload']),
        bsync.LinkedPremises(
                bsync.LinkedPremises.Section(
                    bsync.LinkedSectionID(IDref=section['spaceid'])
                )
            ),
        ID=f"PlugLoad-{section['spaceid']}"
    )
    plug_systems += psys
```


```python
# For the lighting systems, this is a bit different. When 
# performing an audit, it is atypical to know the LPD of a space / zone
# as you would in 'Energy Modeling' world / design world.
# Assuming drawings are unavailable and we go in to check,
# based on the vintage it's likely we will find T8 linear
# fluorescents (thanks Jay Wratten!). So we add that information
light_systems = bsync.LightingSystems()
systems += light_systems
for section in plugloads:
    ls = bsync.LightingSystem(
        bsync.LampType(
            bsync.LinearFluorescent(
                bsync.LinearFluorescent.LampLabel("T8")
            )
        ),
        bsync.BallastType("Standard Electronic"),
        bsync.LinkedPremises(
            bsync.LinkedPremises.Section(
                bsync.LinkedSectionID(IDref=section['spaceid'])
            )
        ),
        ID=f"LightingSystem-{section['spaceid']}"
    )
    light_systems += ls
```


```python
# The Primary School prototype model has 3 packaged rooftop units (single-speed dx cooling and fuel fired furnace) and 4 packaged rooftop VAV with hot water reheat.
# We create them and link them back to the sections of interest.
# At this point, we aren't modeling separate HVAC zones.
# This level of detail fulfills requirements for a Level 1 audit

hvac_systems = bsync.HVACSystems()
systems+=hvac_systems
plugloads = [{'spaceid' : lobby_sec["ID"], 'plugload' : 4.0},
             {'spaceid' : corridor1_sec["ID"], 'plugload' : 4.0},
             {'spaceid' : corridor2_sec["ID"], 'plugload' : 4.0},
             {'spaceid' : corridor3_sec["ID"], 'plugload' : 4.0},
             {'spaceid' : corridormain_sec["ID"], 'plugload' : 4.0},
             {'spaceid' : classroom1_sec["ID"], 'plugload' : 15.0},
             {'spaceid' : classroom2_sec["ID"], 'plugload' : 15.0},
             {'spaceid' : classroom3_sec["ID"], 'plugload' : 15.0},
             {'spaceid' : computerlab_sec["ID"], 'plugload' : 20.0},
             {'spaceid' : bath_sec["ID"], 'plugload' : 4.0},
             {'spaceid' : cafeteria_sec["ID"], 'plugload' : 25.39},
             {'spaceid' : gym_sec["ID"], 'plugload' : 5.0},
             {'spaceid' : kitchen_sec["ID"], 'plugload' : 1630.3893},
             {'spaceid' : lib_sec["ID"], 'plugload' : 15.0},
             {'spaceid' : mech_sec["ID"], 'plugload' : 10.0},
             {'spaceid' : office_sec["ID"], 'plugload' : 10.8},
]

# First, the VAVs

# For the first VAV servicing pod 1:
pod1premises = bsync.LinkedPremises()
pod1premises += bsync.LinkedPremises.Section(bsync.LinkedSectionID(IDref=corridor1_sec["ID"]))
pod1premises += bsync.LinkedPremises.Section(bsync.LinkedSectionID(IDref=classroom1_sec["ID"]))

vav_pod1 = bsync.HVACSystem(
        bsync.PrincipalHVACSystemType("Packaged Rooftop VAV with Hot Water Reheat"),
        pod1premises,
        ID="VAV-Pod1"
    )

# For the second VAV servicing pod 2:
pod2premises = bsync.LinkedPremises()
pod2premises += bsync.LinkedPremises.Section(bsync.LinkedSectionID(IDref=corridor2_sec["ID"]))
pod2premises += bsync.LinkedPremises.Section(bsync.LinkedSectionID(IDref=classroom2_sec["ID"]))

vav_pod2 = bsync.HVACSystem(
        bsync.PrincipalHVACSystemType("Packaged Rooftop VAV with Hot Water Reheat"),
        pod2premises,
        ID="VAV-Pod2"
    )

# For the third VAV servicing pod 3:
pod3premises = bsync.LinkedPremises()
pod3premises += bsync.LinkedPremises.Section(bsync.LinkedSectionID(IDref=corridor3_sec["ID"]))
pod3premises += bsync.LinkedPremises.Section(bsync.LinkedSectionID(IDref=classroom3_sec["ID"]))

vav_pod3 = bsync.HVACSystem(
        bsync.PrincipalHVACSystemType("Packaged Rooftop VAV with Hot Water Reheat"),
        pod3premises,
        ID="VAV-Pod1"
    )

# For the last VAV servicing other rooms:
vav4premises = bsync.LinkedPremises()
vav4premises += bsync.LinkedPremises.Section(bsync.LinkedSectionID(IDref=computerlab_sec["ID"]))
vav4premises += bsync.LinkedPremises.Section(bsync.LinkedSectionID(IDref=corridormain_sec["ID"]))
vav4premises += bsync.LinkedPremises.Section(bsync.LinkedSectionID(IDref=lobby_sec["ID"]))
vav4premises += bsync.LinkedPremises.Section(bsync.LinkedSectionID(IDref=mech_sec["ID"]))
vav4premises += bsync.LinkedPremises.Section(bsync.LinkedSectionID(IDref=bath_sec["ID"]))
vav4premises += bsync.LinkedPremises.Section(bsync.LinkedSectionID(IDref=office_sec["ID"]))
vav4premises += bsync.LinkedPremises.Section(bsync.LinkedSectionID(IDref=lib_sec["ID"]))

vav_other = bsync.HVACSystem(
        bsync.PrincipalHVACSystemType("Packaged Rooftop VAV with Hot Water Reheat"),
        vav4premises,
        ID="VAV-other"
    )

# Now, the packaged single-zone constant air volume rooftop units with multi speed DX coil and fuel-fired furnace

# For the first PSZ-AC:
pszac_1 = bsync.HVACSystem(
        bsync.PrincipalHVACSystemType("Packaged Rooftop Air Conditioner"),
        bsync.LinkedPremises(bsync.LinkedPremises.Section(bsync.LinkedSectionID(IDref=gym_sec["ID"]))),
        ID="PSZAC-Gym"
    )

# For the second PSZ-AC:
pszac_2 = bsync.HVACSystem(
        bsync.PrincipalHVACSystemType("Packaged Rooftop Air Conditioner"),
        bsync.LinkedPremises(bsync.LinkedPremises.Section(bsync.LinkedSectionID(IDref=kitchen_sec["ID"]))),
        ID="PSZAC-Kitchen"
    )

# For the last PSZ-AC:
pszac_3 = bsync.HVACSystem(
        bsync.PrincipalHVACSystemType("Packaged Rooftop Air Conditioner"),
        bsync.LinkedPremises(bsync.LinkedPremises.Section(bsync.LinkedSectionID(IDref=cafeteria_sec["ID"]))),
        ID="PSZAC-Cafeteria"
    )

hvac_systems += vav_pod1
hvac_systems += vav_pod2
hvac_systems += vav_pod3
hvac_systems += vav_other
hvac_systems += pszac_1
hvac_systems += pszac_2
hvac_systems += pszac_3

    
```

### Current Building Measured Scenario
Relevant Standard 211 Sections:
- 6.1.2

Now that we have a quick sense of the building, let's start off by looking at the requirements for an ASHRAE 211 Level 1 audit. This leads us to the concept of a [Scenario](https://buildingsync.net/schema/v2.3.0/documentation/BuildingSync_xsd.html#ScenarioType). A Scenario in BuildingSync is used to refer to energy and timeseries data associated with a particular, well, scenario. Specifically, there are 5 primary Scenarios used in BuildingSync, all which relate back to Standard 211:

![Scenario Types](./img/b1-sc-docs.png)

We will repeatedly come back to the concept of a Scenario, as they are core to organizing information in a BuildingSync document. 

The current building measured scenario is intended to capture true measured historical data. Typically this refers to utility bill data, but AMI type data can also be captured (later).  We start off by creating a new scenario element and defining its type as follows:
- `Scenario[ScenarioType/CurrentBuilding/CalculationMethod/Measured]`. This is an XPath expression that can be interpreted as "A Scenario that has the child elements ScenarioType/CurrentBuilding/CalculationMethod/Measured".  The XML for this would look like:

<Scenario>
    <ScenarioType>
        <CurrentBuilding>
            <CalculationMethod>
                <Measured/>
            </CalculationMethod>
        </CurrentBuilding>
    </ScenarioType>
</Scenario>


We build this scenario up programatically as follows:



```python
# Create a section for scenarios
scenarios = bsync.Scenarios()
r1 += scenarios
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
cbms['ID'] = 'Scenario-1'

# add the scenario to the audit report and scenarios parent grouping
scenarios += cbms
```

#### Utilities
Relevant Standard 211 Sections: 6.1.2
In the next section, we will create resource use elements to define energy data. First, we need to get add utility information. Utility information gets added at the report level. Specific information required includes:
- Rate schedules (you can get very expressive in BuildingSync with Rate Schedules - we keep it pretty minimal here)
- Utility account numbers


```python
# we define two flat rate periods
utilities = bsync.Utilities()
r1 += utilities
elec_ut = bsync.Utility(
    bsync.RateSchedules(
        bsync.RateSchedule(
            bsync.TypeOfRateStructure(
                bsync.FlatRate(
                    bsync.FlatRate.RatePeriods(
                        bsync.FlatRate.RatePeriods.RatePeriod(
                                bsync.ApplicableStartDateForEnergyRate(date(2019,1,1)),
                                bsync.ApplicableEndDateForEnergyRate(date(2020,1,1)),
                                bsync.EnergyCostRate(0.00461),
                                bsync.ApplicableStartDateForDemandRate(date(2019,1,1)),
                                bsync.ApplicableEndDateForDemandRate(date(2020,1,1)),
                                bsync.ElectricDemandRate(5.63)
                        )
                    )
                    
                )
            ),
            bsync.ReferenceForRateStructure("https://www.xcelenergy.com/staticfiles/xe/Regulatory/COBusRates.pdf"),
            bsync.FixedMonthlyCharge(36.17),
            ID="RateSchedule-Electricity"
        )
    ),
    bsync.UtilityName("XCEL Energy"),
    bsync.UtilityAccountNumber("some-account-number"),
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
                            bsync.EnergyCostRate(1.158) # $/MMBtu
                        )
                    )
                )
            ),
            bsync.ReferenceForRateStructure("https://www.xcelenergy.com/staticfiles/xe/Regulatory/COBusRates.pdf"),
            ID="RateSchedule-Natural-Gas"
        )
    ),
    bsync.UtilityName("XCEL Energy"),
    bsync.UtilityAccountNumber("some-other-account-number"),
    ID="Utility-Natural-Gas"
)

utilities += elec_ut
utilities += ng_ut

```


#### ResourceUses and TimeSeries Data
Now that we have a current building measured scenario, we want to declare energy and monthly billing data. Per Std 211 6.1.2.1, a minimum of 12 months (preferably up to 3 years) of energy use data is required. We run an example simulation to get estimates for this, which come out as follows:

| Resource Type | Jan | Feb | Mar | Apr | May | Jun | Jul | Aug | Sep | Oct | Nov | Dec |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Electricity (kWh) | 52651.67 | 46018.33 | 52645.00 | 49929.17 | 58176.39 | 66276.94 | 52738.06 | 56057.78 | 60436.11 | 57091.67 | 51428.89 | 50311.11 |
| Natural Gas (MMBtu) | 164.43 | 143.11 | 102.60 | 59.73 | 49.42 | 39.98 | 36.71 | 40.76 | 37.69 | 60.47 | 86.44 | 168.89 |
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
    )
)

# given the above, we add the annual totals
elec_ru += bsync.AnnualFuelUseNativeUnits(653761.11)
elec_ru += bsync.AnnualFuelUseConsistentUnits(2230.84) #convert to MMBTU
elec_ru += bsync.AnnualPeakNativeUnits(248431.13) # kW as specified above
elec_ru += bsync.AnnualPeakConsistentUnits(248431.13) # already in kW, same as above
elec_ru += bsync.AnnualFuelCost(16412.13)

# create a resource use for greenhouse gas emissions, units of MtCO2e, all end uses



ghg_ru = bsync.ResourceUse(
    bsync.Emissions(
        bsync.Emission(
            bsync.EmissionBoundary("Indirect"), 
            bsync.EmissionsType("CO2e"),
            bsync.GHGEmissions(25000.0),
        )
    )
)

# create a resource use for natural gas, units of MMBtu, all end uses
# additional connect it up to the utility
ng_ru = bsync.ResourceUse(
    bsync.EnergyResource('Natural gas'),
    bsync.ResourceUseNotes("No irregularities in monthly energy consumption found."),
    bsync.ResourceUnits('MMBtu'),
    bsync.EndUse('All end uses'),
    bsync.UtilityIDs(
        bsync.UtilityID(IDref=ng_ut['ID'])
    )
)

# given the above, we add the annual totals
ng_ru += bsync.AnnualFuelUseNativeUnits(994.95)
ng_ru += bsync.AnnualFuelUseConsistentUnits(994.95) # already in MMBTU
ng_ru += bsync.AnnualFuelCost(1152.52) # ~ $1.158/MMBtu

# add these to the ResourceUses parent element
all_ru += elec_ru
all_ru += ghg_ru
all_ru += ng_ru

# we can still add information to the child elements
elec_ru['ID'] = 'ResourceUse-Electricity'
ghg_ru['ID'] = 'ResourceUse-GreenhouseGasEmissions'
ng_ru['ID'] = 'ResourceUse-Natural-gas'

# ResourceUses are child elements of a specific scenario:
cbms += all_ru
```

#### Example TimeSeries Walkthrough
Now that we have resource uses, we want to associate timeseries data to those specific resources. We will assume the utility billing data is nicely segmented for us and each billing period starts on the 1st of the month and ends on the last day. We use BuildingSync TimeSeries elements to store temporal data. We walk through creating a simple timeseries element to capture January's electricity consumption.


```python
# all timeseries is captured in a TimeSeriesData parent
ts_data = bsync.TimeSeriesData()

# Create a new TimeSeries element for Electricity
jan_elec = bsync.TimeSeries(ID="TS-Example")

# a ReadingType of 'Total' signifies a summation / integral over the time period specified
jan_elec += bsync.ReadingType('Total')

# A TimeSeriesReadingQuantity isn't necessary for timeseries specific to a ResourceUse since we will 'point back to'
# the resource use later, however, verbosity never hurts
jan_elec += bsync.TimeSeriesReadingQuantity('Energy')

# Add start and end timestamps. XSD datatypes are translated into python datatypes
# within the bsync package. For example, the xs:dateTime datatype, we need to provide python datetime object

# this_will_fail = bsync.TimeSeriesData.TimeSeries.StartTimestamp('2019-01-01T00:00:00')

# we need to do something like this
start_dt = datetime(2021, 1, 1, 0, 0)
end_dt = datetime(2021, 2, 1, 0, 0)

# in bsync, a StartTimetamp is inclusive and an EndTimestamp is exclusive
# the interval notation for the above would be like:
# [ start, end ) 
jan_elec += bsync.StartTimestamp(start_dt)
jan_elec += bsync.EndTimestamp(end_dt)

# next, we convey the IntervalReading, i.e. the value.
# The value should use the same units as declared by the ResourceUse/ResourceUnits
jan_elec += bsync.IntervalReading(52651.67)

# finally, we need to convey to which resource this timeseries element is 'connected',
# i.e. the value represented by this reading conveys information for the Electricity resource use
jan_elec += bsync.ResourceUseID(IDref=elec_ru['ID'])

# and we add this as a child to the TimeSeriesData element
ts_data += jan_elec
pretty_print(ts_data)
```

    <TimeSeriesData>
      <TimeSeries ID="TS-Example">
        <ReadingType>Total</ReadingType>
        <TimeSeriesReadingQuantity>Energy</TimeSeriesReadingQuantity>
        <StartTimestamp>2021-01-01T00:00:00</StartTimestamp>
        <EndTimestamp>2021-02-01T00:00:00</EndTimestamp>
        <IntervalReading>52651.670000</IntervalReading>
        <ResourceUseID IDref="ResourceUse-Electricity"/>
      </TimeSeries>
    </TimeSeriesData>
    



```python
# Create a new TimeSeries element now for GHG Emissions
jan_ghg_elec = bsync.TimeSeries(ID="TS-ResourceUse-MtCO2e-1")

# a ReadingType of 'Total' signifies a summation / integral over the time period specified
jan_ghg_elec += bsync.ReadingType('Total')

# A TimeSeriesReadingQuantity isn't necessary for timeseries specific to a ResourceUse since we will 'point back to'
# the resource use later, however, verbosity never hurts
jan_ghg_elec += bsync.TimeSeriesReadingQuantity('Other')

# Add start and end timestamps. XSD datatypes are translated into python datatypes
# within the bsync package. For example, the xs:dateTime datatype, we need to provide python datetime object

# this_will_fail = bsync.TimeSeriesData.TimeSeries.StartTimestamp('2019-01-01T00:00:00')

# we need to do something like this
start_dt = datetime(2021, 1, 1, 0, 0)
end_dt = datetime(2021, 2, 1, 0, 0)

# in bsync, a StartTimetamp is inclusive and an EndTimestamp is exclusive
# the interval notation for the above would be like:
# [ start, end ) 
jan_ghg_elec += bsync.StartTimestamp(start_dt)
jan_ghg_elec += bsync.EndTimestamp(end_dt)

# next, we convey the IntervalReading, i.e. the value.
# The value should use the same units as declared by the ResourceUse/ResourceUnits
jan_ghg_elec += bsync.IntervalReading(250.0)

# finally, we need to convey to which resource this timeseries element is 'connected',
# i.e. the value represented by this reading conveys information for the GHG Emissions resource use
jan_ghg_elec += bsync.ResourceUseID(IDref=elec_ru['ID'])

# and we add this as a child to the TimeSeriesData element
ts_data += jan_ghg_elec
pretty_print(ts_data)
```

    <TimeSeriesData>
      <TimeSeries ID="TS-Example">
        <ReadingType>Total</ReadingType>
        <TimeSeriesReadingQuantity>Energy</TimeSeriesReadingQuantity>
        <StartTimestamp>2021-01-01T00:00:00</StartTimestamp>
        <EndTimestamp>2021-02-01T00:00:00</EndTimestamp>
        <IntervalReading>52651.670000</IntervalReading>
        <ResourceUseID IDref="ResourceUse-Electricity"/>
      </TimeSeries>
      <TimeSeries ID="TS-ResourceUse-MtCO2e-1">
        <ReadingType>Total</ReadingType>
        <TimeSeriesReadingQuantity>Other</TimeSeriesReadingQuantity>
        <StartTimestamp>2021-01-01T00:00:00</StartTimestamp>
        <EndTimestamp>2021-02-01T00:00:00</EndTimestamp>
        <IntervalReading>250.000000</IntervalReading>
        <ResourceUseID IDref="ResourceUse-Electricity"/>
      </TimeSeries>
    </TimeSeriesData>
    


#### All TimeSeries Data
The following cell simply performs the following:
1. Create a simple function to generate monthly timeseries elements for each resource use
2. Add it to a `TimeSeriesData` parent element
3. Add this back to the previously defined current building measured scenario (i.e. Scenario-1)


```python
full_ts_data = bsync.TimeSeriesData()

# usage and peak data
monthly_elec = [
    52651.67,
    46018.33,
    52645.00,
    49929.17,
    58176.39,
    66276.94,
    52738.06,
    56057.78,
    60436.11,
    57091.67,
    51428.89,
    50311.11
]
monthly_ghg = [250.0, 240.0, 260.0, 250.0, 260.0, 230.0, 280.0, 270.0, 260.0, 250.0, 240.0, 250.0] #Check GHG in EP output TK
monthly_ng = [
    165.21,
    143.79,
    103.09,
    60.02,
    49.66,
    40.18,
    36.89,
    40.95,
    37.87,
    60.75,
    86.85,
    169.70
]
monthly_elec_peak = [
    167374.99,
    155851.46,
    165633.22,
    191066.24,
    219526.40,
    248431.13,
    181331.96,
    178148.53,
    227075.02,
    223758.04,
    194377.02,
    150135.32

]

# costs data
monthly_elec_cost = [
    1221.22,
    1125.76,
    1211.38,
    1342.05,
    1540.30,
    1740.37,
    1300.19,
    1297.57,
    1593.21,
    1559.12,
    1367.60,
    1113.37

]
monthly_ng_cost = [
    191.31,
    166.50,
    119.38,
    69.50,
    57.50,
    46.52,
    42.72,
    47.43,
    43.86,
    70.35,
    100.58,
    196.51
]

elec_ids = []
ghg_ids = []
ng_ids = []
def create_monthly(values, resource_use_id, start_year, tsrq='Energy', rt='Total'):
    """
    tsrq: One of Energy, Power, Cost, Greenhouse Gas Emissions
    rt: One of Total, Peak, Cost
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

        if tsrq == 'Other':
            my_id = f"TS-{resource_use_id}-{start_month}"
        else:
            my_id = f"TS-{resource_use_id}-{tsrq}-{start_month}"
        ts = bsync.TimeSeries(
            bsync.ReadingType(rt),
            bsync.TimeSeriesReadingQuantity(tsrq),
            bsync.StartTimestamp(start_dt),
            bsync.EndTimestamp(end_dt),
            bsync.IntervalFrequency("Month"),
            bsync.IntervalReading(float(val)),
            bsync.ResourceUseID(IDref=resource_use_id),
            ID=my_id
        )
        monthly.append(ts)
        
        if tsrq == 'Other':
            ghg_ids.append(my_id)
        if tsrq == 'Energy':
            if 'Electricity' in resource_use_id:
                elec_ids.append(my_id)
            else:
                ng_ids.append(my_id)
    return monthly
    
elec_ts = create_monthly(monthly_elec, elec_ru['ID'], 2021)
ghg_ts = create_monthly(monthly_ghg, ghg_ru['ID'], 2021, tsrq="Other")
ng_ts = create_monthly(monthly_ng, ng_ru['ID'], 2021)
elec_peak_ts = create_monthly(monthly_elec_peak, elec_ru['ID'], 2021, 'Power', 'Peak')

elec_cost_ts = create_monthly(monthly_elec_cost, elec_ru['ID'], 2021, 'Cost', 'Cost')
ng_cost_ts = create_monthly(monthly_ng_cost, ng_ru['ID'], 2021, 'Cost', 'Cost')
 
def add_to_full(months, full):
    for month in months:
        full += month

add_to_full(elec_ts, full_ts_data)
add_to_full(ghg_ts, full_ts_data)
add_to_full(ng_ts, full_ts_data)
add_to_full(elec_peak_ts, full_ts_data)
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
        bsync.AllResourceTotal.SiteEnergyUse(3236419.05), # reported in kBtu
        bsync.SiteEnergyUseIntensity(43.75), # reported in kbtu/ft2
        
        # Since there is no energy generated onsite, there is no difference btw site and building energy usage / intensity
        bsync.BuildingEnergyUse(3236419.05), 
        bsync.BuildingEnergyUseIntensity(43.75),
        
        bsync.ImportedEnergyConsistentUnits(3236.41905),  # in this case, same as building and site energy, but in MMBTU
        bsync.OnsiteEnergyProductionConsistentUnits(0.), # no energy produced onsite, MMBtu
        bsync.ExportedEnergyConsistentUnits(0.), # no energy exported, MMBtu
        bsync.NetIncreaseInStoredEnergyConsistentUnits(0.),  # no energy stored, MMBtu
        
        bsync.AllResourceTotal.SourceEnergyUse(8177253.314), # reported in kBtu. Assume site -> source: elec = 3.167, ng = 1.084
        bsync.SourceEnergyUseIntensity(110.56), # kbtu/ft2
        bsync.EnergyCost(17564.29),
        bsync.EnergyCostIndex(0.2375), # $/ft2
        ID="AllResourceTotal-1"
    )
)
cbms += art
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
measures = bsync.Measures()
f1 += measures

# A measure to upgrade the lighting system to LEDs
led_measure = bsync.Measure(
    bsync.TypeOfMeasure(
        bsync.Replacements(
            bsync.Replacement(
                bsync.ExistingSystemReplaced(IDref="LightingSystem-1")
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
                bsync.ExistingSystemAffected(IDref="PSZAC-Gym"),
                bsync.ExistingSystemAffected(IDref="PSZAC-Kitchen"),
                bsync.ExistingSystemAffected(IDref="PSZAC-Cafeteria"),
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
    ID="Measure-VSDs"
)
```

#### POM Scenarios
Now that the measures have been added, we create three potential POM scenarios, and add the necessary attributes per Standard 211 6.1.5 and 6.1.6
1. LEDs only
2. VSDs only
3. LEDs and VSDs


```python
pom_sc_1 = bsync.Scenario(
    bsync.Scenario.ScenarioType(
        bsync.PackageOfMeasures(
            bsync.ReferenceCase(IDref=cbms['ID']),
            bsync.MeasureIDs(
                bsync.MeasureID(IDref="Measure-LEDs")
            ),
            bsync.CostCategory("Capital"),
            bsync.SimpleImpactAnalysis(
                bsync.ImpactOnOccupantComfort("Low"),
                bsync.EstimatedCost("Medium"),
                bsync.EstimatedAnnualSavings("Medium"),
                bsync.EstimatedROI("High"),
                bsync.SimpleImpactAnalysis.Priority("Medium")
            ),
            ID="POM-LEDs"
        )
    ),
    ID="Scenario-POM-LEDs"
)

pom_sc_2 = bsync.Scenario(
    bsync.Scenario.ScenarioType(
        bsync.PackageOfMeasures(
            bsync.ReferenceCase(IDref=cbms['ID']),
            bsync.MeasureIDs(
                bsync.MeasureID(IDref="Measure-VSDs")
            ),
            bsync.CostCategory("Capital"),
            bsync.SimpleImpactAnalysis(
                bsync.ImpactOnOccupantComfort("Low"),
                bsync.EstimatedCost("Medium"),
                bsync.EstimatedAnnualSavings("Medium"),
                bsync.EstimatedROI("High"),
                bsync.SimpleImpactAnalysis.Priority("Medium")
            ),
            ID="POM-VSDs"
        )
    ),
    ID="Scenario-POM-VSDs"
)

pom_sc_3 = bsync.Scenario(
    bsync.Scenario.ScenarioType(
        bsync.PackageOfMeasures(
            bsync.ReferenceCase(IDref=cbms['ID']),
            bsync.MeasureIDs(
                bsync.MeasureID(IDref="Measure-LEDs"),
                bsync.MeasureID(IDref="Measure-VSDs")
            ),
            bsync.CostCategory("Capital"),
            bsync.SimpleImpactAnalysis(
                bsync.ImpactOnOccupantComfort("Low"),
                bsync.EstimatedCost("Medium"),
                bsync.EstimatedAnnualSavings("Medium"),
                bsync.EstimatedROI("High"),
                bsync.SimpleImpactAnalysis.Priority("Medium")
            ),
            ID="POM-LEDs-VSDs"
        )
    ),
    ID="Scenario-POM-LEDs-VSDs"
)

pom_sc_4 = bsync.Scenario(
    bsync.Scenario.ScenarioType(
        bsync.PackageOfMeasures(
            bsync.ReferenceCase(IDref=cbms['ID']),
            bsync.MeasureIDs(
                bsync.MeasureID(IDref="Measure-LEDs"),
                bsync.MeasureID(IDref="Measure-VSDs")
            ),
            bsync.CostCategory("Capital"),
            bsync.SimpleImpactAnalysis(
                bsync.ImpactOnOccupantComfort("Low"),
                bsync.EstimatedCost("Medium"),
                bsync.EstimatedAnnualSavings("Medium"),
                bsync.EstimatedROI("High"),
                bsync.SimpleImpactAnalysis.Priority("Medium")
            ),
            ID="POM-LEDs-VSDs"
        )
    ),
    ID="Scenario-POM-LEDs-VSDs"
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
bsync_dump(root, file='PrimarySchool-Level1.xml')
```




    True



You should see a green check mark for the L100 AUDIT use case!

![Valid](./img/valid.png)
