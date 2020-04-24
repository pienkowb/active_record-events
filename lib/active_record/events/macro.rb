module ActiveRecord
  module Events
    class Macro
      def initialize(event_name, options)
        @event_name = event_name.to_s
        @options = options
      end

      def to_s
        "has_event :#{event_name}#{options_list}"
      end

      private

      def event_name
        @event_name.underscore
      end

      def options_list
        options.unshift('').join(', ') if options.present?
      end

      def options
        @options.map { |k, v| "#{k}: #{convert_value(v)}" }
      end

      def convert_value(value)
        symbol_or_string?(value) ? ":#{value}" : value
      end

      def symbol_or_string?(value)
        value.is_a?(Symbol) || value.is_a?(String)
      end
    end
  end
end
