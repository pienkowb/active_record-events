class AddExpiredAtToTasks < ACTIVE_RECORD_MIGRATION_CLASS
  def change
    add_column :tasks, :expired_at, :datetime
  end
end
