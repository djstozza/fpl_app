class AddActiveToFplTeams < ActiveRecord::Migration[5.0]
  def change
    add_column :fpl_teams, :active, :boolean
  end
end
