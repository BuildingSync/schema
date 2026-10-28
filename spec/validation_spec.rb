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
      'CBECS',
      'Capacity',
      'ClimateZone',
      'CommunicationProtocol',
      'Control',
      'ControlSensor',
      'ControlStrategy',
      'ControlSystemTypes',
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

# Deprecated elements and enumerations are detected from `xs:documentation` text matching /deprecat/i.
# - Deprecation on a local element or on a `ref` applies only to that location (parent element).
# - Deprecation on a global element applies to all of its refs, except under the replacement path
#   named in the documentation (e.g. "use WeatherStations/WeatherStation/WeatherDataStationID").
RSpec.describe 'No deprecated elements in examples' do
  it 'should warn about deprecated elements or enumerations' do
    xsd = Nokogiri::XML(File.read('BuildingSync.xsd'))
    ns = { 'xs' => 'http://www.w3.org/2001/XMLSchema' }

    deprecation_doc = lambda do |node|
      node.xpath('./xs:annotation/xs:documentation', ns).map(&:text).find { |t| t =~ /deprecat/i }
    end

    # Instance names of the element(s) that directly contain an XSD node
    instance_parents = lambda do |node|
      ancestor = node.parent
      ancestor = ancestor.parent until ancestor.nil? || ancestor.is_a?(Nokogiri::XML::Document) ||
                                       (ancestor.name == 'element' && ancestor['name']) ||
                                       (%w(complexType simpleType).include?(ancestor.name) && ancestor['name'])
      next [] if ancestor.nil? || ancestor.is_a?(Nokogiri::XML::Document)
      next [ancestor['name']] if ancestor.name == 'element'

      xsd.xpath("//xs:element[@type='auc:#{ancestor['name']}']", ns).map { |e| e['name'] || e['ref'].sub('auc:', '') }
    end

    rules = [] # { name:, parents: [..], value: nil|String, note: }
    xsd.xpath('//xs:element', ns).each do |el|
      doc = deprecation_doc.call(el)
      next unless doc

      name = el['name'] || el['ref'].sub('auc:', '')
      if el.parent.name == 'schema'
        segments = doc[/use\s+([\w\/]+)/i, 1].to_s.split('/')
        replacement_parent = segments.last == name ? segments[-2] : nil
        parents = xsd.xpath("//xs:element[@ref='auc:#{name}']", ns).flat_map { |r| instance_parents.call(r) }.uniq - [replacement_parent]
      else
        parents = instance_parents.call(el)
      end
      rules << { name: name, parents: parents, value: nil, note: doc.strip }
    end
    xsd.xpath('//xs:enumeration', ns).each do |enum|
      doc = deprecation_doc.call(enum)
      next unless doc

      owner = enum.ancestors('element').first
      names = if owner && owner['name']
                [owner['name']]
              else
                instance_parents.call(enum.parent) # named simpleType -> elements of that type
              end
      names.each { |n| rules << { name: n, parents: nil, value: enum['value'], note: doc.strip } }
    end

    expect(rules).not_to be_empty

    auc_ns = 'http://buildingsync.net/schemas/bedes-auc/2019'
    findings = []
    Dir['examples/*.xml'].sort.each do |xml|
      next if xml =~ /Invalid Schema/

      doc = Nokogiri::XML(File.read(xml))
      counts = Hash.new(0)
      doc.xpath('//*').each do |node|
        next unless node.namespace&.href == auc_ns

        rules.each do |rule|
          next unless node.name == rule[:name]

          if rule[:value]
            counts["#{rule[:name]}=#{rule[:value]}"] += 1 if node.text.strip == rule[:value]
          elsif rule[:parents].include?(node.parent.name)
            counts["#{node.parent.name}/#{rule[:name]}"] += 1
          end
        end
      end
      counts.each { |usage, count| findings << "#{xml}: #{usage} (#{count})" }
    end

    # Warning only: deprecated usages are reported but do not fail the build.
    unless findings.empty?
      warn 'WARNING: Deprecated usages found in examples:'
      findings.each { |f| warn "  #{f}" }
    end
  end
end
