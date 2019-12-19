class CreateBooks < ACTIVE_RECORD_MIGRATION_CLASS
  def change
    create_table :books do |t|
      t.date :borrowed_on

      t.timestamps null: false
    end
  end
end
