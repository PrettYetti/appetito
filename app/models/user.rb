class User < ActiveRecord::Base
	has_many :events
	has_many :friendships
	has_and_belongs_to_many :friends, 
	              class_name: "User", 
	              join_table: :friendships, 
	              foreign_key: :user_id, 
	              association_foreign_key: :friend_user_id
	has_secure_password
	validates :email, uniqueness: true
end
