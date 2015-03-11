class EventInvite < Notification
	
	def message
		sender = User.find(self.sender_id).name
		event = Event.find(self.event_id).name
		@message = "#{sender} invited you to #{event}!"
	end
end