class FriendRequest < Notification

	def message
		sender = User.find(self.sender_id).name
		@message = "You have a friend request from #{sender}!"
	end
end