# BuildingSync Schema - AI Agent Instructions

This is the canonical instruction file for AI coding agents (Copilot, Claude Code, Codex, Cursor, etc.). `.claude/CLAUDE.md` and `.github/copilot-instructions.md` point here.

BuildingSync is an XML schema (`BuildingSync.xsd`, namespace prefix `auc`) for exchanging building energy audit and building characteristics data. Every change must keep historical documents and downstream tools (Audit Template, Use Case Validator, BuildingSync-gem, bsyncpy, website schema viewer) working unless a major version bump is intended.

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

1. Non-trivial features start with a proposal in `proposals/<current year>/<Title Case Name>.md` containing at least **Overview**, **Justification**, **Implementation** (breaking changes must discuss severity); optional **References**.
2. Edit `BuildingSync.xsd` following [.github/instructions/schema-xsd.instructions.md](.github/instructions/schema-xsd.instructions.md).
3. Update or add `examples/*.xml` when the change affects them; keep examples free of deprecated elements where possible.
4. If a linking (`IDref`) element is added, update [docs/linking_elements.md](docs/linking_elements.md).
5. Run `bundle exec rake remove_tabs`, `bundle exec rake`, `bundle exec rake generate_data_dictionary`, and pre-commit.
6. Do **not** edit `CHANGELOG.md` or schema version numbers in feature PRs; the changelog is generated from PR labels at release time ([docs/release_instructions.md](docs/release_instructions.md)).

## Pull requests ([docs/developer_resources.md](docs/developer_resources.md), `.github/workflows/CI_Labels.yml`)

- One logical/discrete change per PR (e.g. removing an element is separate from adding an unrelated enum).
- Use [.github/PULL_REQUEST_TEMPLATE.md](.github/PULL_REQUEST_TEMPLATE.md): background, what it does, how to test, relevant tickets, screenshots.
- Labels (CI-enforced on `develop-v2`/`develop-v3`): either exactly one of `Breaking Change` / `Non-breaking Change` **plus** a `Schema: ...` scope label (`Controls`, `Documentation`, `General`, `Measures`, `Reports`, `Systems`, `Validation`), or `No Schema Changes` alone, or `ignore` alone (release/procedural PRs).
- Contributions align with the release schedule: two releases per year (about end of May and November), cutoff about two weeks before ([.github/CONTRIBUTING.md](.github/CONTRIBUTING.md)).

## Agent behavior

- Read the relevant XSD region before editing; cite line numbers; never reformat unrelated parts of the 17k-line XSD.
- Prefer additive, non-breaking changes; flag anything breaking and ask before proceeding.
- Do not push, tag, release, or comment on GitHub issues/PRs without explicit approval.
- Do not add files to the repo root or create summary markdown files unless asked; use `tmp/` for scratch notes.
- Keep this file the single source of truth; update it (not the pointer files) when rules change.
