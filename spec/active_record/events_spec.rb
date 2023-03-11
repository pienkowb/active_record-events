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

  context 'with a non-persisted object' do
    it 'updates the timestamp' do
      task = build(:task, completed_at: 3.days.ago)

      task.complete!

      expect(task.completed_at).to eq(Time.current)
    end
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

  describe 'time comparison strategy' do
    it 'defines a predicate method comparing against current time' do
      task.update_columns(expired_at: 1.hour.from_now)
      expect(task.expired?).to eq(false)

      task.update_columns(expired_at: 1.hour.ago)
      expect(task.expired?).to eq(true)

      task.update_columns(expired_at: nil)
      expect(task.expired?).to eq(false)
    end

    it 'defines an inverse predicate method comparing against current time' do
      task.update_columns(expired_at: 1.hour.from_now)
      expect(task.not_expired?).to eq(true)

      task.update_columns(expired_at: 1.hour.ago)
      expect(task.not_expired?).to eq(false)

      task.update_columns(expired_at: nil)
      expect(task.not_expired?).to eq(true)
    end

    it 'defines a scope comparing against current time' do
      task.update_columns(expired_at: 1.hour.from_now)
      expect(Task.expired).not_to include(task)

      task.update_columns(expired_at: 1.hour.ago)
      expect(Task.expired).to include(task)

      task.update_columns(expired_at: nil)
      expect(Task.expired).not_to include(task)
    end

    it 'defines an inverse scope comparing against current time' do
      task.update_columns(expired_at: 1.hour.from_now)
      expect(Task.not_expired).to include(task)

      task.update_columns(expired_at: 1.hour.ago)
      expect(Task.not_expired).not_to include(task)

      task.update_columns(expired_at: nil)
      expect(Task.not_expired).to include(task)
    end

    describe 'for date fields' do
      it "considers today's event over" do
        task.update_columns(notified_on: Date.today)
        expect(task.notified?).to eq(true)
      end

      it "considers tomorrow's event pending" do
        task.update_columns(notified_on: Date.tomorrow)
        expect(task.notified?).to eq(false)
      end

      it "considers yesterday's event over" do
        task.update_columns(notified_on: Date.yesterday)
        expect(task.notified?).to eq(true)
      end

      it 'includes current date in scope' do
        task.update_columns(notified_on: Date.current)
        expect(Task.notified).to include(task)
      end

      it 'excludes current date in inverse scope' do
        task.update_columns(notified_on: Date.current)
        expect(Task.not_notified).not_to include(task)
      end
    end
  end
end
