ENV['RAILS_ENV'] ||= 'test'

require 'bundler/setup'
require 'simplecov'

SimpleCov.start do
  if ENV['CI']
    require 'simplecov-lcov'

    SimpleCov::Formatter::LcovFormatter.config do |config|
      config.report_with_single_file = true
      config.single_report_path = 'coverage/lcov.info'
    end

    formatter SimpleCov::Formatter::LcovFormatter
  end
end

require File.expand_path('dummy/config/environment.rb', __dir__)

require 'factory_girl'
require 'generator_spec'
require 'timecop'
require 'zonebie/rspec'

Dir["#{__dir__}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include GeneratorHelpers, type: :generator
end
