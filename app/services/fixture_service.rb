class FixtureService
  def initialize(fixture_hash:)
    @fixture_hash = fixture_hash
    @fixture = Fixture.find_or_create_by(id: fixture_hash['id'])
  end

  def update_fixture
    @fixture.update(
      kickoff_time: @fixture_hash['kickoff_time'],
      deadline_time: @fixture_hash['deadline_time'],
      team_h_difficulty: @fixture_hash['team_h_difficulty'],
      team_a_difficulty: @fixture_hash['team_a_difficulty'],
      code: @fixture_hash['code'],
      team_h_score: @fixture_hash['team_h_score'],
      team_a_score: @fixture_hash['team_a_score'],
      round_id: @fixture_hash['event'],
      minutes: @fixture_hash['minutes'],
      team_a_id: @fixture_hash['team_a'],
      team_h_id: @fixture_hash['team_h'],
      started: @fixture_hash['started'],
      finished: @fixture_hash['finished'],
      provisional_start_time: @fixture_hash['provisional_start_time'],
      finished_provisional: @fixture_hash['finished_provisional'],
      round_day: @fixture_hash['event_day']
    )
  end

  def update_fixture_stats
    return unless @fixture.started
    stats = {}
    key_stats_arr.each do |stat|
      stats[stat] = {}
      stats[stat]['initials'] = stat.split('_').map(&:first).join.upcase
      stats[stat]['name'] = stat.humanize.titleize
      ['home_team', 'away_team'].each do |x|
        stats[stat][x] = []
        @fixture_hash['stats'].find { |s| s[stat] }.dig(stat, x[0]).each do |s|
          player = Player.find(s['element'])
          stats[stat][x] << {
            value: s['value'],
            player: { id: player.id, last_name: player.last_name }
          }
        end
      end
    end

    @fixture.update(stats: stats)
  end

  private

  def key_stats_arr
    %w(goals_scored assists own_goals penalties_saved penalties_missed yellow_cards red_cards saves bonus)
  end
end
