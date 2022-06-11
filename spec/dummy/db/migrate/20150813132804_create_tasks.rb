class CreateTasks < ACTIVE_RECORD_MIGRATION_CLASS
  def change
    create_table :tasks do |t|
      t.datetime :completed_at

      t.timestamps null: false
    end
  end
end
