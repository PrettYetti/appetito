class AddLatitudeAndLongitudeAndLocationToInvite < ActiveRecord::Migration
  def change
    add_column :invites, :latitude, :float
    add_column :invites, :longitude, :float
  end
end
