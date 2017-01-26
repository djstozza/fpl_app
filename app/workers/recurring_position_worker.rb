require 'sidekiq'
require 'sidetiq'

class RecurringPositionWorker
  include HTTParty
  include Sidekiq::Worker
  include Sidetiq::Schedulable
  sidekiq_options retry: 2

  recurrence { yearly.month_of_year(:june) }

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
