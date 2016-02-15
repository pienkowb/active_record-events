ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../dummy/config/environment.rb',  __FILE__)

require 'factory_girl'
require 'timecop'

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.color = true
  config.order = :random

  config.include FactoryGirl::Syntax::Methods

  config.around(:each) do |example|
    Timecop.freeze { example.run }
  end
end
