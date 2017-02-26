class AddStatColumnsToPlayers < ActiveRecord::Migration
  def up
    player_stats_arr.each do |stat|
      add_column :players, stat.to_sym, :integer
    end

    Player.all.each do |player|
      player_stats_arr.each do |stat|
        player.update(stat => player.player_fixture_histories.inject(0) { |sum, pfh| sum + pfh.public_send(stat) })
      end
    end
  end

  def down
    player_stats_arr.each do |stat|
      remove_column :players, stat.to_sym, :integer
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
