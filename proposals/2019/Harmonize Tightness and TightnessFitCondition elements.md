# Harmonize Tightness and TightnessFitCondition elements

## Overview

The enumerations for the `auc:Tightness` and `auc:TightnessFitCondition` elements are very similar (one uses the term "Leaky"; whereas, the other uses the term "Loose").

The `auc:Tightness` element is strictly more expressive, since it includes "Very Tight" and "Very Leaky" enumerations.

## Justification

Adding the enumerations "Very Tight" and "Very Loose" to the `auc:TightnessFitCondition` element introduces unnecessary redundancy.

## Implementation

This proposal is to:

- Reify the `auc:Tightness` enumeration into a new `xs:simpleType`.
- Modify the definitions of the `auc:Tightness` and `auc:TightnessFitCondition` elements to reuse the new `auc:Tightness` enumeration.

This is a breaking change.
Occurrences of "Loose" in the `auc:TightnessFitCondition` element must be replaced with "Leaky".

## References

n/a
