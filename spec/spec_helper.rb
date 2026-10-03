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

# Use UTC timezone for all tests to avoid timezone-related test failures
ENV['TZ'] = 'UTC'

require File.expand_path('dummy/config/environment.rb', __dir__)

# Monkey-patch Time to compare UTC values, ignoring timezone representation
class Time
  alias original_eq ==

  def ==(other)
    return original_eq(other) unless other.is_a?(Time)

    # Compare at millisecond precision, as timestamps lose microseconds
    # when stored in the database
    to_i == other.to_i && usec / 1000 == other.usec / 1000
  end
end

require 'factory_girl'
require 'generator_spec'
require 'timecop'
require 'zonebie/rspec'
require 'database_cleaner'

Dir["#{__dir__}/support/**/*.rb"].sort.each { |f| require f }

# Load the schema for the test database
load File.expand_path('dummy/db/schema.rb', __dir__)

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning { example.run }
  end

  config.include FactoryGirl::Syntax::Methods
  config.include GeneratorHelpers, type: :generator
end
