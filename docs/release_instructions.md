# Releasing

Follow the steps below when releasing a new version

* Update the Version in the header of the XSD in two places:
    * Update in the <xs:schema ...> element.
    * Update in the first <xs:annotation> element. 

* Convert XSD to JSON schema. This is still in prototype. 
    * Use XMLSpy to Generate JSON Schema (Convert->Convert XML Schema to/from JSON Schema...)
    * Use the default options

* Ensure that the XSD and JSON Schema have spaces, and not tabs.

    * You can run the following command to convert tabs to spaces (make sure to create backups of the files before running).

        ```bash
        rake remove_tabs
        ```

* Update the CHANGELOG.md to include the latest changes, and the most recent version.

	* Run the change_log.rb script (e.g. ruby src/change_log.rb -t abcdefghijklmnopqrstuvwxyz -s 2019-11-15).
	* Copy the results of this into the CHANGELOG. Remove items that are not useful to an end user such as version bumps, formatting, etc.

* After merging down the release into the main branch, draft a release in GitHub. *Upload the XSD and JSON file as part of the release.*

* Use XMLSpy to generate documentation.

    * Schema Design -> Generate Documentation
    * Set to HTML
    * Check all the includes and details
    * Make sure to output to a single file (uncheck "Split output in multiple files")
    * Embed CSS into HTML
    * Export as `index.html` in the website's `schema/vX.Y/documentation` folder.

* Edit the BuildingSync Website GitHub repo on a new branch (https://github.com/BuildingSync/website):

	* Run the schema's rake task for generating the data dictionary (`bundle exec rake generate_data_dictionary`). This will create the list of enumerations in both JSON and XSLX format. In the BuildingSync/website repository:
	    * Copy this repository's `docs/enumerations.json` file into a new `_data/vXXX` folder in the website folder. Note that the folder cannot contain a dot.
	    * Copy the `DataDictionary.xlsx` into the `schema/vXXX/datadictionary` folder.
        * Update the `datadictionary/index.html` and `measures/index.html` to point to the new `enumerations.json` file.
        * Update `/schema/index.md` to include new release by following the existing pattern.

* Create a Pull Request from the new branch to gh-pages.
