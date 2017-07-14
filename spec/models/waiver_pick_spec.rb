# == Schema Information
#
# Table name: waiver_picks
#
#  id               :integer          not null, primary key
#  pick_number      :integer
#  status           :integer          default("pending")
#  list_position_id :integer
#  player_id        :integer
#  round_id         :integer
#  fpl_team_id      :integer
#  league_id        :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'rails_helper'

RSpec.describe WaiverPick, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
