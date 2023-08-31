These scripts each take in a BuildingSync file and upgrade it from one schema to another. ex:

```
python migration_scripts/upgrade_from_2.4_to_2.5.py path/to/file
```
or, if you want to write to a new file:
```
python migration_scripts/upgrade_from_2.4_to_2.5.py path/to/file --to_file ./new_file.xml
```