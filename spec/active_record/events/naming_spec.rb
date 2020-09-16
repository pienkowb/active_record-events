require 'spec_helper'

RSpec.describe ActiveRecord::Events::Naming do
  let(:event_name) { :complete }
  let(:options) { {} }

  subject { described_class.new(event_name, options) }

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
    let(:options) { { object: :task } }

    it 'generates a field name' do
      expect(subject.field).to eq('task_completed_at')
    end

    it 'generates a predicate name' do
      expect(subject.predicate).to eq('task_completed?')
    end

    it 'generates an inverse predicate name' do
      expect(subject.inverse_predicate).to eq('task_not_completed?')
    end

    it 'generates an action name' do
      expect(subject.action).to eq('complete_task!')
    end

    it 'generates a safe action name' do
      expect(subject.safe_action).to eq('complete_task')
    end

    it 'generates a collective action name' do
      expect(subject.collective_action).to eq('complete_all_tasks')
    end

    it 'generates a scope name' do
      expect(subject.scope).to eq('task_completed')
    end

    it 'generates an inverse scope name' do
      expect(subject.inverse_scope).to eq('task_not_completed')
    end
  end

  context 'with a date field' do
    let(:options) { { field_type: :date } }

    it 'generates a field name' do
      expect(subject.field).to eq('completed_on')
    end
  end

  context 'with a custom field name' do
    let(:options) { { field_name: :completion_time } }

    it 'returns the field name' do
      expect(subject.field).to eq('completion_time')
    end
  end
end
