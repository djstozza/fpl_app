require 'sidekiq'
require 'sidekiq-scheduler'
require 'rake'
FplApp::Application.load_tasks

class RecurringFixtureWorker
  include HTTParty
  include Sidekiq::Worker
  sidekiq_options retry: 2

  def perform
    Rake::Task['data_seeding:populate_fixtures'].invoke
    Rake::Task['data_seeding:populate_fixture_stats'].invoke
  end
end
