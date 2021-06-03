import sys
import lxml.etree as ET

### Inputs
# Path to the xml file you need to transform
xml_path = "..\examples\Reference Building - Primary School.xml"
# Path to the xsl file
xsl_path = "v2_to_v3.xsl"
# Path to the output xml file
output_path = "new_xml.xml"

xml_origin = ET.parse(xml_path)
xslt = ET.parse(xsl_path)
transform = ET.XSLT(xslt)
xml_new = transform(xml_origin)

with open(output_path, "wb") as f:
    f.write(ET.tostring(xml_new, pretty_print=True))
