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

require 'test_helper'

class ChatlogTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
