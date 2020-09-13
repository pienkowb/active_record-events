require 'active_record/events/method_factory'

module ActiveRecord
  module Events
    module Extension
      def has_events(*names)
        options = names.extract_options!
        names.each { |n| has_event(n, options) }
      end

      def has_event(name, options = {})
        method_factory = MethodFactory.new(name, options)

        include method_factory.instance_methods
        extend method_factory.class_methods
      end
    end
  end
end
