class Leagues::ActivateLeagueForm
  include ActiveModel::Model
  include Virtus.model

  attr_accessor :league

  def initialize(league:)
    @league = league
    @league_decorator = LeagueDecorator.new(league)
  end

  validate :all_draft_picks_filled

  def save
    return false unless valid?
    ActiveRecord::Base.transaction do
      @league_decorator.fpl_teams.each do |fpl_team|
        ::FplTeams::ProcessInitialLineUp.run(fpl_team: fpl_team)
      end
      @league.update!(active: true)
    end
  end

  private

  def all_draft_picks_filled
    return if @league_decorator.all_draft_picks.all? { |pick| pick['player_id'].present? }
    errors.add(:base, 'All draft picks need to be filled before the league is activated')
  end
end
