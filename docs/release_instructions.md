# Releasing

Follow the steps below when releasing a new version

### Prepare for release

* Checkout develop and pull the most recent changes

* Update the Version in the header of the XSD in three places:
    * Update in the <xs:schema ...> element.
    * Update in the first <xs:annotation> element.
    * Add enumeration to /version with the latest version 

* Update the CHANGELOG.md to include the latest changes, and the most recent version.

	* Run the change_log.rb script (e.g. ruby src/change_log.rb -t abcdefghijklmnopqrstuvwxyz -s 2019-12-21).
	* Copy the results of this into the CHANGELOG. Remove items that are not useful to an end user such as version bumps, formatting, etc.

* Create a Pull Request into `master`
    * Mark the PR with an `ignore` label to prevent the PR from being added to future change logs. 
    * Merge the PR

### Tag and release

Check out master locally, pull changes, and create a tag and push it
```bash
git checkout master && git pull
git tag -a v<version> -m "<message>" [SHA]
```
Where `v<version>` is a valid [semantic version](https://semver.org/) (e.g. `v1.2` or `v1.2-pr.1`) and `<message>` is the tagging message (e.g. "First official release")
```bash
# push the tag
git push origin 
```

This should trigger a GitHub workflow for building and publishing the release. Once the release has been successfully published on GitHub, continue.

### Update BuildingSync Website

At this point the GitHub action for publishing the release should be finished. Now we need to update the docs/data in [this repo](https://github.com/BuildingSync/website]). Check out the repo and make a new branch.

* Copy `index.html` from the release into `schema/vX.Y.Z/documentation/index.html`.
* Copy `enumerations.json` from the release into file into a new `_data/vXXX` folder in the website folder. Note that the folder cannot contain a dot.
* Copy the `DataDictionary.xlsx` from the release into the `schema/vXXX/datadictionary` folder.
* Update the `datadictionary/index.html` and `measures/index.html` to point to the new `enumerations.json` file.
* Update `/schema/index.md` to include new release by following the existing pattern.

Create a Pull Request from the new branch to gh-pages.
