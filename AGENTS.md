# BuildingSync Schema - AI Agent Instructions

This is the canonical instruction file for AI coding agents (Copilot, Claude Code, Codex, Cursor, etc.). `.claude/CLAUDE.md` and `.github/copilot-instructions.md` point here.

BuildingSync is an XML schema (`BuildingSync.xsd`, namespace prefix `auc`) for exchanging building energy audit and building characteristics data. Every change must keep historical documents and downstream tools (see [BuildingSync ecosystem](#buildingsync-ecosystem)) working unless a major version bump is intended.

## Repository layout

| Path                                          | Purpose                                                                                                |
| --------------------------------------------- | ------------------------------------------------------------------------------------------------------ |
| `BuildingSync.xsd`                            | The schema (single file). Imports gbXML v6.01 via URL.                                                 |
| `examples/*.xml`                              | Example instances. All must validate (except files named `*Invalid Schema*`).                          |
| `proposals/<YEAR>/*.md`                       | Feature proposals (see [proposals/README.md](proposals/README.md)).                                    |
| `docs/`                                       | Versioning, release, linking (ID/IDREF), gbXML, developer docs; Jupyter notebooks in `docs/notebooks`. |
| `migration_scripts/`                          | `upgrade_from_X_to_Y.py` scripts for breaking upgrades between adjacent versions.                      |
| `spec/validation_spec.rb`                     | RSpec checks run by `bundle exec rake`.                                                                |
| `src/data_dictionary.rb`, `src/change_log.rb` | Data dictionary and changelog generators.                                                              |
| `.github/instructions/`                       | File-scoped rules; read before editing matching files (see below).                                     |
| `tmp/`                                        | Git-ignored scratch space. Never commit it.                                                            |

## File-scoped rules (read before editing)

- `BuildingSync.xsd`: [.github/instructions/schema-xsd.instructions.md](.github/instructions/schema-xsd.instructions.md)
- `proposals/**/*.md`: [.github/instructions/proposals.instructions.md](.github/instructions/proposals.instructions.md)

## Commands

- Tests (CI): `bundle exec rake` then `bundle exec rake generate_data_dictionary` (the latter also detects name conflicts).
- `generate_data_dictionary` writes `docs/DataDictionary.xlsx` and `docs/enumerations.json`; these are release artifacts built by the publish workflow. Do not commit them; delete them after a local run.
- Format XSD/examples (removes tabs and XMLSpy comments, 2-space indent): `bundle exec rake remove_tabs`.
- Lint/format everything else: `poetry run pre-commit run --all-files` (prettier for Markdown/YAML/JSON, ruff for Python with line length 140, trailing whitespace, end-of-file newline, JSON pretty-format).
- Bulk documentation edits: `bundle exec rake generate_documentation_csv`, edit `updated_documentation` column, then `bundle exec rake update_documentation`.
- On Windows, `C:\Ruby32-x64\bin\ruby.exe -S bundle exec rake` is more reliable than bare `bundle`.

## Rules enforced by tests (`spec/validation_spec.rb`)

1. Every `examples/*.xml` (except `*Invalid Schema*`) validates against `BuildingSync.xsd`.
2. No tab characters in `BuildingSync.xsd` or `examples/*.xml`.
3. No `XMLSpy` text in `BuildingSync.xsd` or `examples/*.xml`.
4. No `xs:complexContent` anywhere in `BuildingSync.xsd`.
5. Global `xs:element`/`xs:complexType`/`xs:simpleType`/`xs:attribute` names must not collide with gbXML global names (only `Capacity Latitude Location Longitude Manufacturer State ZipCode` are permitted).
6. Named `xs:element` names must be unique across the whole schema, except the legacy `ignored_dupes` list. Never add to that list; reuse a shared type or `ref` instead.

## Versioning and change classification ([docs/versioning.md](docs/versioning.md))

Classify every schema change before making it and report the classification:

- **Breaking (MAJOR)**: any historical document could stop validating - adding a required element/attribute, moving/renaming an element (including order in a sequence or new parent), changing to an incompatible type (e.g. decimal to integer), narrowing a simple-type restriction (removing an enum, tighter bounds).
- **Non-breaking (MINOR)**: new optional element/attribute, compatible type widening (e.g. decimal to string), new enum value.
- **Patch**: documentation-only changes, or restructuring that does not change what validates (e.g. inline definition to named type or `ref`).

Deprecation policy (in the XSD header): **"Schema elements may only be removed by incrementing the major version of the schema document."** In a minor/patch release, deprecate instead of removing or renaming. Breaking changes need a migration script in `migration_scripts/` (see [upgrade_from_2.4_to_2.5.py](migration_scripts/upgrade_from_2.4_to_2.5.py)) that updates the root `version` and inserts a generated-from comment.

## Workflow for a schema change

1. Every change to `BuildingSync.xsd` other than a documentation-only edit needs a proposal in `proposals/<current year>/<Title Case Name>.md` containing at least **Overview**, **Justification**, **Implementation** (state the breaking/non-breaking/patch classification; breaking changes must discuss severity and migration); optional **References**. If you skip a proposal, say so explicitly and explain why.
2. Edit `BuildingSync.xsd` following [.github/instructions/schema-xsd.instructions.md](.github/instructions/schema-xsd.instructions.md).
3. Update or add `examples/*.xml` when the change affects them; keep examples free of deprecated elements where possible.
4. If a linking (`IDref`) element is added, update [docs/linking_elements.md](docs/linking_elements.md).
5. Run `bundle exec rake remove_tabs`, `bundle exec rake`, `bundle exec rake generate_data_dictionary`, and pre-commit.
6. Do **not** edit `CHANGELOG.md` or schema version numbers in feature PRs; the changelog is generated from PR labels at release time ([docs/release_instructions.md](docs/release_instructions.md)).

## Pull requests ([docs/developer_resources.md](docs/developer_resources.md), `.github/workflows/CI_Labels.yml`)

- One logical/discrete change per PR (e.g. removing an element is separate from adding an unrelated enum). A proposal and its implementation count as one change and may share a PR; separate PRs are not required.
- Use [.github/PULL_REQUEST_TEMPLATE.md](.github/PULL_REQUEST_TEMPLATE.md): background, what it does, how to test, relevant tickets, screenshots.
- Labels (CI-enforced on `develop-v2`/`develop-v3`): either exactly one of `Breaking Change` / `Non-breaking Change` **plus** a `Schema: ...` scope label (`Controls`, `Documentation`, `General`, `Measures`, `Reports`, `Systems`, `Validation`), or `No Schema Changes` alone, or `ignore` alone (release/procedural PRs).
- Contributions align with the release schedule: two releases per year (about end of May and November), cutoff about two weeks before ([.github/CONTRIBUTING.md](.github/CONTRIBUTING.md)).

## BuildingSync ecosystem

This repo is the source of truth; the tools below consume released versions of `BuildingSync.xsd` (all under <https://github.com/BuildingSync>). Versions noted were current in October 2026; verify on GitHub before relying on them.

| Repo                                                                                                                                                                                                                                                                                                 | Role                                                                                                                                         | Coupling to this schema                                                                                                                                                         |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [BuildingSync-website](https://github.com/BuildingSync/BuildingSync-website) (live at <https://buildingsync.net>)                                                                                                                                                                                    | Django app: schema viewer, validator (web + `POST /api/validate`), use case hosting, BEDES mapping                                           | Parses each released XSD and `enumerations.json` from the release; hosts example files per schema version; BEDES terms re-mapped per schema version.                            |
| [use-cases](https://github.com/BuildingSync/use-cases)                                                                                                                                                                                                                                               | Official/community Schematron use cases (`<Org>/schematron/<Name>-X.Y.Z.sch`) with examples (`<Org>/examples/<Name>-X.Y.Z-*.xml`)            | XPaths in `.sch` files reference element paths; `schemaVersion` = `<sch ver>-<min bsync ver>[-<max bsync ver>]`. Renames/moves break rules.                                     |
| [TestSuite](https://github.com/BuildingSync/TestSuite) (`pip install testsuite`)                                                                                                                                                                                                                     | Python library/CLI to generate and validate Schematron                                                                                       | Used by use-cases CI.                                                                                                                                                           |
| [BOSS](https://github.com/BuildingSync/BOSS)                                                                                                                                                                                                                                                         | BuildingSync OpenStudio Simulator: BuildingSync XML to OpenStudio workflow (OpenStudio 3.10, BuildingSync 2.7.0). Replaces BuildingSync-gem. | Reads specific XPaths (e.g. `OccupancyClassification`, `FloorAreas`, `PrincipalHVACSystemType`, `ClimateZoneType`, lighting `InstalledPower`, plug load `WeightedAverageLoad`). |
| [buildingsync-measures-gem](https://github.com/BuildingSync/buildingsync-measures-gem)                                                                                                                                                                                                               | OpenStudio measures used by BOSS (HVAC, envelope, schedules, infiltration)                                                                   | Measure arguments map from BuildingSync enumerations/values.                                                                                                                    |
| [BuildingSync-gem](https://github.com/BuildingSync/BuildingSync-gem)                                                                                                                                                                                                                                 | Legacy Ruby translator (OpenStudio 3.4); superseded by BOSS                                                                                  | Do not target for new work.                                                                                                                                                     |
| [BuildingSync-asset-extractor](https://github.com/BuildingSync/BuildingSync-asset-extractor)                                                                                                                                                                                                         | Python: extracts assets from BuildingSync for SEED; BuildingSync to CTS spreadsheet (BuildingSync 2.7.0)                                     | Asset definitions reference element paths and enumerations.                                                                                                                     |
| [bsyncpy](https://github.com/BuildingSync/bsyncpy)                                                                                                                                                                                                                                                   | Python classes generated from a released XSD (currently 2.5.0)                                                                               | Regenerated per schema release.                                                                                                                                                 |
| [bsyncr](https://github.com/BuildingSync/bsyncr), [bsyncr-server](https://github.com/BuildingSync/bsyncr-server)                                                                                                                                                                                     | R package/server serializing NMEC (nmecr) results to BuildingSync                                                                            | Writes `Scenarios`, `TimeSeries`, `DerivedModels`.                                                                                                                              |
| [transformations](https://github.com/BuildingSync/transformations), [std211-translator](https://github.com/BuildingSync/std211-translator), [gbXML_Schemas](https://github.com/BuildingSync/gbXML_Schemas), [assetscore-schematron-docs](https://github.com/BuildingSync/assetscore-schematron-docs) | Older one-off scripts and reference material                                                                                                 | Low activity; check before relying on them.                                                                                                                                     |

Archived repos (`website`, `website-schemas`, `website-legacy`, `measures`, `python-package`, `projectmonitor`) are out of scope.

When a schema change renames, moves, deprecates, or changes the meaning of an element or enumeration:

- Search the affected names in the repos above (at least use-cases, BOSS, buildingsync-measures-gem, BuildingSync-asset-extractor) and list impacted repos in the proposal's **Implementation** section.
- Suggest follow-up issues in those repos; do not edit or open issues/PRs in other repos without explicit approval.
- Do not assume another repo's internals from this file; fetch its README or source first.

## Agent behavior

- Read the relevant XSD region before editing; cite line numbers; never reformat unrelated parts of the 17k-line XSD.
- Prefer additive, non-breaking changes; flag anything breaking and ask before proceeding.
- Do not push, tag, release, or comment on GitHub issues/PRs without explicit approval.
- Do not add files to the repo root or create summary markdown files unless asked; use `tmp/` for scratch notes.
- Keep this file the single source of truth; update it (not the pointer files) when rules change.
