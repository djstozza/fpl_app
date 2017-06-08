# == Schema Information
#
# Table name: leagues
#
#  id              :integer          not null, primary key
#  name            :string           not null
#  code            :string           not null
#  active          :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  commissioner_id :integer
#

require 'test_helper'

class LeagueTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
