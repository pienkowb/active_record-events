ENV['RAILS_ENV'] ||= 'test'

require 'bundler/setup'
require 'coveralls'

Coveralls.wear!

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
