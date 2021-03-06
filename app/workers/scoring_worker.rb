require 'sidekiq'

class ScoringWorker
  include HTTParty
  include Sidekiq::Worker
  sidekiq_options retry: 2

  def perform
    round = Round.find_by(is_current: true)
    return unless round.data_checked
    next_round = Round.find_by(is_next: true)
    League.where(active: true).each do |league|
      next if league.fpl_team_lists.where(round: round).all? { |list| list.rank.present? }
      ::Leagues::ProcessScoringService.run!(league: league, round: round)
      ::Leagues::ProcessRankingService.run!(league: league, round: round)
      league.fpl_teams.each do |fpl_team|
        if next_round
          ::FplTeams::ProcessNextLineUp.run!(fpl_team: fpl_team, current_round: round, next_round: next_round)
        end
      end
    end
  end
end
