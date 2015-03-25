# == Schema Information
#
# Table name: events
#
#  id         :integer          not null, primary key
#  creator_id :integer
#  name       :string
#  when       :datetime
#  location   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  finalized  :boolean          default("false")
#  latitude   :float
#  longitude  :float
#  restaurant :string
#

class Event < ActiveRecord::Base
  # belongs_to :user
  belongs_to :creator, class_name: "User", foreign_key: :creator_id
  has_many :notifications, dependent: :destroy
  has_many :invites, dependent: :destroy
  has_many :chatlogs, dependent: :destroy
  has_many :restaurants, dependent: :destroy
  has_many :favorites
  has_many :users, through: :invites

  geocoded_by :location   # can also be an IP address
  after_validation :geocode

  delegate :event_invites, :event_updates, to: :notifications
end
