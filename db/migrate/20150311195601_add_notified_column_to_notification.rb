class AddNotifiedColumnToNotification < ActiveRecord::Migration
  def up
  	add_column :notifications, :notified, :boolean, default: false
  end

  def down
  	remove_column :notifications, :notified
  end
end
