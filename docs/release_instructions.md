# Releasing

When releasing new versions, make sure to do the following:

* Update the Version in the header of the XSD with the release date
(e.g. Version 0.2 (November 5, 2017))
* (Optional) Convert XSD to JSON schema. This is still in prototype. 
* Update the Changelog to include the latest changes, and the most 
recent version. Easiest to run the change_log.rb script (e.g. ruby src/change_log.rb -t abcdefghijklmnopqrstuvwxyz -s <last-release-data>).
* After merging down the release into the main branch, draft a release in Github. Upload the XSD and JSON file as part of the release.
* Copy the schema to the website-schemas repo with documentation. Note that this is not what we really want to do anymore. (website-schema repo here: https://github.com/BuildingSync/website-schemas)
* Add links ot the index.md in the root of website-schemas repo
* In the website repo update the docs/schema/index.md to include the 
new release.
