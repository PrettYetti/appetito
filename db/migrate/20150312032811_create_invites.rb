class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.references :user, index: true
      t.references :event, index: true
      t.string :rsvp

      t.timestamps null: false
    end
    add_foreign_key :invites, :users
    add_foreign_key :invites, :events
  end
end
