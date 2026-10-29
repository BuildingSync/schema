# *********************************************************************************************************
# BuildingSync®, Copyright (c) 2015-2025, Alliance for Sustainable Energy, LLC, and other contributors.
#
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification, are permitted
# provided that the following conditions are met:
#
# (1) Redistributions of source code must retain the above copyright notice, this list of conditions
# and the following disclaimer.
#
# (2) Redistributions in binary form must reproduce the above copyright notice, this list of conditions
# and the following disclaimer in the documentation and/or other materials provided with the distribution.
#
# (3) Neither the name of the copyright holder nor the names of any contributors may be used to endorse
# or promote products derived from this software without specific prior written permission from the
# respective party.
#
# (4) Other than as required in clauses (1) and (2), distributions in any form of modifications or other
# derivative works may not use the "BuildingSync" trademark or any other confusingly similar designation
# without specific prior written permission from Alliance for Sustainable Energy, LLC.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER(S) AND ANY CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
# FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER(S), ANY
# CONTRIBUTORS, THE UNITED STATES GOVERNMENT, OR THE UNITED STATES DEPARTMENT OF ENERGY, NOR ANY OF
# THEIR EMPLOYEES, BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
# OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
# STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# *********************************************************************************************************

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

    GBXML_XSD_PATH = 'gbxml.xsd'
    GBXML_IMPORT_PATH = 'xs:schema/xs:import[@namespace = "http://www.gbxml.org/schema"]'
    if !File.file?(GBXML_XSD_PATH) || File.size(GBXML_XSD_PATH) == 0 then
      imported_schema_locations = schema_doc.xpath(GBXML_IMPORT_PATH).collect { |nokogiri_xml_node|
        nokogiri_xml_node.attribute("schemaLocation").value
      }
      expect(imported_schema_locations.length).to eq 1

      begin
        puts "Downloading gbXML schema from: #{imported_schema_locations[0]}"
        File.open(GBXML_XSD_PATH, 'wb') do |file|
          file << URI.open(imported_schema_locations[0]).read
        end

        # Verify the downloaded file is valid XML
        if File.size(GBXML_XSD_PATH) == 0
          raise "Downloaded file is empty"
        end

        # Test parse the downloaded XSD to ensure it's valid
        Nokogiri::XML(File.read(GBXML_XSD_PATH)) do |config|
          config.strict
        end
        puts "Successfully downloaded and validated gbXML schema"
      rescue => e
        puts "Failed to download gbXML schema: #{e.message}"
        # Clean up empty or invalid file
        File.delete(GBXML_XSD_PATH) if File.exist?(GBXML_XSD_PATH)
        raise "Could not download valid gbXML schema from #{imported_schema_locations[0]}: #{e.message}"
      end
    end
    schema_doc.xpath(GBXML_IMPORT_PATH).collect { |nokogiri_xml_node|
      nokogiri_xml_node.attribute("schemaLocation").value = GBXML_XSD_PATH
    }

    @xsd = Nokogiri::XML::Schema.from_document(schema_doc)
  end

  def auc_ns
    {'auc' => 'http://buildingsync.net/schemas/bedes-auc/2019'}
  end

  def xsd_ns
    {'xs' => 'http://www.w3.org/2001/XMLSchema'}
  end

  def load_example(path)
    Nokogiri::XML(File.read(path))
  end

  def auc_node(xml)
    Nokogiri::XML("<root xmlns:auc='#{auc_ns['auc']}'>#{xml}</root>").root.element_children.first
  end

  def expect_valid(doc)
    errors = @xsd.validate(doc)
    expect(errors).to be_empty, errors.map(&:message).join("\n")
  end

  def expect_invalid(doc)
    errors = @xsd.validate(doc)
    expect(errors).not_to be_empty
  end

  def set_choice_capacity(target, value)
    target.xpath('auc:OutputCapacity | auc:Capacity', auc_ns).remove
    capacity = auc_node("<auc:Capacity auc:Source='Direct measurement'>#{value}</auc:Capacity>")
    units = target.at_xpath('auc:CapacityUnits', auc_ns)
    if units
      units.add_previous_sibling(capacity)
    else
      target.add_child(capacity)
    end
  end

  def add_output_capacity(target, value)
    output_capacity = auc_node("<auc:OutputCapacity>#{value}</auc:OutputCapacity>")
    units = target.at_xpath('auc:CapacityUnits', auc_ns)
    if units
      units.add_previous_sibling(output_capacity)
    else
      target.add_child(output_capacity)
    end
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

  it 'keeps issue 356 patch structure and cardinality constraints' do
    schema_doc = Nokogiri::XML(File.read('BuildingSync.xsd'))

    expect(schema_doc.xpath("//xs:element[@name='Capacity']", xsd_ns).length).to eq 1
    expect(schema_doc.xpath("//xs:element[@name='CBECS']", xsd_ns).length).to eq 1
    expect(schema_doc.at_xpath("/xs:schema/xs:element[@name='CBECS']", xsd_ns)['type']).to eq 'auc:CBECSType'
    expect(schema_doc.xpath("//xs:element[@ref='auc:CBECS']", xsd_ns).length).to eq 2
    expect(schema_doc.xpath("//xs:element[@name='ControlSystemTypes']", xsd_ns).length).to eq 1
    expect(schema_doc.xpath("//xs:element[@name='Controls']", xsd_ns).length).to eq 2
    expect(schema_doc.xpath("//xs:element[@name='Control']", xsd_ns).length).to eq 2
    expect(schema_doc.xpath("//xs:element[@name='Other']", xsd_ns).length).to eq 6
    expect(schema_doc.xpath("/xs:schema/xs:element[@name='Control']", xsd_ns).length).to eq 0

    expect(schema_doc.xpath("//xs:element[@ref='auc:Controls']", xsd_ns).length).to eq 19
    expect(schema_doc.xpath("//xs:element[@ref='auc:ControlSystemTypes']", xsd_ns).length).to eq 3
    expect(schema_doc.xpath("//xs:element[@ref='auc:Other']", xsd_ns).length).to eq 16
    %w[Capacity CBECS Controls ControlSystemTypes Other].each do |name|
      schema_doc.xpath("//xs:element[@ref='auc:#{name}']", xsd_ns).each do |node|
        expect(node['minOccurs']).to eq '0'
        expect(node['maxOccurs'] || '1').to eq '1'
      end
    end
    expect(schema_doc.at_xpath("/xs:schema/xs:element[@name='Other']", xsd_ns)['type']).to eq 'auc:OtherType'

    global_controls = schema_doc.at_xpath("/xs:schema/xs:element[@name='Controls']", xsd_ns)
    global_control = global_controls.at_xpath('./xs:complexType/xs:sequence/xs:element[@name="Control"]', xsd_ns)
    expect(global_control['type']).to eq 'auc:ControlGeneralType'
    expect(global_control['maxOccurs']).to eq 'unbounded'
    expect(global_control['minOccurs']).to be_nil

    control_system_types = schema_doc.at_xpath("/xs:schema/xs:element[@name='ControlSystemTypes']", xsd_ns)
    control_system_type_child = control_system_types.at_xpath('./xs:complexType/xs:sequence/xs:element[@ref="auc:ControlSystemType"]', xsd_ns)
    expect(control_system_type_child['minOccurs']).to eq '0'
    expect(control_system_type_child['maxOccurs']).to eq 'unbounded'
  end

  it 'validates consolidated Capacity behavior across the four patched contexts' do
    contexts = {
      'HeatingSource' => lambda { |doc|
        doc.at_xpath("//auc:HeatingSource[@ID='HeatingSource-70049129212260']", auc_ns)
      },
      'Boiler' => lambda { |doc|
        doc.at_xpath("//auc:HeatingPlant[@ID='HeatingPlantType-70049116420780']/auc:Boiler", auc_ns)
      },
      'DistrictHeating' => lambda { |doc|
        boiler = doc.at_xpath("//auc:HeatingPlant[@ID='HeatingPlantType-70049116420780']/auc:Boiler", auc_ns)
        boiler.replace(auc_node('<auc:DistrictHeating><auc:DistrictHeatingType>Hot water</auc:DistrictHeatingType><auc:CapacityUnits>kBtu/hr</auc:CapacityUnits></auc:DistrictHeating>'))
        doc.at_xpath("//auc:HeatingPlant[@ID='HeatingPlantType-70049116420780']/auc:DistrictHeating", auc_ns)
      },
      'SolarThermal' => lambda { |doc|
        boiler = doc.at_xpath("//auc:HeatingPlant[@ID='HeatingPlantType-70049116420780']/auc:Boiler", auc_ns)
        boiler.replace(auc_node('<auc:SolarThermal><auc:CapacityUnits>kBtu/hr</auc:CapacityUnits></auc:SolarThermal>'))
        doc.at_xpath("//auc:HeatingPlant[@ID='HeatingPlantType-70049116420780']/auc:SolarThermal", auc_ns)
      }
    }

    contexts.each do |name, target_builder|
      aggregate_failures(name) do
      valid_doc = load_example('examples/AT_example_SF_audit_report.xml')
      valid_target = target_builder.call(valid_doc)
      set_choice_capacity(valid_target, '123.45')
      expect_valid(valid_doc)

      invalid_non_decimal_doc = load_example('examples/AT_example_SF_audit_report.xml')
      invalid_non_decimal_target = target_builder.call(invalid_non_decimal_doc)
      set_choice_capacity(invalid_non_decimal_target, 'abc')
      expect_invalid(invalid_non_decimal_doc)

      invalid_both_doc = load_example('examples/AT_example_SF_audit_report.xml')
      invalid_both_target = target_builder.call(invalid_both_doc)
      set_choice_capacity(invalid_both_target, '123.45')
      add_output_capacity(invalid_both_target, '456.0')
      expect_invalid(invalid_both_doc)

      no_capacity_doc = load_example('examples/AT_example_SF_audit_report.xml')
      no_capacity_target = target_builder.call(no_capacity_doc)
      no_capacity_target.xpath('auc:OutputCapacity | auc:Capacity', auc_ns).remove
      expect_valid(no_capacity_doc)
      end
    end
  end

  it 'keeps consolidated CBECS behavior in benchmark and climate zone contexts' do
    contexts = {
      'Benchmark' => lambda { |doc, cbecs_xml|
        scenario = doc.at_xpath("//auc:Scenario[@ID='ScenarioType-70049018982360']/auc:ScenarioType", auc_ns)
        scenario.children.remove
        scenario.add_child(auc_node("<auc:Benchmark><auc:BenchmarkType>#{cbecs_xml}</auc:BenchmarkType></auc:Benchmark>"))
      },
      'ClimateZoneType' => lambda { |doc, cbecs_xml|
        climate_zone_type = doc.at_xpath('//auc:ClimateZoneType', auc_ns)
        climate_zone_type.children.remove
        climate_zone_type.add_child(auc_node(cbecs_xml))
      }
    }
    examples = {
      'Benchmark' => 'examples/AT_example_SF_audit_report.xml',
      'ClimateZoneType' => 'examples/BuildingSync Website Valid Schema.xml'
    }

    contexts.each do |name, builder|
      aggregate_failures(name) do
        ['<auc:CBECS/>', '<auc:CBECS><auc:ClimateZone>1</auc:ClimateZone></auc:CBECS>',
         '<auc:CBECS><auc:ClimateZone>5</auc:ClimateZone></auc:CBECS>'].each do |xml|
          doc = load_example(examples[name])
          builder.call(doc, xml)
          expect_valid(doc)
        end

        ['<auc:CBECS><auc:ClimateZone>6</auc:ClimateZone></auc:CBECS>',
         '<auc:CBECS><auc:ClimateZone>1</auc:ClimateZone><auc:ClimateZone>2</auc:ClimateZone></auc:CBECS>',
         '<auc:CBECS>text</auc:CBECS>'].each do |xml|
          doc = load_example(examples[name])
          builder.call(doc, xml)
          expect_invalid(doc)
        end
      end
    end
  end

  it 'keeps consolidated ControlSystemTypes semantics for all three plant contexts' do
    plant_paths = [
      "//auc:HeatingPlant[@ID='HeatingPlantType-70049116420780']",
      "//auc:CoolingPlant[@ID='CoolingPlantType-70049112503700']",
      "//auc:CondenserPlant[@ID='CondenserPlantType-70049110218100']"
    ]

    plant_paths.each do |plant_path|
      empty_doc = load_example('examples/AT_example_SF_audit_report.xml')
      empty_plant = empty_doc.at_xpath(plant_path, auc_ns)
      empty_plant.at_xpath('auc:ControlSystemTypes', auc_ns)&.remove
      empty_plant.at_xpath('auc:UserDefinedFields', auc_ns).add_previous_sibling(auc_node('<auc:ControlSystemTypes/>'))
      expect_valid(empty_doc)

      repeated_doc = load_example('examples/AT_example_SF_audit_report.xml')
      repeated_plant = repeated_doc.at_xpath(plant_path, auc_ns)
      repeated_plant.at_xpath('auc:ControlSystemTypes', auc_ns)&.remove
      repeated_plant.at_xpath('auc:UserDefinedFields', auc_ns).add_previous_sibling(
        auc_node('<auc:ControlSystemTypes><auc:ControlSystemType><auc:Digital/></auc:ControlSystemType><auc:ControlSystemType><auc:Other><auc:OtherCommunicationProtocolName>Custom protocol</auc:OtherCommunicationProtocolName></auc:Other></auc:ControlSystemType></auc:ControlSystemTypes>')
      )
      expect_valid(repeated_doc)
    end

    invalid_doc = load_example('examples/AT_example_SF_audit_report.xml')
    invalid_heating_plant = invalid_doc.at_xpath("//auc:HeatingPlant[@ID='HeatingPlantType-70049116420780']", auc_ns)
    invalid_heating_plant.at_xpath('auc:ControlSystemTypes', auc_ns)&.remove
    invalid_heating_plant.at_xpath('auc:UserDefinedFields', auc_ns).add_previous_sibling(
      auc_node('<auc:ControlSystemTypes><auc:ControlSystemType>Analog</auc:ControlSystemType></auc:ControlSystemTypes>')
    )
    expect_invalid(invalid_doc)
  end

  it 'preserves general Controls wrapper behavior and value boundaries' do
    source_path = "//auc:HeatingSource[@ID='HeatingSource-70049129212260']"

    omitted_doc = load_example('examples/AT_example_SF_audit_report.xml')
    omitted_doc.at_xpath("#{source_path}/auc:Controls", auc_ns).remove
    expect_valid(omitted_doc)

    empty_doc = load_example('examples/AT_example_SF_audit_report.xml')
    empty_doc.at_xpath("#{source_path}/auc:Controls", auc_ns).replace(auc_node('<auc:Controls/>'))
    expect_invalid(empty_doc)

    one_control_doc = load_example('examples/AT_example_SF_audit_report.xml')
    one_control_doc.at_xpath("#{source_path}/auc:Controls", auc_ns).replace(
      auc_node('<auc:Controls><auc:Control><auc:Thermostat><auc:ControlStrategy>Manual</auc:ControlStrategy></auc:Thermostat></auc:Control></auc:Controls>')
    )
    expect_valid(one_control_doc)

    multi_control_doc = load_example('examples/AT_example_SF_audit_report.xml')
    multi_control_doc.at_xpath("#{source_path}/auc:Controls", auc_ns).replace(
      auc_node('<auc:Controls><auc:Control><auc:Thermostat><auc:ControlStrategy>Manual</auc:ControlStrategy></auc:Thermostat></auc:Control><auc:Control><auc:Manual><auc:ControlStrategy>Manual</auc:ControlStrategy></auc:Manual></auc:Control></auc:Controls>')
    )
    expect_valid(multi_control_doc)

    invalid_daylighting_doc = load_example('examples/AT_example_SF_audit_report.xml')
    invalid_daylighting_doc.at_xpath("#{source_path}/auc:Controls", auc_ns).replace(
      auc_node('<auc:Controls><auc:Control><auc:Daylighting/></auc:Control></auc:Controls>')
    )
    expect_invalid(invalid_daylighting_doc)
  end

  it 'keeps lighting Controls specific to lighting control types' do
    lighting_controls_path = "//auc:LightingSystem[@ID='LightingSystemType-70049015970580']/auc:Controls"

    lighting_daylighting_doc = load_example('examples/AT_example_SF_audit_report.xml')
    lighting_daylighting_doc.at_xpath(lighting_controls_path, auc_ns).replace(
      auc_node('<auc:Controls><auc:Control><auc:Daylighting><auc:ControlSensor>Photocell</auc:ControlSensor></auc:Daylighting></auc:Control></auc:Controls>')
    )
    expect_valid(lighting_daylighting_doc)

    lighting_thermostat_doc = load_example('examples/AT_example_SF_audit_report.xml')
    lighting_thermostat_doc.at_xpath(lighting_controls_path, auc_ns).replace(
      auc_node('<auc:Controls><auc:Control><auc:Thermostat/></auc:Control></auc:Controls>')
    )
    expect_invalid(lighting_thermostat_doc)
  end

  it 'keeps consolidated Other element strict while preserving distinct typed Other variants' do
    scenario_other_path = "//auc:Scenario[@ID='ScenarioType-70049018982360']/auc:ScenarioType/auc:Other"

    valid_empty_other_doc = load_example('examples/AT_example_SF_audit_report.xml')
    expect_valid(valid_empty_other_doc)

    invalid_text_other_doc = load_example('examples/AT_example_SF_audit_report.xml')
    invalid_text_other_doc.at_xpath(scenario_other_path, auc_ns).content = 'unexpected text'
    expect_invalid(invalid_text_other_doc)

    invalid_child_other_doc = load_example('examples/AT_example_SF_audit_report.xml')
    invalid_child_other_doc.at_xpath(scenario_other_path, auc_ns).add_child(auc_node('<auc:Unexpected>bad</auc:Unexpected>'))
    expect_invalid(invalid_child_other_doc)

    climate_zone_doc = load_example('examples/BuildingSync Website Valid Schema.xml')
    climate_zone_doc.at_xpath('//auc:ClimateZoneType', auc_ns).add_child(
      auc_node('<auc:Other><auc:ClimateZone>Custom climate zone</auc:ClimateZone></auc:Other>')
    )
    expect_valid(climate_zone_doc)

    control_system_other_doc = load_example('examples/AT_example_SF_audit_report.xml')
    control_system_other_doc.at_xpath("//auc:HeatingPlant[@ID='HeatingPlantType-70049116420780']/auc:ControlSystemTypes", auc_ns).replace(
      auc_node('<auc:ControlSystemTypes><auc:ControlSystemType><auc:Other><auc:OtherCommunicationProtocolName>Protocol X</auc:OtherCommunicationProtocolName></auc:Other></auc:ControlSystemType></auc:ControlSystemTypes>')
    )
    expect_valid(control_system_other_doc)
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

