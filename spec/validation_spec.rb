require 'nokogiri'
require 'pp'


RSpec.describe 'Validate Examples' do
  before :all do
    @xsd = Nokogiri::XML::Schema(File.read('BuildingSync.xsd'))
  end

  it 'should validate xmls' do
    total_errors = 0
    Dir['examples/*.xml'].each do |xml|
      puts "Validating file: #{xml}"

      doc = Nokogiri::XML(File.read(xml))

      errors = []
      @xsd.validate(doc).each do |error|
        errors << { file: xml, error: error }
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
