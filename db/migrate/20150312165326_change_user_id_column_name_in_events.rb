class ChangeUserIdColumnNameInEvents < ActiveRecord::Migration

  def self.up
    rename_column :events, :user_id, :creator_id
  end

  def self.down
    rename_column :events, :creator_id, :user_id
  end
  
end
