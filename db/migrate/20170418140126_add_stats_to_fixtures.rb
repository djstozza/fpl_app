class AddStatsToFixtures < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        add_column :fixtures, :stats, :json

        HTTParty.get('https://fantasy.premierleague.com/drf/fixtures/').each do |fixture|
          next unless fixture['started']
          stats = {}
          key_stats_arr.each do |stat|
            stats[stat] = {}
            stats[stat]['initials'] = stat.split('_').map(&:first).join.upcase
            stats[stat]['name'] = stat.humanize.titleize
            ['home_team', 'away_team'].each do |x|
              stats[stat][x] = []
              fixture['stats'].find { |s| s[stat] }.dig(stat, x[0]).each do |s|
                stats[stat][x] << { value: s['value'], player: Player.find(s['element']).last_name }
              end
            end
          end

          Fixture.find_by(id: fixture['id'])&.update(stats: stats)
        end
      end

      dir.down do
        remove_column :fixtures, :stats, :json
      end
    end
  end

  private

  def key_stats_arr
    %w(goals_scored assists own_goals penalties_saved penalties_missed yellow_cards red_cards saves bonus)
  end
end
