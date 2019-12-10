require 'verbs'

module ActiveRecord
  module Events
    class Naming
      def initialize(infinitive, options = {})
        @infinitive = infinitive
        @object = options[:object].presence
        @field_type = options[:field_type]
      end

      def field
        if @field_type == :date
          [@object, past_participle, 'on'].compact.join('_')
        else
          [@object, past_participle, 'at'].compact.join('_')
        end
      end

      def predicate
        [@object, past_participle].compact.join('_')
      end

      def inverse_predicate
        [@object, 'not', past_participle].compact.join('_')
      end

      def action
        [@infinitive, @object].compact.join('_')
      end

      def collective_action
        [@infinitive, 'all', pluralized_object].compact.join('_')
      end

      def scope
        [@object, past_participle].compact.join('_')
      end

      def inverse_scope
        [@object, 'not', past_participle].compact.join('_')
      end

      private

      def past_participle
        @infinitive.verb.conjugate(tense: :past, aspect: :perfective)
      end

      def pluralized_object
        @object.to_s.pluralize if @object.present?
      end
    end
  end
end
