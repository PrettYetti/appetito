class User < ActiveRecord::Base
	has_many :events
	has_secure_password
	validates :email, uniqueness: true
end
