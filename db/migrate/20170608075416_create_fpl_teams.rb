class CreateFplTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :fpl_teams do |t|
      t.string :name, null: false
      t.references :users, index: true, foreign_key: true
      t.references :leagues, index: true, foreign_key: true
      t.integer :total_score
      t.timestamps null: false
    end
  end
end
