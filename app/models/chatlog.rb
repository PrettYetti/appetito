# == Schema Information
#
# Table name: chatlogs
#
#  id         :integer          not null, primary key
#  event_id   :integer
#  user_id    :integer
#  message    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Chatlog < ActiveRecord::Base
end
