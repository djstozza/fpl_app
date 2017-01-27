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

  def stats
    {
      home_team_stats: team_stat('h'),
      away_team_stats: team_stat('a')
    }
  end

  def home_team
    Team.find_by(id: team_h_id)
  end

  def away_team
    Team.find_by(id: team_a_id)
  end

  private

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

  def team_stat(team)
    stats = {}
    key_stats_arr.each { |stat| stats[stat] = stat_arr(team, stat) }
    stats
  end

  def stat_arr(team, stat)
    bool = team == 'h'
    arr = []
    player_fixture_histories.where(was_home: bool).where.not("#{stat}": 0).each do |player_stat|
      arr << { player: player_stat.player.name, value: player_stat.public_send(stat) }
    end
    arr
  end
end
