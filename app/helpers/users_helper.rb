module UsersHelper
	def current_user
		if session[:user_id]
			@current_user ||= User.find(session[:user_id])
		else
			nil
		end
	end

	def user_friend_request_path
	end
end
