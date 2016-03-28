require 'minitest/autorun'
require 'nokogiri'
require 'pp'

class ValidateExampleFiles < Minitest::Test
  def test_validate_all

    xsd = Nokogiri::XML::Schema(File.read('BuildingSync.xsd'))

    Dir['examples/*.xml'].each do |xml|
      puts "Validating #{xml}"

      doc = Nokogiri::XML(File.read(xml))

      errors = []
      xsd.validate(doc).each do |error|
        errors << { file: xml, error: error }
      end

      pp errors
      puts "There were #{errors.size} errors"

      assert 'Example XML files are not valid' if errors.size > 0
    end
  end
end
