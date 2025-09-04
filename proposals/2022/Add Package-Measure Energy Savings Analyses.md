# Add Package-Measure Energy Savings Analyses

## Overview

Currently, BuildingSync XML schema supports the exchange of (standalone) package- and measure-level energy savings analysis data, but it does not support the exchange of (contextual) package-measure-level energy savings analysis data.

This proposal is to add elements to the schema to support the exchange of package-measure-level energy savings analysis data.

## Justification

The term "package-level" refers to data that are intrinsic to the package of measures.
For a given `<auc:PackageOfMeasures>` element, package-level energy savings analysis data are exchanged using the `<auc:AnalysisSavingsByFuel>` child element.

The interpretation of package-level energy savings analysis data is that said data applies to the package of measures as a whole (i.e., the net savings for all measures of said package).

The term "measure-level" refers to data that are intrinsic to the measure.
For a given `<auc:Measure>` element, measure-level energy savings analysis data are exchanged using the `<auc:MeasureSavingsAnalysis>` child element, which includes a `<auc:AnalysisSavingsByFuel>` child element.

The interpretation of measure-level energy savings analysis data is that said data applies to the measure as a whole (i.e., not in the context of any specific package of measures).

### Example

Suppose that we have 2 arbitrary measures, #1 and #2.
Implementation of the first measure (as a whole) would cost $100 and would provide electricity savings only.
Implementation of the second measure (as a whole) would cost $200 and would provide natural gas savings only.

| Measure ID | Cost ($) | Electricity Savings (kWh/yr) | Natural Gas Savings (therms/yr) |
| ---------- | -------- | ---------------------------- | ------------------------------- |
| #1         | 100      | 50                           | 0                               |
| #2         | 200      | 0                            | 100                             |
| **Total:** | 300      | 50                           | 100                             |

Suppose that we have 1 arbitrary package, #1, that includes measures #1 and #2.
When purchased together, the vendor offers a $25 discount on measure #1.
Moreover, when implemented with measure #2, measure #1 also provides an additional electricity saving of 25 kWh per year.

Hence, at the package-level, we have the following data:

| Package ID | Measure IDs | Cost ($) | Electricity Savings (kWh/yr) | Natural Gas Savings (therms/yr) |
| ---------- | ----------- | -------- | ---------------------------- | ------------------------------- |
| #1         | #1, #2      | 275      | 75                           | 100                             |

The above table conveys both the discount and the additional electricity savings, but it does not attribute the discount or the additional electricity savings to a specific measure (or measures).

The data are different when the measure is considered standalone or in the context of a specific package, and hence, at the package-measure-level, we have the following data:

| Measure ID | Package ID | Cost ($)                                                    | Electricity Savings (kWh/yr)                               | Natural Gas Savings (therms/yr) |
| ---------- | ---------- | ----------------------------------------------------------- | ---------------------------------------------------------- | ------------------------------- |
| #1         | #1         | <span style="color:red;background-color:yellow;">75</span>  | <span style="color:red;background-color:yellow;">75</span> | 0                               |
| #2         | #1         | 200                                                         | 0                                                          | 100                             |
|            | **Total:** | <span style="color:red;background-color:yellow;">275</span> | <span style="color:red;background-color:yellow;">75</span> | 100                             |

## Implementation

BuildingSync XML schema supports the many-to-many association of packages and measures using the `<auc:MeasureID>` element.

This proposal is to promote the `<auc:MeasureSavingsAnalysis>` element to the top-level (instead of its definition being inlined) and then to add the `<auc:MeasureSavingsAnalysis>` element as a child element of the `<auc:MeasureID>` element.

```xml
<xs:element name="MeasureIDs" minOccurs="0">
  <xs:annotation>
    <xs:documentation>ID numbers for measures included in the package. Multiple items may be selected.</xs:documentation>
  </xs:annotation>
  <xs:complexType>
    <xs:sequence>
      <xs:element name="MeasureID" maxOccurs="unbounded">
        <xs:annotation>
          <xs:documentation>ID number of measure.</xs:documentation>
        </xs:annotation>
        <xs:complexType>
          <xs:attribute name="IDref" type="xs:IDREF" use="required"/>
          <xs:sequence>
            <xs:element ref="auc:MeasureSavingsAnalysis" minOccurs="0"/>
            <!-- Question for reviewers: other elements? -->
          </xs:sequence>
        </xs:complexType>
      </xs:element>
    </xs:sequence>
  </xs:complexType>
</xs:element>
```

**Question for reviewers:**
Are there other elements that would make sense to assert on the relationship (e.g., `<auc:MVCost>`, `<auc:MVOption>`, `<auc:UsefulLife>`, etc.)?
