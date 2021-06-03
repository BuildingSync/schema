# Translation
To assist with "updating" users BuildingSync documents, this directory provides XSLTs for translating one version into another.
Note that the translation is not guaranteed to be perfect as there might not always be a one to one mapping.
We will list any known limitations of the translators in the [limitations](#limitations) section below

## Usage
If using Linux or a Mac, make sure xsltproc is installed by running
```bash
xsltproc
```
Then transform your file(s) with
```bash
xsltproc [-o <output>] <stylesheet> <file> [<file> ...]
```
Where `-o <output>` can optionally be included to save the result, `<stylesheet>` is the path to the desired `.xsl` file, and `<file>` is the path to the file you'd like to transform.

If on Windows, run the simple python script `xsltproc.py` with desired inputs, or either find another XSLT processor or use an online processor.

## Limitations
### v2 to v3
There are no known limitations.
