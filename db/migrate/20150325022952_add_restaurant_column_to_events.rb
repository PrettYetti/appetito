class AddRestaurantColumnToEvents < ActiveRecord::Migration
  def change
    add_column :events, :restaurant, :string
    remove_column :events, :cuisine
  end
end
