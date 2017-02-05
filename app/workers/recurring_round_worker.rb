require 'sidekiq'

class RecurringRoundWorker
  include HTTParty
  include Sidekiq::Worker
  sidekiq_options retry: 2

  def perform
    HTTParty.get('https://fantasy.premierleague.com/drf/events').each do |round|
      fpl_round = Round.find_or_create_by(id: round['id'])
      fpl_round.update(name: round['name'],
                       deadline_time: round['deadline_time'],
                       finished: round['finished'],
                       data_checked: round['data_checked'],
                       deadline_time_epoch: round['deadline_time_epoch'],
                       deadline_time_game_offset: round['deadline_time_game_offset'],
                       is_previous: round['is_previous'],
                       is_current: round['is_current'],
                       is_next: round['is_next'])
    end
  end
end

Sidekiq::Cron::Job.create(name: 'RecurringRoundWorker - every day at 12pm UTC',
                          cron: '00 12 * * *',
                          class: 'RecurringRoundWorker')
