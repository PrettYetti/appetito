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

require 'test_helper'

class EventTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
