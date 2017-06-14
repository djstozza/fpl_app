class CreateFplTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :fpl_teams do |t|
      t.string :name, null: false
      t.references :user, index: true
      t.references :league, index: true
      t.integer :total_score
      t.timestamps null: false
    end
  end
end
