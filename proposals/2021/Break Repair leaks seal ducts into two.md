# Break Repair leaks / seal ducts into two

## Overview

This proposal is to break the `Repair leaks / seal ducts` element into two options: `Repair leaks in ducts` and `Seal ducts`.  

## Justification

To avoid ambiguity when using `/` to connect two options.

## Implementation

Change
```xml
<xs:enumeration value="Repair leaks / seal ducts"/>
```
to
```xml
<xs:enumeration value="Repair leaks in ducts"/>
<xs:enumeration value="Seal ducts"/>
```

## References