# BuildingSync®

![Build Status](https://github.com/BuildingSync/schema/actions/workflows/ci.yml/badge.svg?branch=develop)

BuildingSync is a building data exchange schema to better enable integration between software tools and building data 
workflows. The schema's original use case was focused on commercial building energy audits; however, several additional 
use cases have been realized including building energy modeling and more high-level generic building data exchange. 

BuildingSync helps streamline the data exchange process, improving the value of the data, minimizing duplication of 
effort for subsequent building data collection efforts (including audits), and facilitating the achievement of greater 
energy efficiency. This in done in part by standarizing on (a) reporting audits in an electronic format, 
(b) tracking proposed, implemented, and discarded energy conservation measures, and (c) storing building 
characteristics (at multiple levels) for audits, benchmarking, and building energy analysis.

## The BuildingSync Ecosystem

BuildingSync has several documents and tools avaliable to help users understand how to best leverage BuildingSync. The
list below are only a subset of the resources available. If new resources are discovered, then feel free to create
a new pull request with the additions. 

* Generic BuildingSync information is available on the [DOE website](https://www.energy.gov/eere/buildings/buildingsync) 
  and the [project website](https://buildingsync.net/).
* [BuildingSync Examples](examples) - These examples are kept up to date and show a wide range of implementations. Any 
  new update to BuildingSync is required to pass validation on these example files.
* [BuildingSync Use Case Validator](https://buildingsync.net/validation) allows for users to determine 
  if their instance complies with a specific use case for BuildingSync by checking if the required elements are 
  implemented in an uploaded instance. An API is also provided for automated integration into
  other tools. Also, the website contains an easy way to view the entirety of the schema and how elements relate to
  the [Building Exchange Data Exchange Specification](https://bedes.lbl.gov/). The Validator is open sourced 
  [here](https://github.com/BuildingSync/selection-tool)
* [Use Case TestSuite](https://pypi.org/project/testsuite/) provides a Python package for easier generation of BuildingSync use cases. BuildingSync use cases depend on the generation of schematron documents, which is time-consuming and difficult to implement well. The TestSuite allows users to define a use case using a more palatable CSV template, which it then turns into a Schematron document. The source code is available [here](https://github.com/BuildingSync/TestSuite).
* [BuildingSync to OpenStudio/EnergyPlus](https://rubygems.org/gems/buildingsync). The translator is open sourced 
  [here](https://github.com/BuildingSync/BuildingSync-gem). This project will translate a Level 1 (and partial Level 2) 
  ASHRAE Energy Audit to a fully defined OpenStudio and EnergyPlus model. This project is in early Beta testing and 
  any feedback is welcome!

## Contribution

New contributions to BuildingSync are welcome. Please follow the proposal process outlined [here](proposals).

