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

class WaiverPick < ApplicationRecord
  belongs_to :league
  belongs_to :round
  belongs_to :player
  belongs_to :fpl_team
  belongs_to :list_position
  validates :list_position_id, :status, :fpl_team_id, :player_id, :league_id, presence: true
  validates_uniqueness_of :pick_number, scope: [:fpl_team_id, :round_id], on: :create
  enum status: %w[pending approved declined]
end
