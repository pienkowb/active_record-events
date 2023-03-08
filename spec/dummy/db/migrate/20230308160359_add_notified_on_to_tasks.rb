class AddNotifiedOnToTasks < ACTIVE_RECORD_MIGRATION_CLASS
  def change
    add_column :tasks, :notified_on, :date
  end
end
