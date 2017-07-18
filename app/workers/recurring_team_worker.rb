require 'sidekiq'
require 'sidekiq-scheduler'

class RecurringTeamWorker
  include Sidekiq::Worker
  sidekiq_options retry: 2

  def perform
    teams_service = TeamsService.new
    teams_service.update_teams
    teams_service.update_team_stats
  end
end
