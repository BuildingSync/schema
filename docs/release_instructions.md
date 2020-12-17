# Releasing

Follow the steps below when releasing a new version

* Update the Version in the header of the XSD in three places:
    * Update in the <xs:schema ...> element.
    * Update in the first <xs:annotation> element.
    * Add enumeration to /version with the latest version 

* Convert XSD to JSON schema. This is still in prototype. This functionality will be moved to Oxygen XML soon.
    * Use XMLSpy to Generate JSON Schema (Convert->Convert XML Schema to/from JSON Schema...)
    * Use the default options

* Ensure that the XSD and JSON Schema have spaces, and not tabs.

    * You can run the following command to convert tabs to spaces (make sure to create backups of the files before running).

        ```bash
        rake remove_tabs
        ```

* Update the CHANGELOG.md to include the latest changes, and the most recent version.

	* Run the change_log.rb script (e.g. ruby src/change_log.rb -t abcdefghijklmnopqrstuvwxyz -s 2019-12-21).
	* Copy the results of this into the CHANGELOG. Remove items that are not useful to an end user such as version bumps, formatting, etc.

* Create a Pull Request into `master`
    * Mark the PR with an `ignore` label to prevent the PR from being added to future change logs. 
    * After merging the Pull Request, draft a release in GitHub. 
    * *Upload the XSD and JSON file as part of the release.*
    
* Use Oxygen XML to generate the documentation. The documentation will actually be saved in [this repo](https://github.com/BuildingSync/website]).
    * Tools -> Generate Documentation -> XML Schema Documentation
    * Choose *Format HTML*
    * Check *split output into multiple* and *Split by location*    
    * Set directory and name to be the website's folder `schema/vX.Y.Z/documentation/index.html`. The name needs to be `index.html`.
    * Select *Generate*
    
* Edit the BuildingSync Website GitHub repo on a new branch (https://github.com/BuildingSync/website):

	* Run the schema's rake task for generating the data dictionary (`bundle exec rake generate_data_dictionary`). This will create the list of enumerations in both JSON and XSLX format. In the BuildingSync/website repository:
	    * Copy this repository's `docs/enumerations.json` file into a new `_data/vXXX` folder in the website folder. Note that the folder cannot contain a dot.
	    * Copy the `DataDictionary.xlsx` into the `schema/vXXX/datadictionary` folder.
        * Update the `datadictionary/index.html` and `measures/index.html` to point to the new `enumerations.json` file.
        * Update `/schema/index.md` to include new release by following the existing pattern.

* Create a Pull Request from the new branch to gh-pages.
