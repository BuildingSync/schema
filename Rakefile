




require 'nokogiri'
require 'pp'

desc 'Validate all the XMLs in the examples directory'
task :validate_examples do

  xsd = Nokogiri::XML::Schema(File.read('BuildingSync.xsd'))

  puts xsd

  Dir['examples/*.xml'].each do |xml|
    puts "Validating #{xml}"

    doc = Nokogiri::XML(File.read(xml))

    errors = []
    xsd.validate(doc).each do |error|
      errors << { file: xml, error: error}
    end

    pp errors
    puts "There were #{errors.size} errors"

    fail "Example XML files are not valid" if errors.size > 0
  end
end