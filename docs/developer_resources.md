# Developer Resources

## Git Naming Conventions

Commit messages should follow the format of


```bash
<type>[optional scope]: <description>

[optional body]
```

`type` must be one of the following:

- **docs**: Changes to the documentation (e.g. improving the annotation of an element, updating this file, etc)
- **feat**: Adds a new feature (e.g. adding a new element to the schema)
- **fix**: A bug fix (e.g. adding a missing closing tag, or moving a misplaced element)
- **proposal**: Adding or editing a proposal (e.g. creating a proposal for a new modeling concept for the schema)
- **refactor**: Changes that don't fix a bug or add a new feature (e.g. turning an element into a complexType for reuse)
- **style**: Changes that don't affect the meaning of code (e.g. whitespace)
- **test**: Adding or correcting tests

`scope` is optional, and should indicate the general area of the application affected.

`description` is a short description of the changes in imperative present tense (such as “add function to _”, not “added function”)

Branches should be named as `<type>/<scope>`, where `scope` is the general scope affected, or if creating a feature branch, a shortened name of the feature being added. If `scope` is more than one word, it should be separated by dashes.

Commit examples:

- `feat(schema): add MyElement to ParentElement`
- `proposal: add proposal for MyElement`
- `refactor: make SimpleElement restriction a regex test`

Branch examples:

- `feat/typical-operating-hours`
- `refactor/terminal-unit-type`
