# Releasing

Follow the steps below when releasing a new version

* Update the Version in the header of the XSD with the release date
(e.g. Version 0.2 (November 5, 2017))

* (Optional) Convert XSD to JSON schema. This is still in prototype. Use XMLSpy to Generate JSON Schema (use default options).

* Ensure that the XSD and JSON Schema have spaces, and not tabs.
   
    * You can run the following command to convert tabs to spaces (make sure to create backups of the files before running).

        ```bash
        rake remove_tabs
        ```

* Update the CHANGELOG to include the latest changes, and the most recent version.

	* Run the change_log.rb script (e.g. ruby src/change_log.rb -t abcdefghijklmnopqrstuvwxyz -s <last-release-data>).
	* Copy the results of this into the CHANGELOG. Remove items that are not useful to an end user such as version bumps, formatting, etc.

* After merging down the release into the main branch, draft a release in GitHub. Upload the XSD and JSON file as part of the release.

* Use xs3p to generate the documentation. .

	* Download [V1.1.5](https://sourceforge.net/projects/xs3p/) and unzip.
	* Run `xsltproc xs3p.xsl <path-to-BuildingSync.xsd> > index.html` to generate the new html documentation. Note that xsltproc may need to be installed on your machine to run.

* Edit the BuildingSync Website GitHub repo on a new branch (https://github.com/BuildingSync/website):

	* Add generated documentation under /documents/schema/documentation/<new_version>
	* Update /documents/schema/index.md to include new release, follow existing pattern.

* Create a Pull Request from the new branch to gh-pages.

