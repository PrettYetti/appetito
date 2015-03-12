# == Schema Information
#
# Table name: events
#
#  id         :integer          not null, primary key
#  creator_id :integer
#  name       :string
#  when       :datetime
#  location   :string
#  cuisine    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  finalized  :boolean          default("false")
#

class Event < ActiveRecord::Base
  # belongs_to :user
  belongs_to :creator, class_name: "User", foreign_key: :creator_id
  has_many :notifications
  has_many :invites
  delegate :event_invites, :event_updates, to: :notifications
end
