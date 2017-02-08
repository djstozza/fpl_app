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

  def fixture_arr
    fixtures.sort_by(&:kickoff_time).group_by { |fixture| fixture.kickoff_time.to_time.strftime('%A %-d %B %Y') }
  end

  def short_name
    "GW#{id}"
  end

  def fixture_stats
    cached_or_unchached_fixture_hash
  end

  def fixture_stats_by_game_day
    cache_or_uncached_fixture_stats_by_game_day
  end

  private

  def cached_or_unchached_fixture_hash
    data_checked ? Rails.cache.fetch("round/#{id}/fixtures") { fixture_hash } : fixture_hash
  end

  def cache_or_uncached_fixture_stats_by_game_day
    if data_checked
      Rails.cache.fetch("round/#{id}/fixture_stats_by_game_day") { fixture_hash_by_game_day }
    else
      fixture_hash_by_game_day
    end
  end

  def base_fixture_hash(fixture)
    {
      fixture: fixture,
      kickoff_time: fixture.adjusted_kickoff_time,
      home_team: fixture.home_team,
      away_team: fixture.away_team,
      stats: fixture.stats
    }
  end


  def fixture_hash
    {
      round: self,
      fixtures: fixtures.sort_by(&:kickoff_time)
                        .map do |fixture|
          base_fixture_hash(fixture)
      end
    }
  end

  def fixture_hash_by_game_day
    {
      fixture_groups: fixture_arr.map do |fixture_group|
        {
          game_day: fixture_group[0],
          fixtures: fixture_group[1].map do |fixture|
            base_fixture_hash(fixture)
          end
        }
      end
    }
  end
end
