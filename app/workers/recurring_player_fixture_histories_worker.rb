require 'sidekiq'
require 'sidekiq-scheduler'

class RecurringPlayerFixtureHistoriesWorker
  include HTTParty
  include Sidekiq::Worker
  sidekiq_options retry: 2

  def perform
    round_id = Round.current.id
    Player.all.each do |player|
      pfh = HTTParty.get("https://fantasy.premierleague.com/drf/element-summary/#{player.id}")['history']
                    .find { |pfh| pfh['round'] == round_id && pfh['minutes'] > 0 }
      next unless pfh

      player_stats_arr.each do |stat|
        player.update(stat =>  pfh.inject(0) { |sum, fix_hist| sum + fix_hist[stat] })
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
