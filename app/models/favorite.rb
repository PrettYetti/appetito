class Favorite < ActiveRecord::Base
  belongs_to :event
  belongs_to :user

  validates :user_id, uniqueness: { scope: [:restaurant, :event_id],
      message: "Cannot add place twice." }
end
