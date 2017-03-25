# == Schema Information
#
# Table name: fixtures
#
#  id                     :integer          not null, primary key
#  kickoff_time           :string
#  deadline_time          :string
#  team_h_difficulty      :integer
#  team_a_difficulty      :integer
#  code                   :integer
#  team_h_score           :integer
#  team_a_score           :integer
#  round_id               :integer
#  minutes                :integer
#  team_a_id              :integer
#  team_h_id              :integer
#  started                :boolean
#  finished               :boolean
#  provisional_start_time :boolean
#  finished_provisional   :boolean
#  round_day              :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class Fixture < ActiveRecord::Base
  belongs_to :round
  belongs_to :team
  has_many :player_fixture_histories
  validates :round_id, presence: true

  scope :active, -> { where(started: true).where(finished: false) }
  scope :finished, -> { where(finished: true) }

  def stats
    key_stats_hash
  end

  def home_team
    Team.find_by(id: team_h_id)
  end

  def away_team
    Team.find_by(id: team_a_id)
  end

  private

  def key_stats_hash
    stats = {}
    key_stats_arr.each { |stat| stats[stat] = stat_hash(stat) }
    stats
  end

  def key_stats_arr
    ['goals_scored',
     'assists',
     'own_goals',
     'saves',
     'yellow_cards',
     'red_cards',
     'penalties_saved',
     'penalties_missed',
     'bonus']
  end

  def stat_hash(stat)
    hash = {}
    home_team_arr = []
    away_team_arr = []
    hash['home_team'] = home_team_arr
    hash['away_team'] = away_team_arr
    player_fixture_histories.where.not("#{stat}": 0).each do |player_stat|
      arr = player_stat.was_home ? home_team_arr : away_team_arr
      arr  << { player: player_stat.player.last_name, value: player_stat.public_send(stat) }
    end
    hash
  end
end
