class AddPlayerFixtureHistoriesToPlayers < ActiveRecord::Migration[5.0]
  def change
    reversible do |dir|
      dir.up do
        add_column :players, :player_fixture_histories, :json
        Player.all.each do |player|
          player.update(
            player_fixture_histories:
              HTTParty.get("https://fantasy.premierleague.com/drf/element-summary/#{player.id}")['history']
          )
        end
      end

      dir.down do
        remove_column :players, :player_fixture_histories, :json
      end
    end
  end
end
