require 'active_record/events/naming'

module ActiveRecord
  module Events
    module Extension
      def has_events(*names)
        options = names.extract_options!
        names.each { |n| has_event(n, options) }
      end

      def has_event(name, options = {})
        naming = Naming.new(name, options)

        include(Module.new do
          define_method(naming.predicate) do
            self[naming.field].present?
          end

          define_method(naming.inverse_predicate) do
            !__send__(naming.predicate)
          end

          define_method(naming.action) do
            touch(naming.field)
          end

          define_method(naming.safe_action) do
            __send__(naming.action) if __send__(naming.inverse_predicate)
          end
        end)

        extend(Module.new do
          define_method(naming.collective_action) do
            if respond_to?(:touch_all)
              touch_all(naming.field)
            else
              update_all(naming.field => Time.current)
            end
          end

          unless options[:skip_scopes]
            define_method(naming.scope) do
              where(arel_table[naming.field].not_eq(nil))
            end

            define_method(naming.inverse_scope) do
              where(arel_table[naming.field].eq(nil))
            end
          end
        end)
      end
    end
  end
end
