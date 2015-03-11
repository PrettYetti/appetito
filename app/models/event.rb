class Event < ActiveRecord::Base
  belongs_to :user
  has_many :notifications
  delegate :event_invites, :event_updates, to: :notifications
end
