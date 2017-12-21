# == Schema Information
#
# Table name: fpl_teams
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  user_id     :integer
#  league_id   :integer
#  total_score :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  rank        :integer
#  active      :boolean
#

class FplTeam < ApplicationRecord
  belongs_to :player
  belongs_to :league
  belongs_to :user
  has_many :draft_picks
  has_many :fpl_team_lists
  has_many :waiver_picks, through: :fpl_team_lists
  has_many :inter_team_trade_groups, through: :fpl_team_lists
  has_and_belongs_to_many :players
  has_many :teams, through: :players
  has_many :positions, through: :players
  validates_presence_of :user
  validates_presence_of :league
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  has_many :mini_draft_picks

  QUOTAS = { team: 3, goalkeepers: 2, midfielders: 5, defenders: 5, forwards: 3 }.freeze
end
