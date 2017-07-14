require 'sidekiq'

class ActivateLeagueWorker
  include Sidekiq::Worker
  sidekiq_options retry: 2

  def perform(league_id)
    ::Leagues::ActivateLeagueService.run!(league: League.find_by(id: league_id))
  end
end
