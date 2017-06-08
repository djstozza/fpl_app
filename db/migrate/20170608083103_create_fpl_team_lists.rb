class CreateFplTeamLists < ActiveRecord::Migration[5.0]
  def change
    create_table :fpl_team_lists do |t|
      t.references :fpl_team, index: true, foreign_key: true
      t.references :round, index: true, foreign_key: true
      t.string :formation, array: true, default: []
      t.integer :total_score
      t.integer :rank
      t.timestamps null: false
    end
  end
end
