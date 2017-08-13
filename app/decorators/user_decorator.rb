class UserDecorator < SimpleDelegator
  def fpl_team_league_statuses
    fpl_teams.joins(:league).pluck_to_hash(:id, :name, :rank, :total_score, :league_id, 'leagues.name as league_name')
  end
end
