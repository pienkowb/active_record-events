require 'spec_helper'

RSpec.describe ActiveRecord::Events::MethodFactory do
  let(:event_name) { :complete }
  let(:options) { {} }

  subject { described_class.new(event_name, options) }

  it 'generates instance methods' do
    result = subject.instance_methods

    expect(result).to have_method(:completed?)
    expect(result).to have_method(:not_completed?)
    expect(result).to have_method(:complete!)
    expect(result).to have_method(:complete)
  end

  it 'generates class methods' do
    result = subject.class_methods

    expect(result).to have_method(:complete_all)
    expect(result).to have_method(:completed)
    expect(result).to have_method(:not_completed)
  end

  context 'with the object option' do
    let(:options) { { object: :task } }

    it 'generates instance methods' do
      result = subject.instance_methods

      expect(result).to have_method(:task_completed?)
      expect(result).to have_method(:task_not_completed?)
      expect(result).to have_method(:complete_task!)
      expect(result).to have_method(:complete_task)
    end

    it 'generates class methods' do
      result = subject.class_methods

      expect(result).to have_method(:complete_all_tasks)
      expect(result).to have_method(:task_completed)
      expect(result).to have_method(:task_not_completed)
    end
  end

  context 'with the skip scopes option' do
    let(:options) { { skip_scopes: true } }

    it 'generates class methods without scopes' do
      result = subject.class_methods

      expect(result).to have_method(:complete_all)

      expect(result).not_to have_method(:completed)
      expect(result).not_to have_method(:not_completed)
    end
  end
end
