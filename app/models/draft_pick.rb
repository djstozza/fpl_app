# == Schema Information
#
# Table name: draft_picks
#
#  id          :integer          not null, primary key
#  pick_number :integer
#  league_id   :integer
#  player_id   :integer
#  fpl_team_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class DraftPick < ApplicationRecord
  belongs_to :league
  belongs_to :fpl_team
  belongs_to :player

  validates :pick_number, presence: true
  validates :league_id, presence: true
  validates :player_id, allow_blank: true, uniqueness: { scope: :league_id }
end
