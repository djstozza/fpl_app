class CreateJoinTablePlayersFplTeamLists < ActiveRecord::Migration[5.0]
  def change
    create_join_table :players, :fpl_team_lists do |t|
      t.index [:player_id, :fpl_team_list_id]
    end
  end
end
