require 'spec_helper'
require 'active_record/events/macro'

RSpec.describe ActiveRecord::Events::Macro do
  let(:event_name) { :confirm }

  subject { described_class.new(event_name, options) }

  context 'without options' do
    let(:options) { {} }

    it "doesn't include any options" do
      expect(subject.to_s).to eq('has_event :confirm')
    end
  end

  context 'with a string option' do
    let(:options) { { object: 'email' } }

    it 'prepends the option value with a colon' do
      expect(subject.to_s).to eq('has_event :confirm, object: :email')
    end
  end

  context 'with a symbol option' do
    let(:options) { { object: :email } }

    it 'prepends the option value with a colon' do
      expect(subject.to_s).to eq('has_event :confirm, object: :email')
    end
  end

  context 'with a boolean option' do
    let(:options) { { skip_scopes: true } }

    it "doesn't prepend the option value with a colon" do
      expect(subject.to_s).to eq('has_event :confirm, skip_scopes: true')
    end
  end

  context 'with multiple options' do
    let(:options) { { object: :email, field_type: :date } }

    it 'includes all of the options' do
      macro = 'has_event :confirm, object: :email, field_type: :date'
      expect(subject.to_s).to eq(macro)
    end
  end
end
