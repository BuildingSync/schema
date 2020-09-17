require 'nokogiri'
require 'pp'
require 'open-uri'
require 'set'


RSpec.describe 'Validate Examples' do
  before :all do
    # Nokogiri doesn't seem to support XSDs which import other schemas with URLs
    # for the schemaLocation. To allow testing, we download the imported schema
    # and point schemaLocation to it instead
    schema_doc = Nokogiri::XML(File.read('BuildingSync.xsd'))

    GEOJSON_XSD_PATH = 'geojson.xsd'
    GEOJSON_IMPORT_XPATH = 'xs:schema/xs:import[@namespace = "http://www.gbxml.org/schema"]'
    if !File.file?(GEOJSON_XSD_PATH) then
      imported_schema_locations = schema_doc.xpath(GEOJSON_IMPORT_XPATH).collect { |nokogiri_xml_node|
        nokogiri_xml_node.attribute("schemaLocation").value
      }
      expect(imported_schema_locations.length).to eq 1

      open(GEOJSON_XSD_PATH, 'wb') do |file|
        file << open(imported_schema_locations[0]).read
      end
    end

    schema_doc.xpath(GEOJSON_IMPORT_XPATH).collect { |nokogiri_xml_node|
      nokogiri_xml_node.attribute("schemaLocation").value = GEOJSON_XSD_PATH
    }

    @xsd = Nokogiri::XML::Schema.from_document(schema_doc)
  end

  it 'should validate xmls' do
    total_errors = 0
    Dir['examples/*.xml'].each do |xml|
      puts "Validating file: #{xml}"
      # skip the invalid schema file
      next if xml =~ /Invalid Schema/

      doc = Nokogiri::XML(File.read(xml))

      errors = []
      @xsd.validate(doc).each do |error|
        errors << {file: xml, error: error}
      end
      unless errors.size.zero?
        puts "  There were #{errors.size} errors!"
        pp errors
      end
      total_errors += errors.size
      puts "\n"
    end

    expect(total_errors).to eq 0
  end
end


RSpec.describe 'No Tabs in Examples' do
  it 'should not have any tabs in the XMLS' do
    total_errors = 0
    Dir['examples/*.xml', 'BuildingSync.xsd'].each do |xml|
      puts "Checking for tabs in file: #{xml}"

      errors = []
      if File.read(xml).include? "\t"
        errors << "File #{xml} includes tabs, please remove the Tabs (run 'rake remove_tabs')"
      end

      unless errors.size.zero?
        puts "  There were #{errors.size} errors!"
        pp errors
      end

      total_errors += errors.size

      puts "\n"
    end

    expect(total_errors).to eq 0
  end
end

RSpec.describe 'No XMLSpy content' do
  it 'should not have any XMLSpy comments' do
    total_errors = 0
    Dir['examples/*.xml', 'BuildingSync.xsd'].each do |xml|
      puts "Checking for XMLSpy in file: #{xml}"

      errors = []
      if File.read(xml).include? "XMLSpy"
        errors << "File #{xml} includes XMLSpy, please remove the offending lines (run 'rake remove_tabs')"
      end

      unless errors.size.zero?
        puts "  There were #{errors.size} errors!"
        pp errors
      end

      total_errors += errors.size

      puts "\n"
    end

    expect(total_errors).to eq 0
  end
end

RSpec.describe 'No complexContent in XSD' do
  it 'should not have any complexContent' do
    expect(File.read('BuildingSync.xsd').include? "complexContent").to eq false
  end
end

RSpec.describe 'No naming collisions between schemas' do
  it 'should not have any collisions between names in schemas' do
    imported_schema_locations = File.open("BuildingSync.xsd", "r") do |file|
      xml_schema = Nokogiri::XML(file)
  
      xml_schema.xpath('xs:schema/xs:import').collect { |nokogiri_xml_node|
        nokogiri_xml_node.attribute("schemaLocation").value
      }
    end

    FILENAMES = ["BuildingSync.xsd"].concat(imported_schema_locations)
    NAMESPACES = {
      xs: "http://www.w3.org/2001/XMLSchema",
    }
    NAME_ATTRIBUTE = "name"

    XPATH_FOR_NAME_ATTRIBUTE = %w(attribute complexType element simpleType).collect { |s|
      "./xs:schema/xs:#{s}[@#{NAME_ATTRIBUTE}]"
    }.join(" | ")

    $stdout.puts("Checking files: #{FILENAMES.inspect}")

    sets = FILENAMES.collect { |filename|
      if filename.start_with?('http') then
        nokogiri_xml_document = Nokogiri::XML(URI.open(filename))
      else
        nokogiri_xml_document = File.open(filename, "r") do |file|
          Nokogiri::XML(file)
        end
      end

      nokogiri_xml_document.xpath(XPATH_FOR_NAME_ATTRIBUTE, **NAMESPACES).collect { |nokogiri_xml_node|
        nokogiri_xml_node.attribute(NAME_ATTRIBUTE).value
      }.to_set
    }

    # permitted because AT’s xsd2ruby script has already been tested with them and it was OK
    PERMITTED_CONFLICTS = %w(Capacity Latitude Location Longitude Manufacturer State ZipCode)

    conflicts = []
    sets.each_with_index do |set_a, a_index|
      sets.each_with_index do |set_b, b_index|
        if a_index < b_index then
          intersection_set = set_a.intersection(set_b).subtract(PERMITTED_CONFLICTS)
          if intersection_set.length() > 0 then
            found_conflict = true
            conflicts.append("Collision(s) between #{FILENAMES[a_index].inspect} and #{FILENAMES[b_index].inspect}: #{intersection_set.to_a.sort.inspect}")
          end
        end
      end
    end

    expect(conflicts).to be_empty
  end
end