# == Schema Information
#
# Table name: players_fpl_teams
#
#  player_id   :integer
#  fpl_team_id :integer
#

class PlayerFplTeam < ApplicationRecord
  self.table_name = :players_fpl_teams
  belongs_to :player
  belongs_to :fpl_team
  validates_uniqueness_of :player_id, scope: :fpl_team_id
end
