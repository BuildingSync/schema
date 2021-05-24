# Deprecate InstalledFlowRate under FanSystem

## Overview

This proposal is to deprecate `InstalledFlowRate` under `FanSystem` element.

## Justification

`FanInstalledFlowRate` should be used to match flow rate element for `PumpSystem` (`PumpInstalledFlowRate`). `FanInstallFlowRate` was added in PR [#263](https://github.com/BuildingSync/schema/pull/263) as a choice element in parallel with `InstalledFlowRate` to avoid breaking change. Now we propose to deprecate `InstalledFlowRate` in version 3.0.

## References
