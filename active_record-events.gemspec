$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'active_record/events/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'active_record-events'
  s.version     = ActiveRecord::Events::VERSION
  s.author      = 'Bartosz Pieńkowski'
  s.email       = 'pienkowb@gmail.com'
  s.homepage    = 'https://github.com/pienkowb/active_record-events'
  s.summary     = 'Manage timestamps in ActiveRecord models'
  s.description = 'An ActiveRecord extension providing convenience methods for timestamp management.'
  s.license     = 'MIT'

  s.files = Dir['lib/**/*'] + %w(MIT-LICENSE Rakefile README.md)
  s.test_files = Dir['spec/**/*']

  s.required_ruby_version = '>= 1.9.3'

  s.add_dependency 'activerecord', '>= 3.0'
  s.add_dependency 'verbs'

  s.add_development_dependency 'standalone_migrations'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'factory_girl'
  s.add_development_dependency 'timecop'
end
