require 'active_record/events/naming'

module ActiveRecord
  module Events
    class MethodFactory
      def initialize(event_name, options)
        @options = options
        @naming = Naming.new(event_name, options)
        @strategy = options[:strategy].try(:to_sym)
      end

      def instance_methods
        Module.new.tap do |module_|
          define_predicate_method(module_, naming, strategy)
          define_inverse_predicate_method(module_, naming)

          define_action_method(module_, naming)
          define_safe_action_method(module_, naming)
        end
      end

      def class_methods
        Module.new.tap do |module_|
          define_collective_action_method(module_, naming)

          unless options[:skip_scopes]
            define_scope_method(module_, naming, strategy)
            define_inverse_scope_method(module_, naming, strategy)
          end
        end
      end

      private

      attr_reader :options
      attr_reader :naming
      attr_reader :strategy

      def define_predicate_method(module_, naming, strategy)
        module_.send(:define_method, naming.predicate) do
          if strategy == :time_comparison
            self[naming.field].present? && self[naming.field].past?
          else
            self[naming.field].present?
          end
        end
      end

      def define_inverse_predicate_method(module_, naming)
        module_.send(:define_method, naming.inverse_predicate) do
          !__send__(naming.predicate)
        end
      end

      def define_action_method(module_, naming)
        module_.send(:define_method, naming.action) do
          if persisted?
            touch(naming.field)
          else
            self[naming.field] = current_time_from_proper_timezone
          end
        end
      end

      def define_safe_action_method(module_, naming)
        module_.send(:define_method, naming.safe_action) do
          __send__(naming.action) if __send__(naming.inverse_predicate)
        end
      end

      def define_collective_action_method(module_, naming)
        module_.send(:define_method, naming.collective_action) do
          if respond_to?(:touch_all)
            touch_all(naming.field)
          else
            update_all(naming.field => Time.current)
          end
        end
      end

      def define_scope_method(module_, naming, strategy)
        module_.send(:define_method, naming.scope) do
          if strategy == :time_comparison
            where(arel_table[naming.field].lteq(Time.current))
          else
            where(arel_table[naming.field].not_eq(nil))
          end
        end
      end

      def define_inverse_scope_method(module_, naming, strategy)
        module_.send(:define_method, naming.inverse_scope) do
          if strategy == :time_comparison
            where(arel_table[naming.field].eq(nil)
              .or(arel_table[naming.field].gt(Time.current)))
          else
            where(arel_table[naming.field].eq(nil))
          end
        end
      end
    end
  end
end
