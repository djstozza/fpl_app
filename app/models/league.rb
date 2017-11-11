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

class League < ApplicationRecord
  belongs_to :commissioner, class_name: 'User', foreign_key: 'commissioner_id'
  has_many :fpl_teams
  has_many :draft_picks
  has_many :mini_draft_picks
  has_and_belongs_to_many :players
  has_many :users, through: :fpl_teams
  has_many :fpl_team_lists, through: :fpl_teams
  has_many :waiver_picks, through: :fpl_teams
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :code, presence: true
  validates_presence_of :commissioner
end
