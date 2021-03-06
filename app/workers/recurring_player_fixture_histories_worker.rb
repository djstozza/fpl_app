require 'sidekiq'
require 'sidekiq-scheduler'

class RecurringPlayerFixtureHistoriesWorker
  include HTTParty
  include Sidekiq::Worker
  sidekiq_options retry: 2

  def perform
    Player.all.each do |player|
      response = HTTParty.get("https://fantasy.premierleague.com/drf/element-summary/#{player.id}")
      player_json = response&.parsed_response || response
      next unless player_json.instance_of?(Hash)
      player.update(player_past_histories: player_json['history_past'])
      fixture_histories = player_json['history']
      player.update(player_fixture_histories: fixture_histories)
      player_stats_arr.each do |stat|
        player.update(stat =>  fixture_histories.inject(0) { |sum, pfh| sum + pfh[stat] })
      end
    end
  end

  private

  def player_stats_arr
    %w(open_play_crosses
       big_chances_created
       clearances_blocks_interceptions
       recoveries
       key_passes
       tackles
       winning_goals
       dribbles
       fouls
       errors_leading_to_goal
       big_chances_missed
       offside
       attempted_passes
       target_missed)
  end
end
