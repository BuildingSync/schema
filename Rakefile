# Nicholas Long
require 'rake/testtask'

# Specific gems used elsewhere
require 'nokogiri'
require 'rubyXL'
require 'pp'

# Local files
require_relative 'src/data_dictionary'
Rake::TestTask.new do |t|
  t.pattern = 'test/*_test.rb'
end

desc 'generate data dictionary'
task :generate_data_dictionary do
  dd = DataDictionary.new
  dd.generate
end

desc "Remove tabs from example files"
task :remove_tabs do
  Dir['examples/*.xml'].each do |file|
    puts " Cleaning #{file}"
    doc = Nokogiri.XML(File.read(file)) do |config|
      config.default_xml.noblanks
    end

    File.open(file, 'w') { |f| f << doc.to_xml(:indent => 2) }
  end
end