RSpec.describe 'No naming collisions within the schema' do
  it 'should not have any elements with duplicate names' do
    schema_doc = Nokogiri::XML(File.read('BuildingSync.xsd'))
    named_elements = schema_doc.xpath("//xs:element[@name]")
    element_names = Hash.new
    named_elements.each do |node|
      element_name = node['name']
      if element_names.key?(element_name)
        element_names[element_name].append(node.line())
      else
        element_names[element_name] = [node.line()]
      end
    end

    # TODO: remove ignored dupes once we fix them all. (ie make no exceptions)
    # See - https://github.com/BuildingSync/project-tracker/issues/21
    #     - https://github.com/BuildingSync/schema/issues/323
    #     - https://github.com/BuildingSync/schema/issues/324
    #     - https://github.com/BuildingSync/schema/issues/325
    ignored_dupes = [
      'AdvancedPowerStrip',
      'AssemblyType',
      'Building',
      'ClimateZone',
      'CommunicationProtocol',
      'Control',
      'ControlSensor',
      'ControlStrategy',
      'Controls',
      'ConveyanceSystems',
      'Facility',
      'HeatPump',
      'LampLabel',
      'Manual',
      'MeasureName',
      'Other',
      'OtherControlTechnology',
      'Priority',
      'RatePeriod',
      'RatePeriods',
      'Section',
      'Site',
      'SiteEnergyUse',
      'SourceEnergyUse',
      'Space',
      'ThermalZone',
      'Timer',
      'WaterSideEconomizer',
      'WaterUse'
    ]

    dupe_names = element_names.select{ |k, v| v.length() > 1 && !ignored_dupes.include?(k) }
    expect(dupe_names).to be_empty
  end
end
