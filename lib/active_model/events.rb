require 'verbs'

module ActiveModel
  module Events
    def self.field_name(event_name)
      "#{past_participle(event_name)}_at"
    end

    def self.past_participle(infinitive)
      options = { tense: :past, aspect: :perfective }
      infinitive.verb.conjugate(options)
    end
  end
end
