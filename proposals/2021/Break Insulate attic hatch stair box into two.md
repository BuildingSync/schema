# Break `Insulate attic hatch / stair box` into two options

## Overview

This proposal is to break the `Insulate attic hatch / stair box` element into two options: `Insulate attic hatch` and `Insulate attic stair box`.  

## Justification

To avoid ambiguity when using `/` to connect two options.

## Implementation

Change
```xml
<xs:enumeration value="Insulate attic hatch / stair box"/>
```
to
```xml
<xs:enumeration value="Insulate attic hatch"/>
<xs:enumeration value="Insulate attic stair box"/>
```

## References