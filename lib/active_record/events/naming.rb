require 'verbs'

module ActiveRecord
  module Events
    class Naming
      def initialize(infinitive, options = {})
        @infinitive = infinitive
        @object = options[:object].presence
      end

      def field
        [@object, past_participle, 'at'].compact.join('_')
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
    end
  end
end
