ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../dummy/config/environment.rb',  __FILE__)

require 'rspec/rails'
require 'rspec/autorun'
require 'factory_girl'
require 'timecop'

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.order = :random
  config.use_transactional_fixtures = true
  config.color_enabled = true

  config.include FactoryGirl::Syntax::Methods

  config.around(:each) do |example|
    Timecop.freeze { example.run }
  end
end
