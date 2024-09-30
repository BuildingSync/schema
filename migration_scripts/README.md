These scripts each take in a BuildingSync file and upgrade it from one schema to another. ex:

```
python migration_scripts/upgrade_from_2.4_to_2.5.py path/to/file
```
or, if you want to write to a new file:
```
python migration_scripts/upgrade_from_2.4_to_2.5.py path/to/file --to_file ./new_file.xml
```

The migration script will only be created for two adjacent versions that might lead to validation failures when updating the older BuildingSync XML to newer version (except for required version referencing update). 