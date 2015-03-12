# == Schema Information
#
# Table name: invites
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  event_id   :integer
#  rsvp       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#



#This class is a join table for events and users
class Invite < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  validates :rsvp, inclusion: { in: %w(Attending Maybe Not\ Attending),
      message: "%{value} is not a valid rsvp" }
end
