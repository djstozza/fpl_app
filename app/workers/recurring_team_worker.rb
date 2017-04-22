require 'sidekiq'
require 'sidekiq-scheduler'
require 'httparty'
FplApp::Application.load_tasks

class RecurringTeamWorker
  include HTTParty
  include Sidekiq::Worker
  sidekiq_options retry: 2

  def perform
    Rake::Task['data_seeding:populate_teams'].invoke
  end
end
