class AddActiveToFplTeamLists < ActiveRecord::Migration[5.0]
  def change
    add_column :fpl_team_lists, :active, :boolean
  end
end
