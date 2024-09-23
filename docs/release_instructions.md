# Releasing

Follow the steps below when releasing a new version

### Prepare for release

* Checkout develop and pull the most recent changes

* Update the Version in the header of the XSD in three places:
    * Update version the `/xs:schema@version`.
    * Update version in the "schema title", at `/xs:schema/xs:annotation/xs:documentation[1]`.
    * If creating an official release (i.e., you are NOT creating a pre-release), add the version as an enumeration to the `auc:BuildingSync` `version` attribute with the latest version. Though we historically added some pre-releases to `@version`, they should no longer be included.

* Update the CHANGELOG.md to include the latest changes, and the most recent version:
    * Obtain [Github API token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens) for the next step.
	* Run the change_log.rb script (e.g., ruby src/change_log.rb -t TOKEN_string -s 2019-12-21). The date range must span from the last official release (ie don't start at a pre-release) until the current date.
	* Copy the results of this into the CHANGELOG. Remove items that are not useful to an end user such as version bumps, formatting, etc.
    * Create a Pull Request (prep release) into `develop`:
        * Mark the PR with an `ignore` label to prevent the PR from being added to future change logs. 
        * Merge the PR.

* Create a Pull Request (release) into `main`:
    * Mark the PR with an `ignore` label to prevent the PR from being added to future change logs. 
    * Merge the PR.

### Tag and release

Check out main locally, pull changes, and create a tag and push it
```bash
git checkout main && git pull
git tag -a v<version> -m "<message>" [SHA]
```
Where `v<version>` is a valid [semantic version](https://semver.org/) (e.g., `v1.2.3` or `v1.2.3-pr.1`) and `<message>` is the tagging message (e.g. "First official release"). See [Versioning](versioning.md) for more information.
```bash
# push the tag
git push --tags origin 
```

This should trigger a GitHub workflow for building and publishing the release. If publishing a pre-release, you are done. Otherwise, once the release has been successfully published on GitHub, continue.

### Update BuildingSync Website

At this point the GitHub action for publishing the release should be finished. Now we need to update the docs/data in [this repo](https://github.com/BuildingSync/BuildingSync-website). Read the README in that repository.



