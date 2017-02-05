require 'sidekiq'

class RecurringPlayerPastHistoryWorker
  include HTTParty
  include Sidekiq::Worker
  sidekiq_options retry: 2

  def perform
    Player.all.each do |player|
      HTTParty.get("https://fantasy.premierleague.com/drf/element-summary/#{player.id}")['history_past']
              .each do |history|
        fpl_player_fixture_history = PlayerPastHistory.find_or_create_by(id: history['id'])
        fpl_player_fixture_history.update(season_name: history['season_name'],
                                          player_code: history['element_code'],
                                          start_cost: history['start_cost'],
                                          end_cost: history['end_cost'],
                                          total_points: history['total_points'],
                                          minutes: history['minutes'],
                                          goals_scored: history['goals_scored'],
                                          assists: history['assists'],
                                          clean_sheets: history['clean_sheets'],
                                          own_goals: history['own_goals'],
                                          penalties_saved: history['penalties_saved'],
                                          penalties_missed: history['penalties_missed'],
                                          yellow_cards: history['yellow_cards'],
                                          red_cards: history['red_cards'],
                                          saves: history['saves'],
                                          bonus: history['bonus'],
                                          bps: history['bps'],
                                          influence: history['influence']&.to_d,
                                          creativity: history['creativity']&.to_d,
                                          threat: history['treat']&.to_d,
                                          ict_index: history['ict_index'],
                                          ea_index: history['ea_index'],
                                          season: history['season'])
      end
    end
  end
end

Sidekiq::Cron::Job.create(name: 'RecurringPlayerPastHistoryWorker - every Friday at 12pm UTC',
                          cron: '00 12 * * 5 *',
                          class: 'RecurringPlayerPastHistoryWorker')
