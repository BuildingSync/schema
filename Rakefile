# Author: Nicholas Long

# Specific gems used elsewhere
require 'nokogiri'
require 'rubyXL'
require 'pp'

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

    File.open(file, 'w') { |f| f << doc.to_xml(:indent => 2) }
  end
end

require 'rspec/core/rake_task'
# require 'ci/reporter/rake/rspec'  # Always create spec reports

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.rspec_opts = ['--format', 'progress']
  spec.pattern = FileList['spec/**/*_spec.rb']
end

task :default => :spec
