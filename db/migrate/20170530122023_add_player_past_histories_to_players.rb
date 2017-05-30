class AddPlayerPastHistoriesToPlayers < ActiveRecord::Migration[5.0]
  def change
    add_column :players, :player_past_histories, :json

    Player.all.each do |player|
      player.update(
        player_past_histories:
          HTTParty.get("https://fantasy.premierleague.com/drf/element-summary/#{player.id}")['history_past']
      )
    end
  end
end
