# == Schema Information
#
# Table name: notifications
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  sender_id  :integer
#  event_id   :integer
#  accept     :boolean
#  type       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  notified   :boolean          default("false")
#

class Notification < ActiveRecord::Base
	attr_accessor :message
  belongs_to :user
  belongs_to :event

  after_update :check_accept_status

  scope :friend_requests, -> { where(type: 'FriendRequest')}
  scope :event_invites, -> { where(type: 'EventInvite')}
  scope :event_updates, -> { where(type: 'EventUpdates')}

  def message
  	raise 'Abstract Method'
  end

  def check_accept_status
  	if accept == true || accept == nil
  		case type
  		when "FriendRequest"
  			sender = User.find(sender_id)
  			sender.friend_ids=(sender.friend_ids).push(user.id)
  			user.friend_ids=user.friend_ids.push(sender.id)
  		end
  	elsif accept == false
  		self.destroy
  	end
  end
end
