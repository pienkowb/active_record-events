require 'verbs'

module ActiveRecord
  module Events
    class Naming
      def initialize(infinitive, options = {})
        @infinitive = infinitive
        @object = options[:object].presence
        @field_name = options[:field_name].to_s
        @field_type = options[:field_type].try(:to_sym)
      end

      def field
        return field_name if field_name.present?

        suffix = field_type == :date ? 'on' : 'at'

        concatenate(object, past_participle, suffix)
      end

      def predicate
        concatenate(object, past_participle) + '?'
      end

      def inverse_predicate
        concatenate(object, 'not', past_participle) + '?'
      end

      def action
        concatenate(infinitive, object) + '!'
      end

      def safe_action
        concatenate(infinitive, object)
      end

      def collective_action
        concatenate(infinitive, 'all', plural_object)
      end

      def scope
        concatenate(object, past_participle)
      end

      def inverse_scope
        concatenate(object, 'not', past_participle)
      end

      private

      attr_reader :infinitive
      attr_reader :object
      attr_reader :field_name
      attr_reader :field_type

      def concatenate(*parts)
        parts.compact.join('_')
      end

      def past_participle
        infinitive.verb.conjugate(tense: :past, aspect: :perfective)
      end

      def plural_object
        object.to_s.pluralize if object.present?
      end
    end
  end
end
