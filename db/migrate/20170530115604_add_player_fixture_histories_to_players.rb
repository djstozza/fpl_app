class AddPlayerFixtureHistoriesToPlayers < ActiveRecord::Migration[5.0]
  def change
    add_column :players, :player_fixture_histories, :json

    Player.all.each do |player|
      player.update(
        player_fixture_histories:
          HTTParty.get("https://fantasy.premierleague.com/drf/element-summary/#{player.id}")['history']
      )
    end
  end
end
