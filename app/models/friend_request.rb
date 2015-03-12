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

class FriendRequest < Notification

	def message
		sender = User.find(self.sender_id).name
		@message = accept ? "You are now friends with #{sender}" : "You have a friend request from #{sender}!"
	end
	
end
