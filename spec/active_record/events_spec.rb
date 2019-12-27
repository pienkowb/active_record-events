require 'spec_helper'

RSpec.describe ActiveRecord::Events do
  around(:each) { |e| Timecop.freeze { e.run } }

  context 'without an object' do
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

    it 'records multiple timestamps' do
      Task.complete_all
      expect(task.reload.completed?).to eq(true)
    end

    it 'defines a scope' do
      expect(Task.completed).not_to include(task)
    end

    it 'defines an inverse scope' do
      expect(Task.not_completed).to include(task)
    end

    it 'allows overriding methods' do
      task.complete!
      expect(task.completed?).to eq(true)
    end
  end

  context 'with an object' do
    let!(:user) { create(:user) }

    it 'records a timestamp' do
      user.confirm_email

      expect(user.email_confirmed?).to eq(true)
      expect(user.email_not_confirmed?).to eq(false)
    end

    it 'records multiple timestamps' do
      User.confirm_all_emails
      expect(user.reload.email_confirmed?).to eq(true)
    end

    it 'defines a scope' do
      expect(User.email_confirmed).not_to include(user)
    end

    it 'defines an inverse scope' do
      expect(User.email_not_confirmed).to include(user)
    end
  end

  context 'with a date field' do
    let!(:book) { create(:book) }

    it 'records a timestamp' do
      book.borrow

      expect(book.borrowed?).to eq(true)
      expect(book.not_borrowed?).to eq(false)

      expect(book.reload.borrowed_on).to eq(Date.current)
    end

    it 'preserves a timestamp' do
      book = create(:book, borrowed_on: 3.days.ago)
      book.borrow

      expect(book.reload.borrowed_on).to eq(3.days.ago.to_date)
    end

    it 'updates a timestamp' do
      book = create(:book, borrowed_on: 3.days.ago)
      book.borrow!

      expect(book.reload.borrowed_on).to eq(Date.current)
    end

    it 'records multiple timestamps' do
      Book.borrow_all
      expect(book.reload.borrowed?).to eq(true)
    end

    it 'defines a scope' do
      expect(Book.borrowed).not_to include(book)
    end

    it 'defines an inverse scope' do
      expect(Book.not_borrowed).to include(book)
    end
  end
end
