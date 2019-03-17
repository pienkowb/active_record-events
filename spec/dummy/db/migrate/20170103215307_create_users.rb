class CreateUsers < ACTIVE_RECORD_MIGRATION_CLASS
  def change
    create_table :users do |t|
      t.datetime :email_confirmed_at

      t.timestamps null: false
    end
  end
end
