require 'sidekiq'

class RecurringPositionWorker
  include HTTParty
  include Sidekiq::Worker
  sidekiq_options retry: 2

  def perform
    HTTParty.get('https://fantasy.premierleague.com/drf/element-types').each do |position|
      fpl_position = Position.find_or_create_by(id: position['id'])
      fpl_position.update(singular_name: position['singular_name'],
                          singular_name_short: position['singular_name_short'],
                          plural_name: position['plural_name'],
                          plural_name_short: position['plural_name_short'])
    end
  end
end

Sidekiq::Cron::Job.create(name: 'RecurringPositionWorker - every Friday at 12pm UTC',
                          cron: '00 12 * * 5 *',
                          class: 'RecurringPositionWorker')
