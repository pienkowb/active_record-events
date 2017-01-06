require 'verbs'

module ActiveRecord
  module Events
    class Naming
      def initialize(infinitive, options = {})
        @infinitive = infinitive
        @subject = options[:subject].presence
      end

      def field
        [@subject, past_participle, 'at'].compact.join('_')
      end

      def predicate
        [@subject, past_participle].compact.join('_')
      end

      def action
        [@infinitive, @subject].compact.join('_')
      end

      def scope
        [@subject, past_participle].compact.join('_')
      end

      def inverse_scope
        [@subject, 'not', past_participle].compact.join('_')
      end

      private

      def past_participle
        options = { tense: :past, aspect: :perfective }
        @infinitive.verb.conjugate(options)
      end
    end
  end
end
