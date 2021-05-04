# Delete Install or upgrade master venting

## Overview

This proposal is to address the issue of the redundant `Install or upgrade master venting` measure option under `ChilledWaterHotWaterAndSteamDistributionSystems` and `Install or Upgrade Master Venting` measure option under `OtherHVAC`.

## Justification

`Install or upgrade master venting` measure repeats in `ChilledWaterHotWaterAndSteamDistributionSystems` and `OtherHVAC`, and we should keep only one of them. This proposal suggests that we remove it under `OtherHVAC` and keep it under `ChilledWaterHotWaterAndSteamDistributionSystems`, as venting approach is generally implemented for boiler systems.

## Decision

We will delete `Install or Upgrade Master Venting` measure option under `OtherHVAC`.

## References
ASHRAE Standard 100-2018:
D3.3 Boiler Systems - D3.3.3 Venting
D3.3 Boiler Systems - D3.3.4 Steam and Condensate Return Loop - D3.3.4.3 Maintain pressure relief and venting.
