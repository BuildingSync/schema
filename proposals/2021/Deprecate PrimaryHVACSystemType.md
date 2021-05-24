# Deprecate PrimaryHVACSystemType

## Overview

This proposal is to deprecate the `PrimaryHVACSystemType` element.

## Justification

In Standard 211, the term "Principal HVAC" is used rather than "Primary HVAC", see section 5.3.4. `PrincipalHVACSystemType` was added as a choice in PR [#215](https://github.com/BuildingSync/schema/pull/215) in parallel with `PrimaryHVACSystemType` to avoid breaking change. In version 3.0, we propose to deprecate the `PrimaryHVACSystemType` element and keep only `PrincipalHVACSystemType`.

## References

Standard 211 5.3.4
