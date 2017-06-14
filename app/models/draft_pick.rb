# == Schema Information
#
# Table name: draft_picks
#
#  id          :integer          not null, primary key
#  league_id   :integer
#  player_id   :integer
#  fpl_team_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class DraftPick < ApplicationRecord
end
