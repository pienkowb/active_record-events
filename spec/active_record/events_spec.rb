require 'spec_helper'

RSpec.describe ActiveRecord::Events do
  around(:each) do |example|
    Timecop.freeze { example.run }
  end

  let!(:task) { create(:task) }

  it 'records a timestamp' do
    task.complete

    expect(task.completed?).to eq(true)
    expect(task.not_completed?).to eq(false)

    expect(task.completed_at).to eq(Time.current)
  end

  it 'preserves a timestamp' do
    task = create(:task, completed_at: 3.days.ago)

    task.complete

    expect(task.completed_at).to eq(3.days.ago)
  end

  it 'updates a timestamp' do
    task = create(:task, completed_at: 3.days.ago)

    task.complete!

    expect(task.completed_at).to eq(Time.current)
  end

  it 'On non-persisted object, it updates the timestamp' do
    task = build(:task, completed_at: 3.days.ago)

    task.complete!

    expect(task.completed_at).to eq(Time.current)
  end

  it 'records multiple timestamps at once' do
    Task.complete_all

    expect(task.reload).to be_completed
  end

  it 'defines a scope' do
    expect(Task.completed).not_to include(task)
  end

  it 'defines an inverse scope' do
    expect(Task.not_completed).to include(task)
  end

  it 'allows overriding instance methods' do
    expect(ActiveRecord::Base.logger).to receive(:info)

    task.complete!

    expect(task).to be_completed
  end

  it 'allows overriding class methods' do
    expect(ActiveRecord::Base.logger).to receive(:info)

    Task.complete_all

    expect(task.reload).to be_completed
  end
end
