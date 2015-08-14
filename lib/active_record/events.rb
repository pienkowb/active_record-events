require 'active_record'
require 'verbs'

module ActiveRecord::Events
  extend ActiveSupport::Concern

  def self.past_participle(infinitive)
    options = { tense: :past, aspect: :perfective }
    infinitive.verb.conjugate(options)
  end

  module ClassMethods
    def handles(*event_names)
      _module = ActiveRecord::Events

      event_names.each do |name|
        past_participle = _module.past_participle(name)
        field_name = "#{past_participle}_at"

        define_method(name) do
          touch(field_name) if send(field_name).blank?
        end

        define_method("#{name}!") do
          touch(field_name)
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, ActiveRecord::Events
