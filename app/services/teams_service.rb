require 'httparty'

class TeamsService
  def initialize
    @teams_hash = HTTParty.get('https://fantasy.premierleague.com/drf/teams')
  end

  def update_teams
    @teams_hash.each do |team_hash|
      fpl_team = Team.find_or_create_by(id: team_hash['id'])
      fpl_team.update(name: team_hash['name'],
                      code: team_hash['code'],
                      short_name: team_hash['short_name'],
                      strength: team_hash['strength'],
                      played: team_hash['played'],
                      link_url: team_hash['link_url'],
                      strength_overall_home: team_hash['strength_overall_home'],
                      strength_overall_away: team_hash['strength_overall_away'],
                      strength_attack_home: team_hash['strength_attack_home'],
                      strength_attack_away: team_hash['strength_attack_away'],
                      strength_defence_home: team_hash['strength_defence_home'],
                      strength_defence_away: team_hash['strength_defence_away'],
                      team_division: team_hash['team_division'])
    end
  end

  def update_team_stats
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
