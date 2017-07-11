class AddRankToFplTeams < ActiveRecord::Migration[5.0]
  def change
    add_column :fpl_teams, :rank, :integer
  end
end
