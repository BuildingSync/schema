import os
import glob
import lxml.etree as ET

### Inputs
# Path to the xsl file
xsl_path = "v2_to_v3.xsl"
# Path to the working folder
example_path = '..\examples'

### Prepare processor
xslt = ET.parse(xsl_path)
transform = ET.XSLT(xslt)

### Transform files in the working folder and output in current folder
for filename in glob.glob(os.path.join(example_path, '*.xml')):
    
    print('Working on ' + filename)
    
    xml_origin = ET.parse(filename)
    xml_new = transform(xml_origin)

    # Path to the output xml file
    output_path = os.path.basename(filename)

    xml_new.write_output(output_path)
