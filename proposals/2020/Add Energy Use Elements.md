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

Standard 211 sections 5.2.3 and 5.2.3.1 require Building energy use and use intensity (ie it's non-optional in this proposal). Adding the other energy elements could provide an easier way to validate calculations, a more direct mapping to the 211 spreadsheet, and a more understandable breakdown of how 211 models EUI for users.

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
