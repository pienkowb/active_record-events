require 'rails/generators'

require 'active_record/events/naming'
require 'active_record/events/macro'

module ActiveRecord
  module Generators
    class EventGenerator < Rails::Generators::Base
      MACRO_OPTIONS = %w[object field_type skip_scopes strategy].freeze

      argument :model_name, type: :string
      argument :event_name, type: :string

      class_option :skip_scopes, type: :boolean,
        desc: 'Skip the inclusion of scope methods'
      class_option :field_type, type: :string,
        desc: 'The field type (datetime or date)'
      class_option :object, type: :string,
        desc: 'The name of the object'
      class_option :strategy, type: :string,
        desc: 'The comparison strategy (presence or time_comparison)'

      source_root File.expand_path('templates', __dir__)

      def generate_migration_file
        naming = ActiveRecord::Events::Naming.new(event_name, options)

        table_name = model_name.tableize
        field_name = naming.field
        field_type = options[:field_type] || 'datetime'

        migration_name = "add_#{field_name}_to_#{table_name}"
        attributes = "#{field_name}:#{field_type}"

        invoke 'active_record:migration', [migration_name, attributes]
      end

      def update_model_file
        return unless model_file_exists?

        macro_options = options.slice(*MACRO_OPTIONS)
        macro = ActiveRecord::Events::Macro.new(event_name, macro_options)

        inject_into_file model_file_path, "\s\s#{macro}\n", after: /class.+\n/
      end

      private

      def model_file_exists?
        File.exist?(model_file_path)
      end

      def model_file_path
        File.expand_path("app/models/#{model_file_name}", destination_root)
      end

      def model_file_name
        "#{model_name.underscore.singularize}.rb"
      end
    end
  end
end
