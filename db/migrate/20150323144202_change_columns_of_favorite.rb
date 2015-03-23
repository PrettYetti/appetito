class ChangeColumnsOfFavorite < ActiveRecord::Migration

  def up
  	remove_column :favorites, :restaurant
  	remove_column :favorites, :event_id
  	add_column :favorites, :restaurant_id, :integer, null: false
  	add_index :favorites, :restaurant_id
  end

  def down
  	add_column :favorites, :restaurant, :string
  	add_column :favorites, :event_id, :integer, null: false
  	add_index :favorites, :event_id
  	remove_column :favorites, :restaurant_id
  end

end
