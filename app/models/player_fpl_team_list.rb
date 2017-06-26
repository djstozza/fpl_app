# == Schema Information
#
# Table name: players_fpl_team_lists
#
#  player_id        :integer
#  fpl_team_list_id :integer
#

class PlayerFplTeamList < ApplicationRecord
  self.table_name = :players_fpl_team_lists
  belongs_to :player
  belongs_to :fpl_team_list
  validates_uniqueness_of :player_id, scope: :fpl_team_list_id
end
