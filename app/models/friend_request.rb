class FriendRequest < Notification

	def message
		sender = User.find(self.sender_id).name
		accept ? @message ="You are now friends with #{sender}" : @message = "You have a friend request from #{sender}!"
	end
	
end