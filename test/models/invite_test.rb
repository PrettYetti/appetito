# == Schema Information
#
# Table name: invites
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  event_id   :integer
#  rsvp       :string           default("Undecided")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  location   :string
#

require 'test_helper'

class InviteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
