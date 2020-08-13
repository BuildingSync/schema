# Add Energy Use Elements

## Overview

This proposal is to add the following children to `auc:AllResourceTotal`
- `auc:BuildingEnergyUse`
- `auc:BuildingEnergyUseIntensity`
- `auc:ImportedEnergyConsistentUnits`
- `auc:OnsiteEnergyProductionConsistentUnits`
- `auc:ExportedEnergyConsistentUnits`
- `auc:NetIncreaseInStoredEnergyConsistentUnits`

## Justification

Standard 211 refers to ASHRAE 105 for defining specific terms related to energy use. Within ASHRAE 105, there is a clear distinction between Building Energy and Site Energy, as depicted by ASHRAE 105 Figure 5.6. Additionally defined in ASHRAE 105 are the following intermediate calculation concepts:

- Imported Energy
- Exported Energy
- On-Site Renewable Energy Production
- Net Increase in Stored Imported Energy

Currently, the auc:AllResourceTotal complex type includes:

- auc:SiteEnergyUse
- auc:SiteEnergyUseIntensity

We want to shore up this representation by distinctly aligning BuildingSync elements with ASHRAE 105, with the intention of making the distinction between Building and Site energy more clear, as well as having a referenceable standard by which users can refer for making energy calculations for their site or building. This would better align calculations to the 211 spreadsheet as well.

## Implementation

The structure for each element would be the same
```xml
      <xs:element name="<name here>" minOccurs="0">
        <xs:complexType>
          <xs:simpleContent>
            <xs:extension base="xs:decimal">
              <xs:attribute ref="auc:Source"/>
            </xs:extension>
          </xs:simpleContent>
        </xs:complexType>
```

## References

Standard 211 sections 5.2.3 and 5.2.3.1
