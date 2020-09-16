# Author: Nicholas Long

# Specific gems used elsewhere
require 'nokogiri'
require 'rubyXL'
require 'pp'
require 'json'
require 'csv'
require 'set'
require 'open-uri'

# Local files
require_relative 'src/data_dictionary'

desc 'generate data dictionary'
task :generate_data_dictionary do
  dd = DataDictionary.new
  dd.generate
end

desc 'Convert tabs to spaces'
task :remove_tabs do
  Dir['examples/**/*.xml', 'BuildingSync.xsd'].each do |file|
    puts " Cleaning #{file}"
    doc = Nokogiri.XML(File.read(file)) do |config|
      config.default_xml.noblanks
    end

    doc.xpath('//comment()').each do |node|
      if node.text =~ /XMLSpy/
        node.remove
      end
    end

    File.open(file, 'w') { |f| f << doc.to_xml(:indent => 2) }
  end

  if File.exist? "BuildingSync.json"
    f = JSON.parse(File.read('BuildingSync.json'))
    File.open('BuildingSync.json', 'w') do |file|
      file << JSON.pretty_generate(f)
    end
  end
end

csv_filename = "./schema_documentation.csv"

desc 'Generate CSV of the schema\'s documentation elements'
task :generate_documentation_csv do
  # WARNING: this task is coupled with the `update_documentation` task
  CSV.open(csv_filename, "w") do |csv|
    csv << ["file_line", "original_documentation", "updated_documentation", "xpath"]
    doc = Nokogiri.XML(File.read("BuildingSync.xsd")) do |config|
      config.default_xml.noblanks
    end

    doc.xpath('//xs:documentation', 'xs' => 'http://www.w3.org/2001/XMLSchema').each do |node|
      csv << ["BuildingSync.xsd:%d" % [node.line], node.text, '', node.path]
    end
  end
end

desc 'Update schema\'s documentation elements from CSV'
task :update_documentation do
  # WARNING: this task is coupled with the `generate_documentation_csv` task
  doc = Nokogiri.XML(File.read("BuildingSync.xsd")) do |config|
    config.default_xml.noblanks
  end

  csv_row_number = 1
  CSV.foreach(csv_filename, :headers => :first_row) do |row|
    csv_row_number += 1
    updated_documentation = row.field("updated_documentation")
    if updated_documentation == nil || updated_documentation.length == 0
      next
    end

    documentation_elem = doc.xpath(row.field("xpath"))
    if documentation_elem.length != 1
      raise "%s:%d Xpath returned an unexpected number of elements (expected one)" % [csv_filename, csv_row_number]
    end

    documentation_elem[0].content = updated_documentation
  end

  File.open("BuildingSync.xsd", 'w') { |f| f << doc.to_xml(:indent => 2) }
end

desc 'Get report of naming collisions between schemas'
task :check_collisions do
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

  found_conflict = false
  sets.each_with_index do |set_a, a_index|
    sets.each_with_index do |set_b, b_index|
      if a_index < b_index then
        intersection_set = set_a.intersection(set_b)
        if intersection_set.length() > 0 then
          found_conflict = true
          $stdout.puts("Collision: #{FILENAMES[a_index].inspect} #{FILENAMES[b_index].inspect} #{intersection_set.to_a.sort.inspect}")
        end
      end
    end
  end

  if found_conflict then
    exit(1)
  end
end

require 'rspec/core/rake_task'
# require 'ci/reporter/rake/rspec'  # Always create spec reports

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.rspec_opts = ['--format', 'progress']
  spec.pattern = FileList['spec/**/*_spec.rb']
end

task :default => :spec
