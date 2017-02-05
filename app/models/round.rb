# == Schema Information
#
# Table name: rounds
#
#  id                        :integer          not null, primary key
#  name                      :string
#  deadline_time             :string
#  finished                  :boolean
#  data_checked              :boolean
#  deadline_time_epoch       :integer
#  deadline_time_game_offset :integer
#  is_previous               :boolean
#  is_current                :boolean
#  is_next                   :boolean
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

class Round < ActiveRecord::Base
  has_many :fixtures
  has_many :player_fixture_histories

  def short_name
    "GW#{id}"
  end

  def fixture_arr
    fixtures.sort_by(&:kickoff_time).group_by { |fixture| fixture.kickoff_time.to_time.strftime('%A %-d %B %Y') }
  end

  def fixture_hash
    {
      round: self,
      daily_fixtures: fixtures.sort_by(&:kickoff_time)
                              .group_by { |fixture| fixture.kickoff_time.to_time.strftime('%A %-d %B %Y') }
                              .map do |fixture_group|
                                {
                                  day: fixture_group[0],
                                  fixtures: fixture_group[1].map do |fixture|
                                    {
                                      fixture: fixture,
                                      home_team: fixture.home_team,
                                      away_team: fixture.away_team,
                                      stats: fixture.stats
                                    }
                                  end
                                }
                              end
    }
  end
end
