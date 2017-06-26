class AddUniquenessConstraints < ActiveRecord::Migration[5.0]
  def change
    add_index :fpl_team_lists_players,
              [:fpl_team_list_id, :player_id],
              unique: true,
              name: 'by_fpl_team_list_and_player'
    add_index :leagues_players, [:league_id, :player_id], unique: true, name: 'by_league_and_player'
    add_index :fpl_teams_players, [:fpl_team_id, :player_id], unique: true, name: 'by_fpl_team_and_player'
  end
end
