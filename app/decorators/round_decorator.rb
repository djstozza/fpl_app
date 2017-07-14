class RoundDecorator < SimpleDelegator
  def round_short_name
    "GW#{id}"
  end

  def fixture_stats
    cache_or_uncached_fixture_stats
  end

  private

  def fixture_arr
    fixtures.sort_by(&:kickoff_time)
            .group_by { |fixture| Time.zone.at(fixture.kickoff_time).strftime('%A %-d %B %Y') }
  end

  def cache_or_uncached_fixture_stats
    if is_current && !data_checked
      fixture_hash_by_game_day
    else
      fixture_hash_by_game_day
    end
  end

  def base_fixture_hash(fixture)
    {
      fixture: fixture,
      kickoff_time: Time.zone.at(fixture.kickoff_time).strftime('%H:%M'),
      home_team: fixture.home_team,
      away_team: fixture.away_team,
      stats: fixture.stats
    }
  end

  def fixture_hash_by_game_day
      arr = []
      fixture_arr.each do |fixture_group|
      arr << {
          game_day: fixture_group[0],
          fixtures: fixture_group[1].map do |fixture|
            base_fixture_hash(fixture)
          end
        }
      end
      arr
  end
end
