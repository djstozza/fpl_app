class CreateJoinTablePlayerFplTeam < ActiveRecord::Migration[5.0]
  def change
    create_join_table :players, :fpl_teams do |t|
      t.index [:player_id, :fpl_team_id]
    end
  end
end
