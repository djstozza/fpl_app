class AddOverallRankToFplTeamLists < ActiveRecord::Migration[5.0]
  def change
    reversible do |dir|
      dir.up do
        add_column :fpl_team_lists, :overall_rank, :integer
      end

      dir.down do
        remove_column :fpl_team_lists, :overall_rank, :integer
      end
    end
  end
end
