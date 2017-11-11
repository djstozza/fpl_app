class Leagues::ActivateLeagueService < ActiveInteraction::Base
  object :league, class: League

  validate :all_draft_picks_filled

  def execute
    ActiveRecord::Base.transaction do
      league.fpl_teams.each do |fpl_team|
        ::FplTeams::ProcessInitialLineUp.run!(fpl_team: fpl_team)
      end
      league.update!(active: true)
    end
  end

  private

  def all_draft_picks_filled
    return if LeagueDraftPicksDecorator.new(league).all_draft_picks.all? { |pick| pick['player_id'].present? }
    errors.add(:base, 'All draft picks need to be filled before the league is activated')
  end
end
