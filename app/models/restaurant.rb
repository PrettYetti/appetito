# == Schema Information
#
# Table name: restaurants
#
#  id         :integer          not null, primary key
#  name       :string
#  cuisine    :string
#  phone      :string
#  address    :string
#  rating     :float
#  price      :integer
#  event_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Restaurant < ActiveRecord::Base
	belongs_to :event
	has_many :favorites
	validates :phone, :address, uniqueness: {scope: :event_id, 
		message: "Restaurant already added to this event."}
end
