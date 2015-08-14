require 'spec_helper'

RSpec.describe ActiveModel::Events do
  before(:each) { @task = Task.create! }

  it 'records a timestamp' do
    @task.complete
    expect(@task.completed_at).to eq(Time.now)
  end

  it 'preserves a timestamp' do
    @task.completed_at = 3.days.ago
    @task.complete

    expect(@task.completed_at).to eq(3.days.ago)
  end

  it 'updates a timestamp' do
    @task.completed_at = 3.days.ago
    @task.complete!

    expect(@task.completed_at).to eq(Time.now)
  end
end
