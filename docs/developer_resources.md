# Developer Resources

## Deprecation Policy

Details of the deprecation policy are included in the BuildingSync XML schema file.

## Pull Requests

### Summary

BuildingSync uses Pull Requests (PRs) to track and report changes to users when creating releases. Specifically, we document changes to the schema/repo by using labels on PRs, thus we require developers to add labels to all PRs. Our CI will validate labels.

### Requirements

- PRs are our "source of truth" for important changes to the repo/schema
- We encourage separate PRs for each "logical"/"discrete" change to the schema (especially if the changes are impactful/non-trivial to users). For example, removing an element from the schema should be separate from adding a choice to an unrelated element.
- The labels for the PR indicate the implications of the changes. Our CI system will validate your labels. See [CI Labels](../.github/workflows/CI_Labels.yml) for more info.
