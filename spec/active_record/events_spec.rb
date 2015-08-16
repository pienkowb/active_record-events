require 'spec_helper'

RSpec.describe ActiveRecord::Events do
  let(:task) { create(:task) }

  it 'records a timestamp' do
    task.complete

    expect(task).to be_completed
    expect(task.completed_at).to eq(Time.now)
  end

  it 'preserves a timestamp' do
    task = create(:task, completed_at: 3.days.ago)
    task.complete

    expect(task.completed_at).to eq(3.days.ago)
  end

  it 'updates a timestamp' do
    task = create(:task, completed_at: 3.days.ago)
    task.complete!

    expect(task.completed_at).to eq(Time.now)
  end

  it 'defines scope methods' do
    expect(Task.not_completed).to include(task)
    expect(Task.completed).not_to include(task)
  end
end
