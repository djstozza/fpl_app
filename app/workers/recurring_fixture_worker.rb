require 'sidekiq'
require 'sidekiq-scheduler'
require 'rake'
FplApp::Application.load_tasks

class RecurringFixtureWorker
  include HTTParty
  include Sidekiq::Worker
  sidekiq_options retry: 2

  def perform
    FixturesService.new.update_fixtures
  end
end
