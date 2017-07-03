class RemoveFormationFromFplTeamLists < ActiveRecord::Migration[5.0]
  def change
    remove_column :fpl_team_lists, :formation, :string
  end
end
