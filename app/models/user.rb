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
#  privacy         :boolean          default("false")
#

class User < ActiveRecord::Base
	has_many :created_events, class_name: "Event", foreign_key: :creator_id
	has_many :notifications
	has_many :invites
	has_many :events, through: :invites
	has_and_belongs_to_many :friends, 
	              class_name: "User", 
	              join_table: :friendships, 
	              foreign_key: :user_id, 
	              association_foreign_key: :friend_user_id
	has_secure_password
	validates :email, uniqueness: true
	delegate :friend_requests, :event_invites, :event_updates, to: :notifications

	has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
end
