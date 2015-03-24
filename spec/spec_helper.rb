require 'simplecov'
require 'codeclimate-test-reporter'
require 'pry'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  CodeClimate::TestReporter::Formatter
]

SimpleCov.start do
  add_filter '/vendor/'
end
