require 'active_support'
require 'active_record/events/naming'

module ActiveRecord
  module Events
    def has_events(*names)
      options = names.extract_options!
      names.each { |n| has_event(n, options) }
    end

    def has_event(name, options = {})
      naming = Naming.new(name, options)

      define_singleton_method(naming.collective_action) do
        update_all(naming.field => Time.current)
      end

      define_singleton_method(naming.scope) do
        where(arel_table[naming.field].not_eq(nil))
      end

      define_singleton_method(naming.inverse_scope) do
        where(arel_table[naming.field].eq(nil))
      end

      mod = Module.new
      include mod
      mod.class_eval <<-RUBY, __FILE__, __LINE__+1
        define_method("#{naming.predicate}?") do
          self[naming.field].present?
        end
  
        define_method("#{naming.inverse_predicate}?") do
          self[naming.field].blank?
        end
  
        define_method(naming.action) do
          touch(naming.field) if self[naming.field].blank?
        end
  
        define_method("#{naming.action}!") do
          touch(naming.field)
        end
      RUBY
    end
  end
end

ActiveSupport.on_load(:active_record) do
  extend ActiveRecord::Events
end
