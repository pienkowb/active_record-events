require 'spec_helper'

RSpec.describe ActiveRecord::Events::Naming do
  subject { described_class.new(:complete) }

  it 'generates a field name' do
    expect(subject.field).to eq('completed_at')
  end

  it 'generates a predicate name' do
    expect(subject.predicate).to eq('completed?')
  end

  it 'generates an inverse predicate name' do
    expect(subject.inverse_predicate).to eq('not_completed?')
  end

  it 'generates an action name' do
    expect(subject.action).to eq('complete!')
  end

  it 'generates a safe action name' do
    expect(subject.safe_action).to eq('complete')
  end

  it 'generates a collective action name' do
    expect(subject.collective_action).to eq('complete_all')
  end

  it 'generates a scope name' do
    expect(subject.scope).to eq('completed')
  end

  it 'generates an inverse scope name' do
    expect(subject.inverse_scope).to eq('not_completed')
  end

  context 'with an object' do
    subject { described_class.new(:confirm, object: :email) }

    it 'generates a field name' do
      expect(subject.field).to eq('email_confirmed_at')
    end

    it 'generates a predicate name' do
      expect(subject.predicate).to eq('email_confirmed?')
    end

    it 'generates an inverse predicate name' do
      expect(subject.inverse_predicate).to eq('email_not_confirmed?')
    end

    it 'generates an action name' do
      expect(subject.action).to eq('confirm_email!')
    end

    it 'generates a safe action name' do
      expect(subject.safe_action).to eq('confirm_email')
    end

    it 'generates a collective action name' do
      expect(subject.collective_action).to eq('confirm_all_emails')
    end

    it 'generates a scope name' do
      expect(subject.scope).to eq('email_confirmed')
    end

    it 'generates an inverse scope name' do
      expect(subject.inverse_scope).to eq('email_not_confirmed')
    end
  end

  context 'with a date field' do
    subject { described_class.new(:deliver, field_type: :date) }

    it 'generates a field name' do
      expect(subject.field).to eq('delivered_on')
    end
  end
end
