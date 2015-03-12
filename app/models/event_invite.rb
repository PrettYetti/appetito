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


# This is a notification for the invite.
class EventInvite < Notification
	
	def message
		sender = User.find(self.sender_id).name
		event = Event.find(self.event_id).name
		accept ? @message = "You accepted an invite from #{sender} for #{event}" : @message = "#{sender} invited you to #{event}!"
	end

	#this message is for event#show page
end
