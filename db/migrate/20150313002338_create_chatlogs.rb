class CreateChatlogs < ActiveRecord::Migration
  def change
    create_table :chatlogs do |t|
      t.references :event
      t.references :user
      t.string :message

      t.timestamps null: false
    end
  end
end
