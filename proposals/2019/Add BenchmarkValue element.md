# Add BenchmarkValue element

## Overview

This proposal is to add the `auc:BenchmarkValue` child element to the `auc:Benchmark` element.

## Justification

The `auc:Assessment` element (a child element of the `auc:Building` element) provides a mechanism to assert programs that issue energy labels, ratings, scores, certifications, etc., at the building level; however, there is no corresponding mechanism at the scenario level.

The `auc:Benchmark` element (a child element of the `auc:ScenarioType` element) is available; however, there is nowhere within the schema to assert the calculated score or rating.

## Implementation

1. Add `auc:BenchmarkValue` child element to `auc:Benchmark` element.

## References

N/A
