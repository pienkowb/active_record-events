#!/usr/bin/env rake

begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

begin
  require 'rdoc/task'
rescue LoadError
  require 'rdoc/rdoc'
  require 'rake/rdoctask'
  RDoc::Task = Rake::RDocTask
end

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = 'ActiveRecord::Events'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

require 'active_record'
require 'yaml'

include ActiveRecord::Tasks

dummy_root = File.expand_path('spec/dummy', __dir__)
database_config = YAML.load_file("#{dummy_root}/config/database.yml")

DatabaseTasks.root = dummy_root
DatabaseTasks.env = ENV['RAILS_ENV'] || 'development'
DatabaseTasks.db_dir = "#{dummy_root}/db"
DatabaseTasks.database_configuration = database_config
DatabaseTasks.migrations_paths = "#{dummy_root}/db/migrate"

task :environment do
  require "#{dummy_root}/config/environment.rb"
end

ACTIVE_RECORD_MIGRATION_CLASS =
  if ActiveRecord::VERSION::MAJOR >= 5
    ActiveRecord::Migration[4.2]
  else
    ActiveRecord::Migration
  end

load 'active_record/railties/databases.rake'

Bundler::GemHelper.install_tasks

require 'rspec/core'
require 'rspec/core/rake_task'

desc 'Run all specs in spec directory (excluding plugin specs)'
RSpec::Core::RakeTask.new(spec: 'db:test:prepare')

task default: :spec
