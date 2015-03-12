

#This class is a join table for events and users
class Invite < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
end
