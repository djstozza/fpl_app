desc 'populate teams'

namespace :data_seeding do
  task populate_teams: :environment do
    HTTParty.get('https://fantasy.premierleague.com/drf/teams').each do |team|
      fpl_team = Team.find_or_create_by(id: team['id'])
      fpl_team.update(name: team['name'],
                      code: team['code'],
                      short_name: team['short_name'],
                      strength: team['strength'],
                      played: team['played'],
                      link_url: team['link_url'],
                      strength_overall_home: team['strength_overall_home'],
                      strength_overall_away: team['strength_overall_away'],
                      strength_attack_home: team['strength_attack_home'],
                      strength_attack_away: team['strength_attack_away'],
                      strength_defence_home: team['strength_defence_home'],
                      strength_defence_away: team['strength_defence_away'],
                      team_division: team['team_division'])
    end

    Team.all.each do |team|
      team_decorator = TeamDecorator.new(team)
      wins = team_decorator.fixtures_won.count
      draws = team_decorator.fixtures_drawn.count
      goals_for = team_decorator.goal_calculator('team_h', 'team_a')
      goals_against = team_decorator.goal_calculator('team_a', 'team_h')
      team.update(
        wins: wins,
        losses: team_decorator.fixtures_lost.count,
        draws: draws,
        clean_sheets: team_decorator.clean_sheet_fixtures.count,
        goals_for: goals_for,
        goals_against: goals_against,
        goal_difference: (goals_for - goals_against),
        points: (wins * 3 + draws),
        played: team_decorator.fixtures.finished.count,
        form: team_decorator.current_form,
        position: team_decorator.find_position
      )
    end
  end
end
