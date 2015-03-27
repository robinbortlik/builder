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


RSpec.configure do |config|
  config.before(:all) do
    `git config --global push.default simple`
  end
end

require 'excon'
Excon.defaults[:ssl_verify_peer] = false
