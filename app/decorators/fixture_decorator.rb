class FixtureDecorator < SimpleDelegator
  def home_team
    Team.find_by(id: team_h_id)
  end

  def away_team
    Team.find_by(id: team_a_id)
  end
end
