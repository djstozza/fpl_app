class Leagues::CreateLeagueForm < ApplicationInteraction
  object :current_user, class: User
  object :league, class: League, default: -> { League.new }
  object :fpl_team, class: FplTeam, default: -> { FplTeam.new }
  string :league_name
  string :code
  string :fpl_team_name

  validate :league_name_uniqueness
  validate :fpl_team_name_uniqueness

  run_in_transaction!

  def execute
    league.assign_attributes(name: league_name, code: code, commissioner: current_user)
    league.save
    fpl_team.assign_attributes(name: fpl_team_name, user: current_user, league: league)
    fpl_team.save
  end

  private

  def league_name_uniqueness
    if League.where('lower(name) = ?', league_name.downcase).count.positive?
      errors.add(:base, 'League name has already been taken')
    end
  end

  def fpl_team_name_uniqueness
    if FplTeam.where('lower(name) = ?', fpl_team_name.downcase).count.positive?
      errors.add(:base, 'Fpl team name has already been taken')
    end
  end
end
