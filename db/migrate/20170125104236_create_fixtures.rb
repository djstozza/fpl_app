class CreateFixtures < ActiveRecord::Migration
  def change
    create_table :fixtures do |t|
      t.string :kickoff_time
      t.string :deadline_time
      t.integer :team_h_difficulty
      t.integer :team_a_difficulty
      t.integer :code
      t.integer :team_h_score
      t.integer :team_a_score
      t.integer :round_id
      t.integer :minutes
      t.integer :team_a_id
      t.integer :team_h_id
      t.boolean :started
      t.boolean :finished
      t.boolean :provisional_start_time
      t.boolean :finished_provisional
      t.integer :round_day
      t.timestamps null: false
    end
  end
end
