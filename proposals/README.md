# BuildingSync Feature Proposals #

## Overview ##
This document lays out the procedure for the proposal and completion of changes to BuildingSync. The procedure is described in further detail below. The proposal process is initiated with the creation of a document similar to this one. The document is expected to have at least three sections: **Overview**, **Justification**, and **Implementation**. The overview section provides a high-level description of the proposal, the justification section provides evidence that the changes are needed or required, and the implementation section describes how the changes will be implemented. 

## Justification ##
BuildingSync is intended to be a standardized language for commercial building energy audit data that software developers can use to exchange data between audit tools. BuildingSync will only continue to provide a standard data specification for audit-related information if there is an open, transparent process by which stakeholders can propose changes, in particular additions, to the schema.

## Implementation ##
The process is semi-formal and is not intended to be rigidly applied. The procedure is roughly comprised of the following steps:

  1. The proposer writes a Markdown document, modeled on this document, that succinctly describes the changes that are proposed.
  2. The proposer creates a GitHub pull request that adds the document to the proposal directory in a subdirectory named for the year in which the submission is being made (e.g. proposals/2018/Add_New_Feature_XYZ.md).
  3. The proposer, the BuildingSync team, and other stakeholders and interested parties discuss the proposal and make modifications using the GitHub pull request discussion facility. At the conclusion of this process, the proposal is accepted or rejected.
  4. If the proposal is accepted, new GitHub issues are created to track the development (or a GitHub Project if it is a larger proposal), and a developer is assigned to the issues (not necessarily the proposer or a BuildingSync team member). The "proposal" pull request is then merged.
  5. The change is made by the developer in accordance with the contribution policy.
  6. The developer initiates a GitHub pull request when the changes are complete. The BuildingSync team and other stakeholders and interested parties will review the implementation and request necessary changes. If consensus can be reached that the implementation is acceptable, the pull request is merged and tracking items are closed.

The proposal document must contain at least three sections: **Overview**, **Justification**, and **Implementation**. The purpose of each of the sections is as follows:

  * Overview: Provides a brief, high-level summary of the proposed changes.
  * Justification: Provides supporting evidence for the changes. The evidence given here must be sufficient to establish that the changes are needed and will provide a benefit to users and/or developers.
  * Implementation: Describes the implementation of the changes. If the changes are breaking, discussion of the severity of the breakage is required.

If needed, additional sections (e.g. **References**) may be added.

## References ##
N/A
