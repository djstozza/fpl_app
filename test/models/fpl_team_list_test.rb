# == Schema Information
#
# Table name: fpl_team_lists
#
#  id          :integer          not null, primary key
#  fpl_team_id :integer
#  round_id    :integer
#  formation   :string           default([]), is an Array
#  total_score :integer
#  rank        :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class FplTeamListTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
