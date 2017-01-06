class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.datetime :email_confirmed_at

      t.timestamps null: false
    end
  end
end
