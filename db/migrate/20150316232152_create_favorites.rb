class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.references :event, index: true
      t.references :user, index: true
      t.string :restaurant

      t.timestamps null: false
    end
    add_foreign_key :favorites, :events
    add_foreign_key :favorites, :users
  end
end
