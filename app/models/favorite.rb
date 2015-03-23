# == Schema Information
#
# Table name: favorites
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  restaurant_id :integer          not null
#

class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :restaurant

  validates :user_id, uniqueness: { scope: :restaurant_id,
      message: "Cannot add place twice." }
end
