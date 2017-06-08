# == Schema Information
#
# Table name: fpl_teams
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  users_id    :integer
#  leagues_id  :integer
#  total_score :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class FplTeam < ApplicationRecord
  belongs_to :player
  belongs_to :league
  has_many :fpl_team_lists
end
