require 'spec_helper'

RSpec.describe ActiveRecord::Events do
  let(:task) { create(:task) }

  it 'records a timestamp' do
    task.complete

    expect(task.completed?).to eq(true)
    expect(task.not_completed?).to eq(false)

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

  let(:user) { create(:user) }

  it 'handles an object' do
    user.confirm_email

    expect(user.email_confirmed?).to eq(true)
    expect(user.email_not_confirmed?).to eq(false)
  end
end
