class AddFinalizedToEvents < ActiveRecord::Migration
  def up
  	add_column :events, :finalized, :boolean, default: false
  end

  def down
  	remove_column :events, :finalized
  end
end
