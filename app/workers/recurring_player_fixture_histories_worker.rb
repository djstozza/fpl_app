require 'sidekiq'
require 'sidekiq-scheduler'

class RecurringPlayerFixtureHistoriesWorker
  include HTTParty
  include Sidekiq::Worker
  sidekiq_options retry: 2

  def perform
    Player.all.each do |player|
      pfhs = HTTParty.get("https://fantasy.premierleague.com/drf/element-summary/#{player.id}")['history']
                     .select { |pfh| pfh['minutes'] > 0 }
      next unless pfhs
      player.update(player_fixture_histories: pfhs)
      player_stats_arr.each do |stat|
        player.update(stat =>  pfhs.inject(0) { |sum, pfh| sum + pfh[stat] })
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
