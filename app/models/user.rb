# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string
#  password_digest :string
#  name            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ActiveRecord::Base
	has_many :events
	has_many :notifications
	has_and_belongs_to_many :friends, 
	              class_name: "User", 
	              join_table: :friendships, 
	              foreign_key: :user_id, 
	              association_foreign_key: :friend_user_id
	has_secure_password
	validates :email, uniqueness: true
	delegate :friend_requests, :event_invites, :event_updates, to: :notifications
end
