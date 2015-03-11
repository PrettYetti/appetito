# == Schema Information
#
# Table name: notifications
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  sender_id  :integer
#  event_id   :integer
#  accept     :boolean
#  type       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  notified   :boolean          default("false")
#

class EventUpdate < Notification
end
