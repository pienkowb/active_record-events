require File.expand_path('../boot', __FILE__)

require 'active_record'

Bundler.require(:default, ENV['RAILS_ENV'])

# Load application files
Dir["#{File.dirname(__FILE__)}/../app/**/*.rb"].each { |f| require f }

# Load the database configuration
config_file = File.expand_path('../database.yml', __FILE__)
config = YAML.load_file(config_file)[ENV['RAILS_ENV']]

ActiveRecord::Base.logger = Logger.new(File::NULL)

ActiveRecord::Base.establish_connection(config)
