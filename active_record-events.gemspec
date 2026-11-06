$LOAD_PATH.unshift(File.expand_path('lib', __dir__))

require 'active_record/events/version'

Gem::Specification.new do |spec|
  spec.name = 'active_record-events'
  spec.version = ActiveRecord::Events::VERSION
  spec.author = 'Bartosz Pieńkowski'
  spec.email = 'pienkowb@gmail.com'
  spec.homepage = 'https://github.com/pienkowb/active_record-events'
  spec.summary = 'Manage timestamps in ActiveRecord models'
  spec.description = 'An ActiveRecord extension providing convenience ' \
                     'methods for timestamp management.'
  spec.license = 'MIT'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir['lib/**/*'] + %w[LICENSE Rakefile README.md]

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_dependency 'activerecord', '>= 4.0'
  spec.add_dependency 'verbs', '>= 2.2'
end
