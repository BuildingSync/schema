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
