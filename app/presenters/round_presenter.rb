class RoundPresenter < BasePresenter
  def initialize(round:)
    @round = round
  end

  def id
    @round.id
  end

  def data_checked
    @round.data_checked
  end

  def round_short_name
    "GW#{@round.id}"
  end

  def fixtures
    @round.fixtures
  end

  def fixture_stats_to_json(*)
    fixture_stats.to_json
  end

  def fixture_stats
    cached_or_unchached_fixture_hash
  end

  def fixture_stats_by_game_day
    cache_or_uncached_fixture_stats_by_game_day
  end

  private

  def fixture_arr
    @round.fixtures
          .sort_by(&:kickoff_time)
          .group_by { |fixture| Time.zone.at(fixture.kickoff_time).strftime('%A %-d %B %Y') }
  end

  def cached_or_unchached_fixture_hash
    data_checked ? Rails.cache.fetch("round/#{id}/fixtures") { fixture_hash } : fixture_hash
  end

  def cache_or_uncached_fixture_stats_by_game_day
    if @round.data_checked
      Rails.cache.fetch("round/#{@round.id}/fixture_stats_by_game_day") { fixture_hash_by_game_day }
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


  def fixture_hash
    {
      round: @round,
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
