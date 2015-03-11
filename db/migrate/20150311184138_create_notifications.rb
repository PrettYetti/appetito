class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :user, index: true
      t.integer :sender_id
      t.references :event, index: true
      t.boolean :accept
      t.string :type

      t.timestamps null: false
    end
    add_foreign_key :notifications, :users
    add_foreign_key :notifications, :events
  end
end
