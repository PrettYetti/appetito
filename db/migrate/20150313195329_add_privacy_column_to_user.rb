class AddPrivacyColumnToUser < ActiveRecord::Migration
  def up
  	add_column :users, :privacy, :boolean, default: false
  end

  def down
  	remove_column :users, :privacy
  end
end
