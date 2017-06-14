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
#

class FplTeam < ApplicationRecord
  belongs_to :player
  belongs_to :league
  belongs_to :user
  has_many :fpl_team_lists
  validates_presence_of :user
  validates_presence_of :league
  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
