class SetDefaultRsvpToUndecided < ActiveRecord::Migration
  def up
  	change_column :invites, :rsvp, :string, default: "Undecided"
  	add_column :invites, :location, :string
  end

  def down
  	change_column :invites, :rsvp, :string, default: nil
  	remove_column :invites, :location
  end
end
