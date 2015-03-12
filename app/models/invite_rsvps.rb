class InviteRSVP < Notification

	def message
		event = Event.find(self.event_id)
		invitee = User.find(self.user_id).name
		@message = "#{invitee} is attending."
	end

end